function Get-GrafanaServerHealth {
    <#
        
        .SYNOPSIS
        Returns Grafana server health info

        .EXAMPLE 

        Get-GrafanaServerhealth

    #>

    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaServerHealth")]
    Param()
    
    begin { $null = Get-GrafanaConfig}

    process {
        
         Invoke-RestMethod -Uri "$($Configuration.GrafanaUri)/health"
    
    }

}