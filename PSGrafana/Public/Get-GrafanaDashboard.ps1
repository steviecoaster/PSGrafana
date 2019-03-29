function Get-GrafanaDashboard {
    <#
        .SYNOPSIS
        Returns an object with details about a Grafana dashboard
        
        .PARAMETER Name
        Search the Grafana instance for dashboards by friendly name
        
        .PARAMETER Uuid
        Search the Grafana instance for dashboards by UID
        
        .PARAMETER IncludeMetadata
        Include extra metadata about the dashboard. Excluded by default.
        
        .EXAMPLE
        Get-GrafanaDashboard -Name 'Prod - FileServer'
        
        .EXAMPLE
        Get-GrafanaDashboard -Uuid O0E3f5t
        
        .EXAMPLE
        Get-GrafanaDashboard -Name 'Smiley' -IncudeMetadata
    
    #>
    [cmdletBinding()]
    Param(

        [Parameter(Position=0,ParameterSetName='Name')]
        [String]
        $Name,

        [Parameter(Position=0,ParameterSetName='Uuid')]
        [String]
        $Uuid,

        [Parameter(Position=0,ParameterSetName='Tag')]
        [String]
        $Tag,

        [Parameter()]
        [Switch]
        $IncludeMetadata
    )

    begin { $null = Get-GrafanaConfig }

    process {

        $header = @{ Authorization = "Bearer $($Configuration.apikey)"}

        Switch($PSCmdlet.ParameterSetName){

            'Name' {
                
                $irmParams = @{
            
                    Method      = "GET"
                    Uri         = "$($configuration.GrafanaUri)/search?query=$Name"
                    Headers     = $header
                    ContentType = "application/json"

                }

                $result = Invoke-WebRequest @irmParams

                $result.Content | ConvertFrom-Json
            
            }

            'Uuid' {
                
                $irmParams = @{
            
                    Method      = "GET"
                    Uri         = "$($configuration.GrafanaUri)/dashboards/uid/$uuid" 
                    Headers     = $header
                    ContentType = "application/json"
    
                }

                $result = Invoke-RestMethod @irmParams
                
                If($IncludeMetadata){
            
                    $result | Format-List
        
                }
        
                Else { 
        
                    $result.dashboard
                }
            
            }

            'Tag' {
                
                $irmParams = @{
            
                    Method      = "GET"
                    Uri         =  "$($configuration.GrafanaUri)/search?tag=$Tag" 
                    Headers     = $header
                    ContentType = "application/json"
    
                }

                $result = Invoke-WebRequest @irmParams
                
                $result.Content | ConvertFrom-Json
            
            }
        
        }#switch
                
    }#process

}#function