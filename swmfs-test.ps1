<#
.DESCRIPTION
Generate a swmfs based support bundle
.PARAMETER sw_root
(string) root of a 5.x installation
.PARAMETER pathname
(string) pathname of a remote directory. can be unc or drive based path (if swmfs is running locally). host-qualified pathnames are not supported
.PARAMETER filename
(string) filename to test
.PARAMETER test_length
(string) test length as recognised by swmfs_test 23. default value is '10s'
.PARAMETER trace_level
(integer) swmfs_trace level. default value is 0 (disabled)
.PARAMETER help
(switch) Display full help and examples
.EXAMPLE
# generate a swmfs support bundle using a UNC pathname
.\swmfs_test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname \\server-name\path\to\ds\ds_gis -filename gdb.ds
.EXAMPLE
# generate a swmfs support bundle using a UNC pathname including swmfs_trace logging for the duration of the tests
# trace levels are 1 to 3 as normal, plus level 0 is disabled (default)
.\swmfs_test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname \\server-name\path\to\ds\ds_gis -filename gdb.ds -trace 2
.EXAMPLE
# generate a swmfs support bundle using a local pathname. note: this only works on a swmfs server directly
.\swmfs_test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin -filename ace.ds
.NOTES
TODO: work with 4.x based installation
.LINK
https://github.build.ge.com/105007530/swmfs-tools.git
https://github.com/OpenSmallworld/swmfs-tools
#>

[CmdletBinding()]
param (
    [string]$sw_root,
    [string]$pathname,
    [string]$filename,
    [string]$test_length = '10s',
    [ValidateRange(0, 3)]
    [int]$trace_level = 0,
    [switch]$help
)

BEGIN {
    try {
        # this try/catch block does not handle the exception but left in to highlight the location for new releases
        #Requires -Version 6.0
    }
    catch {
        Write-Error "A later version of Powershell is recommended. Download from https://github.com/PowerShell/PowerShell/releases."
    }
    
    $version = 1

    if ($help.IsPresent) { 
        Get-Help $($MyInvocation.MyCommand.Definition) -full
    }
    
    $savedVerbosePreference = $VerbosePreference
    $VerbosePreference = "Continue"
}

PROCESS {
    function Invoke-SwmfsCommand {
        [CmdletBinding()]
        param (
            $log_file,
            $command,
            $params
        )
    
        Write-Verbose "$command $params"
        $now = (Get-Date).ToUniversalTime()
        Add-Content -Path $log_file -Value "--`n$now - $command $params`n"
        $result = & $command $params
        Add-Content -Path $log_file -Value $result   

        if (($command.Contains("swmfs_test")) -and ($params[0] -eq 15)) {
            if ([bool]($result -match "Tls port")) {
                Add-Content -Path $log_file -Value "`nNote: Encryption is enabled"
            }
        }
    }

    function Invoke-HeaderFooter {
        [CmdletBinding()]
        param (
            $log_file,
            [switch]$header,
            [switch]$footer
        )

        $now = (Get-Date).ToUniversalTime()

        if ($header.IsPresent) {
            $string = "--`nversion: $version`nbegin: $now"
        }
        elseif ( $footer.IsPresent) {
            $string = "--`nend: $now"
        }

        Add-Content -Path $log_file -Value $string
    }
    

    if ($help.IsPresent) { 
        return
    }

    if (!( Test-Path $sw_root)) {
        Write-Error "$sw_root does not exist"
        return
    }

    if ($pathname -match '^\\\\([a-z0-9_.$-]+)\\') {
        $server = $matches[1]
    }
    else {
        $server = 'localhost'
    }

    $log_file = "swmfs_test_{0}.log" -f (Get-Date (Get-Date).ToUniversalTime() -UFormat '+%Y%m%dT%H%M%S')

    $x86_dir = "$sw_root\core\bin\x86"
    $etc_dir = "$sw_root\core\etc\x86"
    $swmfs_test = "$x86_dir\swmfs_test.exe"
    $swmfs_trace = "$etc_dir\swmfs_trace.exe"
    $swmfs_monitor = "$x86_dir\swmfs_monitor.exe"
    
    if (!( Test-Path $swmfs_test)) {
        Write-Error "$swmfs_test does not exist"
        return
    }
    
    if (!( Test-Path $swmfs_trace)) {
        Write-Error "$swmfs_trace does not exist"
        return
    }

    $params = 13, $pathname, $filename
    Write-Verbose "$swmfs_test $params"
    $result = & $swmfs_test $params
    
    if ($result -eq "open returns MDBE_NO_ACCESS") {
        Write-Error "$pathname\$filename does not exist or is inaccessible"
        return
    }
    

    if (( Test-Path $log_file)) {
        Remove-Item $log_file
    }

    Invoke-HeaderFooter -log_file $log_file -header

    $params = $server, "-n", 10, "-l", 4096
    Invoke-SwmfsCommand -log_file $log_file -command "ping" -params $params

    $params = 15, $server
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    $params = $server
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_monitor -params $params

    if ($trace_level -gt 0) {
        $params = "-times", "-local_times", $trace_level, $server
        Write-Verbose "$swmfs_trace $params"
        $job = & $swmfs_trace $params &    
    }

    $params = 13, $pathname, $filename, 10
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    $params = 23, $pathname, $filename, $test_length, "100:#"
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    $params = 23, $pathname, $filename, $test_length, 0
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    Invoke-HeaderFooter -log_file $log_file -footer

    if ($trace_level -gt 0) {
        Write-Verbose "retrieve swmfs_trace output..."
        Add-Content -Path $log_file -Value "--"
        $job | Receive-Job | Add-Content -Path $log_file    
    }
    else {
        Add-Content -Path $log_file -Value "no swmfs_trace specified"        
    }
}

END {
    Write-Verbose "output to $log_file"
    $VerbosePreference = $savedVerbosePreference
}