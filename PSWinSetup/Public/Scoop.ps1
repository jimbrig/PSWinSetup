Function Export-Scoop {
    param(
        $path
    )

    $today = Get-Date -Format "MM-dd-yyyy"
    $outputFile = $today + "-scoop-packages.config"
    $outputPath = Join-Path $path $outputFile
    scoop export > $outputPath
}

Function Import-Scoop {
    param(
        $exported
    )

    $apps = (
        Get-Content -Path $exported | Select-String '(?<app>.*)\s\(v:(?<version>.*)\)\s\[(?<bucket>.*)\]' -AllMatches | 
        Foreach-Object { $_.Matches } | 
        Foreach-Object { ($_.Groups["bucket"].Value) + "/" + ($_.Groups["app"].Value) }
    )

    $apps = ($apps | Out-String).Replace("`r`n", " ")
    $cmd = "scoop install " + $apps.Trim(" ")
    Invoke-Expression $cmd

}
