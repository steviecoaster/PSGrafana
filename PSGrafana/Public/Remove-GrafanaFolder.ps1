function Remove-GrafanaFolder {
<#
.SYNOPSIS
Removes the specified folder from your Grafana instance

.DESCRIPTION
Removes the specified folder from your Grafana instance using the API. This is a highly destructive operation. Any Panels that are stored within the folder will be destroyed.

.PARAMETER Folder
The folder you wish to delete

.EXAMPLE
Remove-GrafanaFolder -Folder Duckies

#>

    [cmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]
    Param(
        
        [Parameter(Mandatory,Position=0)]
        [String]
        $Folder
    )

    begin { $null = Get-GrafanaConfig }

    process {

        $Uid = Get-GrafanaFolder | Where-Object { $_.title -eq "$Folder" } | Select-Object -ExpandProperty uid

        $irmParams = @{
            
            Method      = "DELETE"
            Headers     = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"
            Uri         = "$($configuration.GrafanaUri)/folders/$Uid"

        }

        If($PSCmdlet.ShouldProcess("Folder: $Folder", "DELETE")){
        $return = Invoke-RestMethod @irmParams

        $return
        }
    }
}