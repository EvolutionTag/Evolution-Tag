$d = [System.IO.File]::Exists(".w3x");
 if ($d)
 {
 }
 else 
 {
    write-output ".w3x not found";
    exit;
 }
 