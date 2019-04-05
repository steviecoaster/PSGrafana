function Get-GrafanaFolder {
    <#
    .SYNOPSIS
    Retrieve folder information from Grafana via the API
    
    .DESCRIPTION
    You can search for Grafana folders via the API with this cmdlet. You may search via Uid,Id, or return All folders
    
    .PARAMETER Uid
    The UID value of a folder you wish to search for. This is an alphanumeric value
    
    .PARAMETER Id
    This is the ID of the folder you wish to search for. This is an int value
    
    .PARAMETER All
    Return all folders which you have access too.
    
    .EXAMPLE
    Get-GrafanaFolder

    Returns all folders which the user has access to in Grafana.
    
    .EXAMPLE
    Get-GrafanaFolder -Uid Ax8x33

    Returns the information for the folder with the Uid you entered

    .EXAMPLE
    Get-GrafanaFolder -Id 3

    Returns the information for the folder with the specified ID
   
    #>

    [cmdletBinding(HelpUri="hhttps://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaFolder",DefaultParameterSetName="All")]
    Param(
        [Parameter(ParameterSetName="Uid")]
        [String]
        $Uid,

        [Parameter(ParameterSetName="Id")]
        [Int]
        $Id,

        [Parameter(ParameterSetName="All")]
        [Switch]
        $All

    )

    begin { $null = Get-GrafanaConfig }
    
    process {

        $irmParams = @{
            
            Method      = "GET"
            Headers     = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"

        }

        Switch ($PSCmdlet.ParameterSetName) {

            'Uid' {

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/folders/$Uid")

            }

            'Id' {
            
                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/folders/id/$Id")
            
            }
            
            default {

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/folders")

            }
        }

        Invoke-RestMethod @irmParams

        
    }
}