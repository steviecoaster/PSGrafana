function Set-GrafanaFolder {
    <#
    .SYNOPSIS
    Update the Title of a Folder in Grafana
    
    .DESCRIPTION
    The API only allows updates to the Title of a folder in Grafana. This cmdlet accomplishes that task
    
    .PARAMETER OldTitle
    The current title of the Folder you wish to change
    
    .PARAMETER NewTitle
    The new title of the folder you wish to change
    
    .EXAMPLE
    Set-GrafanaFolder -OldTitle "FooBar" -NewTitle "FizzBuzz"

    Set the title of the folder FooBar to FizzBuzz
    
    .NOTES
    
    #>
    
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Set-GrafanaFolder",SupportsShouldProcess=$true,ConfirmImpact="High")]
    Param(
        [Parameter(Mandatory,Position=0)]
        [String]
        $OldTitle,

        [Parameter(Mandatory,Position=1)]
        [String]
        $NewTitle
    )

    begin { $null = Get-GrafanaConfig }

    process {

        $Uid = Get-GrafanaFolder | Where-Object { $_.title -eq "$OldTitle" } | Select-Object -ExpandProperty uid
        $Version = Get-GrafanaFolder -Uid $uid | Select-Object -ExpandProperty version

        Write-Warning -Message "Modifying folder with Uid: $Uid and Version: $Version"

        $irmParams = @{
            
            Method      = "PUT"
            Headers     = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"
            Uri         = "$($configuration.GrafanaUri)/folders/$Uid?overwrite=true"
            Body        = (@{Title = $NewTitle}| ConvertTo-Json)

        }

        If($PSCmdlet.ShouldProcess("Folder: $OldTitle", "UPDATE")){
            
            Invoke-RestMethod @irmParams
        
        }

    }

}