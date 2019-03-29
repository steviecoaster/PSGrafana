$public = Get-ChildItem $PSScriptRoot\Public\*.ps1
$private = Get-ChildItem $PSScriptRoot\Private\*.ps1

Foreach($Script in @($public + $private)){

    . $Script.FullName

}
