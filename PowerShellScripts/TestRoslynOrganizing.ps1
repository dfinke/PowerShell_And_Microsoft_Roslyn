#requires -version 3
cls

$path = "..\VisualStudioSolutions\TestRoslynUsingStatements"
. .\RoslynOrganize.ps1
$sln = (dir $path *.sln).Fullname

(dir (Join-Path $path TestRoslynUsingStatements) *.cs).FullName | 
    ForEach {
        .\GetRandomUsings.ps1 | Set-Content $_
    }

Invoke-OrganizeUsings $sln