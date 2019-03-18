$public = Get-ChildItem $PSScriptRoot\Public\*.ps1
$private = Get-ChildItem $PSScriptRoot\Private\*.ps1

Foreach($Script in @($public + $private)){

    . $Script.FullName

}

If(!(Test-Path $PSScriptRoot\Config\Grafana.json)){
    $grafanaConfig = @{
        
    }
    Write-Host "No config file found in Config folder. Assuming first run..." -ForegroundColor yellow
    Write-Host "We will now ask some questions to get things setup" -ForegroundColor yellow
    $GrafanUri = Read-Host -Prompt "What is your base Grafana uri?"

    Write-Host "Adding URI and appending /api to config file..." -ForegroundColor yellow
    $grafanaConfig.Add('GrafanaUri',"$GrafanUri/api")

    $ApiKey = Read-Host -Prompt "What is your API Key? Found at https://$grafanaUri/org/apikeys"

    Write-Host "Adding API Key to config file..." -ForegroundColor yellow
    $grafanaConfig.Add('apikey',$ApiKey)

    $grafanaConfig | ConvertTo-Json | Out-File $PSScriptRoot\Config\Grafana.json

    Write-Host "Config file has been generated successfully. Run 'Get-GrafanaConfig' to verify" -ForegroundColor yellow
    

}