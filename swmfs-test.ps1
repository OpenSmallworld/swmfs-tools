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
.PARAMETER no_git_check
(switch) do not check for git repo changes
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
.\swmfs-test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin -filename ace.ds
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
    [ValidateRange(0, 255)] # TODO: possibly validate predefined valies i.e. 0, 192, 255 etc
    [int]$mdb_trace_level = 0,
    [switch]$no_git_check,
    [switch]$help
)

BEGIN {
    try {
        # this try/catch block does not handle the exception but left in to highlight the location for new releases
        #Requires -Version 5.0
        # $PSVersionTable.PSVersion
    }
    catch {
        Write-Error "A later version of Powershell is recommended. Download from https://github.com/PowerShell/PowerShell/releases."
    }
    
    $version = 3
    $threshold = 5 # ms

    if ($help.IsPresent) { 
        Get-Help $($MyInvocation.MyCommand.Definition) -full
    }
    
    $savedSW_TRACE = $env:SW_TRACE

    if ($mdb_trace_level -gt 0) {
        $env:SW_TRACE = "mdb={0}" -f $mdb_trace_level
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
        $start = (Get-Date).ToUniversalTime()
        Add-Content -Path $log_file -Value "--`n$start - $command $params`n"
        $result = & $command $params 2>&1
        Add-Content -Path $log_file -Value $result   

        if (($command.Contains("swmfs_test")) -and ($params[0] -eq 15)) {
            if ([bool]($result -match "Tls port")) {
                Add-Content -Path $log_file -Value "`nEncryption is enabled`n"
            }
        }

        if ($command.Contains("ping")) {
            $regex = 'Minimum = (\d{1,4})ms, Maximum = (\d{1,4})ms, Average = (\d{1,4})ms'
            # as result was an array, -match will only filter and does not populate $matches (https://stackoverflow.com/questions/71519641/match-and-matches-in-powershell-via-regex) so cast to string
            $line = [string]($result -match $regex)
            if ($line -match $regex) {
                $avg = [int]$matches[3]
                if ($avg -gt $threshold) {
                    $string = "${avg}ms average ping time > ${threshold}ms. Poor latency between client and server may have a disproportionate impact on overall performance"
                    Write-Warning "*** $string ***"
                    Add-Content -Path $log_file -Value "`n*** Warning: $string ***"
                }
            }
        }

        $interval = New-TimeSpan -Start $start -End (Get-Date).ToUniversalTime()
        Add-Content -Path $log_file -Value "`nTime interval: $interval"
    }

    function Invoke-HeaderFooter {
        [CmdletBinding()]
        param (
            $log_file,
            [switch]$header,
            [switch]$footer,
            [string]$command
        )

        $now = (Get-Date).ToUniversalTime()

        if ($header.IsPresent) {
            $string = "--`nversion: {0}`nbegin: {1}`npowershell: {2}`ncommand: {3}" -f $version, $now, $PSVersionTable.PSVersion, $command
        }
        elseif ( $footer.IsPresent) {
            $string = "--`nend: $now"
        }

        Add-Content -Path $log_file -Value $string
    }
 
    function Get-GitPath {
        [CmdletBinding()]
        param (
        )
        $path = $null
        $path = (Get-Command "git.exe" -ErrorAction SilentlyContinue).Path
    
        return $path
    }

    function Invoke-CheckGit {
        [CmdletBinding()]
        param (
            $script
        )

        if ($no_git_check.IsPresent) {
            return
        }

        if (Get-GitPath) {
            $pathname = Split-Path (Get-Item $script.MyCommand.Path) -Parent
            if (Test-Path "$pathname\.git") {
                $status = & git fetch --dry-run --verbose 2>&1
                if (!([bool]($status -match "[up to date]"))) {
                    git fetch --dry-run --verbose
                    Write-Warning "Consider \"git pull\" to refresh or re-run with -no_git_check" 
                    exit
                }
                else {
                    # Write-Host "ok"
                }
            }
        }
    }

    if ($help.IsPresent) { 
        return
    }

    Invoke-CheckGit -script $MyInvocation

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
    $swmfs_lock_monitor = "$x86_dir\swmfs_lock_monitor.exe"
    
    if (!( Test-Path $swmfs_test)) {
        Write-Error "$swmfs_test does not exist"
        return
    }
    
    if (!( Test-Path $swmfs_trace)) {
        Write-Error "$swmfs_trace does not exist"
        return
    }

    $params = 13, $pathname, $filename
    Write-Verbose "Testing accessibility"
    $result = & $swmfs_test $params 2>&1
    
    if ($result -eq "open returns MDBE_NO_ACCESS") {
        Write-Error "$pathname\$filename does not exist or is inaccessible"
        return
    }
    

    if (( Test-Path $log_file)) {
        Remove-Item $log_file
    }

    Invoke-HeaderFooter -log_file $log_file -header -command $MyInvocation.Line

    $params = $server, "-n", 10, "-l", 4096
    Invoke-SwmfsCommand -log_file $log_file -command "ping" -params $params

    $params = "/all"
    Invoke-SwmfsCommand -log_file $log_file -command "ipconfig" -params $params

    $params = $server
    Invoke-SwmfsCommand -log_file $log_file -command "tracert" -params $params

    $params = 15, $server
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    $params = $server
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_lock_monitor -params $params

    $params = $server
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_monitor -params $params

    if ($trace_level -gt 0) {
        # $params = "-times", "-local_times", $trace_level, $server # ps6
        Write-Verbose "$swmfs_trace $params"
        $command = { param($cmd, $level, $server) & $cmd -times -local_times $level $server 2>&1 }
        $job = Start-Job $command -ArgumentList $swmfs_trace, $trace_level, $server
        Start-Sleep 3 # allow swmfs_trace to connect
        # $job = & $swmfs_trace $params & # ps6
    }

    $params = 13, $pathname, $filename
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    $params = 13, $pathname, $filename, 10
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    $params = 20, $pathname, $filename
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    $params = 23, $pathname, $filename, $test_length, "100:#"
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    $params = 23, $pathname, $filename, $test_length, 0
    Invoke-SwmfsCommand -log_file $log_file -command $swmfs_test -params $params

    Invoke-HeaderFooter -log_file $log_file -footer

    if ($trace_level -gt 0) {
        Write-Verbose "retrieve swmfs_trace output..."
        Add-Content -Path $log_file -Value "--"
        Receive-Job -Job $job | Add-Content -Path $log_file    
    }
    else {
        Add-Content -Path $log_file -Value "no swmfs_trace specified"        
    }

    Write-Verbose "output to $log_file"
}

END {
    $VerbosePreference = $savedVerbosePreference
    $env:SW_TRACE = $savedSW_TRACE
}