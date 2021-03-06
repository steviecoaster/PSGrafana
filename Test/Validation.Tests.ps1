$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\PSGrafana\*.psm1")
$ModuleName = Split-Path $ModuleRoot -Leaf

Describe "General project validation: $ModuleName" {
    BeforeAll {
        $FileSearch = @{
            Path    = $ProjectRoot
            Include = '*.ps1'
            Recurse = $true
            
        }
        $Scripts = Get-ChildItem @FileSearch
    }

    # TestCases are splatted to the script so we need hashtables
    $TestCases = $Scripts | ForEach-Object { @{File = $_} }
    It "<File> should be valid powershell" -TestCases $TestCases {
        param($File)

        $File.FullName | Should -Exist

        $FileContents = Get-Content -Path $File.FullName -ErrorAction Stop
        $Errors = $null
        [System.Management.Automation.PSParser]::Tokenize($FileContents, [ref]$Errors) > $null
        $Errors.Count | Should -Be 0
    }

    If((Test-Path $ProjectRoot\PSGrafana\Config\*.json)){
    It "'$ModuleName' can import cleanly" {
        {Import-Module (Join-Path $ModuleRoot "PSGrafana.psd1") -Force} | Should -Not -Throw
    }
    }
}