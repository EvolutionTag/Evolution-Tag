$jashelper = "D:\\Program Files\\WC3Edit\\jasshelper\\clijasshelper.exe"
$wc3lni = "d:\\program files\\wc3edit\\wc3lni\\w2l.exe"
$TempFolder = ".\\Temp" #warning! will be deleted after compilation


$d = [System.IO.File]::Exists(".w3x");
 if ($d)
 {

     $location = Get-Location
     mkdir $TempFolder
     Set-Location $TempFolder
    &$jashelper ("--scriptonly","..\\Scripts\\common.j", "..\Scripts\\blizzard.j","..\Precompiled\\Scripts\\war3map.j","..\Map\\war3map.j")
    Set-Location $location
    Remove-Item -Path:$TempFolder -Confirm:$false -force -recurse
    &$wc3lni slk;
 }
 else 
 {
     write-output ".w3x not found";
     exit;
 }
 