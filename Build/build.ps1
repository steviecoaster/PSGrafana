[CmdletBinding()]
param(
    [switch]
    $Bootstrap,

    [switch]
    $Compile,

    [switch]
    $Test
)

# Bootstrap step
if ($Bootstrap.IsPresent) {
    Write-Information "Validate and install missing prerequisits for building ..."

    # For testing Pester
    if (-not (Get-Module -Name Pester -ListAvailable)) {
        Write-Warning "Module 'Pester' is missing. Installing 'Pester' ..."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }


}

# Compile step
if ($Compile.IsPresent) {
    if (Get-Module PSGrafana) {
        Remove-Module PSGrafana -Force
    }

    if ((Test-Path ./Output)) {
        Remove-Item -Path ./Output -Recurse -Force
    }

    # Copy non-script files to output folder
    if (-not (Test-Path .\Output)) {
        $null = New-Item -Path .\Output -ItemType Directory
    }

    Copy-Item -Path '.\*' -Filter '*.*' -Exclude '*.ps1', '*.psm1' -Recurse -Destination .\Output -Force
    Remove-Item -Path .\Output\Private, .\Output\Public -Recurse -Force

    # Copy Module README file
    Copy-Item -Path '.\README.md' -Destination .\Output -Force

    Get-ChildItem -Path ".\Private\*.ps1" -Recurse | Get-Content | Add-Content .\Output\PSGrafana.psm1

    $Public  = @( Get-ChildItem -Path ".\Public\*.ps1" -ErrorAction SilentlyContinue )

    $Public | Get-Content | Add-Content .\Output\PSGrafana.psm1

    "`$PublicFunctions = '$($Public.BaseName -join "', '")'" | Add-Content .\Output\PSGrafana.psm1

    Get-Content -Path .\Azure-Pipelines\PSGrafana-Template.psm1 | Add-Content .\Output\PSGrafana.psm1

    Remove-Item -Path .\PSGrafana -Recurse -Force
    Rename-Item -Path .\Output -NewName 'PSGrafana'

    # Compress output, for GitHub release
    Compress-Archive -Path .\* -DestinationPath .\Azure-Pipelines\PSGrafana.zip

    # Re-import module, extract release notes and version
    Import-Module .\PSGrafana.psd1 -Force
    (Get-Module PSGrafana)[0].ReleaseNotes | Add-Content .\Azure-Pipelines\release-notes.txt
    (Get-Module PSGrafana)[0].Version.ToString() | Add-Content .\Azure-Pipelines\release-version.txt
}

# Test step
if($Test.IsPresent) {
    if (-not (Get-Module -Name Pester -ListAvailable)) {
        throw "Cannot find the 'Pester' module. Please specify '-Bootstrap' to install build dependencies."
    }

    Install-Module -Name Pester -RequiredVersion 4.3.1 -Scope CurrentUser

    $RelevantFiles = (Get-ChildItem $PSScriptRoot -Recurse -Include "*.psm1","*.ps1").FullName

    $RelevantFiles = (Get-ChildItem $PSScriptRoot -Recurse -Include "*.psm1","*.ps1").FullName

    if ($env:TF_BUILD) {
        $res = Invoke-Pester "./Test" -OutputFormat NUnitXml -OutputFile TestResults.xml -CodeCoverage $RelevantFiles -PassThru
        if ($res.FailedCount -gt 0) { throw "$($res.FailedCount) tests failed." }
    } else {
        $res = Invoke-Pester "./Test/Validation.Tests.ps1" -PassThru
    }

}