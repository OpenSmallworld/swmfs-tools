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

#Requires -Version 6.0

BEGIN {
    if ($help.IsPresent) { 
        Get-Help $($MyInvocation.MyCommand.Definition) -full
    }
    
    $savedVerbosePreference = $VerbosePreference
    $VerbosePreference = "Continue"
}

PROCESS {
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

    $swmfs_test_log = "swmfs_test_{0}.log" -f (Get-Date (Get-Date).ToUniversalTime() -UFormat '+%Y%m%dT%H%M%S')

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
    

    if (( Test-Path $swmfs_test_log)) {
        Remove-Item $swmfs_test_log
    }

    $now = (Get-Date).ToUniversalTime()
    Add-Content -Path $swmfs_test_log -Value "--`nbegin: $now"

    # TODO: refactor to function
    $params = 15, $server
    Write-Verbose "$swmfs_test $params"
    $now = (Get-Date).ToUniversalTime()
    Add-Content -Path $swmfs_test_log -Value "--`n$now - $swmfs_test $params`n"
    $result = & $swmfs_test $params
    Add-Content -Path $swmfs_test_log -Value $result   

    $params = $server
    Write-Verbose "$swmfs_monitor $params"
    $now = (Get-Date).ToUniversalTime()
    Add-Content -Path $swmfs_test_log -Value "--`n$now - $swmfs_monitor $params`n"
    $result = & $swmfs_monitor $params
    Add-Content -Path $swmfs_test_log -Value $result   

    if ($trace_level -gt 0) {
        # $params = "-times", "-local_times", $trace_level, $pathname, $filename
        $params = "-times", "-local_times", $trace_level, $server
        Write-Verbose "$swmfs_trace $params"
        $job = & $swmfs_trace $params &    
    }

    $params = 13, $pathname, $filename, 10
    Write-Verbose "$swmfs_test $params"
    $now = (Get-Date).ToUniversalTime()
    Add-Content -Path $swmfs_test_log -Value "--`n$now - $swmfs_test $params`n"
    $result = & $swmfs_test $params
    Add-Content -Path $swmfs_test_log -Value $result   

    $params = 23, $pathname, $filename, $test_length, "100:#"
    Write-Verbose "$swmfs_test $params"
    $now = (Get-Date).ToUniversalTime()
    Add-Content -Path $swmfs_test_log -Value "`n--`n$now - $swmfs_test $params`n"
    $result = & $swmfs_test $params
    Add-Content -Path $swmfs_test_log -Value $result
    
    $params = 23, $pathname, $filename, $test_length, 0
    Write-Verbose "$swmfs_test $params"
    $now = (Get-Date).ToUniversalTime()
    Add-Content -Path $swmfs_test_log -Value "`n--`n$now - $swmfs_test $params`n"
    $result = & $swmfs_test $params
    Add-Content -Path $swmfs_test_log -Value $result    

    $now = (Get-Date).ToUniversalTime()
    Add-Content -Path $swmfs_test_log -Value "--`nend: $now`n--"

    if ($trace_level -gt 0) {
        Write-Verbose "retrieve swmfs_trace output..."
        $job | Receive-Job | Add-Content -Path $swmfs_test_log    
    }
    else {
        Add-Content -Path $swmfs_test_log -Value "no swmfs_trace specified"        
    }
}

END {
    $VerbosePreference = $savedVerbosePreference
}