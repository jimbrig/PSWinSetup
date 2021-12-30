---
external help file: PSWinSetup-help.xml
Module Name: PSWinSetup
online version: https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-WindowsDefenderExclusions.md
schema: 2.0.0
---

# Get-AllPackageInfo

## SYNOPSIS
This function gathers information about a particular installed program from 3-4 different sources:
    - The Get-Package Cmdlet fromPowerShellGet/PackageManagement Modules
    - Chocolatey CmdLine (if it is installed)
    - Windows Registry
    - The \`Get-AppxPakcage\` cmdlet (if the -IncludeAppx switch is used)
All of this information is needed in order to determine the proper way to install/uninstall a program.

## SYNTAX

```
Get-AllPackageInfo [[-ProgramName] <String>] [-IncludeAppx] [<CommonParameters>]
```

## DESCRIPTION
See .SYNOPSIS

## EXAMPLES

### EXAMPLE 1
```
# Open an elevated PowerShell Session, import the module, and -
```

PS\> Get-AllPackageInfo -IncludeAppX

### EXAMPLE 2
```
# Open an elevated PowerShell Session, import the module, and -
```

PS\> Get-AllPackageInfo openssh

## PARAMETERS

### -ProgramName
This parameter is OPTIONAL.
This parameter takes a string that represents the name of the Program that you would like to gather information about.
The name of the program does NOT have to be exact.
For example, if you have 'python3' installed, you can simply use:
    Get-AllAvailablePackages python

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeAppx
This parameter is OPTIONAL.
This parameter is a switch.
If used, information about available Appx (UWP) packages will also be returned.

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
