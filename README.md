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

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/7envtm62lymipy9h/branch/master?svg=true)](https://ci.appveyor.com/project/ergo3114/psharp/branch/master)

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/7envtm62lymipy9h/branch/dev?svg=true)](https://ci.appveyor.com/project/ergo3114/psharp/branch/dev)


## Motivation

I love PowerShell and wanted a way to manipulate my .cs files.

## Installation

1. Import the module into PowerShell
```powershell
Import-Module <PathTo.psm1>
```
