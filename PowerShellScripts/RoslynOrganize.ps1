#requires -version 3

function Invoke-OrganizeUsings {    
    #
    # http://www.microsoft.com/en-us/download/details.aspx?id=27745
    # Getting Started - Workspace (CSharp)

    param (
        [Parameter(ValueFromPipeline)]
        $FileName
    )

    Get-Content .\DLLs.txt | foreach { Add-Type -Path $_ }

    $CancellationToken = New-Object System.Threading.CancellationToken

    $workspace        = [Roslyn.Services.Workspace]::LoadSolution($FileName)
    $originalSolution = $workspace.CurrentSolution
    $newSolution      = $originalSolution

    foreach ($project in $originalSolution.Projects)
    {
        foreach ($documentId in $project.DocumentIds)
        {
            $document       = $newSolution.GetDocument($documentId)
            
            Write-Host "Organizing $($document.Name)"

            $transformation = [Roslyn.Services.DocumentExtensions]::OrganizeImports($document, $true, $CancellationToken)
            $newDocument    = $transformation.GetUpdatedDocument($CancellationToken)
            $newSolution    = $newDocument.Project.Solution
        }
    }

    [void]$workspace.ApplyChanges($originalSolution, $newSolution, $CancellationToken)
}