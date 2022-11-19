./build/lib/paths.ps1
&$wc3lni slk;
$prefix = "../"
$suffix = ".w3x"

Write-Output $name
del $name
copy "../Evolution Tag.w3x" $name
del "../Evolution Tag.w3x"
