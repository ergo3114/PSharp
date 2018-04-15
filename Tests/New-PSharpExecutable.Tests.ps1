Describe "New-PSharpExecutable" {
    #region Import-Module
    try{
        Import-Module ..\PSharp.psm1 -ErrorAction Stop
    }
    catch{
        Import-Module .\PSharp.psm1
    }
    #endregion

    New-PSharp "Test" -Path "TestDrive:\"
    New-PSharp "Test" -Path "TestDrive:\Path\To\File\"
    New-PSharp "Test.test" -Path "TestDrive:\Path\To\File\"

    It "Should not error when giving a FileName and Path" {
        { New-PSharpExecutable "Test" -Path "TestDrive:\" } | Should Not Throw
    }

    It "Should not error when giving a FileName and full Path" {
        { New-PSharpExecutable "Test" -Path "TestDrive:\Path\To\File\" } | Should Not Throw
    }

    It "Should not error when giving a FileName with extension and full Path" {
        { New-PSharpExecutable "Test.test" -Path "TestDrive:\Path\To\File\" } | Should Not Throw
    }
}