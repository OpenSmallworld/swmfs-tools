<#
.SYNOPSIS
Create certificates for secure swmfs communication
.DESCRIPTION
This tool will create a .pem, .key and .pfx file suitable for use with swmfs. By default it will create a certificate for the current machine or a named machine.
See -help for full details and examples
.PARAMETER hostname
(string) hostname for certificate (defaults to $env:computername) 
.PARAMETER domainname
(string) domainname for certificate (defaults to $env:userdnsdomain)
.PARAMETER casubject
(string) CA Subject for certificate (defaults to CN=MyRootCA,O=MyRootCA,OU=MyRootCA)
.PARAMETER cakeylength
(integer) key length for certificate. accetable values are 2048 or 4096 only (defaults to 2048)
.PARAMETER subject
(string) Subject for certificate (defaults to CN=swmfs)
.PARAMETER months
(integer) number of months for certificate (defaults to 36)
.PARAMETER help
(switch) list arguments and examples
.EXAMPLE
# Create certificates for current machine
.\create-certs.ps1
.EXAMPLE
# Create certificates for named machine smallworld.example.org
.\create-certs.ps1 -hostname smallworld -domainname example.org
.EXAMPLE
# Create certificates for named machine smallworld.example.org and display details of pem file in human readable format
.\create-certs.ps1 -hostname smallworld -domainname example.org -details
#
.\create-certs.ps1 -hostname smallworld -domainname example.org -verbose
.EXAMPLE
# Create certificates for named machine smallworld.example.org with higher strength key length
.\create-certs.ps1 -host smallworld -domain example.org -cakeylen 4096
.EXAMPLE
# Create certificates for named machine smallworld.example.org for 120 months
.\create-certs.ps1 -hostname smallworld -domainname example.org -months 120
.EXAMPLE
# List arguments and examples
#
.\create-certs.ps1 -help
#
Get-Help .\create-certs.ps1 -examples
.NOTES
Pre-requisites: this tool requires a standalone install of openssl
.LINK
https://github.com/OpenSmallworld/swmfs-tools
https://github.build.ge.com/105007530/swmfs-tools.git
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, ParameterSetName = "GenerateCertificates")]
    [string]$hostname = $env:computername,
    [Parameter(Mandatory = $false, ParameterSetName = "GenerateCertificates")]
    [string]$domainname = $env:userdnsdomain,
    [Parameter(Mandatory = $false, ParameterSetName = "GenerateCertificates")]
    [string]$CASubject = 'CN=MyRootCA,O=MyRootCA,OU=MyRootCA',
    [Parameter(Mandatory = $false, ParameterSetName = "GenerateCertificates")]
    [ValidateSet(2048, 4096)]
    [int]$CAKeyLength = 2048,
    [Parameter(Mandatory = $false, ParameterSetName = "GenerateCertificates")]
    [string]$subject = 'CN=swmfs',
    [Parameter(Mandatory = $false, ParameterSetName = "GenerateCertificates")]
    [ValidateRange(12, 120)]
    [int]$months = 36,
    [Parameter(Mandatory = $false, ParameterSetName = "GenerateCertificates")]
    [switch]$detail = $false,

    [Parameter(Mandatory = $true, ParameterSetName = "Help")]
    [switch]$help = $false
)

function Get-CertificateOutput {
    [CmdletBinding()]
    param (
        $inputfile,
        $outputfile,
        $startdelimiter,
        $enddelimiter
    )

    $fileContents = Get-Content -Path $inputfile
    $insection = $false

    if (Test-Path $outputfile) {
        Remove-Item $outputfile
    }

    New-Item -Name $outputfile -ItemType File | Out-Null

    foreach ($line in $fileContents) {
        if ($line -eq $startdelimiter) {
            Add-Content -Path $outputfile -Value $line
            $insection = $true
        }
        elseif ($line -eq $enddelimiter) {
            Add-Content -Path $outputfile -Value $line
            $insection = $false
        }
        else {
            if ($insection) {
                Add-Content -Path $outputfile -Value $line # Add the line to the current section if we are in a section
            }
        }
    }

}

try {
    openssl -help 2> $null
}
catch {
    Write-Error "OpenSSL is not installed. Downloads available here https://github.com/openssl/openssl/releases"
    return
}

$fqhn = '{0}.{1}' -f $hostname, $domainname    
$pfx = "./swmfs.pfx"
$keypem = "./swmfs.key"
$certpem = "./swmfs.pem"
$txt = "./swmfs.txt"

$Debug = $PSBoundParameters.Debug.IsPresent
$Verbose = $PSBoundParameters.Verbose.IsPresent

if ($Debug) { } # keep linters quiet
if ($Verbose) { }

if ($help.IsPresent) { 
    Get-Help $($MyInvocation.MyCommand.Definition) -full
    return
}

Write-Verbose "Creating root certiicate with subject '$CASubject' and key length $CAKeyLength"
$rootCert = New-SelfSignedCertificate `
    -Subject $CASubject `
    -KeyExportPolicy Exportable `
    -KeyUsage CertSign, CRLSign, DigitalSignature `
    -KeyLength $CAKeyLength `
    -KeyUsageProperty All `
    -KeyAlgorithm 'RSA'  `
    -HashAlgorithm 'SHA256'  `
    -Provider 'Microsoft Enhanced RSA and AES Cryptographic Provider'

Write-Verbose "Creating certificate with subject '$Subject' for $fqhn and $hostname"
$cert = New-SelfSignedCertificate `
    -CertStoreLocation cert:\LocalMachine\My `
    -Subject $subject `
    -DnsName @($fqhn, $hostname, 'localhost', '127.0.0.1') `
    -NotAfter (Get-Date).AddMonths($months) `
    -Signer $rootCert `
    -KeyUsage KeyEncipherment, DigitalSignature

# export
$password = New-Object -TypeName PSObject
$password | Add-Member -MemberType ScriptProperty -Name "Password" -Value { ("!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".tochararray() | Sort-Object { Get-Random })[0..15] -join '' }

$CertPassword = ConvertTo-SecureString -String $password -Force -AsPlainText

$certpath = 'cert:\LocalMachine\My\{0}' -f $cert.thumbprint

Write-Verbose "Exporting certificate $certpath"
Export-PfxCertificate -Cert $certpath -FilePath $pfx -Password $CertPassword | Out-Null

Write-Verbose "Writing $keypem"
openssl pkcs12 -in $pfx -nocerts -out $txt -nodes -password pass:$password 
Get-CertificateOutput -inputfile $txt -outputfile $keypem -startdelimiter "-----BEGIN PRIVATE KEY-----" -enddelimiter "-----END PRIVATE KEY-----"

Write-Verbose "Writing $certpem"
openssl pkcs12 -in $pfx -nokeys -out $txt -nodes -password pass:$password 
Get-CertificateOutput -inputfile $txt -outputfile $certpem -startdelimiter "-----BEGIN CERTIFICATE-----" -enddelimiter "-----END CERTIFICATE-----"

$password = $null

if ($detail.IsPresent -or $Verbose) {
    Write-Host ''
    openssl x509 -in $certpem -noout -text
    Write-Host ''
}

Remove-Item $txt
