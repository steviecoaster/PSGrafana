function New-GrafanaDashboard {
    <#
    .SYNOPSIS
    Add a new dashboard to Grafana
    
    .DESCRIPTION
    This cmdlet adds a new dashboard to the specified folder inside of Grafana
    
    .PARAMETER Title
    The Title of the Dashbaord
    
    .PARAMETER Tags
    The tags you wish the Dashboard to use
    
    .PARAMETER Folder
    The folder in which to store the Dashboard in Grafana
    
    .EXAMPLE
    New-GrafanaDashboard -Title "My Awesome Dashboard" -Folder "Fancy Dashboards"

    .EXAMPLE
    New-GrafanaDashboard -Title "My Awesome Dashboard" -Tags "production","webserver","cats" -Folder Home
    
    #>
    
    [cmdletBinding(DefaultParameterSetName="New")]
    Param(
        [Parameter(Mandatory,ParameterSetName="New")]
        [String]
        $Title,

        [Parameter(ParameterSetName="New")]
        [String[]]
        $Tags,

        [Parameter(Mandatory,ParameterSetName="New")]
        [String]
        $Folder

       
    )

    begin { $null = Get-GrafanaConfig }

    process {

        $irmParams = @{
            Headers = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"
            Method = "POST"
            Uri = "$($configuration.GrafanaUri)/dashboards/db"
        }

        $body = @{}
        $dashboard = @{
            
            title = "$Title"
            tags = $Tags

        }

        $FolderId = Get-GrafanaFolder | Where-Object { $_.title -eq $Folder } | Select-Object -ExpandProperty id
        
        $body.Add('folderId',$FolderId)
        $body.Add("overwrite",$false)
        $body.Add("dashboard",$dashboard)
        
        $dashboard.Add("id",$null)
        $dashboard.Add("uid",$null)       

        $irmParams.Add('Body',($body | ConvertTo-Json))

        $result = Invoke-RestMethod @irmParams

        $result

    }#process

}#function