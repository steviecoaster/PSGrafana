function New-GrafanaSnapshot {

    [cmdletBinding()]
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