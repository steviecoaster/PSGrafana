function Get-GrafanaOrgUser {
    <#
    .SYNOPSIS
    Returns all users within the current org
    
    .DESCRIPTION
    Returns all users of the current org in the context of the API key token holder's context
    
    .EXAMPLE
    Get-GrafanaOrgUser
   
    #>
    
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaOrgUser")]
    Param(
        
    )

    begin { $null = Get-GrafanaConfig } 

    process {
        
        $irmParams = @{
            
            Method      = 'GET'
            Headers     = @{ Authorization = "Bearer $($Configuration.apikey)"}
            ContentType = "application/json"
            Uri         ="$($configuration.GrafanaUri)/org/users"

        }

        $return = Invoke-RestMethod @irmParams

        $return

    }
}