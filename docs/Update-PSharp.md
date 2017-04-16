---
external help file: PSharp-help.xml
online version: 
schema: 2.0.0
---

# Update-PSharp

## SYNOPSIS
Updates sections of a .cs file

## SYNTAX

```
Update-PSharp [[-Path] <String>] [-FileName] <String> [-UpdateString] <String[]> [-UpdateSection] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Update using statements, namespaces, classes, and methods.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -FileName
{{Fill FileName Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{Fill Path Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateSection
{{Fill UpdateSection Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: Using, Namespace, Class, Method

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateString
{{Fill UpdateString Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

