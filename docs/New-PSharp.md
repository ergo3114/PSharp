---
external help file: PSharp-help.xml
online version: 
schema: 2.0.0
---

# New-PSharp

## SYNOPSIS
Creates new C# file

## SYNTAX

```
New-PSharp [[-Path] <String>] [-FileName] <String> [[-UsingStatements] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Creates C# files from the given parameters

## EXAMPLES

### Example 1
```
PS C:\> New-PSharp -Path .\pathtoproject -FileName newcs
```

## PARAMETERS

### -FileName
Name of the file to be created. This is also the name of the C# class inside the file.

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
Directory that the file should be created in.

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

### -UsingStatements
Optional using statements to be included in the output.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
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
Author: C. David Littlejohn

## RELATED LINKS

