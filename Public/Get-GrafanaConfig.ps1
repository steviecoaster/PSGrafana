function Get-GrafanaConfig {

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