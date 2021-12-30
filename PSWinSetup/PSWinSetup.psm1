# Current Script Path
[string]$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope Script).Value.MyCommand.Definition -Parent

# Define Variables

# Imports

# Dotsource Functions
Get-ChildItem $ScriptPath/Private -Recurse -Filter '*.ps1' -File | ForEach-Object {
    . $_.FullName
}

Get-ChildItem $ScriptPath/Public -Recurse -Filter '*.ps1' -File | ForEach-Object {
    . $_.FullName
}