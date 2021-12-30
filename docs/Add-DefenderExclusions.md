---
external help file: PSWinSetup-help.xml
Module Name: PSWinSetup
online version: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-exclusions-microsoft-defender-antivirus?view=o365-worldwide
schema: 2.0.0
---

# Add-DefenderExclusions

## SYNOPSIS
This function detects and applies various Windows defender exclusions.

## SYNTAX

```
Add-DefenderExclusions
```

## DESCRIPTION
This function adds exclusions for:
* node.exe
* git.exe
* gitkraken.exe
* devenv.exe
* code.exe / code-insiders.exe
* ~/Dev/*
* %APPDATA%\npm
* %APPDATA%\npm-cache
* ~/.dotfiles
* ~/scoop
* %PROGRAMDATA%\scoop
* %PROGRAMDATA%\chocolatey
* %PROGRAMDATA%\DockerDesktop
* %PROGRAMDATA%\nvm
* %PROGRAMDATA%\ssh
The primary aim is to improve developer machine performance.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-exclusions-microsoft-defender-antivirus?view=o365-worldwide](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-exclusions-microsoft-defender-antivirus?view=o365-worldwide)

