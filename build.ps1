$d = [System.IO.File]::Exists(".w3x");
 if ($d)
 {

     $location = Get-Location
     mkdir ".\Temp"
     Set-Location ".\Temp"
    &"D:\Program Files\WC3Edit\jasshelper\clijasshelper.exe" ("--scriptonly","..\Scripts\\common.j", "..\Scripts\\blizzard.j","..\Precompiled\\Scripts\\war3map.j","..\Map\\war3map.j")
    Set-Location $location
    Remove-Item -Path:".\Temp" -Confirm:$false -force -recurse
    &"d:\program files\wc3edit\wc3lni\w2l.exe" slk;
 }
 else 
 {
     write-output ".w3x not found";
     exit;
 }
 