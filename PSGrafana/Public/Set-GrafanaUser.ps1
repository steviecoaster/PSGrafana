function Set-GrafanaUser {
    [cmdletBinding()]
    Param(
        [Parameter(Mandatory,Position=0)]
        [String]
        $Username,

        [Parameter(Position=1)]
        [ValidateSet('default','light','dark')]
        [String]
        $Theme,

        [Parameter(Position=2)]
        [String]
        $FullName,

        [Parameter(Position=3)]
        [String]
        $EmailAddress,

        [Parameter(Position=4)]
        [String]
        $NewUsername,

        [Parameter(Mandatory,Position=5)]
        [PSCredential]
        $Credential

    )

    begin { $null = Get-GrafanaConfig }

    process {

        $User = Get-GrafanaUser -Username $Username -Credential $Credential

        $irmParams = @{
            
            Method = 'PUT'
            Authentication = "Basic"
            Credential = $Credential
            ContentType = "application/json"
            
        }

        If($($configuration.GrafanaUri) -match '^(http://)'){
                    
            $irmParams.Add('AllowUnencryptedAuthentication',$true)
        
        }

        $body = @{}

        Switch($PSBoundParameters.Keys){

            'Username' {

                $irmParams.Add('Uri',"$($configuration.GrafanaUri)/users/$($User.users.id)")
                $body.Add("login","$Username")

            }

            'Theme' {

                $body.Add('theme',"$Theme")
            }

            'FullName' {

                $body.Add("name","$FullName")

            }

            'EmailAddress' {

                $body.Add("email","$EmailAddress")

            }

            'NewUsername' {

                $body.Add("login","$NewUsername")

            }

        }#switch

        $body | ConvertTo-Json
        
        $irmParams.Add("body",($body | ConvertTo-Json))

        $result = Invoke-RestMethod @irmParams

        $result

    }#process

}#function