function New-GrafanaSnapshot {
    <#
        .SYNOPSIS
        Take a snapshot of a dashboard in Grafana

        .PARAMETER DashboardTitle
        Title of the dashboard you wish to snapshot

        .PARAMETER SnapshotName
        Name of the snapshot you are creating

        .PARAMETER Expires
        Time (in seconds) the snapshot stays alive. Set to 0 to never expire.
    
        .EXAMPLE
        New-GrafanaSnapshot -DashboardTitle WebHosts -SnapshotName WebSnap -Expires 0
        
        Create a new snapshot of WebHosts with the name WebSnap that never expires
    #>

    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/New-GrafanaSnapshot")]
    Param(

        [Parameter(Mandatory,Position=0)]
        [String]
        $DashboardTitle,

        [Parameter(Mandatory,Position=1)]
        [String]
        $SnapshotName,

        [Parameter(Position=0)]
        [Int]
        $Expires = 0
    )

    begin { $null = Get-GrafanaConfig}
    
    process {
        
        
        $irmParams = @{
            
            headers = @{ Authorization = "Bearer $($Configuration.apikey)"}
            body= @{
            
                dashboard = [ordered]@{
                editable     = $False
                hideControls = $True
                nav          = @(@{enable=$False
                                type = 'timepicker'})
                rows         = @(@{})
                style        = "dark"
                tags         = @()
                templating   = @{list = @()}
                time         = @{}
                timezone    = "browser"
                title        = "$DashboardTitle"
                version      = 5
                }
                expires = $Expires
                name = "$SnapshotName"
            
            } | ConvertTo-Json -Depth 4
            Method      = "POST"
            Uri         = "$($configuration.GrafanaUri)/snapshots"
            ContentType = "application/json"


        }

        Invoke-RestMethod @irmParams

    }
}