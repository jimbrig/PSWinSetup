Function Add-GodmodeShortcut {
    <#
    .SYNOPSIS
    Adds a desktop shortcut for the `GodMode` Windows Advanced Options.
    .EXAMPLE
    Add-GodmodeShortcut
    # Now Desktop has a shortcut.
    #>
    $desktop = [Environment]::GetFolderPath("Desktop")
    if (!(Test-Path "$desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}")) { mkdir "$desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" | Out-Null }
}