function New-GraphanaGraphPanel {

    [cmdletBinding()]
    Param(
        [Parameter(Mandatory,Position=0)]
        [String]
        $Title,

        [Parameter(Mandatory,Position=1)]
        [String]
        $Description,

        [Parameter(Mandatory,Position=2)]
        [String]
        $Datasource,

        [Parameter(Mandatory,Position=3)]
        [String]
        [ValidateSet('graph','singlestat','gauge','table','text','heatmap','alert list','dashboard list','plugin list')]
        $Type,
        
        [Parameter()]
        [Switch]
        $Transparent,

        [Parameter()]
        [Array]
        $valueMappings,

        [Parameter()]
        [Switch]
        $showThresholdLabels,

        [Parameter()]
        [Switch]
        $showThresholdMarkers,

        [Parameter()]
        [Int]
        $minValue,

        [Parameter()]
        [int]
        $thresholds_Index,

        [Parameter()]
        [string]
        $threshold_HexColor,

        [Parameter()]
        [int]
        $threshold_Value

        

    )

    begin {}

    process {
        $panelHash = @{
            
        }

    }

    end {}

}