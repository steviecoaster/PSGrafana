function Get-GrafanaOrg {
    <#
    .SYNOPSIS
    Returns information about Grafana Organizations
    
    .DESCRIPTION
    Returns information about various organizations configured in your Grafana installation.
    
    .PARAMETER OrgName
    Specify an Org name to retrieve information about that Org
    
    .PARAMETER CurrentOrg
    Retrieve information about the Current Org the user belongs too.
    
    .EXAMPLE
    Get-GrafanaOrg -OrgName Headquarters

    .EXAMPLE
    Get-GrafanaOrg -CurrentOrg
 
    #>
    
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaOrg")]
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