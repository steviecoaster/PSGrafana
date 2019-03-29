[CmdletBinding()]
param(
    [switch]
    $Bootstrap,

    [switch]
    $DefineTag,

    [switch]
    $Publish,

    [switch]
    $Tweet
)

# Bootstrap step
if ($Bootstrap.IsPresent) {
    Write-Information "Validate and install missing prerequisits for building ..."

    # For tweeting
    if (-not (Get-Module -Name PSTwitterAPI -ListAvailable)) {
        Write-Warning "Module 'PSTwitterAPI' is missing. Installing 'PSTwitterAPI' ..."
        Install-Module -Name PSTwitterAPI -Scope CurrentUser -Force
    }
}

# Define Tag step
if ($DefineTag.IsPresent) {
    $ReleaseVersion = Get-Content -Path $env:ArtifactDir\PipelinesScripts\release-version.txt
    Write-Host "##vso[task.setvariable variable=RELEASETAG]$ReleaseVersion"
}

# Publish step
if ($Publish.IsPresent) {
    # Publish Module to PowerShell Gallery
    Try {
        $Splat = @{
            Path        = (Resolve-Path -Path $env:ArtifactDir\BurntToast)
            NuGetApiKey = $env:PSGallery
            ErrorAction = 'Stop'
        }
        Publish-Module @Splat

        Write-Output -InputObject ('BurntToast PowerShell Module published to the PowerShell Gallery')
    } Catch {
        throw $_
    }
}

# Tweet step
if($Tweet.IsPresent) {
    if (-not (Get-Module -Name PSTwitterAPI -ListAvailable)) {
        throw "Cannot find the 'PSTwitterAPI' module. Please specify '-Bootstrap' to install release dependencies."
    }

    Import-Module -Name PSTwitterAPI

    $OAuthSettings = @{
        ApiKey            = $env:TwitterConsumerKey
        ApiSecret         = $env:TwitterConsumerSecret
        AccessToken       = $env:TwitterAccessToken
        AccessTokenSecret = $env:TwitterAccessSecret
    }

    Set-TwitterOAuthSettings @OAuthSettings

    $ReleaseVersion = Get-Content -Path $env:ArtifactDir\PipelinesScripts\release-version.txt

    $Tweet = "Guys! PSGrafana v$ReleaseVersion is pushed to the #PowerShell Gallery via @AzureDevOps!$([System.Environment]::NewLine)$([System.Environment]::NewLine)$([System.Environment]::NewLine)https://www.powershellgallery.com/packages/PSGrafana/$ReleaseVersion"
                
    Send-TwitterStatuses_Update -status $Tweet
        
}