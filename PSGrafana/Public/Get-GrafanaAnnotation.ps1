function Get-GrafanaAnnotation {
    <#
    .SYNOPSIS
    Retrieves annotations via the Grafana API
    
    .DESCRIPTION
    Search for various types of annotations via the Grafana API
    
    .PARAMETER From
    The start time to search
    
    .PARAMETER To
    The end time to search
    
    .PARAMETER AlertName
    The specific alert annotation you want to find
    
    .PARAMETER DashboardName
    The specific dashboard to return results for
    
    .PARAMETER PanelName
    The specific panel to retrieve results for
    
    .PARAMETER Username
    The specific username to search for
    
    .PARAMETER Type
    Retrieve annotations of a certain type
    
    .PARAMETER Tags
    Retrieve annotation based on tags
    
    .PARAMETER All
    Return all annotations
    
    .PARAMETER Credential
    The Grafana credentials to use to retrieve annotations
    
    .EXAMPLE
    Get-GrafanaAnnotation -All -Credential $cred

    .EXAMPLE
    Get-GrafanaAnnotation -DashboardName WebServer

    .EXAMPLE
    Get-GrafanaAnnotation -Username bob
    
    #>
    
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaAnnotation")]
    Param(
        [Parameter(Mandatory,Position=0,ParameterSetName="time")]
        [String]
        $From,

        [Parameter(Mandatory,Position=1,ParameterSetName="time")]
        [string]
        $To,

        [Parameter(Mandatory,Position=0,ParameterSetName="alert")]
        [String]
        $AlertName,

        [Parameter(Mandatory,Position=0,ParameterSetName="dashboard")]
        [String]
        $DashboardName,

        [Parameter(Mandatory,Position=0,ParameterSetName="panel")]
        [String]
        $PanelName,

        [Parameter(Mandatory,Position=0,ParameterSetName="user")]
        [String]
        $Username,

        [Parameter(Mandatory,Position=0,ParameterSetName="type")]
        [ValidateSet("Alert","Annotation")]
        [String]
        $Type,

        [Parameter(Mandatory,Position=0,ParameterSetName="tags")]
        [String[]]
        $Tags,

        [Parameter(Mandatory,Position=0,ParameterSetName="all")]
        [Switch]
        $All,

        [Parameter(Mandatory,Position=1,ParameterSetName="all")]
        [Parameter(Mandatory,Position=2,ParameterSetName="time")]
        [Parameter(Mandatory,Position=1,ParameterSetName="alert")]
        [Parameter(Mandatory,Position=1,ParameterSetName="dashboard")]
        [Parameter(Mandatory,Position=1,ParameterSetName="panel")]
        [Parameter(Mandatory,Position=1,ParameterSetName="user")]
        [Parameter(Mandatory,Position=1,ParameterSetName="type")]
        [Parameter(Mandatory,Position=1,ParameterSetName="tags")]
        [PSCredential]
        $Credential

    )
    
    begin { $null = Get-GrafanaConfig }

    process {

        $irmParams = @{
            
            Method      = "GET"
            ContentType = "application/json"
            Authentication = "Basic"
            Credential = $Credential

        }

        If($($configuration.GrafanaUri) -match '^(http://)'){
                    
            $irmParams.Add('AllowUnencryptedAuthentication',$true)
        
        }
    

        Switch($PSCmdlet.ParameterSetName){

            'time' {}
            'alert' {

                $alertId = Get-GrafanaAlert | Where-Object { $_.Name -eq "$AlertName" } | Select -ExpandProperty id

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/annotations?alertId=$alertID")

            }
            'dashboard' {

                $dashboardId = Get-GrafanaDashboard | Where-Object { $_.title -eq "$DashboardName"} | Select-Object -ExpandProperty id

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/annotations?dashboardId=$dashboardId")

            }
            'panel' {}
            'user' {

                $userId = Get-GrafanaUser -Username $Username | Select-Object -ExpandProperty id

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/annotations?userId=$userId")

            }
            'type' {

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/annotations?type=$($Type.ToLower())")

            }
            'tags' {

                $uri = @("$($configuration.GrafanaUri)/annotations?tags=")
                
                $tags = $Tags -join "&tags="

                Write-Host $uri$tags

                $irmParams.Add('Uri',"$uri$tags")


            }

            'all' {

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/annotations")

            }
        }

        $result = Invoke-RestMethod @irmParams

        $result

    }

}