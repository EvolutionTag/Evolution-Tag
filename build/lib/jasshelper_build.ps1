$location = Get-Location
Remove-Item -Path:$TempFolder -Confirm:$false -force -recurse 
mkdir $TempFolder
Set-Location $TempFolder #шобы жасхелпер срал в временную папку, несколько усложняет пути например для импорта.
&$jashelper ("--scriptonly","--nooptimize",$commonj , $blizzardj,$war3MapToCompile,$CompiledScriptPath)
Set-Location $location