$location = Get-Location
. .\build\lib\paths.ps1

$wc3 = ($wc3folder+"war3.exe")
$map = '"'+(Get-Item $location).FullName+".w3x"+'"'

$arg = @("-loadfile",$map,"-windowed")
Write-Output $arg

Start-Process -FilePath $wc3 -ArgumentList $arg -WorkingDirectory $wc3folder