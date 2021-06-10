Describe 'Get-FunctionScriptAnalyzerResult' {

    BeforeAll {
        $ModuleName = 'PSCodeHealth'
        Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )

        $FunctionDefinitions = InModuleScope $ModuleName {
            $Files = (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\" -Filter '*.psm1').FullName
            Get-FunctionDefinition -Path $Files
        }

        $InModuleScopeParams = @{
            FunctionDefinitions = $FunctionDefinitions
            Mocks = $Mocks
        }
    }

    Context 'No Invoke-ScriptAnalyzer Mock' {

        BeforeAll {
            $Result = InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                $Function = $FunctionDefinitions | Where-Object Name -eq 'Set-Nothing'
                Get-FunctionScriptAnalyzerResult -FunctionDefinition $Function
            }
        }

        It 'Should return PSScriptAnalyzer [DiagnosticRecord] objects' {
            $Result |
            Should -BeOfType [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]
        }

        It 'Should return the expected ScriptAnalyzer finding' {
            $Result.Extent.Text | Should -BeIn '$InputObject', '$Value', 'Set-Nothing'
            $Result.RuleName | Should -BeIn 'PSReviewUnusedParameter', 'PSUseShouldProcessForStateChangingFunctions'
        }

    }

    Context 'When the function contains no best practices violation' {

        BeforeAll {
            Mock Invoke-ScriptAnalyzer -ModuleName $ModuleName { }
        }

        It 'Should return $Null' {
            InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions
                )
                Get-FunctionScriptAnalyzerResult -FunctionDefinition $FunctionDefinitions[0] |
                Should -BeNullOrEmpty
            }
        }

    }
    Context 'When the function contains 1 best practices violation' {

        BeforeAll {
            $Result = InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions,
                    $Mocks
                )
                Mock Invoke-ScriptAnalyzer { $Mocks.'Invoke-ScriptAnalyzer'.'1Result_PSProvideCommentHelp' | Where-Object { $_ } }
                Get-FunctionScriptAnalyzerResult -FunctionDefinition $FunctionDefinitions[0]
            }
        }

        It 'Should return the expected PSScriptAnalyzer finding' {
            $Result.RuleName | Should -Be 'PSProvideCommentHelp'
            $Result.Extent.Text | Should -Be 'BadFunction'
        }

    }
    Context 'When the function contains 2 best practices violations' {

        BeforeAll {
            $Results = InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionDefinitions,
                    $Mocks
                )
                Mock Invoke-ScriptAnalyzer { $Mocks.'Invoke-ScriptAnalyzer'.'2Results_2Rules' | Where-Object { $_ } }
                Get-FunctionScriptAnalyzerResult -FunctionDefinition $FunctionDefinitions[0]
            }
        }

        It 'Should return 2 PSScriptAnalyzer findings' {
            $Results.Count | Should -Be 2
        }

        It 'Should return the expected PSScriptAnalyzer rule names' {
            $Results.RuleName -contains 'PSProvideCommentHelp' | Should -Be $True
            $Results.RuleName -contains 'PSAvoidGlobalVars' | Should -Be $True
        }

        It 'Should return the expected PSScriptAnalyzer extents' {
            ($Results.Extent.Where({$_.Text -eq 'VeryBadFunction'})).Count |
            Should -Be 2
        }

    }

}