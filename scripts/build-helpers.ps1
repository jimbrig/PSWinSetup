# Ensure everything works in the most strict mode.
Set-StrictMode -Version Latest

$RepoRoot = Join-Path $PSScriptRoot '..' | Resolve-Path
$ModuleName = 'PSWinSetup' # '<%=$PLASTER_PARAM_ModuleName%>'
$ModulePath = Join-Path $RepoRoot $ModuleName
$PublicFunctionsPath = Join-Path $ModulePath 'Public'
$DocsPath = Join-Path $RepoRoot 'docs'
$DocsLocale = 'en-US'
$ModuleManifestPath = Join-Path $ModulePath "$ModuleName.psd1"
$LocalBuildPath = Join-Path $RepoRoot 'build'

Function Get-Version {
	if (Test-Path $ModuleManifestPath) {
		$manifest = Test-ModuleManifest -Path $ModuleManifestPath
		[System.Version]$version = $manifest.Version
		# Write-Host "Old Version: $version"
		$env:version = New-Object -TypeName System.Version -ArgumentList ($version.Major, $version.Minor, ($version.Build + 1 ))
		# Write-Host "New Version: $env:version"
		Try {
			# Update the manifest with the new version value and fix the weird string replace bug
			$functionList = ((Get-ChildItem -Path $PublicFunctionsPath -Recurse -Filter "*.ps1").BaseName)
			Update-ModuleManifest -Path $ModuleManifestPath -ModuleVersion $env:version -FunctionsToExport $functionList
			(Get-Content -Path $ModuleManifestPath) -replace "PSGet_$ModuleName", "$ModuleName" | Set-Content -Path $ModuleManifestPath
			(Get-Content -Path $ModuleManifestPath) -replace 'NewManifest', "$ModuleName" | Set-Content -Path $ModuleManifestPath
			(Get-Content -Path $ModuleManifestPath) -replace 'FunctionsToExport = ', 'FunctionsToExport = @(' | Set-Content -Path $ModuleManifestPath -Force
			(Get-Content -Path $ModuleManifestPath) -replace "$($functionList[-1])'", "$($functionList[-1])')" | Set-Content -Path $ModuleManifestPath -Force
		} catch {
			throw $_
		}
	} else {
		throw 'Versioning requires Module Manifest'
	}
}

Function Test-Module {
    try {
		$testResultsFile = "$RepoRoot\TestResult.xml"
		$result = Invoke-Pester -OutputFormat NUnitXml -OutputFile $testResultsFile -PassThru
		Remove-Item $testResultsFile -Force
		Assert-Build ($result.FailedCount -eq 0) "$($result.FailedCount) Pester test(s) failed."
	} catch {
		throw
	}
}

Function Update-Docs {

    # Import modules
    Import-Module platyPS
    Import-Module $modulePath -Force

    # Generate markdown for new cmdlets
    New-MarkdownHelp -Module $ModuleName -OutputFolder $docsPath -Locale $DocsLocale -UseFullTypeName -ErrorAction SilentlyContinue | Out-Null
    # Update markdown for existing cmdlets
    Update-MarkdownHelp -Path $docsPath -UseFullTypeName | Out-Null
    # Generate external help
    New-ExternalHelp -Path $docsPath -OutputPath (Join-Path -Path $modulePath -ChildPath $DocsLocale) -Force | Out-Null

}

Function Build-Module {
    Get-Version
    # Test-Module
    Update-Docs

    $BuildFolderName = ('{0}\{1}' -f $ModuleName, (Test-ModuleManifest -Path $ModuleManifestPath).Version)
    $BuildFolderPath = (Join-Path $LocalBuildPath $BuildFolderName)
    if(Test-Path $BuildFolderPath) {
        Remove-Item $BuildFolderPath -Force -Recurse
    }
	$BuildFolder = New-Item -Path $LocalBuildPath -Name $BuildFolderName -ItemType Directory
	Copy-Item -Path (Join-Path $RepoRoot "$ModuleName\*") -Destination $BuildFolder -Recurse

}