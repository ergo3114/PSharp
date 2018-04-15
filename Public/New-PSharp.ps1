function New-PSharp {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0)]
        [ValidateNotNullorEmpty()]
        [string]$FileName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [string]$Path = $null,
        
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [string[]]$UsingStatements,

        [switch]$Overwrite
    )
    BEGIN {
        Write-Verbose "[START] $($MyInvocation.MyCommand)"

        if(!$Path){$Path = Get-Location}

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
        if ((Test-Path -Path $file) -and !$Overwrite) {
            Write-Error "File already exists. Choose another file name."
            return
        }
        else {
            Write-Verbose "[PROCESS] $file is being created"
            New-Item -Path $file -ItemType File -Force | Out-Null
            if ($UsingStatements) {
                Write-Verbose "[PROCESS] Handling the using statements provided by the user"
                [string]$using = $null
                foreach ($UsingStatement in $UsingStatements) {
                    if ($UsingStatement -notlike "*;") {$UsingStatement = "$UsingStatement;"}
                    if ($UsingStatement -notlike "using*") {$UsingStatement = "using $UsingStatement"}
                    if ($UsingStatement -notlike "*System;" -and $UsingStatement -notlike "*System.Windows;*") {
                        Write-Verbose "[PROCESS] Using statement: $UsingStatement"
                        $using += "$UsingStatement$([Environment]::NewLine)"
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
    public void PublicMethod(){
        
    }
    private void PrivateMethod(){
        
    }
    protected void ProtectedMethod(){
        
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