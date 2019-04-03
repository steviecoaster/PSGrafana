function New-GrafanaApiKey {
    <#
        .SYNOPSIS
        Creates a new API key in Grafana
        
        .PARAMETER Name
        The friendly name of the API key
        
        .PARAMETER Role
        The access level for the key. Available options are Admin,Editor, and Viewer
        
        .EXAMPLE
        New-GrafanaApiKey -Name RickyBobby -Role Admin

        .EXAMPLE
        New-GrafanaApiKey -Name Alice -Role Editor

        .NOTES
        The generated API key is only displayed at runtime. If you need to retain it for any reason, be sure to it somewhere safe.
        It is highly recommended you run this command saved to a variable such as $ApiKey = New-GrafanaApiKey -Name ElmerFudd -Role Viewer.
        This way you can access the properties Name and Key within the variable. E.g. $ApiKey.name, or $ApiKey.key.
    #>
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/New-GrafanaApiKey")]
    Param(
        
        [Parameter(Mandatory,Position=0)]
        [String]
        $Name,

        [Parameter(Mandatory,Position=1)]
        [ValidateSet('Admin','Viewer','Editor')]
        [String]
        $Role

    )

    begin { 
        
        $null = Get-GrafanaConfig
        
    }

    process {
        
        $header = @{ Authorization = "Bearer $($Configuration.apikey)"}
        $body = @{name = $Name; role = $Role} | ConvertTo-Json

        $irmParams = @{
            Method = 'POST'
            Uri = "$($Configuration.GrafanaUri)/auth/keys"
            Body = "$body"
            Headers = $header
            ContentType = "application/json"

        }
        Write-Warning -Message "You'll only see the API key generated here one time. There is no method to retrieve/generate it."
        Invoke-RestMethod @irmParams

    }

}