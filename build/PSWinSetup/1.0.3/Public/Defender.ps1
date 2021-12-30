Function Add-WindowsDefenderExclusions {
  <#
      .SYNOPSIS
      This function add Windows defender exclusions.
      .DESCRIPTION
      This function in details adds exclusions for:
      * specified processes,
      * specified folders,
      * specified files,
      * specified extensions.
      The primary aim is to improve developer machine performance.
      .PARAMETER ProcessesPaths
      Paths where specified processess should be search for.
      .PARAMETER ProcessesList
      Processess to exclude within Windows Defender.
      .PARAMETER FoldersPaths
      Paths where specified folders should be search for.
      .PARAMETER FoldersList
      Folders to exclude within Windows Defender.
      .PARAMETER FilesList
      Files to exclude within Windows Defender.
      .PARAMETER ExtensionsList
      File extensions to exclude within Windows Defender.
      .LINK
      https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-WindowsDefenderExclusions.md
      .LINK
      https://github.com/a4099181/vagrant-provvin/blob/master/modules/defender.psm1
      .LINK
      https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-exclusions-microsoft-defender-antivirus?view=o365-worldwide
  #>
  Param ( [String[]] $ProcessesPaths = ( ${env:ProgramFiles(x86)}, $env:ProgramW6432 )
    , [String[]] $ProcessesList = ( 'msbuild.exe', 'devenv.exe', 'sqlcmd.exe', 'sqllocaldb.exe', 'sqlservr.exe', 'sqlwriter.exe')
    , [String[]] $FoldersPaths = ( $env:USERPROFILE )
    , [String[]] $FoldersList = ( 'MyProjects', '.nuget', '.babun' )
    , [String[]] $FilesList = ( 'C:\pagefile.sys' )
    , [String[]] $ExtensionsList = ( 'config', 'cs' , 'ldf', 'lnk', 'mdf', 'ttf', 'txt', 'xml', 'log' ) )

  Get-ChildItem -Path $ProcessesPaths -Include $ProcessesList -File -Recurse |
  ForEach-Object { Add-MpPreference -ExclusionProcess $_.FullName }

  Get-ChildItem -Path $FoldersPaths -Include $FoldersList -Directory -Recurse |
  ForEach-Object { Add-MpPreference -ExclusionPath $_.FullName }

  Add-MpPreference -ExclusionPath $FilesList -ExclusionExtension $ExtensionsList
}

Function Add-DefenderExclusions {
  <#
      .SYNOPSIS
      This function detects and applies various Windows defender exclusions.
      .DESCRIPTION
      This function adds exclusions for:
      * node.exe
      * git.exe
      * gitkraken.exe
      * devenv.exe
      * code.exe / code-insiders.exe
      * ~/Dev/*
      * %APPDATA%\npm
      * %APPDATA%\npm-cache
      * ~/.dotfiles
      * ~/scoop
      * %PROGRAMDATA%\scoop
      * %PROGRAMDATA%\chocolatey
      * %PROGRAMDATA%\DockerDesktop
      * %PROGRAMDATA%\nvm
      * %PROGRAMDATA%\ssh
      The primary aim is to improve developer machine performance.
      .LINK
      https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-exclusions-microsoft-defender-antivirus?view=o365-worldwide
  #>

  $extensions = @(
    "*.vhd"
    "*.vhdx"
    "*.iso"
    "*.bin"
    "*.R"
    "*.py"
    "*.cmd"
    "*.ps1"
    "*.psm1"
    "*.exe"
  )

  $paths = @(
    "$env:PROGRAMDATA\DockerDesktop"
    "$env:PROGRAMDATA\chocolatey"
    "$env:PROGRAMDATA\scoop"
    "$env:PROGRAMDATA\Boxstarter"
    "$env:PROGRAMDATA\Backblaze"
    "$env:PROGRAMFILES\Docker"
    "$env:PROGRAMFILES\Everything"
    "$env:PROGRAMFILES\Git"
    "$env:PROGRAMFILES\Hyper-V"
    "$env:PROGRAMFILES\7-Zip"
    "$env:PROGRAMFILES\nodejs"
    "$env:PROGRAMFILES\NTLite"
    "$env:PROGRAMFILES\PowerShell"
    "$env:PROGRAMFILES\R"
    "$env:PROGRAMFILES\Rainmeter"
    "$env:PROGRAMFILES\RStudio"
    "$env:PROGRAMFILES\Teracopy"
    "$env:PROGRAMFILES\Uninstall Tool"
    "$env:PROGRAMFILES\Winaero Tweaker"
    "$env:PROGRAMFILES\Windows Defender"
    "$env:PROGRAMFILES\WindowsApps"
    "$env:PROGRAMFILES\wureset"
    "${env:ProgramFiles(x86)}\Backblaze"
    "${env:ProgramFiles(x86)}\EaseUS"
    "${env:ProgramFiles(x86)}\GitHub Cli"
    "${env:ProgramFiles(x86)}\Google"
    "${env:ProgramFiles(x86)}\Java"
    "${env:ProgramFiles(x86)}\Keeper Commander"
    "$env:ONEDRIVE\Documents\PowerShell"
    "$env:ONEDRIVE\Documents\WindowsPowerShell"
  )   

  foreach ($item in $extensions) {
    Write-Host "Adding $item to Exlusion Extensions..." -ForegroundColor Yellow
    Add-MpPreference -ExclusionExtension $item
  }

  foreach ($item in $paths) {
    Write-Host "Adding $item to Exlusion Paths..." -ForegroundColor Yellow
    Add-MpPreference -ExclusionPath $item
  }

  $MPpreferences = Get-MpPreference
  $extsout = $MPpreferences.ExclusionExtension -split ";"
  $pathsout = $MPpreferences.ExclusionPath -split ";"
  $processesout = $MPpreferences.ExclusionProcess -split ";"
  
  Write-Host "
  ------------------------------------------------------------
  Windows Defender Exclusion Items
  ------------------------------------------------------------
  "
  Write-Host "Excluded Extensions:" -ForegroundColor Red
  $extsout
  Write-Host "Excluded Paths:" -ForegroundColor Red
  $pathsout -split ';'
  Write-Host "Excluded Processes:" -ForegroundColor Red
  $processesout
}
