function Get-GrafanaServerHealth {
    <#
        
        .SYNOPSIS
        Returns Grafana server health info

        .EXAMPLE 

        Get-GrafanaServerhealth

    #>
    begin { $null = Get-GrafanaConfig}

    process {
        
         Invoke-RestMethod -Uri "$($Configuration.GrafanaUri)/health"
    
    }

}