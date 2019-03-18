function Set-GrafanaConfig {
    <#
        .SYNOPSIS
        Modifies the configuration file for the module
        
        .PARAMETER ConfigurationFile
        The path to the JSON configuration file. Defaults to Config\Grafana.json
        
        .PARAMETER APIKey
        Your new API Key
        
        .PARAMETER GrafanaUri
        The new Grafana uri
        
        .EXAMPLE
        Set-GrafanaConfig -APIKey '10395j23oi2r' -GrafanaUri 'https://test-grafana.mydomain.org'

    #>
    [cmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $ConfigurationFile = "$(Split-Path $PSScriptRoot)\Config\Grafana.json",

        [Parameter()]
        [String]
        $APIKey,

        [Parameter()]
        [String]
        $GrafanaUri
    )


    begin { $config = Get-GrafanaConfig }

    process {

        Switch($PSBoundParameters.Keys){

            'APIKey' {
                $config.apikey = $APIKey
            }

            'GrafanaUri' { 
                $config.GrafanaUri = $GrafanaUri
            }
        }

        $config | ConvertTo-Json | Set-Content $ConfigurationFile
    }
}