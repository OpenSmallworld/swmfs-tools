# swmfs-tools

## create-certs.ps1

Create `swmfs.key`, `swmfs.pem` and `swmfs.pfx` suitable for use with secured swmfs communication. By default it will create a certificate for the current machine or a named machine which can be Linux based.
Use `.\create-certs.ps1 -help` for full details and examples

### Usage

```powershell
# Create certificates for current machine
.\create-certs.ps1

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
.\create-certs.ps1 -help
```

### Examples

```
(admin PS) C:\opt\sw\src\repos\swmfs-tools> .\create-certs.ps1 -help

NAME
    C:\opt\sw\src\repos\swmfs-tools\create-certs.ps1

SYNOPSIS
    Create certificates for secure swmfs communication


SYNTAX
    C:\opt\sw\src\repos\swmfs-tools\create-certs.ps1 [-hostname <String>] [-domainname <String>] [-CASubject <String>] [-CAKeyLength <Int32>] [-subject <String>] [-months
    <Int32>] [-detail] [<CommonParameters>]

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
        (string) CA Subject for certificate (defaults to CN=MyRootCA,O=MyRootCA,OU=MyRootCA')

        Required?                    false
        Position?                    named
        Default value                CN=MyRootCA,O=MyRootCA,OU=MyRootCA
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -CAKeyLength <Int32>
        (integer) key length for certificate. accetable values are 2048 or 4096 only (defaults to 2048)

        Required?                    false
        Position?                    named
        Default value                2048
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -subject <String>
        (string) Subject for certificate (defaults to CN=swmfs')

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

    PS > # Create certificates for named machine smallworld.example.org
    .\create-certs.ps1 -hostname smallworld -domainname example.org






    -------------------------- EXAMPLE 3 --------------------------

    PS > # Create certificates for named machine smallworld.example.org and display details of pem file in human readable format
    .\create-certs.ps1 -hostname smallworld -domainname example.org -details
    #
    .\create-certs.ps1 -hostname smallworld -domainname example.org -verbose






    -------------------------- EXAMPLE 4 --------------------------

    PS > # Create certificates for named machine smallworld.example.org with higher strength key length
    .\create-certs.ps1 -host smallworld -domain example.org -cakeylen 4096






    -------------------------- EXAMPLE 5 --------------------------

    PS > # Create certificates for named machine smallworld.example.org for 120 months
    .\create-certs.ps1 -hostname smallworld -domainname example.org -months 120






    -------------------------- EXAMPLE 6 --------------------------

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


(admin PS) C:\opt\sw\src\repos\swmfs-tools> .\create-certs.ps1 -host smallworld -domain example.org -cakeylen 4096 -months 120 -verb
VERBOSE: Creating root certiicate with subject 'CN=MyRootCA,O=MyRootCA,OU=MyRootCA' and key length 4096
VERBOSE: Creating certificate with subject 'CN=swmfs' for smallworld.example.org and smallworld
VERBOSE: Exporting certificate cert:\LocalMachine\My\5EAC5D7F8EE79284E19175FFA97A6751F97939C0
VERBOSE: Writing ./swmfs.key
VERBOSE: Writing ./swmfs.pem

Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            5e:be:08:e7:fd:cc:38:8a:4f:80:57:fa:18:d2:a7:2d
        Signature Algorithm: sha1WithRSAEncryption
        Issuer: OU = MyRootCA, O = MyRootCA, CN = MyRootCA
        Validity
            Not Before: Jul 25 06:53:28 2023 GMT
            Not After : Jul 25 07:03:28 2033 GMT
        Subject: CN = swmfs
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:b7:48:11:f0:66:22:36:64:48:64:5b:91:6e:82:
                    82:f4:0b:f9:ed:61:9a:84:4e:ab:15:59:ea:fb:7b:
                    63:71:87:b3:54:f4:4a:09:ea:b1:ab:4f:a2:22:1a:
                    dc:e4:50:3e:a6:02:c9:d8:23:8f:84:2f:0b:ed:17:
                    30:79:6b:a3:69:c4:8d:0b:04:81:cc:e7:ef:fb:14:
                    61:d5:3a:4d:26:0a:20:0e:49:51:d7:6d:04:fb:43:
                    7d:a8:42:c9:32:94:19:da:a8:d2:a8:ad:01:a0:cd:
                    6c:74:c8:54:dc:5b:3b:a8:2c:19:f2:45:35:a4:ca:
                    7d:88:06:2e:a1:03:3a:eb:f2:64:c4:5f:93:c7:4a:
                    01:82:74:bc:a0:c8:19:e0:6d:ca:a4:26:06:6b:ce:
                    f7:ee:af:48:90:89:1b:6e:da:e6:2b:82:25:53:97:
                    83:83:35:d0:c9:b9:60:2f:18:53:14:e9:82:52:9b:
                    03:db:1f:b5:05:a9:90:ed:2c:47:15:ec:e2:31:04:
                    38:f1:b8:1a:eb:97:65:71:34:7d:71:0d:ea:d8:8a:
                    18:b3:e8:fa:02:bf:00:bd:76:8c:84:fc:56:6c:46:
                    e4:d3:56:9e:0d:ad:3b:16:41:ca:d0:d2:9f:c0:5d:
                    d7:01:33:35:34:d2:2f:88:84:26:2a:ae:f8:fd:5a:
                    86:49
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Client Authentication, TLS Web Server Authentication
            X509v3 Subject Alternative Name:
                DNS:smallworld.example.org, DNS:smallworld, DNS:localhost, DNS:127.0.0.1
            X509v3 Authority Key Identifier:
                CB:43:A8:C6:1C:D8:AF:E8:22:09:CC:FE:DE:6F:2A:0C:C5:3F:46:73
            X509v3 Subject Key Identifier:
                A6:1B:B1:A9:EA:FD:F3:60:2F:87:01:5C:0A:78:D5:70:BE:95:C0:2F
    Signature Algorithm: sha1WithRSAEncryption
    Signature Value:
        ae:6f:0b:b0:df:32:3f:19:7c:1d:f7:f0:ed:15:93:ab:c2:f9:
        ee:f3:b6:1b:4e:42:e3:5d:17:75:40:b3:45:79:ab:2e:14:1d:
        58:6f:d2:d4:19:c3:1d:bf:0c:31:6a:a6:64:e3:50:23:6c:a1:
        4a:d0:41:23:ae:f7:27:c0:9f:4b:13:21:a9:67:e3:16:85:53:
        4b:75:2e:ec:01:70:6e:ae:19:6d:e6:f5:c6:d2:21:28:00:38:
        5d:e0:b9:37:f4:40:f1:16:76:83:96:19:45:96:c1:d8:ec:07:
        11:42:88:b5:cd:31:7e:17:38:70:03:27:81:ca:98:83:2c:aa:
        cf:ab:9b:7e:ba:fa:9c:78:02:05:be:7b:cc:6b:d5:80:eb:75:
        49:0e:ca:f6:c9:18:5f:60:6b:20:0a:70:df:71:4d:49:2c:24:
        5b:55:0a:e8:0f:26:ac:fc:aa:b8:c7:e5:c8:53:75:7a:47:b2:
        cf:2a:8d:92:84:c3:e3:b4:8b:31:3a:b4:2f:5b:e2:45:e8:e7:
        1b:4e:b1:43:37:13:9d:04:12:d2:70:20:ee:81:d8:9f:13:42:
        dd:0d:75:ed:82:50:db:5b:de:ee:57:9f:8f:5e:a4:04:f2:78:
        47:13:a7:48:9e:99:a4:19:c7:c3:23:ec:0b:e6:03:19:24:d2:
        a3:ee:5d:55:b1:87:84:ae:11:ff:ef:f4:35:fc:40:87:e8:8d:
        30:17:b0:87:76:fa:44:2f:d6:7a:67:ea:8d:67:c9:cf:bd:37:
        26:10:5e:db:e8:00:23:89:de:41:fe:bb:d2:20:fc:46:c6:6d:
        8f:d0:e1:24:7e:cd:6b:22:b6:d8:ab:69:db:5b:be:dd:64:8e:
        2f:c4:c5:6d:52:98:21:f9:99:1b:3b:c6:26:42:df:5e:ca:35:
        c0:95:22:d6:1e:49:b9:1b:50:d2:1d:b9:e5:84:fa:00:8b:d0:
        4b:cc:c8:c0:ac:1a:0f:46:d1:93:01:6a:65:1b:9e:f8:bd:21:
        44:45:90:87:4b:db:7a:13:63:ed:fb:bd:a8:8f:76:ce:24:79:
        dd:f6:66:2e:42:b6:2e:2f:a2:13:5d:7b:d7:a1:5b:4d:d7:ac:
        d5:dd:e0:06:0c:f9:77:bf:64:82:c6:3d:6c:3b:e8:64:6f:d0:
        7c:f9:8a:84:5c:50:86:de:f4:5f:01:a4:72:fc:67:76:7d:0d:
        8b:27:02:af:9b:c1:81:47:8a:a8:18:5f:17:14:bf:47:b7:96:
        9c:23:bb:09:d8:2a:ce:99:7f:c9:f6:18:a2:a9:7e:62:d5:23:
        43:8e:73:7d:a3:b0:47:03:7a:b6:3c:0e:bb:ae:e5:5a:5c:a9:
        db:e2:28:19:ce:d7:c8:b5

(admin PS) C:\opt\sw\src\repos\swmfs-tools>
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
    C:\opt\sw\src\repos\swmfs-tools\swmfs-test.ps1 [[-sw_root] <String>] [[-pathname] <String>] [[-filename] <String>] [[-test_length] <String>] [[-trace_level] <Int32>] [-help] [<CommonParameters>]


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
    .\swmfs-test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname \\server-name\path\to\ds\ds_gis -filename gdb.ds






    -------------------------- EXAMPLE 2 --------------------------

    PS > # generate a swmfs support bundle using a UNC pathname including swmfs_trace logging for the duration of the tests
    # trace levels are 1 to 3 as normal, plus level 0 is disabled (default)
    .\swmfs-test.ps1 -sw_root c:\opt\sw\installed\532PB -pathname \\server-name\path\to\ds\ds_gis -filename gdb.ds -trace 2






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

PS C:\opt\sw\src\repos\swmfs-tools> .\swmfs-test.ps1 -sw_root C:\opt\sw\installed\532PB -pathname C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin -filename ace.ds
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 13 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 15 localhost
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_monitor.exe localhost
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 13 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 23 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10s 100:#
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 23 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10s 0
PS C:\opt\sw\src\repos\swmfs-tools> 

PS > # generate a swmfs support bundle using a local pathname including swmfs_trace output. note: this only works on a swmfs server directly

PS C:\opt\sw\src\repos\swmfs-tools> .\swmfs-test.ps1 -sw_root C:\opt\sw\installed\532PB -pathname C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin -filename ace.ds -trace 2
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 13 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 15 localhost
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_monitor.exe localhost
VERBOSE: C:\opt\sw\installed\532PB\core\etc\x86\swmfs_trace.exe -times -local_times 2 localhost
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 13 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 23 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10s 100:#
VERBOSE: C:\opt\sw\installed\532PB\core\bin\x86\swmfs_test.exe 23 C:\opt\sw\installed\532PB\cambridge_db\ds\ds_admin ace.ds 10s 0
VERBOSE: retrieve swmfs_trace output...
PS C:\opt\sw\src\repos\swmfs-tools> 
```
