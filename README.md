# PSharp
Powershell functions to ease the creation of C# files

## Synopsis

Powershell commands to manipulate .cs files

## Code Example

```powershell
New-PSharp -Path <path> -FileName <filename>
```
```powershell
New-PSharp -Path <path> -FileName <filename> -Using System.Windows.Forms
```
```powershell
Update-PSharp -Path <path> -FileName <filename> -UpdateString <NewClassName> -UpdateSection 'Class'
```

## Motivation

I love PowerShell and wanted a way to manipulate my .cs files.

## Installation

1. Import the module into PowerShell
```powershell
Import-Module <PathTo.psm1>
```
