---
external help file: PSWinSetup-help.xml
Module Name: PSWinSetup
online version: https://github.com/TheTaylorLee/AdminToolbox
schema: 2.0.0
---

# Invoke-Unzip

## SYNOPSIS

## SYNTAX

```
Invoke-Unzip [[-zipfile] <String>] [[-outpath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Provides robust zip file extraction by attempting 3 possible methods.

## EXAMPLES

### EXAMPLE 1
```
Extracts folder.zip to c:\folder
Invoke-Unzip -zipfile c:\folder.zip -outpath c:\folder
```

## PARAMETERS

### -zipfile
Specify the zipfile location and name

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

### -outpath
Specify the extract path for extracted files

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/TheTaylorLee/AdminToolbox](https://github.com/TheTaylorLee/AdminToolbox)

