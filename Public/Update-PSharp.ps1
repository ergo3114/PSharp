function Update-PSharp {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0)]
        [ValidateNotNullorEmpty()]
        [string]$FileName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string[]]$UpdateString,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Using", "Namespace", "Class")]
        [ValidateNotNullorEmpty()]
        [string]$UpdateSection
    )
    BEGIN {
        Write-Verbose "[START] $($MyInvocation.MyCommand)"

        if(!$Path){$Path = Get-Location}

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
