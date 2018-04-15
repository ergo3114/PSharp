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

[![Build status](https://ci.appveyor.com/api/projects/status/7envtm62lymipy9h?svg=true)](https://ci.appveyor.com/project/ergo3114/psharp)

## Tests

### master

[![Tests status](https://appveyor-shields-badge.herokuapp.com/api/api/testResults/ergo3114/7envtm62lymipy9h/badge.svg)](https://ci.appveyor.com/project/ergo3114/7envtm62lymipy9h)

## Motivation

I love PowerShell and wanted a way to manipulate my .cs files.

## Installation

1. Import the module into PowerShell
```powershell
Import-Module <PathTo.psm1>
```
