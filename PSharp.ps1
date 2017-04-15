function New-PSharp {
    [CmdletBinding()]
    Param(
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$FileName,
        [string[]]$UsingStatements
    )
    BEGIN {
        if($Path.Substring($Path.Length-1, 1) -ne "\"){
            if([System.IO.Path]::GetExtension($FileName)){
                $file = Join-Path -Path $Path -ChildPath $FileName
            } else{
                $file = Join-Path -Path $Path -ChildPath "$FileName.cs"
            }
        } else {
            if([System.IO.Path]::GetExtension($FileName)){
                $file = Join-Path -Path $Path.Substring(0, $Path.Length-1) -ChildPath  $FileName
            } else{
                $file = Join-Path -Path $Path.Substring(0, $Path.Length-1) -ChildPath  "$FileName.cs"
            }
        }
    }
    PROCESS {
        if(Test-Path -Path $file){
            Write-Error "File already exists. Choose another file name."
            return
        }else {
            New-Item -Path $file -ItemType File -Force | Out-Null
            if($UsingStatements){
                $using = New-Object System.Collections.ArrayList($null)
                for($i = 0; $i -lt $UsingStatements.Count; $i++){
                    #not working yet
                    $using.Add("using $($UsingStatements[$i]);")
                }
            }
            $csContent = @"
using System;
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
function Update-PSharp{
    [CmdletBinding()]
    Param(
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$FileName,
        [Parameter(Mandatory=$true)]
        [string]$UpdateString,
        [Parameter(Mandatory=$true)]
        [ValidateSet("Using","Namespace","Class","Method")]
        [switch]$UpdateSection
    )
    BEGIN {
        if($Path.Substring($Path.Length-1, 1) -ne "\"){
            if([System.IO.Path]::GetExtension($FileName)){
                $file = Join-Path -Path $Path -ChildPath $FileName
            } else{
                $file = Join-Path -Path $Path -ChildPath "$FileName.cs"
            }
        } else {
            if([System.IO.Path]::GetExtension($FileName)){
                $file = Join-Path -Path $Path.Substring(0, $Path.Length-1) -ChildPath  $FileName
            } else{
                $file = Join-Path -Path $Path.Substring(0, $Path.Length-1) -ChildPath  "$FileName.cs"
            }
        }
    }
    PROCESS {
        if(Test-Path -Path $file){
            #work with the updating of 
            $UpdateSection = $UpdateSection.ToString().ToLower()
            switch ($UpdateSection) {
                "using" {  }
                "namespace" {  }
                "class" {  }
                "method" {  }
                Default {}
            }
        } else{
            Write-Error "File does not exist. Create a new .cs using New-PSharp."
        }
    }
    END {}
}
#New-PSharp -Path C:\Users\David\Downloads\test -FileName Testing6
New-PSharp -Path C:\Users\David\Downloads\test -FileName testing10 -UsingStatements "System.Windows.Forms"