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