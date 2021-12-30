Function Install-ChocoHelpers {
    <#
   .SYNOPSIS
       Installs initial Chocolatey helper packages.
   .DESCRIPTION
       Installs the following:
        - boxstarter
        - choco-cleaner
        - choco-package-list-backup
        - instchoco
        - chocolateygui
        - 7zip.install
   .NOTES
       <Note for the Function>
   #>
   # Initial Installations:
   Write-Host 'Installing chocolatey helpers..' -ForegroundColor Yellow
   choco upgrade boxstarter choco-cleaner choco-package-list-backup instchoco chocolateygui 7zip -y
   refreshenv
}
