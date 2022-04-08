$jashelper = "D:\\Program Files\\wc3 we\\Jass New Gen Pack Rebuild\\jasshelper\\clijasshelper.exe"
$wc3lni = "d:\\program files\\wc3edit\\wc3lni\\w2l.exe"
$TempFolder = ".\\Temp" #warning! will be deleted after compilation (нафиг удалится после компиляции)
$commonj = "..\\Scripts\\common.j"
$blizzardj = "..\\Scripts\\blizzard.j"
$war3MapToCompile = "..\\ToCompile\\Scripts\\war3map.j"
$CompiledScriptPath = "..\\Map\\war3map.j"


$d = [System.IO.File]::Exists(".w3x");
 if ($d)
 {
    &$wc3lni slk;
 }
 else 
 {
     write-output ".w3x not found";
     exit;
 }
 