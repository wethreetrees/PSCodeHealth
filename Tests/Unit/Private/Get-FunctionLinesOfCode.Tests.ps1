Describe 'Get-FunctionLinesOfCode' {

    BeforeAll {
        $ModuleName = 'PSCodeHealth'
        Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force
    }

    Context 'Count lines in function definitions' {

        BeforeEach {
            $FunctionDefinitions = InModuleScope $ModuleName {
                $Files = (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\" -Filter '*.psm1').FullName
                Get-FunctionDefinition -Path $Files
            }
        }

        It 'Counts <ExpectedNumberOfLines> lines in the function definition : <FunctionName>' -TestCases @(
            @{ FunctionName = 'Public'; ExpectedNumberOfLines = 6 }
            @{ FunctionName = 'Private'; ExpectedNumberOfLines = 3 }
            @{ FunctionName = 'Get-Nothing'; ExpectedNumberOfLines = 15 }
            @{ FunctionName = 'Set-Nothing'; ExpectedNumberOfLines = 16 }
        ) {
            $InModuleScopeParams = $_
            $InModuleScopeParams['FunctionDefinitions'] = $FunctionDefinitions
            InModuleScope $ModuleName -Parameters $InModuleScopeParams {
                param (
                    $FunctionName,
                    $ExpectedNumberOfLines,
                    $FunctionDefinitions
                )
                Get-FunctionLinesOfCode -FunctionDefinition ($FunctionDefinitions | Where-Object { $_.Name -eq $FunctionName }) |
                Should -Be $ExpectedNumberOfLines
            }
        }

    }

}