function Get-GrafanaUser {
   <#
   .SYNOPSIS
   Return information about a Grafana user.     
   
   .DESCRIPTION
   Search via Email Address or Username for information about the specified Grafana user.
   
   .PARAMETER Username  
   The username to query information for    
   
   .PARAMETER Credential
   The credentials to use when searching by username
   
   .PARAMETER EmailAddress
   The email address to query information for
   
   .EXAMPLE
   Get-GrafanaUser -EmailAddress bob@foo.com

   .EXAMPLE
   Get-GrafanaUser -Username bob -Credential grafana_admin

    You will be prompted to enter the password for grafana_admin

    .EXAMPLE
    Get-GrafanaUser -Username bob -Credential (Get-Credential)

    Provide the username and password of an org admin in Grafana to the Credential prompt

    .EXAMPLE
    Get-GrafanaUser -Username bob -Credential $Credential

    Use a stored Grafana org admin credential
   
   .NOTES
   General notes
   #>
       
    [cmdletBinding(HelpUri="https://github.com/steviecoaster/PSGrafana/wiki/Get-GrafanaUser",DefaultParameterSetName="Email")]
    Param(
        
        [Parameter(Mandatory,ParameterSetName="Username")]
        [String]
        $Username,

        [Parameter(Position=0,Mandatory,ParameterSetName="Email")]
        [String]
        $EmailAddress,

        [Parameter(Position=0,Mandatory,ParameterSetName="All")]
        [Switch]
        $All,

        [Parameter(Mandatory,ParameterSetName="All")]
        [Parameter(Mandatory,ParameterSetName="Username")]
        [Parameter(Mandatory,ParameterSetName="Email")]
        [PSCredential]
        $Credential
    )

    begin { $null = Get-GrafanaConfig }

    process {

        $irmParams = @{
            
            Method      = "GET"
            ContentType = "application/json"

        }

        If($($configuration.GrafanaUri) -match '^(http://)'){
                    
            $irmParams.Add('AllowUnencryptedAuthentication',$true)
        
        }

        Switch($PSCmdlet.ParameterSetName){

            'Username' {

                
                    $irmParams.Add('Uri',"$($configuration.GrafanaUri)/users/search?query=$Username")
                    $irmParams.Add('Authentication', "Basic")
                    $irmParams.Add('Credential', $Credential)
            }

            'Email' {

                    $irmParams.Add('Uri',"$($configuration.GrafanaUri)/users/search?query=$EmailAddress")
                    $irmParams.Add('Authentication', "Basic")
                    $irmParams.Add('Credential', $Credential)

            }

            'All' { 

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/users/search")
                $irmParams.Add('Authentication', "Basic")
                $irmParams.Add('Credential', $Credential)


            }

        }

        $return = Invoke-RestMethod @irmParams

        $output = [System.Collections.Generic.List[pscustomobject]]::new()

        $return.users | ForEach-Object { $output.Add([pscustomobject]$_) }

        $output

    }

}