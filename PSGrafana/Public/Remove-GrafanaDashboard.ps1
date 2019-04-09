function Remove-GrafanaDashboard {
    <#
    .SYNOPSIS
    Remove a Grafana Dashboard via the API
    
    .DESCRIPTION
    This cmdlet exposes the API to delete a dashboard out of Grafana
    
    .PARAMETER Dashboard
    The friendly name of the Dashbaord to remove.
    
    .EXAMPLE
    Remove-GrafanaDashboard -Name FancyDash

    .EXAMPLE
    Get-GrafanaDashboard -Name FancyDash | Remove-GrafanaDashboard

    .EXAMPLE
    Remove-GrafanaDashbaord -Name WebFarmDev -Confirm:$false
    
    #>
    
    [cmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Default")]
    Param(
        [Parameter(Mandatory,Position=0,ParameterSetName="Default")]
        [Alias('Name')]
        [String]
        $Dashboard,

        [Parameter(Mandatory,ParameterSetName="Pipeline",ValueFromPipeline)]
        [PSObject]
        $InputObject


    )

    begin { $null = Get-GrafanaConfig }

    process { 

        Switch($PSCmdlet.ParameterSetName){

            'Default' {

                $Uid = Get-GrafanaDashboard -Name $Dashboard | Select-Object -ExpandProperty uid
                
            }

            'Pipeline' {

                $Uid = $($InputObject.uid)

            }

        }

        $irmParams = @{
            Method = "DELETE"
            Headers = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"
            Uri = "$($configuration.GrafanaUri)/dashboards/uid/$Uid"
        }

        If($PSCmdlet.ShouldProcess("Dashboard: $Dashboard", "DELETE")){
        $Result = Invoke-RestMethod @irmParams

        $Result

        }

    }

}