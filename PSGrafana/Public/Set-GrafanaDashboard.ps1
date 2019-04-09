function Set-GrafanaDashboard {
    <#
    .SYNOPSIS
    Update an existing Dashboard in Grafana
    
    .DESCRIPTION
    Change the title and tags of an existing Dashboard in Grafana
    
    .PARAMETER Title
    The title of the dashboard you wish to modify
    
    .PARAMETER NewTitle
    The new title of the Dashboard if you wish to change it
    
    .PARAMETER Tags
    The updated tags. This overwrites existing tags
    
    .PARAMETER DashboardId
    If you know the dashboard ID, you may enter it
    
    .PARAMETER DashboardUid
    If you know the dashboard Uid, you may enter it
    
    .EXAMPLE
    Set-GrafanaDashboard -Title "Boring Old Title" -NewTitle "Fancy New Title"

    .EXAMPLE
    Set-GrafanaDashboard -Title "Boring Old Title" -NewTitle "Fancy New Title" -Tags "prod","wizz_bang"

    .EXAMPLE
    Set-GrafanaDashboard -Title "Boring Old Title" -Tags "prod","apache" -DashboardId 35 -DashboardUid 5XWS256
    
    #>
    
    [cmdletBinding(DefaultParameterSetName="Update")]
    Param(
        [Parameter(Mandatory,Position=0,ParameterSetName="Update")]
        [String]
        $Title,

        [Parameter(Position=1,ParameterSetName="Update")]
        [String]
        $NewTitle,

        [Parameter(ParameterSetName="Update")]
        [String[]]
        $Tags,

        [Parameter(Mandatory,ParameterSetName="id")]
        [Int]
        $DashboardId,

        [Parameter(Mandatory,ParameterSetName="id")]
        [String]
        $DashboardUid
    )

    begin { $null = Get-GrafanaConfig }

    process {

        $irmParams = @{
            
            Headers = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"
            Method = "POST"
            Uri = "$($configuration.GrafanaUri)/dashboards/db"

        }

        $body = @{
            
            overwrite = $true

        }
        $dashboard = @{}

        if($NewTitle){
            
            $dashboard.Add("title",$NewTitle)

        }

        else{

            $dashboard.Add("title",$Title)

        }

       If($PSCmdlet.ParameterSetName -eq "id"){

        $dashboard.Add("id",$DashboardId)
        $dashboard.Add("uid",$DashboardUid)

       }

       else{

        $identifiers = Get-GrafanaDashboard -Name $Title | Select-Object id,uid,folderid

        $dashboard.Add("id",$identifiers.id)
        $dashboard.Add("uid",$identifiers.uid)

        $body.Add('folderId',$identifiers.folderid)

       }

       $body.Add("dashboard",$dashboard)

       $irmParams.Add("Body",($body | ConvertTo-Json))

       $return = Invoke-RestMethod @irmParams
       
       $return

    }
}