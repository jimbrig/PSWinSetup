---
external help file: PSWinSetup-help.xml
Module Name: PSWinSetup
online version: https://chocolatey.org/
schema: 2.0.0
---

# Install-Choco

## SYNOPSIS
Installs the Chocolatey Package Manager for Windows into the system.

## SYNTAX

```
Install-Choco [<CommonParameters>]
```

## DESCRIPTION
Installs Chocolatey Package Manager with the default provided installation script from Chocolatey.
Environmental variables are updated in order to use choco 
without having the restart the console host.
A powershell $PROFILE is also created (if necessary) before installation to allow the install script to add
Chocolatey's specific profile and completion to the user $PROFILE.

## EXAMPLES

### EXAMPLE 1
```
Install-Choco
Installs Chocolatey
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### An installed chocolatey package manager that is ready to use by the user.
## NOTES
- This function uses the standard way how to install Chocolatey package manager from chocolatey.org.
- This function requires admin privileges to work properly.
- This function requires a minimum of RemoteSigned Execution Policy to work properly.
- This function looks for and creates (if necessary) a default user powershell $PROFILE before running the installation script.
- This function optionally applies post-installation configurations to Chocolatey if desired.

## RELATED LINKS

[https://chocolatey.org/](https://chocolatey.org/)

