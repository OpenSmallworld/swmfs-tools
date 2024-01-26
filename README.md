# swmfs-tools

## Prerequisites

A later version of Powershell is recommended. Download from [here](https://github.com/PowerShell/PowerShell/releases).

## create-certs.ps1

Create `swmfs.pem`, `swmfs.key` and `swmfs.pfx` suitable for use with secured swmfs communication. By default it will create a certificate for the current machine or a named machine which can be Linux based.

Note: The certificate is exported directly from the certificate store in `pfx` and `pem` formats. There is no need to import anything on Windows.

It is important to point out that self-signed certificates cannot be used in conjunction with the `-mtls` argument. Although the server will start, the client will not use a self-signed certificate and will disconnect. This is a requirement for a trusted secure swmfs installation.

Use `.\create-certs.ps1 -help` for full details and examples.

### Examples

```powershell
# Create certificates for current machine
.\create-certs.ps1

# Create certificates for current machine with increased keysize
.\create-certs.ps1 -keylength 4096

# Create certificates for named machine smallworld.example.org
.\create-certs.ps1 -hostname smallworld -domainname example.org

# Create certificates for named machine smallworld.example.org and display details of pem file in human readable format
.\create-certs.ps1 -hostname smallworld -domainname example.org -details
#
.\create-certs.ps1 -hostname smallworld -domainname example.org -verbose

# Create certificates for named machine smallworld.example.org with higher strength key length
.\create-certs.ps1 -host smallworld -domain example.org -cakeylen 4096

# Create certificates for named machine smallworld.example.org for 120 months
.\create-certs.ps1 -hostname smallworld -domainname example.org -months 120

# List arguments and examples
#
.\create-certs.ps1 -help
#
Get-Help .\create-certs.ps1 -examples
```

### Example session

```text
(admin PS) C:\opt\sw\src\repos\swmfs-tools> .\create-certs.ps1 -host smallworld -domain example.org -cakeylen 4096 -keylength 4096 -months 120 -verb
VERBOSE: Creating root certiicate with subject 'CN=MyRootCA,O=MyRootCA,OU=MyRootCA' and key length 4096
VERBOSE: Creating certificate with subject 'CN=swmfs' for smallworld.example.org and smallworld
VERBOSE: Exporting certificate cert:\LocalMachine\My\A29B4EEF87C5ABB03D78122DF480C626E7E10636
VERBOSE: Writing ./swmfs.key
VERBOSE: Writing ./swmfs.pem

Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            72:4f:2c:fe:83:b6:a0:96:42:9f:29:f7:1c:11:ca:ea
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: OU = MyRootCA, O = MyRootCA, CN = MyRootCA
        Validity
            Not Before: Jan 25 20:45:41 2024 GMT
            Not After : Jan 25 20:55:40 2034 GMT
        Subject: CN = swmfs
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Modulus:
                    00:98:f3:03:6e:b9:0c:0e:95:8b:c2:ba:73:bd:08:
                    60:b0:43:07:3f:2e:88:76:e6:12:85:a6:8f:33:60:
                    b3:a1:ba:23:da:b8:ec:b6:bf:94:a0:ec:91:a3:07:
                    b6:d6:fb:a0:fd:65:97:15:c4:ba:1a:09:3f:10:63:
                    8b:a3:71:30:09:bb:93:38:85:2b:1b:f4:53:fc:ca:
                    08:70:16:d4:de:d7:4e:75:11:94:21:0c:19:f9:9c:
                    0f:34:81:5d:99:96:60:31:f3:b5:31:ec:1c:9c:90:
                    4f:c3:6f:a2:71:30:9a:c9:5a:a2:f7:c5:37:30:d1:
                    4e:6a:29:cc:ca:8c:7e:50:08:79:24:3e:38:03:4c:
                    26:28:8f:0a:83:e4:3d:f7:27:5a:63:44:16:5d:b5:
                    ed:50:76:6e:bb:ff:8c:95:85:2a:50:b3:27:b0:b2:
                    30:1e:09:59:03:20:1c:59:7b:78:73:ca:0b:37:76:
                    d1:d9:91:b5:d3:6e:a8:3d:ff:1f:b7:a7:82:1d:62:
                    a8:2e:b3:fc:07:3b:c2:0b:6f:61:de:3a:7f:3b:20:
                    70:88:f0:3d:96:19:c5:a8:57:db:5a:4f:bd:73:43:
                    6f:18:33:27:50:c3:42:ab:cb:e9:7a:4a:b5:21:e8:
                    86:f5:99:56:20:a5:38:f1:e4:bb:0f:2e:a2:ed:c7:
                    2d:f1:26:4c:fb:1b:54:3d:a6:12:8e:40:6b:d2:f0:
                    33:07:b2:64:72:dd:9a:01:49:07:dd:9c:6c:6a:8f:
                    d0:87:24:a6:30:63:64:92:f2:24:b3:6c:31:9a:40:
                    8c:e3:03:0c:66:1c:62:61:61:c7:c5:99:7c:a2:f5:
                    fb:79:bb:d8:ac:1a:9f:e7:81:ac:30:84:36:5d:e2:
                    d2:6a:2c:6c:6a:52:f1:37:72:3a:1b:49:45:f4:3b:
                    84:06:6d:3a:bb:00:b5:dd:ae:38:ba:a5:67:ba:2b:
                    b5:f4:f6:f4:59:96:49:d3:69:95:29:aa:11:3e:15:
                    3a:7d:16:d1:cd:ac:b6:68:b5:2e:05:17:9e:b9:a0:
                    ea:20:6b:44:09:d8:11:7e:17:c9:4a:bd:1b:b7:41:
                    88:a0:58:12:57:27:22:37:c5:e2:35:82:0a:5b:6e:
                    a4:c4:1b:81:ce:f8:a3:aa:28:0f:05:d5:6a:33:a0:
                    db:b6:72:fe:6c:01:7b:e3:39:1d:7c:e4:11:09:fc:
                    71:d3:df:67:f5:c7:78:19:30:65:82:41:f2:45:fd:
                    21:df:46:9c:64:a1:9b:40:30:0c:72:19:ce:83:49:
                    41:ff:21:c0:3e:89:b1:b3:bf:ed:a8:3a:c7:aa:ee:
                    ad:8e:08:5d:8e:f5:57:90:de:46:9c:b6:0e:71:c5:
                    48:f1:75
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Client Authentication, TLS Web Server Authentication
            X509v3 Subject Alternative Name:
                DNS:smallworld.example.org, DNS:smallworld, DNS:localhost, DNS:127.0.0.1
            X509v3 Authority Key Identifier:
                C5:22:19:49:C8:ED:11:D8:7C:52:94:9C:C1:9C:46:C7:E8:A5:81:FC
            X509v3 Subject Key Identifier:
                0E:00:50:7F:4B:1E:D3:46:FC:AC:50:F7:4E:9D:EE:30:60:ED:BF:BD
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        a3:aa:0a:47:79:b9:65:96:04:69:86:f8:1b:af:08:9c:cb:a1:
        6b:a7:0e:0c:30:8b:3b:c9:2d:e4:9f:cd:70:72:b2:e7:3b:cc:
        42:b8:df:4b:4c:73:52:fc:e0:5c:96:fb:8f:ca:1a:40:3f:e9:
        d4:63:66:7b:a3:aa:f8:71:4d:e1:cd:22:85:c6:1f:a9:3c:bb:
        e7:41:ba:cf:1e:b6:37:29:e4:54:2e:55:9e:80:14:59:f8:c5:
        95:8f:f3:63:b8:77:06:ef:aa:c6:b4:c2:29:3c:1b:f6:58:53:
        ed:d5:73:8d:f2:bc:25:a9:9e:13:cc:09:cd:66:5d:14:c5:53:
        1a:f7:7a:e7:8b:b7:72:61:62:a0:e4:24:32:51:cd:dd:74:53:
        16:c2:82:4c:aa:f8:63:3f:9f:c5:e6:01:2a:b1:d1:93:3d:6d:
        94:56:a3:67:e6:af:85:d4:c0:f5:e9:85:6a:e1:e3:3b:ce:01:
        45:aa:25:0b:c3:e9:66:fc:12:5b:65:1e:db:f3:d4:f2:7a:f5:
        76:77:6f:20:f9:02:c3:3a:23:02:14:33:60:7e:32:b1:dd:27:
        26:b6:0c:b4:d7:5e:8a:86:f8:0c:f1:40:f4:be:07:14:8e:3a:
        31:be:06:06:b9:ea:9e:40:13:6d:ac:73:ce:1e:84:e0:de:6d:
        83:ed:e1:27:dd:cc:b2:52:b1:54:25:87:d7:cf:f4:03:b6:c2:
        f6:ce:6b:0f:a0:5c:14:02:ef:7e:19:ef:3e:c3:e3:b4:9f:b7:
        2f:94:6f:ed:19:6a:d0:0a:af:ed:10:e5:cf:87:2c:ed:b4:3d:
        2a:6e:a3:f8:78:e0:92:57:c8:53:ac:78:98:75:90:a6:d2:a3:
        cb:36:ca:6a:87:7d:b6:b8:ce:2b:8d:23:5c:54:41:09:ff:32:
        1b:6f:85:c3:23:ec:66:4a:85:8f:63:c3:38:38:3a:97:4a:3c:
        ec:0e:37:7a:2d:c4:01:de:53:6e:51:09:fc:54:97:13:9c:56:
        21:26:e3:96:b1:86:7c:95:d9:fe:3d:f3:83:eb:c8:a0:26:06:
        0d:72:f8:3c:9e:e5:8f:7e:1d:fe:a7:23:02:53:05:ba:33:d9:
        ac:77:7b:74:2e:d2:a2:f7:0f:8f:2c:91:62:bc:6c:46:14:36:
        f1:08:42:53:f5:0c:27:5b:1e:46:45:90:d7:ad:b9:9d:20:08:
        1e:9a:4d:26:17:e4:d7:64:61:24:ce:26:86:b3:17:2c:03:e7:
        ad:c1:72:24:d3:27:56:aa:ab:96:0e:4c:bf:50:b7:2e:e5:29:
        5a:67:70:cd:29:e7:53:a6:16:fe:9d:e5:ea:22:82:7c:a0:0c:
        c3:26:11:a5:da:ac:a7:0d

(admin PS) C:\opt\sw\src\repos\swmfs-tools>
```

### Command description

```text
(admin PS) C:\opt\sw\src\repos\swmfs-tools> .\create-certs.ps1 -help

NAME
    C:\opt\sw\src\repos\swmfs-tools\create-certs.ps1

SYNOPSIS
    Create certificates for secure swmfs communication


SYNTAX
    C:\opt\sw\src\repos\swmfs-tools\create-certs.ps1 [-hostname <String>] [-domainname <String>] [-CASubject <String>] [-CAKeyLength <Int32>] [-KeyLength <Int32>] [-subject
    <String>] [-months <Int32>] [-detail] [<CommonParameters>]

    C:\opt\sw\src\repos\swmfs-tools\create-certs.ps1 -help [<CommonParameters>]


DESCRIPTION
    This tool will create a .pem, .key and .pfx file suitable for use with swmfs. By default it will create a certificate for the current machine or a named machine.
    See -help for full details and examples


PARAMETERS
    -hostname <String>
        (string) hostname for certificate (defaults to $env:computername)

        Required?                    false
        Position?                    named
        Default value                $env:computername
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -domainname <String>
        (string) domainname for certificate (defaults to $env:userdnsdomain)

        Required?                    false
        Position?                    named
        Default value                $env:userdnsdomain
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -CASubject <String>
        (string) CA Subject for certificate (defaults to CN=MyRootCA,O=MyRootCA,OU=MyRootCA)

        Required?                    false
        Position?                    named
        Default value                CN=MyRootCA,O=MyRootCA,OU=MyRootCA
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -CAKeyLength <Int32>
        (integer) key length for ca certificate. accetable values are 2048 or 4096 only (defaults to 2048)

        Required?                    false
        Position?                    named
        Default value                2048
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -KeyLength <Int32>
        (integer) key length for certificate. accetable values are 2048 or 4096 only (defaults to 2048)

        Required?                    false
        Position?                    named
        Default value                2048
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -subject <String>
        (string) Subject for certificate (defaults to CN=swmfs)

        Required?                    false
        Position?                    named
        Default value                CN=swmfs
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -months <Int32>
        (integer) number of months for certificate (defaults to 36)

        Required?                    false
        Position?                    named
        Default value                36
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -detail [<SwitchParameter>]

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -help [<SwitchParameter>]
        (switch) list arguments and examples

        Required?                    true
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

NOTES


        Pre-requisites: this tool requires a standalone install of openssl

    -------------------------- EXAMPLE 1 --------------------------

    PS > # Create certificates for current machine
    .\create-certs.ps1






    -------------------------- EXAMPLE 2 --------------------------

    PS > # Create certificates for current machine with increased keysize
    .\create-certs.ps1 -keylength 4096






    -------------------------- EXAMPLE 3 --------------------------

    PS > # Create certificates for named machine smallworld.example.org
    .\create-certs.ps1 -hostname smallworld -domainname example.org






    -------------------------- EXAMPLE 4 --------------------------

    PS > # Create certificates for named machine smallworld.example.org and display details of pem file in human readable format
    .\create-certs.ps1 -hostname smallworld -domainname example.org -details
    #
    .\create-certs.ps1 -hostname smallworld -domainname example.org -verbose






    -------------------------- EXAMPLE 5 --------------------------

    PS > # Create certificates for named machine smallworld.example.org with higher strength key length
    .\create-certs.ps1 -host smallworld -domain example.org -cakeylen 4096






    -------------------------- EXAMPLE 6 --------------------------

    PS > # Create certificates for named machine smallworld.example.org for 120 months
    .\create-certs.ps1 -hostname smallworld -domainname example.org -months 120






    -------------------------- EXAMPLE 7 --------------------------

    PS > # List arguments and examples
    #
    .\create-certs.ps1 -help
    #
    Get-Help .\create-certs.ps1 -examples







RELATED LINKS
    https://github.com/OpenSmallworld/swmfs-tools
    https://github.build.ge.com/105007530/swmfs-tools.git
    https://github.com/OpenSmallworld/swmfs-tools
    https://github.build.ge.com/105007530/swmfs-tools.git
```

## swmfs-test.ps1

Generate a swmfs support "bundle".
Use `.\swmfs-test.ps1 -help` for full details and examples

### Usage

```powershell
PS C:\opt\sw\src\repos\swmfs-tools> .\swmfs-test.ps1 -help

NAME
    C:\opt\sw\src\repos\swmfs-tools\swmfs-test.ps1

SYNOPSIS


SYNTAX
    C:\opt\sw\src\repos\swmfs-tools\swmfs-test.ps1 [[-sw_root] <String>] [[-pathname] <String>] [[-filename] <String>] [[-test_length] <String>] [[-trace_level] <Int32>] [[-mdb_trace_level] <Int32>] [-no_git_check] [-help] [<CommonParameters>]


DESCRIPTION
    Generate a swmfs based support bundle


PARAMETERS
    -sw_root <String>
        (string) root of a 5.x installation

        Required?                    false
        Position?                    1
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -pathname <String>
        (string) pathname of a remote directory. can be unc or drive based path (if swmfs is running locally). host-qualified pathnames are not supported

        Required?                    false
        Position?                    2
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -filename <String>
        (string) filename to test

        Required?                    false
        Position?                    3
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -test_length <String>
        (string) test length as recognised by swmfs_test 23. default value is '10s'

        Required?                    false
        Position?                    4
        Default value                10s
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -trace_level <Int32>
        (integer) swmfs_trace level. default value is 0 (disabled)

        Required?                    false
        Position?                    5
        Default value                0
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -mdb_trace_level <Int32>
        TODO: possibly validate predefined valies i.e. 0, 192, 255 etc

        Required?                    false
        Position?                    6
        Default value                0
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -no_git_check [<SwitchParameter>]
        (switch) do not check for git repo changes

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -help [<SwitchParameter>]
        (switch) Display full help and examples

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

NOTES


        TODO: work with 4.x based installation

    -------------------------- EXAMPLE 1 --------------------------

    PS > # generate a swmfs support bundle using a UNC pathname
    .\swmfs_test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname \\server-name\path\to\ds\ds_gis -filename gdb.ds






    -------------------------- EXAMPLE 2 --------------------------

    PS > # generate a swmfs support bundle using a UNC pathname including swmfs_trace logging for the duration of the tests
    # trace levels are 1 to 3 as normal, plus level 0 is disabled (default)
    .\swmfs_test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname \\server-name\path\to\ds\ds_gis -filename gdb.ds -trace 2





    
    -------------------------- EXAMPLE 3 --------------------------

    PS > # generate a swmfs support bundle using a local pathname. note: this only works on a swmfs server directly
    .\swmfs-test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin -filename ace.ds







RELATED LINKS
    https://github.build.ge.com/105007530/swmfs-tools.git
    https://github.com/OpenSmallworld/swmfs-tools
    https://github.build.ge.com/105007530/swmfs-tools.git
    https://github.com/OpenSmallworld/swmfs-tools

PS C:\opt\sw\src\repos\swmfs-tools> 
```

### Examples

```powershell
PS > # generate a swmfs support bundle using a UNC pathname
.\swmfs-test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname \\server-name\path\to\ds\ds_gis -filename gdb.ds

PS > # generate a swmfs support bundle using a UNC pathname including swmfs_trace logging for the duration of the tests
# trace levels are 1 to 3 as normal, plus level 0 is disabled (default)
.\swmfs-test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname \\server-name\path\to\ds\ds_gis -filename gdb.ds -trace 2

PS > # generate a swmfs support bundle using a local pathname. note: this only works on a swmfs server directly

PS C:\opt\sw\src\repos\swmfs-tools> .\swmfs-test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin -filename ace.ds
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 13 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds
VERBOSE: ping localhost -n 10 -l 4096
VERBOSE: ipconfig /all
VERBOSE: tracert localhost
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 15 localhost
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_lock_monitor.exe localhost
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_monitor.exe localhost
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 13 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 23 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10s 100:#
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 23 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10s 0
VERBOSE: output to swmfs_test_20231026T212128.log
PS C:\opt\sw\src\repos\swmfs-tools> 

PS > # generate a swmfs support bundle using a local pathname including swmfs_trace output. note: this only works on a swmfs server directly

PS C:\opt\sw\src\repos\swmfs-tools> .\swmfs-test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin -filename ace.ds -trace 2
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 13 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds
VERBOSE: ping localhost -n 10 -l 4096
VERBOSE: ipconfig /all
VERBOSE: tracert localhost
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 15 localhost
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_lock_monitor.exe localhost
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_monitor.exe localhost
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 13 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 23 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10s 100:#
VERBOSE: c:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 23 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10s 0
VERBOSE: output to swmfs_test_20231026T212128.log
VERBOSE: retrieve swmfs_trace output...
PS C:\opt\sw\src\repos\swmfs-tools> 
```
