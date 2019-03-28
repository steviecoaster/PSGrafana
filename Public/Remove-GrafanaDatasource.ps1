function Remove-GrafanaDatasource {
    <#
        .SYNOPSIS
        Removes the specified Grafana datasource
        
        .PARAMETER DatasourceId
        The ID of the datasource you wish to remove
        
        .PARAMETER DatasourceName
        The friendly name of the datasouce you wish to remove
        
        .EXAMPLE
        Remove-GrafanaDashboard -DatasourceId 3
        
        .EXAMPLE
        Remove-GrafanaDashboard -DatasourceName 'ElasticPuppies'
    #>
    [cmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    param(
        
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

        Switch($PSBoundParameters.Keys){
                
            'DatasourceId' {    
                
                    $irmParams = @{
                    
                    Method      = "DELETE"
                    Uri         = "$($configuration.GrafanaUri)/datasources/$DatasourceId" 
                    Headers     = $header
                    ContentType = "application/json"

                }

                If($PSCmdlet.ShouldProcess("DELETE","Datasource ID:$DatasourceId")){
                    
                    Invoke-RestMethod @irmParams
                
                }
            }

            'DatasourceName' {    
                
                $irmParams = @{
                    
                    Method      = "DELETE"
                    Uri         = "$($configuration.GrafanaUri)/datasources/name/$DatasourceName" 
                    Headers     = $header
                    ContentType = "application/json"

                }

                If($PSCmdlet.ShouldProcess("Datasource Name:$DatasourceName","DELETE")){
                    
                    Invoke-RestMethod @irmParams
                
                }

            }

        }

    }

}