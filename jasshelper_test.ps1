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

     $location = Get-Location
     mkdir $TempFolder
     Set-Location $TempFolder #шобы жасхелпер срал в временную папку, несколько усложняет пути например для импорта.
    &$jashelper ("--scriptonly",$commonj , $blizzardj,$war3MapToCompile,$CompiledScriptPath)
    Set-Location $location
    Remove-Item -Path:$TempFolder -Confirm:$false -force -recurse 
    #&$wc3lni slk;
 }
 else 
 {
     write-output ".w3x not found";
     exit;
 }
 