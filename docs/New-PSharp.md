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
New-PSharp [[-Path] <String>] [-FileName] <String> [[-UsingStatements] <String[]>]
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

## INPUTS

### None


## OUTPUTS

### System.Object

## NOTES
Author: C. David Littlejohn

## RELATED LINKS

