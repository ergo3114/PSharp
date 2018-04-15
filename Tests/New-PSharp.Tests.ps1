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

    It "Should not error when giving a FileName and Path" {
        { New-PSharp "Test" -Path "TestDrive:\" } | Should Not Throw
    }

    It "Should not error when giving a FileName and full Path" {
        { New-PSharp "Test" -Path "TestDrive:\Path\To\File\" } | Should Not Throw
    }

    It "Should not error when giving a FileName with extension and full Path" {
        { New-PSharp "Test.test" -Path "TestDrive:\Path\To\File\" } | Should Not Throw
    }

    It "Should create file when an extension is given" {
        $File = Get-Item "TestDrive:\Path\To\File\Test.test"
        $File.Extension | Should Be ".test"
    }

    It "Should create file with no additional using statements" {
        $ExpectedResult = $false
        $Result = $false
        $Using = "System.Collections"
        New-PSharp UsingTest -Path "TestDrive:\"
        $File = Get-Item "TestDrive:\UsingTest.cs"
        $Contents = Get-Content $File
        foreach($Line in $Contents){
            if($Line -eq $Using){
                $Result = $true
            }
        }
        $Result | Should Be $ExpectedResult
    }

    It "Should create file with additional using statements" {
        $ExpectedResult = $true
        $Result = $false
        $Using = "System.Collections"
        New-PSharp UsingTest -Path "TestDrive:\" -UsingStatements $Using -Overwrite
        $File = Get-Item "TestDrive:\UsingTest.cs"
        $Contents = Get-Content $File
        $containsWord = $Contents | %{$_ -match $Using}
        If($containsWord -contains $true)
        {
            $Result = $true
        }
        $Result | Should Be $ExpectedResult
    }
}