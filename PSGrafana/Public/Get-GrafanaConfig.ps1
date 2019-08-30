function Get-GrafanaConfig {
    <#
        .SYNOPSIS
        Reads the Grafana.json file and returns an object
        
        .PARAMETER ConfigurationFile
        The path to the configuration json. Defaults to Config\Grafana.json
        
        .EXAMPLE
        Get-GrafanaConfig
        
        .EXAMPLE
        Get-GrafanaConfig -ConfigurationFile C:\Configs\Grafana.json
        
    #>
    [CmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaConfig")]
    Param(
        [Parameter(Position=0)]
        [String]

        $ConfigurationFile = "$ENV:USERPROFILE/.psgrafana/Grafana.json"

    )

    begin {}

    process {
        
        $Global:Configuration = Get-Content $ConfigurationFile | ConvertFrom-Json 

        $Configuration
    
    }

    end {}

}