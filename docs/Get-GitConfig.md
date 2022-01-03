---
external help file: PSWinSetup-help.xml
Module Name: PSWinSetup
online version:
schema: 2.0.0
---

# Get-GitConfig

## SYNOPSIS
Get git configuration settings

## SYNTAX

### default (Default)
```
Get-GitConfig [[-Scope] <String[]>] [<CommonParameters>]
```

### file
```
Get-GitConfig [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION
Git stores configurations settings in a simple text file format.
Fortunately, this file is structured and predictable.
This command will process git configuration information into PowerShell friendly output.

## EXAMPLES

### EXAMPLE 1
```
Get-GitConfig
   
Scope  Category  Name         Setting
-----  --------  ----         -------
global filter    lfs          git-lfs clean -- %f
global filter    lfs          git-lfs smudge -- %f
global filter    lfs          true
global user      name         Art Deco
global user      email        artd@company.com
global gui       recentrepo   C:/Scripts/Gen2Tools
global gui       recentrepo   C:/Scripts/PSVirtualBox
global gui       recentrepo   C:/Scripts/FormatFunctions
global core      editor       powershell_ise.exe
global core      autocrlf     true
global core      excludesfile ~/.gitignore
global push      default      simple
global color     ui           true
global alias     logd         log --oneline --graph --decorate
global alias     last         log -1 HEAD
global alias     pushdev      !git checkout master && git merge dev && git push && git checkout dev
global alias     st           status
global alias     fp           !git fetch && git pull
global merge     tool         kdiff3
global mergetool kdiff3       'C:/Program Files/KDiff3/kdiff3.exe' $BASE $LOCAL $REMOTE -o $MERGED
Getting global configuration settings
```

### EXAMPLE 2
```
Get-GitConfig -scope system | where category -eq 'filter'
Scope  Category Name Setting
-----  -------- ---- -------
system filter   lfs  git-lfs clean -- %f
system filter   lfs  git-lfs smudge -- %f
system filter   lfs  git-lfs filter-process
system filter   lfs  true
Get system configuration and only git filters.
```

### EXAMPLE 3
```
Get-GitConfig -path ~\.gitconfig | format-table -groupby category -property Name,Setting
Get settings from a configuration file and present in a grouped, formatted table.
```

## PARAMETERS

### -Scope
Possible values are Global,Local or System

```yaml
Type: System.String[]
Parameter Sets: default
Aliases:

Required: False
Position: 1
Default value: Global
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Enter the path to a .gitconfig file.
You can use shell paths like ~\.gitconfig

```yaml
Type: System.String
Parameter Sets: file
Aliases: config

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### none
## OUTPUTS

### [pscustomobject]
## NOTES
The command assumes you have git installed.
Otherwise, why would you be using this?
Last updated: 11 May, 2018

## RELATED LINKS

[git]()

