function Get-GrafanaDashboard {
    [cmdletBinding()]
    Param(

        [Parameter(Position=0,ParameterSetName='Name')]
        [String]
        $Name,

        [Parameter(Position=1,ParameterSetName='Uuid')]
        [String]
        $Uuid,

        [Parameter(Position=2)]
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
        }
        
        

        
    }
}