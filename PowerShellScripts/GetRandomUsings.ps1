param($HowMany=5)

$UsingStatements = Get-Content .\UsingStatements.txt

1..$HowMany | foreach {
    $UsingStatements | Get-Random
}