function Get-GrafanaAlert {
    <#
    .SYNOPSIS
    Query Grafana API for alert information
    
    .PARAMETER DashboardId
    The ID of the dashboard to query
    
    .PARAMETER DashboardName
    The friendly name of the dashboard to query
    
    .PARAMETER DashboardTag
    Search for alerts belong to a dashboard with a specific tag
    
    .PARAMETER AlertName
    Query for all alerts matching the alert name
    
    .PARAMETER State
    Query for all alerts in the state of 'ALL','no_data','paused', 'alerting','ok','pending'
    
    .EXAMPLE
    Get-GrafanaAlert

    .EXAMPLE
    Get-GranaAlert -DashboardId 1

    .EXAMPLE
    Get-GrafanaAlert -DashboardName "PeterRabbit"

    .EXAMPLE
    Get-GrafanaAlert -DashboardTag 'prod'

    .EXAMPLE
    Get-GrafanaAlert -AlertName 'Perrywinkle'

    .EXAMPLE State
    Get-GrafanaAlert -State 'paused'

    #>
    
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaAlert")]
    Param(
        
        [Parameter()]
        [Int[]]
        $DashboardId,

        [Parameter()]
        [String]
        $DashboardName,

        [Parameter()]
        [String[]]
        $DashboardTag,

        [Parameter()]
        [Alias('Query')]
        [String]
        $AlertName,

        [Parameter()]
        [String[]]
        [ValidateSet('ALL','no_data','paused', 'alerting','ok','pending')]
        $State
    )

    begin { $null = Get-GrafanaConfig } 

    process { 
        
        $irmParams = @{
            headers = @{ Authorization = "Bearer $($Configuration.apikey)"}
            Method      = "GET"
            ContentType = "application/json"
        }

        If($PSBoundParameters.Count -eq 0){

            $irmParams.Add("Uri","$($configuration.GrafanaUri)/alerts")
        }

        Else {

            Switch($PSBoundParameters.Keys){ 

                "DashboardName" {

                    $irmParams.Add("Uri","$($configuration.GrafanaUri)/alerts?dashboardQuery=$Dashboardname")

                }

                "DashboardId" { 
                    
                    $url = "$($configuration.GrafanaUri)/alerts?"
                    foreach ($id in $DashboardId) {
                        $url += "dashboardId={0}&" -f $id
                    }
                    $irmParams.Add("Uri","$($url -replace ".$")")
                
                }

                "DashboardTag" {

                    $url = "$($configuration.GrafanaUri)/alerts?"
                    foreach ($id in $DashboardTag) {
                        $url += "dashboardTag={0}&" -f $id
                    }
                    $irmParams.Add("Uri","$($url -replace ".$")")

                }

                "State" {
                    
                    $url = "$($configuration.GrafanaUri)/alerts?"
                    foreach ($id in $State) {
                        $url += "state={0}&" -f $id
                    }
                    $irmParams.Add("Uri","$($url -replace ".$")")

                }

                "Alertname" { 

                    $irmParams.Add("Uri","$($configuration.GrafanaUri)/alerts?query=$AlertName")

                }
                
            }#switch
        
        }#else

        $irmParams['Uri']
        $result = Invoke-RestMethod @irmParams

        $result

    }#process

}