function Get-GrafanaServerSettings { 
    <#
    .SYNOPSIS
    Returns server settings for your Grafana Instance
    
    .DESCRIPTION
    Returns the currently configured settings for your Grafana instance. User must be an Org Admin to retrieve these settings
    
    .PARAMETER Credential
    The credentials you wish to use
    
    .EXAMPLE
    Get-GrafanaServerSettings
    
    #>
    
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaServerSettings")]
    Param(
        [Parameter(Mandatory,Position=0)]
        [PSCredential]
        $Credential
    )

    begin { $null = Get-GrafanaConfig }

    process {

        $irmParams = @{
            
            Method = 'GET'
            Authentication = "Basic"
            Credential = $Credential
            ContentType = "application/json"
            Uri = "$($configuration.Grafanauri)/admin/settings"
        }

        If($($configuration.GrafanaUri) -match '^(http://)'){
                    
            $irmParams.Add('AllowUnencryptedAuthentication',$true)
        
        }

        $result = Invoke-RestMethod @irmParams

        $result

    }
}