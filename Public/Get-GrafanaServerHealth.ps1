function Get-GrafanaServerHealth {

    begin { $null = Get-GrafanaConfig}

    process {
        
         Invoke-RestMethod -Uri "$($Configuration.GrafanaUri)/health"
    
    }

}