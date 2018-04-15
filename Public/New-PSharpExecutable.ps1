function New-PSharpExecutable {
    [CmdletBinding(SupportsShouldProcess)]
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
        [string]$Output
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
        $preFolder = 'C:\Windows\Microsoft.NET\Framework64'
        $Version = [environment]::Version
        $Folder = "v$($Version.Major).$($Version.Minor).$($Version.Build)"
        
        if ($pscmdlet.ShouldProcess($file)) {
            if(!$Output){
                ."$preFolder\$Folder\csc.exe" $file
            }
            else{
                try{
                    $out = "$($Output -split '.').exe"
                    ."$preFolder\$Folder\csc.exe" /out:$out $file
                }
                catch{
                    $out = "$Output.exe"
                    ."$preFolder\$Folder\csc.exe" /out:$out $file
                }
            }
        }
    }
    END {
        Write-Verbose "[END] Completed $($MyInvocation.MyCommand)"
    }
}