Function Backup-WTSetting {
    <#
    .SYNOPSIS
    Backs up Windows Terminal `settings.json` configuration file to a specified destination directory.
    .NOTES
    Will detect both Windows Terminal (Default) and Preview settings.
    For Default, Destination directory will be appended by '\Windows-Terminal'.
    For Preview, Destination directory will be appended by '\Windows-Terminal-Preview'.
    .PARAMETER Limit
    Maximum number of backups to house in destination directory. Defaults to 7.
    .PARAMETER Destination
    Destination Directory
    .PARAMETER Passthru
    Pass through
    #>

    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [ValidateScript({$_ -ge 1})]
        [int]$Limit = 7,
        [parameter(Mandatory, HelpMessage = "Specify the backup location. It must already exist.")]
        [ValidateScript( { Test-Path $_ } )]
        [string]$Destination,
        [switch]$Passthru
    )

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($myinvocation.MyCommand)"
    
    $WTPath = "$ENV:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $WTPreviewPath = "$ENV:LOCALAPPDATA\\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"

    If (!(Test-Path $WTPath)) { Write-Info "No Default Windows Terminal Installation Detected." }
    If (!(Test-Path $WTPreviewPath)) { Write-Failure "No Preview Installation of Windows Terminal Detected either, aborting.."; throw "Error." }

    $DestinationWTDefault = Join-Path $Destination "Windows-Terminal"
    $DestinationWTPreview = Join-Path $Destination "Windows-Terminal-Preview"

    $paths = @($WTPath, $WTPreviewPath)
    $dests = @($DestinationWTDefault, $DestinationWTPreview)

    ForEach ($dest in $dests) { If (!(Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force } }

    ForEach ($i in 0..1) {

        $json = $paths[$i] | Resolve-Path
        $Destination = $dests[$i] | Resolve-Path

        if (Test-Path $json) {
            Write-Verbose "[$((Get-Date).TimeofDay)] Backing up $json to $Destination"
            Write-Verbose "[$((Get-Date).TimeofDay)] Get existing backups from $Destination and saving as an array sorted by name"    
            [array]$bak = Get-ChildItem -path $Destination\settings.bak*.json | Sort-Object -Property LastWriteTime    
            if ($bak.count -eq 0) {
                Write-Verbose "[$((Get-Date).TimeofDay)] Creating first backup copy."
                [int]$new = 1
            }
            else {
                $bak | Out-String | Write-Verbose
                [int]$counter = ([regex]"\d+").match($bak[-1]).value
                Write-Verbose "[$((Get-Date).TimeofDay)] Last backup is #$counter"
                [int]$new = $counter + 1
                Write-Verbose "[$((Get-Date).TimeofDay)] Creating backup copy $new"
            }    
            $backup = Join-Path -path $Destination -ChildPath "settings.bak$new.json"
            Write-Verbose "[$((Get-Date).TimeofDay)] Creating backup $backup"
            Copy-Item -Path $json -Destination $backup
            Write-Verbose "Removing any extra backup files over the limit of $Limit"
            Get-ChildItem -path $Destination\settings.bak*.json |
            Sort-Object -Property LastWriteTime -Descending |
            Select-Object -Skip $Limit | Remove-Item
            Write-Verbose "[$((Get-Date).TimeofDay)] Renumbering backup files"
            Get-ChildItem -path $Destination\settings.bak*.json |
            Sort-Object -Property LastWriteTime |
            ForEach-Object -Begin {$n = 0} -process {
                $n++
                $temp = Join-Path -path $env:TEMP -ChildPath "settings.bak$n.json"    
                Write-Verbose "[$((Get-Date).TimeofDay)] Copying temp file to $temp"
                $_ | Copy-Item -Destination $temp    
                Write-Verbose "[$((Get-Date).TimeofDay)] Removing $($_.name)"
                $_ | Remove-Item    
            } -end {
                Write-Verbose "[$((Get-Date).TimeofDay)] Restoring temp files to $Destination"
                Get-ChildItem -Path "$env:TEMP\settings.bak*.json" | Move-Item -Destination $Destination -PassThru:$passthru
            }    
        }
        else {
            Write-Warning "Failed to find expected settings file $json"
        }
    }
    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($myinvocation.MyCommand)"
}