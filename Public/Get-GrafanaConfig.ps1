function Get-GrafanaConfig {
    <#
        .SYNOPSIS
        Reads the Grafana.json file and returns an object
        
        .PARAMETER ConfigurationFile
        The path to the configuration json. Defaults to Config\Grafana.json
        
        .EXAMPLE
        Get-GrafanaConfig
        
        .EXAMPLE
        Get-GrafanaConfig C:\Configs\Grafana.json
        
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Position=0)]
        [String]
        $ConfigurationFile = "$(Split-Path $PSScriptRoot)\Config\Grafana.json"
    )

    begin {}

    process {
        
        $Global:Configuration = Get-Content $ConfigurationFile | ConvertFrom-Json 

        $Configuration
    
    }

    end {}

}