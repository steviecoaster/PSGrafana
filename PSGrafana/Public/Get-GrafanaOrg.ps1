function Get-GrafanaOrg {

    [cmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $OrgName,

        [Parameter()]
        [Switch]
        $CurrentOrg
    )

    begin { $null = Get-GrafanaConfig } 

    process {
        
        $irmParams = @{
            
            Method = 'GET'
            Headers = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"

        }

        Switch($PSBoundParameters.Keys){

            'OrgName' {

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/orgs/name/$OrgName")

            }

            'CurrentOrg' {

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/org")
                
            }

        }

        $return = Invoke-RestMethod @irmParams

        $return

    }
}