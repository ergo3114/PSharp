function New-PSharp {
    [CmdletBinding()]
    Param(
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$FileName,
        [string[]]$UsingStatements
    )
    BEGIN {
        if ($Path.Substring($Path.Length - 1, 1) -ne "\") {
            if ([System.IO.Path]::GetExtension($FileName)) {
                $file = Join-Path -Path $Path -ChildPath $FileName
            }
            else {
                $file = Join-Path -Path $Path -ChildPath "$FileName.cs"
            }
        }
        else {
            if ([System.IO.Path]::GetExtension($FileName)) {
                $file = Join-Path -Path $Path.Substring(0, $Path.Length - 1) -ChildPath  $FileName
            }
            else {
                $file = Join-Path -Path $Path.Substring(0, $Path.Length - 1) -ChildPath  "$FileName.cs"
            }
        }
    }
    PROCESS {
        if (Test-Path -Path $file) {
            Write-Error "File already exists. Choose another file name."
            return
        }
        else {
            New-Item -Path $file -ItemType File -Force | Out-Null
            if ($UsingStatements) {
                [string]$using = $null
                foreach ($i in $UsingStatements) {
                    if($i -notlike "*System;" -and $i -notlike "*System.Windows;"){
                        if ($i -notlike "*;") {$i = "$i;"}
                        if ($i -notlike "using*") {$i = "using $i"}
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
    static void Main(string[] args)
    {
    
    }
}
"@
            Set-Content -Path $file -Value $csContent
        }
    }
    END {}
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
        [ValidateSet("Using", "Namespace", "Class", "Method")]
        [string]$UpdateSection
    )
    BEGIN {
        if ($Path.Substring($Path.Length - 1, 1) -ne "\") {
            if ([System.IO.Path]::GetExtension($FileName)) {
                $file = Join-Path -Path $Path -ChildPath $FileName
            }
            else {
                $file = Join-Path -Path $Path -ChildPath "$FileName.cs"
            }
        }
        else {
            if ([System.IO.Path]::GetExtension($FileName)) {
                $file = Join-Path -Path $Path.Substring(0, $Path.Length - 1) -ChildPath  $FileName
            }
            else {
                $file = Join-Path -Path $Path.Substring(0, $Path.Length - 1) -ChildPath  "$FileName.cs"
            }
        }
    }
    PROCESS {
        if (Test-Path -Path $file) {
            $regex = [regex] '^using\w+;'
            #work with the updating of cs file
            $UpdateSection = $UpdateSection.ToString().ToLower()
            switch ($UpdateSection) {
                "using" {
                    foreach ($i in $UpdateString) {
                        if ($i -notlike "*;") {$i = "$i;"}
                        if ($i -notlike "using*") {$i = "using $i"}
                        $original = Get-Content $file
                        if ($original -notcontains $i) {
                            $pos = [array]::IndexOf($original, $original -match $regex)
                            $newLine = $original[0..($pos - 1)], $i, $original[$pos..($original.Length - 1)]
                            $newLine | Set-Content $file
                        }
                    }
                }
                "namespace" {
                    #not working yet 
                }
                "class" {
                    #not working yet
                }
                "method" {
                    #not working yet
                }
                Default { }
            }
        }
        else {
            Write-Error "File does not exist. Create a new .cs using New-PSharp."
        }
    }
    END {}
}
function Find-Namespace {

}
#New-PSharp -Path C:\Users\David\Downloads\test -FileName Testing6
#New-PSharp -Path C:\Users\David\Downloads\test -FileName testing$(Get-Random) -UsingStatements "System.Windows.Forms", "System.Diagostics", "System.Automation"
#Export-ModuleMember -Function New-PSharp