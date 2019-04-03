function Get-GrafanaDatasource {
    <#
    .SYNOPSIS
    Fetch information about Grafana datasources via the API
    
    .PARAMETER All
    Returns all datasources in your Grafana Instance
    
    .PARAMETER DatasourceId
    The ID of the datasource for which to search
    
    .PARAMETER DatasourceName
    The friendly name of the datasource for which to search
    
    .EXAMPLE
    Get-GrafanaDatasource -All

    .EXAMPLE
    Get-GrafanaDatasource -DatasourceId 4

    .EXAMPLE
    Get-GrafanaDatasource -Datasourcename ElasticPuppies
    
    .NOTES
    
    #>
    
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaDatasource")]
    Param(
        [Parameter()]
        [Switch]
        $All,

        [Parameter()]
        [Int]
        $DatasourceId,

        [Parameter()]
        [String]
        $DatasourceName

    )

    begin { $null = Get-GrafanaConfig }

    process {

        $header = @{ Authorization = "Bearer $($Configuration.apikey)"}

        If($All){

            $irmParams = @{
            
                Method      = "GET"
                Uri         = "$($configuration.GrafanaUri)/datasources" 
                Headers     = $header
                ContentType = "application/json"

            }

            $result = Invoke-RestMethod @irmParams

            $result
        }

        Switch($PSBoundParameters.Keys){

            'DatasourceId' {
                $irmParams = @{
            
                    Method      = "GET"
                    Uri         = "$($configuration.GrafanaUri)/datasources/$DatasourceId" 
                    Headers     = $header
                    ContentType = "application/json"
    
                }
    
                $result = Invoke-RestMethod @irmParams
    
                $result
            }

            'DatasourceName' {
                $irmParams = @{
            
                    Method      = "GET"
                    Uri         = "$($configuration.GrafanaUri)/datasources/name/$DatasourceName" 
                    Headers     = $header
                    ContentType = "application/json"
    
                }
    
                $result = Invoke-RestMethod @irmParams
    
                $result

            }
        }

    }
}