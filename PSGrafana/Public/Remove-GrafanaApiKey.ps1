function Remove-GrafanaApiKey {
    <#
    .SYNOPSIS
    Deletes an API key from your Grafana Instance
    
    .PARAMETER ApiId
    The ID of the API Key you wish to delete
    
    .EXAMPLE
    Remove-GrafanaApiKey -ApiId 6

    #>
    
    [cmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High",HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Remove-GrafanaApiKey")]
    Param(

    [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Int]
    $ApiId

    )

    begin { $Null = Get-GrafanaConfig }

    process {

        If($PSCmdlet.ShouldProcess("ID: $ApiId","DELETE")){

            $header = @{ Authorization = "Bearer $($Configuration.apikey)"}
            
            $irmParams = @{

                Method = "DELETE"
                Uri = "$($Configuration.GrafanaUri)/auth/keys/$ApiId"
                Headers = $header
                ContentType = "application/json"
            }

            Invoke-RestMethod @irmParams

        }
    }
}