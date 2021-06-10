Describe 'Get-FunctionTestCoverage' {

    BeforeAll {
        $ModuleName = 'PSCodeHealth'
        Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )
        $FunctionDefinitions = InModuleScope $ModuleName {
            Get-FunctionDefinition -Path "$($PSScriptRoot)\..\..\TestData\1Public1Nested1Private.psm1"
        }

        $InModuleScopeParams = @{
            FunctionDefinitions = $FunctionDefinitions
            Mocks = $Mocks
        }
    }

    Context 'Pester finds 1 command in the function' {

        BeforeAll {
            Mock Invoke-Pester -ModuleName $ModuleName { $Mocks.'Invoke-Pester'.'1CommandAnalyzed' }
        }

        It 'Should return an object of the type [PSCodeHealth.Function.TestCoverageInfo]' {
            InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                (Get-FunctionTestCoverage -FunctionDefinition $FunctionDefinitions[0] | Get-Member).TypeName[0] |
                Should -Be 'PSCodeHealth.Function.TestCoverageInfo'
            }
        }

    }

    Context "Pester doesn't find any command in the function" {

        BeforeAll {
            Mock Invoke-Pester -ModuleName $ModuleName { $Mocks.'Invoke-Pester'.'0CommandAnalyzed' }

            $Result = InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                Get-FunctionTestCoverage -FunctionDefinition $FunctionDefinitions[0]
            }
        }

        It 'Should return an object with the expected property "CodeCoveragePerCent"' {
            $Result.CodeCoveragePerCent | Should -Be 0
        }

        It 'Should return an object with the expected property "CommandsMissed"' {
            $Result.CommandsMissed | Should -BeNullOrEmpty
        }

    }

    Context 'Invoke-Pester returns nothing at all' {

        BeforeAll {
            Mock Invoke-Pester -ModuleName $ModuleName { }

            $Result = InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                Get-FunctionTestCoverage -FunctionDefinition $FunctionDefinitions[0]
            }
        }

        It 'Should return an object with the expected property "CodeCoveragePerCent"' {
            $Result.CodeCoveragePerCent | Should -BeNullOrEmpty
        }

        It 'Should return an object with the expected property "CommandsMissed"' {
            $Result.CommandsMissed | Should -BeNullOrEmpty
        }

    }

    Context 'TestsPath parameter' {

        BeforeAll {
            New-Item -Path TestDrive:\Module -ItemType Directory
            New-Item -Path TestDrive:\Module\Module.Tests.ps1 -ItemType File
            New-Item -Path TestDrive:\Module\Module2.Tests.ps1 -ItemType File

            "{&Public} | Should -Not -Throw" | Set-Content TestDrive:\Module\Module.Tests.ps1
            "Mock -CommandName Public -MockWith {}" | Set-Content TestDrive:\Module\Module2.Tests.ps1

            Mock Invoke-Pester -ModuleName $ModuleName -MockWith {}
            Mock Invoke-Pester -ModuleName $ModuleName -ParameterFilter { $Configuration.Run.Path.Value -like '*\Module\Module.Tests.ps1' } { $Mocks.'Invoke-Pester'.'1CommandAnalyzed' }
            Mock Invoke-Pester -ModuleName $ModuleName -ParameterFilter { $Configuration.Run.Path.Value -like '*\Module' } { $Mocks.'Invoke-Pester'.'1CommandAnalyzed' }
            Mock Invoke-Pester -ModuleName $ModuleName -ParameterFilter { $Configuration.Run.Path.Value -like '*\TestData\*' } { $Mocks.'Invoke-Pester'.'1CommandAnalyzed' }

            $Result = InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                Get-FunctionTestCoverage -FunctionDefinition $FunctionDefinitions[0] -TestsPath 'TestDrive:\Module\Module.Tests.ps1'
            }
        }

        It 'Should call Invoke-Pester with the file path if TestsPath is a file' {
            InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                $Null = Get-FunctionTestCoverage -FunctionDefinition $FunctionDefinitions[0] -TestsPath 'TestDrive:\Module\Module.Tests.ps1'
                Assert-MockCalled -CommandName Invoke-Pester -Scope It -ParameterFilter { $Configuration.Run.Path.Value -like '*\Module\Module.Tests.ps1' }
            }
        }

        It 'Should not call Invoke-Pester with the directory path if TestsPath is a directory' {
            InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                $Null = Get-FunctionTestCoverage -FunctionDefinition $FunctionDefinitions[0] -TestsPath 'TestDrive:\Module'
                Assert-MockCalled -CommandName Invoke-Pester -Scope It -ParameterFilter { $Configuration.Run.Path.Value -like '*\Module' } -Exactly -Times 0
                Assert-MockCalled -CommandName Invoke-Pester -Scope It -ParameterFilter { $Configuration.Run.Path.Value -like '*\Module\Module.Tests.ps1' }
            }
        }

        It "Should not call Invoke-Pester with the source file's parent directory if TestsPath is not specified" {
            InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                $Null = Get-FunctionTestCoverage -FunctionDefinition $FunctionDefinitions[0]
                Assert-MockCalled -CommandName Invoke-Pester -Scope It -ParameterFilter { $Configuration.Run.Path.Value -like '*\TestData' } -Exactly -Times 0
            }
        }

        It 'Should return an object with the expected property "CodeCoveragePerCent"' {
            $Result.CodeCoveragePerCent | Should -Be 0
        }

        It 'Should return an object with the expected property "CommandsMissed"' {
            $Result.CommandsMissed | Should -Be 'Mocked missed command'
        }

    }

}