Describe "New-PSharp" {
    #region Import-Module
    try{
        Remove-Module PSharp
        Import-Module ..\PSharp.psm1
    }
    catch{
        Import-Module .\PSharp.psm1
    }
    #endregion

    New-PSharp "Test" -Path "TestDrive:\"
    New-PSharp "Test" -Path "TestDrive:\Path\To\File\"
    New-PSharp "Test.test" -Path "TestDrive:\Path\To\File\"

    It "Should not error when giving a FileName and Path" {
        { Update-PSharp "Test" -Path "TestDrive:\" -UpdateString "System.Collections" -UpdateSection Using } | Should Not Throw
    }

    It "Should not error when giving a FileName and full Path" {
        { Update-PSharp "Test" -Path "TestDrive:\Path\To\File\" -UpdateString "System.Collections" -UpdateSection Using } | Should Not Throw
    }

    It "Should not error when giving a FileName with extension and full Path" {
        { Update-PSharp "Test.test" -Path "TestDrive:\Path\To\File\" -UpdateString "System.Collections" -UpdateSection Using } | Should Not Throw
    }

    It "Should update file with additional using statements" {
        function UsingTest ($File){
            $return = $false
            $Contents = Get-Content $File
            $containsWord = $Contents | %{$_ -match $Using}
            If($containsWord -contains $true)
            {
                $return = $true
            }
            return $return
        }

        $ExpectedResult = $true
        $ResultControlled = $false
        $Result = $false
        $Using = "System.Collections"
        New-PSharp UsingTest -Path "TestDrive:\"
        $File = Get-Item "TestDrive:\UsingTest.cs"
        $ResultControlled = UsingTest -File $File
        Update-PSharp UsingTest -Path "TestDrive:\" -UpdateString $Using -UpdateSection Using
        $File = Get-Item "TestDrive:\UsingTest.cs"
        $Result = UsingTest -File $File

        $ResultControlled | Should Be $false
        $Result | Should Be $ExpectedResult
    }
}