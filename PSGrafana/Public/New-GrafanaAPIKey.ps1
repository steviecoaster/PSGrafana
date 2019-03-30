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
    #>
    [cmdletBinding()]
    Param(
        
        [Parameter(Mandatory,Position=0)]
        [String]
        $Name,

        [Parameter(Mandatory,Position=1)]
        [ValidateSet('Admin','Viewer','Editor')]
        [String]
        $Role

    )

    begin { $null = Get-GrafanaConfig}

    process {
        
        $header = @{ Authorization = "Bearer $($Configuration.apikey)"}
        $body = @{name = $Name; role = $Role} | ConvertTo-Json

        $body
        $irmParams = @{
            Method = 'POST'
            Uri = "$($Configuration.GrafanaUri)/auth/keys"
            Body = "$body"
            Headers = $header
            ContentType = "application/json"

        }

        $data = Invoke-RestMethod @irmParams
        $NewApiKey = $data.key
        Write-Information "API Key has been generated successfully"
        Write-Information "This is the only time you'll be able to view the API key."
        Write-Information "The key as been put into the $NewApiKey variable automatically"
        Write-Information "Please make note of this key for your records, should you need it."

        $data | Format-List

        
    }


}