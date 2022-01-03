---
external help file: PSWinSetup-help.xml
Module Name: PSWinSetup
online version:
schema: 2.0.0
---

# Backup-HyperV

## SYNOPSIS
Hyper-V Backup Utility - Flexible backup of Hyper-V Virtual Machines.

## SYNTAX

```
Backup-HyperV [-Backup] <Object> [[-History] <Object>] [[-VmList] <Object>] [[-WorkDir] <Object>]
 [[-SzSwitches] <Object>] [[-LogPath] <Object>] [[-MailSubject] <Object>] [[-MailTo] <Object>]
 [[-MailFrom] <Object>] [[-SmtpServer] <Object>] [[-SmtpPort] <Object>] [[-SmtpUser] <Object>]
 [[-SmtpPwd] <Object>] [-UseSsl] [-NoPerms] [-Compress] [-Sz] [-ShortDate] [-NoBanner] [<CommonParameters>]
```

## DESCRIPTION
This script will create a full backup of virtual machines, complete with configuration, snapshots/checkpoints, and VHD files.
This script should be run on a Hyper-V host and the Hyper-V PowerShell management modules should be installed.
To send a log file via e-mail using ssl and an SMTP password you must generate an encrypted password file.
The password file is unique to both the user and machine.
To create the password file run this command as the user and on the machine that will use the file:
$creds = Get-Credential
$creds.Password | ConvertFrom-SecureString | Set-Content C:\scripts\ps-script-pwd.txt

## EXAMPLES

### EXAMPLE 1
```
Hyper-V-Backup.ps1 -BackupTo \\nas\vms -List C:\scripts\vms.txt -Wd E:\temp -NoPerms -Keep 30 -Compress -Sz
-SzOptions '-t7z,-v2g,-ppassword' -L C:\scripts\logs -Subject 'Server: Hyper-V Backup' -SendTo me@contoso.com
-From hyperv@contoso.com -Smtp smtp.outlook.com -User user -Pwd C:\scripts\ps-script-pwd.txt -UseSsl
This will shutdown, one at a time, all the VMs listed in the file located in C:\scripts\vms.txt and back up
their files to \\nas\vms, using E:\temp as a working directory. A .7z file for each VM folder will be created using
7-zip. 7-zip will use 8 threads, medium compression and split the files in 2GB volumes. Any backups older than 30 days
will also be deleted. The log file will be output to C:\scripts\logs and sent via e-mail with a custom subject line.
```

## PARAMETERS

### -Backup
{{ Fill Backup Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: BackupTo

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -History
{{ Fill History Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: Keep

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VmList
{{ Fill VmList Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: List

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkDir
{{ Fill WorkDir Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: Wd

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SzSwitches
{{ Fill SzSwitches Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: SzOptions

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogPath
{{ Fill LogPath Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: L

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailSubject
{{ Fill MailSubject Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: Subject

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailTo
{{ Fill MailTo Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: SendTo

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailFrom
{{ Fill MailFrom Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: From

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpServer
{{ Fill SmtpServer Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: Smtp

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpPort
{{ Fill SmtpPort Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: Port

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpUser
{{ Fill SmtpUser Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: User

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpPwd
{{ Fill SmtpPwd Description }}

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases: Pwd

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSsl
Configures the utility to connect to the SMTP server using SSL.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoPerms
Configures the utility to shut down the running VM(s) to do the file-copy based backup instead of using the Hyper-V export function.
If no list is specified and multiple VMs are running, the process will run through the VMs alphabetically.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Compress
This option will create a zip file of each Hyper-V VM backup.
Available disk space should be considered when using this option.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sz
Configure the utility to use 7-Zip to compress the VM backups.
7-Zip must be installed in the default location ($env:ProgramFiles) if it is not found, Windows compression will be used as a fallback.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShortDate
Configure the script to use only the Year, Month and Day in backup filenames.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoBanner
Use this option to hide the ASCII art title in the console.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
