function Get-GrafanaSnapshot { 
    <#
    .SYNOPSIS
    Retrieve Grafana Snapshots via API
    
    .DESCRIPTION
    Retrieve a single snapshot by Name, or return All snapshots
    
    .PARAMETER SnapshotName
    The friendly name of the Snapshot to retrieve
    
    .PARAMETER All
    Switch to return all snapshots
    
    .EXAMPLE
    Get-GrafanaSnapshot -SnapshotName SnappyMcSnapperson

    .EXAMPLE
    Get-GrafanaSnapshot -All
    
    #>
    
    [cmdletBinding(DefaultParameterSetName="Snapshot",HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaSnapshot")]
    Param(
        [Parameter(Mandatory,ParameterSetName="Snapshot")]
        [String]
        $SnapshotName,

        [Parameter(Mandatory,ParameterSetName="All")]
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

        Switch($PSCmdlet.ParameterSetName){

            'Snapshot' {
                
                $irmParams.Add("Uri","$($configuration.GrafanaUri)/dashboard/snapshots/?query=$SnapshotName")

            }

            'All' {

                $irmParams.Add("Uri","$($configuration.GrafanaUri)/dashboard/snapshots")

            }
        }
       
        $result = Invoke-RestMethod @irmParams

        $result

    }
}