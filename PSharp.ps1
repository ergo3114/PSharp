﻿function New-PSharp {
    [CmdletBinding()]
    Param(
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$FileName,
        [string[]]$UsingStatements
    )
    BEGIN {
        Write-Verbose "[START] $($MyInvocation.MyCommand)"
        if ($Path.Substring($Path.Length - 1, 1) -ne "\") {
            if ([System.IO.Path]::GetExtension($FileName)) {
                $file = Join-Path -Path $Path -ChildPath $FileName
                Write-Verbose "[BEGIN] File to be created is $file"
            }
            else {
                $file = Join-Path -Path $Path -ChildPath "$FileName.cs"
                Write-Verbose "[BEGIN] File to be created is $file"
            }
        }
        else {
            if ([System.IO.Path]::GetExtension($FileName)) {
                $file = Join-Path -Path $Path.Substring(0, $Path.Length - 1) -ChildPath  $FileName
                Write-Verbose "[BEGIN] File to be created is $file"
            }
            else {
                $file = Join-Path -Path $Path.Substring(0, $Path.Length - 1) -ChildPath  "$FileName.cs"
                Write-Verbose "[BEGIN] File to be created is $file"
            }
        }
    }
    PROCESS {
        Write-Verbose "[PROCESS] Checking to see if $file already exists"
        if (Test-Path -Path $file) {
            Write-Error "File already exists. Choose another file name."
            return
        }
        else {
            Write-Verbose "[PROCESS] $file is being created"
            New-Item -Path $file -ItemType File -Force | Out-Null
            if ($UsingStatements) {
                Write-Verbose "[PROCESS] Handling the using statements provided by the user"
                [string]$using = $null
                foreach ($i in $UsingStatements) {
                    if ($i -notlike "*;") {$i = "$i;"}
                    if ($i -notlike "using*") {$i = "using $i"}
                    if ($i -notlike "*System;" -and $i -notlike "*System.Windows;*") {
                        Write-Verbose "[PROCESS] Using statement: $i"
                        $using += "$i$([Environment]::NewLine)"
                    }
                }
            }
            $csContent = @"
using System;
using System.Windows;
$using

class $($(Get-Item $file).BaseName)
{
    static void Main(string[] args){
        
    }
    public PublicMethod(){
        
    }
    private PrivateMethod(){
        
    }
    protected ProtectedMethod(){
        
    }
}
"@
            Write-Verbose "[PROCESS] Setting contents of $file"
            Set-Content -Path $file -Value $csContent
        }
    }
    END {
        Write-Verbose "[END] Completed $($MyInvocation.MyCommand)"
    }
}
function Update-PSharp {
    [CmdletBinding()]
    Param(
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$FileName,
        [Parameter(Mandatory = $true)]
        [string[]]$UpdateString,
        [Parameter(Mandatory = $true)]
        [ValidateSet("Using", "Namespace", "Class")]
        [string]$UpdateSection
    )
    BEGIN {
        Write-Verbose "[START] $($MyInvocation.MyCommand)"
        if ($Path.Substring($Path.Length - 1, 1) -ne "\") {
            if ([System.IO.Path]::GetExtension($FileName)) {
                $file = Join-Path -Path $Path -ChildPath $FileName
                Write-Verbose "[BEGIN] File to be updated is $file"
            }
            else {
                $file = Join-Path -Path $Path -ChildPath "$FileName.cs"
                Write-Verbose "[BEGIN] File to be updated is $file"
            }
        }
        else {
            if ([System.IO.Path]::GetExtension($FileName)) {
                $file = Join-Path -Path $Path.Substring(0, $Path.Length - 1) -ChildPath  $FileName
                Write-Verbose "[BEGIN] File to be updated is $file"
            }
            else {
                $file = Join-Path -Path $Path.Substring(0, $Path.Length - 1) -ChildPath  "$FileName.cs"
                Write-Verbose "[BEGIN] File to be updated is $file"
            }
        }
    }
    PROCESS {
        Write-Verbose "[PROCESS] Checking to see if $file already exists"
        if (Test-Path -Path $file) {
            Write-Verbose "[PROCESS] Checking update section"
            $UpdateSection = $UpdateSection.ToString().ToLower()
            Write-Verbose "[PROCESS] Section to be updated is $UpdateSection"
            switch ($UpdateSection) {
                "using" {
                    $regex = [regex] '^using\w+;'
                    Write-Verbose "[PROCESS][switch] $UpdateSection"
                    foreach ($i in $UpdateString) {
                        if ($i -notlike "*;") {$i = "$i;"}
                        if ($i -notlike "using*") {$i = "using $i"}
                        $original = Get-Content $file
                        Write-Verbose "[PROCESS] Checking to see if $UpdateString is already in $file"
                        if ($original -notcontains $i) {
                            Write-Verbose "[PROCESS] Inserting $UpdateString"
                            $pos = [array]::IndexOf($original, $original -match $regex)
                            Write-Verbose "[PROCESS] $UpdateString inserted at line $pos"
                            $newLine = $original[0..($pos - 1)], $i, $original[$pos..($original.Length - 1)]
                            $newLine | Set-Content $file
                            Write-Verbose "[PROCESS] $file updated"
                        }
                        else {
                            Write-Verbose "[PROCESS] Skipping $UpdateString"
                        }
                    }
                }
                "namespace" {
                    $regex = [regex] "namespace.+"
                    Write-Verbose "[PROCESS][switch] $UpdateSection"
                    $content = Get-Content $file
                    $content | ForEach-Object {
                        if ($_ -match $regex) {
                            if ($_ -like "*{") {
                                Write-Verbose "[PROCESS][switch] Formatting new namespace with { on a new line"
                                $namespace = "namespace $UpdateString$([Environment]::NewLine){"
                            }
                            else {
                                Write-Verbose "[PROCESS][switch] Formatting new namespace as is"
                                $namespace = "namespace $UpdateString"
                            }
                            $num++
                        }
                    }
                    Write-Verbose "[PROCESS][switch] $num namespace(es) found"
                    if ($num -eq 1) {
                        try {
                            $content | ForEach-Object {
                                $_ -replace $regex, $namespace
                            } | Set-Content $file -Force
                            Write-Verbose "[PROCESS][switch] $file updated"
                        } catch {
                            Write-Error "Unable to update $file"
                        }
                    }
                }
                "class" {
                    $regex = [regex] "class.+"
                    Write-Verbose "[PROCESS][switch] $UpdateSection"
                    $content = Get-Content $file
                    $content | ForEach-Object {
                        if ($_ -match $regex) {
                            if ($_ -like "*{") {
                                Write-Verbose "[PROCESS][switch] Formatting new class with { on a new line"
                                $class = "class $UpdateString$([Environment]::NewLine){"
                            }
                            else {
                                Write-Verbose "[PROCESS][switch] Formatting new class as is"
                                $class = "class $UpdateString"
                            }
                            $num++
                        }
                    }
                    Write-Verbose "[PROCESS][switch] $num class(es) found"
                    if ($num -eq 1) {
                        try {
                            $content | ForEach-Object {
                                $_ -replace $regex, $class
                            } | Set-Content $file -Force
                            Write-Verbose "[PROCESS][switch] $file updated"
                        } catch {
                            Write-Error "Unable to update $file"
                        }
                    }
                }
                Default {
                    Write-Verbose "[PROCESS][switch] Default"
                }
            }
        }
        else {
            Write-Error "File does not exist. Create a new .cs using New-PSharp."
        }
    }
    END {
        Write-Verbose "[END] Completed $($MyInvocation.MyCommand)"
    }
}
function GetCsMethods {
    [CmdletBinding()]
    Param(
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$FileName,
        [validateSet("All", "Protected", "Private", "Public")]
        [string]$MethodType = 'All'
    )
    BEGIN {
        Write-Verbose "[START] $($MyInvocation.MyCommand)"
        $dll = ".\src\PSharp.dll"
    }
    PROCESS {
        if (Test-Path $dll) {
            Write-Verbose "[PROCESS] Loading $dll"
            Add-Type -Path $dll
            $file = [System.IO.Path]::GetFullPath($(Join-Path $Path $FileName))
            switch ($MethodType) {
                'All' { 
                    Write-Verbose "[PROCESS][switch] Getting $MethodType methods"
                    [PSharp.Meta]::GetAllMethodNames($file) 
                }
                'Protected' { 
                    Write-Verbose "[PROCESS][switch] Getting $MethodType methods"
                    [PSharp.Meta]::GetProtectedMethodNames($file) 
                }
                'Private' { 
                    Write-Verbose "[PROCESS][switch] Getting $MethodType methods"
                    [PSharp.Meta]::GetPrivateMethodNames($file) 
                }
                'Public' { 
                    Write-Verbose "[PROCESS][switch] Getting $MethodType methods"
                    [PSharp.Meta]::GetPublicMethodNames($file) 
                }
                Default { 
                    Write-Verbose "[PROCESS][switch] Getting $MethodType methods"
                    [PSharp.Meta]::GetAllMethodNames($file) 
                }
            }
        }
        else {
            Write-Error "$dll not found, unable to load"
        }
    }
    END {
        Write-Verbose "[END] Completed $($MyInvocation.MyCommand)"
    }
}
function Get-CsMethods{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Type
    )
    BEGIN{
        $source = @"
using System;
using System.Collections.Generic;
using System.Reflection;
namespace PSharp
{
    public class Meta
    {
        public List<string> GetMethods(string classType){
            List<string> list = new List<string>();
            Type myType = Type.GetType(classType);
            MethodInfo[] myArrayMethodInfo = myType.GetMethods(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly);
            for (int i = 0; i<myArrayMethodInfo.Length; i++)
            {
                MethodInfo myMethodInfo = (MethodInfo)myArrayMethodInfo[i];
                Console.WriteLine(myMethodInfo.Name);
            }
            return list;
        }
    }
}
"@
        Add-Type $source
    }
    PROCESS{
        [PSharp.Meta]::GetMet
    }
    END{}
}
#Export-ModuleMember -Function *-*