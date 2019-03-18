function New-GrafanaAPIKey {

    [cmdletBinding()]
    Param(
        
        [Parameter(Mandatory,Position=0)]
        [String]
        $GrafanaUri,

        [Parameter(Mandatory,Position=1)]
        [String]
        $Name,

        [Parameter(Mandatory,Position=2)]
        [ValidateSet('Admin','Viewer','Editor')]
        [String]
        $Role

    )

    begin {}

    process {
        $header = New-Object [System.Collections.Generic.Dictionary[[String],[String]]]
        $header.Add("Bearer:", $env:ApiKey)
        $irmParams = @{


        }
    }


}