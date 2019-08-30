$PSGrafanaConfigPath = "$ENV:USERPROFILE/.psgrafana"
If (!(Test-Path $PSGrafanaConfig)) {

    $null = New-Item -Path $PSGrafanaConfigPath -ItemType Directory

    $grafanaConfig = @{
        
    }
    
    Write-Host "No config file found in Config folder. Assuming first run..." -ForegroundColor yellow
    Write-Host "We will now ask some questions to get things setup" -ForegroundColor yellow
    $GrafanaUri = Read-Host -Prompt "What is your base Grafana uri?"

    Write-Host "Adding URI and appending /api to config file..." -ForegroundColor yellow
    $grafanaConfig.Add('GrafanaUri', "$GrafanaUri/api")

    $ApiKey = Read-Host -Prompt "What is your API Key? Found at https://$GrafanaUri/org/apikeys"

    Write-Host "Adding API Key to config file..." -ForegroundColor yellow
    $grafanaConfig.Add('apikey', $ApiKey)

    $grafanaConfig | ConvertTo-Json | Out-File "$PSGrafanaConfigPath/Grafana.json" -Force

    Write-Host "Config file has been generated successfully. Run 'Get-GrafanaConfig' to verify" -ForegroundColor yellow
    
}