---
external help file: PSWinSetup-help.xml
Module Name: PSWinSetup
online version: https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-WindowsDefenderExclusions.md
schema: 2.0.0
---

# Add-WindowsDefenderExclusions

## SYNOPSIS
This function add Windows defender exclusions.

## SYNTAX

```
Add-WindowsDefenderExclusions [[-ProcessesPaths] <String[]>] [[-ProcessesList] <String[]>]
 [[-FoldersPaths] <String[]>] [[-FoldersList] <String[]>] [[-FilesList] <String[]>]
 [[-ExtensionsList] <String[]>]
```

## DESCRIPTION
This function in details adds exclusions for:
* specified processes,
* specified folders,
* specified files,
* specified extensions.
The primary aim is to improve developer machine performance.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ProcessesPaths
Paths where specified processess should be search for.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: ( ${env:ProgramFiles(x86)}, $env:ProgramW6432 )
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessesList
Processess to exclude within Windows Defender.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: ( 'msbuild.exe', 'devenv.exe', 'sqlcmd.exe', 'sqllocaldb.exe', 'sqlservr.exe', 'sqlwriter.exe')
Accept pipeline input: False
Accept wildcard characters: False
```

### -FoldersPaths
Paths where specified folders should be search for.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: ( $env:USERPROFILE )
Accept pipeline input: False
Accept wildcard characters: False
```

### -FoldersList
Folders to exclude within Windows Defender.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: ( 'MyProjects', '.nuget', '.babun' )
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilesList
Files to exclude within Windows Defender.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: C:\pagefile.sys
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensionsList
File extensions to exclude within Windows Defender.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: ( 'config', 'cs' , 'ldf', 'lnk', 'mdf', 'ttf', 'txt', 'xml', 'log' )
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-WindowsDefenderExclusions.md](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-WindowsDefenderExclusions.md)

[https://github.com/a4099181/vagrant-provvin/blob/master/modules/defender.psm1](https://github.com/a4099181/vagrant-provvin/blob/master/modules/defender.psm1)

[https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-exclusions-microsoft-defender-antivirus?view=o365-worldwide](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-exclusions-microsoft-defender-antivirus?view=o365-worldwide)

