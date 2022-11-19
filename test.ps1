$location = Get-Location
. .\build\lib\paths.ps1

$wc3 = ($wc3folder+"war3.exe")
$mapfolder = (Get-Item $location).Parent.FullName
$map = '"'+$mapfolder.ToString() + "\" + $name + ".w3x"+'"'

$arg = @("-loadfile",$map,"-window")
Write-Output $arg

Start-Process -FilePath $wc3 -ArgumentList $arg -WorkingDirectory $wc3folder