$jashelper = "D:\\Program Files\\wc3 we\\Jass New Gen Pack Rebuild\\jasshelper\\clijasshelper.exe"
$wc3lni = "d:\\program files\\wc3edit\\wc3lni\\w2l.exe"
$TempFolder = ".\\Temp" #warning! will be deleted after compilation (нафиг удалится после компиляции)
$commonj = "..\\Scripts\\common.j"
$blizzardj = "..\\Scripts\\blizzard.j"
$war3MapToCompile = "..\\ToCompile\\Scripts\\war3map.j"
$CompiledScriptPath = "..\\Map\\war3map.j"
$wc3folder = "D:\Games\Warcraft 3.3\"
$suffix = ".w3x"
$version = "ET35_23"
$prefix = ((Get-Item (Get-Location).Path).Parent).FullName.ToString()+"\"
$namesimple = $prefix+$version+$suffix
$name = '"'+$namesimple+'"'