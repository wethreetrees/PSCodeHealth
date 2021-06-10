$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'New-PSCodeHealthReport' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )
        [System.Collections.ArrayList]$Path = (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\" -Filter '*.psm1').FullName
        $TestsPath = "$($PSScriptRoot)\..\..\TestData\FakeTestFile.ps1"

        Context 'The value of the FunctionHealthRecord parameter is Null' {

            $Result = New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Path -TestsPath $TestsPath -FunctionHealthRecord $Null
            It 'Should not throw' {
                { New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Path -TestsPath $TestsPath -FunctionHealthRecord $Null } |
                Should Not Throw
            }
            It 'Should return only 1 object' {
                ($Result | Measure-Object).Count | Should Be 1
            }
            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be 'Any'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be 'C:\Any'
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 2
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 0
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 0
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 0
            }
            It 'Should return an object with the expected property "FailedTestsDetails"' {
                $Result.FailedTestsDetails | Should BeNullOrEmpty
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 0
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 0
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 0
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 0
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 0
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 0
            }
            It 'Should return an object with the expected property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords | Should BeNullOrEmpty
            }
        }

        Context 'The FunctionHealthRecord parameter contains 1 object and there is test coverage' {

            $FunctionHealthRecord = ($Mocks.'New-FunctionHealthRecord'.Single)[0]
            $FunctionHealthRecord.psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.HealthRecord')
            Mock Invoke-Pester { $Mocks.'Invoke-Pester'.'NumberOfTests' }
            $Result = New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Path -TestsPath $TestsPath -FunctionHealthRecord $FunctionHealthRecord

            It 'Should throw if the FunctionHealthRecord parameter does not contain PSCodeHealth.Function.HealthRecord object(s)' {
                { New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Path -TestsPath $TestsPath -FunctionHealthRecord [PSCustomObject]$FunctionHealthRecord } |
                Should Throw
            }
            It 'Should return only 1 object' {
                ($Result | Measure-Object).Count | Should Be 1
            }
            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be 'Any'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be 'C:\Any'
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 2
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 1
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 101
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 101
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 3
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 51
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 7
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 44
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 86.27
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 81.48
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 5
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 19
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 19
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 5
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 5
            }
            It 'Should return an object with the expected property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords | Should Be $FunctionHealthRecord
            }
        }
        Context 'The FunctionHealthRecord parameter contains 2 objects' {

            $FunctionHealthRecord = $Mocks.'New-FunctionHealthRecord'.'2HealthRecords' | Where-Object { $_ }
            $FunctionHealthRecord[0].psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.HealthRecord')
            $FunctionHealthRecord[1].psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.HealthRecord')
            $Result = New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Path -TestsPath $TestsPath -FunctionHealthRecord $FunctionHealthRecord

            It 'Should return only 1 object' {
                ($Result | Measure-Object).Count | Should Be 1
            }
            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be 'Any'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be 'C:\Any'
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 2
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 2
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 187
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 93.5
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 9
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 2
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 4
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 4.5
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 1
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 0
            }
            It 'Should return an object with the expected property "FailedTestsDetails"' {
                $Result.FailedTestsDetails | Should BeNullOrEmpty
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 0
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 0
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 15.5
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 19
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 3.5
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 5
            }
            It 'Should return an object with the expected property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords | Should Be $FunctionHealthRecord
            }
        }
        Context 'The FunctionHealthRecord parameter contains 2 objects and there is a manifest with no finding' {

            $FunctionHealthRecord = $Mocks.'New-FunctionHealthRecord'.'2HealthRecords' | Where-Object { $_ }
            $FunctionHealthRecord[0].psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.HealthRecord')
            $FunctionHealthRecord[1].psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.HealthRecord')
            $Null = $Path.Add((Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\ManifestWithNoFindings.psd1").FullName)

            $Result = New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Path -TestsPath $TestsPath -FunctionHealthRecord $FunctionHealthRecord

            It 'Should return only 1 object' {
                ($Result | Measure-Object).Count | Should Be 1
            }
            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be 'Any'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be 'C:\Any'
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 3
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 2
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 187
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 93.5
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 9
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 2
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 4
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 4.5
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 1
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 0
            }
            It 'Should return an object with the expected property "FailedTestsDetails"' {
                $Result.FailedTestsDetails | Should BeNullOrEmpty
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 0
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 0
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 15.5
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 19
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 3.5
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 5
            }
            It 'Should return an object with the expected property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords | Should Be $FunctionHealthRecord
            }
        }
        Context 'The FunctionHealthRecord parameter contains 1 finding and there is a manifest with findings' {

            $FunctionHealthRecord = $Mocks.'New-FunctionHealthRecord'.'Single1Finding' | Where-Object { $_ }
            $FunctionHealthRecord[0].psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.HealthRecord')
            $Null = $Path.Add((Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\ManifestWithFindings.psd1").FullName)

            $Result = New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Path -TestsPath $TestsPath -FunctionHealthRecord $FunctionHealthRecord

            It 'Should not throw' {
                { New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Path -TestsPath $TestsPath -FunctionHealthRecord $FunctionHealthRecord } |
                Should Not Throw
            }
            It 'Should return only 1 object' {
                ($Result | Measure-Object).Count | Should Be 1
            }
            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be 'Any'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be 'C:\Any'
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 4
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 1
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 101
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 101
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 4
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 4
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 1
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 0
            }
            It 'Should return an object with the expected property "FailedTestsDetails"' {
                $Result.FailedTestsDetails | Should BeNullOrEmpty
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 0
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 0
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 19
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 19
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 5
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 5
            }
            It 'Should return an object with the expected property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords | Should Be $FunctionHealthRecord
            }
        }
        Context 'The Path parameter contains only a .psd1 file' {

            $Psd1 = (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\ManifestWithFindings.psd1").FullName
            $Result = New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Psd1 -TestsPath $TestsPath -FunctionHealthRecord $Null

            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be 'Any'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be 'C:\Any'
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 1
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 0
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 0
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 0
            }
            It 'Should return an object with the expected property "FailedTestsDetails"' {
                $Result.FailedTestsDetails | Should BeNullOrEmpty
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 0
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 0
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 0
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 0
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 0
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 0
            }
            It 'Should return an object with the expected property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords | Should BeNullOrEmpty
            }
        }
        Context 'Invoke-Pester returns nothing at all' {

            $Psd1 = (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\ManifestWithFindings.psd1").FullName
            Mock Invoke-Pester { }
            $Result = New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Psd1 -TestsPath $TestsPath -FunctionHealthRecord $Null

            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be 'Any'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be 'C:\Any'
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 1
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 0
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 0
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 0
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 0
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should BeNullOrEmpty
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should BeNullOrEmpty
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 0
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 0
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 0
            }
            It 'Should return an object with the expected property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords | Should BeNullOrEmpty
            }
        }
        Context 'Invoke-Pester returns nothing at all, but the TestsResult parameter is used' {

            $Psd1 = (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\ManifestWithFindings.psd1").FullName
            $PesterResult = $Mocks.'Invoke-Pester'.'NumberOfTests' | Where-Object { $_ }
            Mock Invoke-Pester { }
            $Result = New-PSCodeHealthReport -ReportTitle 'Any' -AnalyzedPath 'C:\Any' -Path $Psd1 -TestsPath $TestsPath -FunctionHealthRecord $Null -TestsResult $PesterResult

            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 0
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 3
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 51
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 7
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 44
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 86.27
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 81.48
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 5
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 0
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 0
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 0
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 0
            }
            It 'Should not call Invoke-Pester' {
                Assert-MockCalled Invoke-Pester -Scope Context -Times 0
            }
        }
    }
}