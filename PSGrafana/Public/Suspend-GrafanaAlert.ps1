function Suspend-GrafanaAlert {
    <#
    .SYNOPSIS
    Pause a Grafana Alert by Name, ID, or pause ALL alerts in Grafana
    
    .DESCRIPTION
    This cmdlet provides a way to pause Grafana alerts via the API
    
    .PARAMETER AlertId
    The ID of the Grafana Alert you wish to pause
    
    .PARAMETER AlertName
    The Name of the Grafana Alert you wish to pause
    
    .PARAMETER All
    Pause all Grafana Alerts
    
    .PARAMETER Credential
    The credential to use to pause all Grafana alerts
    
    .EXAMPLE
    Suspend-GrafanaAlert -AlertId 12

    .EXAMPLE
    Suspend-GrafanaAlert -AlertName WebResponseTime

    .EXAMPLE
    Suspend-GrafanaAlert -All -Credential _username_

    .EXAMPLE
    Suspend-GrafanaAlert -All -Credential (Get-Credential)
    
    .NOTES
    The -Credential parameter is required when pausing all alerts. This is due to how the API handles the authentication header for that operation

    #>
     
    [cmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Name")]
    Param(
        [Parameter(ParameterSetName="Id")]
        [Int]
        $AlertId,

        [Parameter(ParameterSetName="Name")]
        [String]
        $AlertName,

        [Parameter(Mandatory,Position=0,ParameterSetName="All")]
        [Switch]
        $All,

        [Parameter(Mandatory,Position=1,ParameterSetName="All")]
        [System.Management.Automation.PSCredential]
        $Credential

    )

    begin { $null = Get-GrafanaConfig }

    process {

        function Test-Uri($uri) {

            $null = $uri -match '^((?<insecure>http://)|(?<secure>https://))'
    
        }

        Test-Uri -uri $configuration.GrafanaUri

        $irmParams = @{
            
            Method      = "POST"
            ContentType = "application/json"
            Body        = @{'paused' = $true} | ConvertTo-Json

        }

        Switch($PSCmdlet.ParameterSetName){

            'Id' {
                $irmParams.Add('Uri',"$($Configuration.GrafanaUri)/alerts/$AlertId/pause")
                $irmParams.Add("Headers",@{ Authorization = "Bearer $($Configuration.apikey)"})

                    If($PSCmdlet.ShouldProcess("Alert: $AlertId", "PAUSE")){

                        $result = Invoke-RestMethod @irmParams
                        $result
                    }
            }

            'Name' { 

                $Name = (Get-GrafanaAlert -AlertName $AlertName).id
                
                $irmParams.Add('Uri',"$($Configuration.GrafanaUri)/alerts/$Name/pause")
                $irmParams.Add("Headers",@{ Authorization = "Bearer $($Configuration.apikey)"})

                    If($PSCmdlet.ShouldProcess("Alert: $Alertname", "PAUSE")){

                        $result = Invoke-RestMethod @irmParams
                        $result
                    }

            }

            'All' {

                
                    $irmParams.Add("Uri","$($configuration.GrafanaUri)/admin/pause-all-alerts")
                    $irmParams.Add("Authentication","Basic")
                    $irmParams.Add("Credential",$Credential)

                    If($($configuration.GrafanaUri) -match '^(http://)'){
                    
                        $irmParams.Add('AllowUnencryptedAuthentication',$true)
                    
                    }

                    If($PSCmdlet.ShouldProcess("Alert: $Alertname", "PAUSE")){

                        $result = Invoke-RestMethod @irmParams
                        $result
                    }

                }            
            }

    }#process

}#function