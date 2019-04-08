function Remove-GrafanaSnapshot {
    <#
    .SYNOPSIS
    Remove a Grafana snapshot via the API
    
    .DESCRIPTION
    Grafana exposes an endpoint to delete snapshots. This cmdlet leverages that endpoint to let you remove them programmatically
    
    .PARAMETER SnapshotName
    The friendly name of the snapshot you wish to remove
    
    .EXAMPLE
    Remove-GrafanaSnapshot -SnapshotName SnappyMcSnapshoterson
    
    #>
    
    [cmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]
    Param(
        
        [Parameter(Mandatory)]
        [String]
        $SnapshotName

    )

    begin { $null = Get-GrafanaConfig }

    process {

        $Key = Get-GrafanaSnapshot -SnapshotName $SnapshotName | Select-Object -ExpandProperty key

        $irmParams = @{
            
            Method = "DELETE"
            Headers     = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"
            Uri = "$($configuration.GrafanaUri)/snapshots/$key"

        }

        If($PSCmdlet.ShouldProcess("Snapshot: $SnapshotName", "DELETE")){
            
            Invoke-RestMethod @irmParams
        
        }

    }#process

}#function