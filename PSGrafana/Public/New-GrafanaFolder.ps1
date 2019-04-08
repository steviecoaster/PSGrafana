function New-GrafanaFolder { 
    <#
    .SYNOPSIS
    Create a new folder in Grafana via the API
    
    .DESCRIPTION
    The Grafana API allows you to create new folders. This cmdlet accomplishes this. Title is required, but you may supply an optional Uid.
    If you don't specify a Uid, one will be generated for you by the API at runtime.
    
    .PARAMETER Title
    The title of the folder you wish to create with the API
    
    .PARAMETER Uid
    The uid to give the folder when created by the API
    
    .EXAMPLE
    New-GrafanaFolder -Title "My Awesome Folder"

    Creates a new folder in Grafana called "My Awesome Folder"
    
    .EXAMPLE
    New-GrafanaFolder -Title "Web Farm Folder" -Uid nErXDvCkzz

    Creates a new folder in Grafana called "Web Farm Folder" with a Uid of nErXDvCkzz
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/New-GrafanaFolder")]
    Param(
        [Parameter(Mandatory,Position=0)]
        [String]
        $Title,

        [Parameter(Position=1)]
        [String]
        $Uid
    )

    begin { $null = Get-GrafanaConfig }

    process {

        $body = @{

            title = $Title
            
        }
    
        If($Uid){
    
            $body.Add('uid',$Uid)
        }

        $irmParams = @{
            
            Method      = "POST"
            Headers     = @{ Authorization = "Bearer $($Configuration.apikey)"}
            Uri         = "$($Configuration.GrafanaUri)/folders"
            ContentType = "application/json"
            Body = $body | ConvertTo-Json

        }

        Invoke-RestMethod @irmParams

    }
}