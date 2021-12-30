# -------------------------------
# Chocolatey Installation Script
# -------------------------------

Function Install-Choco {
  <#
  .SYNOPSIS
  Installs the Chocolatey Package Manager for Windows into the system.
  .DESCRIPTION
  Installs Chocolatey Package Manager with the default provided installation script from Chocolatey. Environmental variables are updated in order to use choco 
  without having the restart the console host. A powershell $PROFILE is also created (if necessary) before installation to allow the install script to add
  Chocolatey's specific profile and completion to the user $PROFILE.
  .EXAMPLE
  Install-Choco
  Installs Chocolatey
  .NOTES
  - This function uses the standard way how to install Chocolatey package manager from chocolatey.org.
  - This function requires admin privileges to work properly.
  - This function requires a minimum of RemoteSigned Execution Policy to work properly.
  - This function looks for and creates (if necessary) a default user powershell $PROFILE before running the installation script.
  - This function optionally applies post-installation configurations to Chocolatey if desired.
  .LINK
  https://chocolatey.org/
  .INPUTS
  .OUTPUTS
  An installed chocolatey package manager that is ready to use by the user.
  #>
  [CmdletBinding()]
  [Alias("instchoco")]
  Param ()
  
  Write-Begin "Starting the installation process for Chocolatey..."
  
  # Check Administrative Priveledges
  Write-Task "Checking Administrative Priveledges..."
  $isadmin = (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Administrators")
  if (-not ($isadmin)) { Write-Failure "Must have Admininstrative Priveledges; Please re-start shell as Admin and retry."; throw "Error: Non-Admin" }
  Write-Success "Detected Administrative Priveledges."

  # Check/Set Execution Policy
  Write-Task "Checking Execution Policy..."
  $exepolicy = Get-ExecutionPolicy
  if ($exepolicy -ne 'Unrestricted') {
    Write-Info "Setting Execution Policy to Unrestricted"
    Set-ExecutionPolicy Unrestricted
    Set-ExecutionPolicy Unrestricted -scope CurrentUser
  }
  Write-Success "Applied Unrestricted Execution Policy for both Machine and CurrentUser Scopes."

  # Create $PROFILE if necessary before installing:
  Write-Task "Checking for a PowerShell PROFILE..."
  if (!(Test-Path -Path $PROFILE)) {
    Write-Info "Creating Powershell Profile for the User..."
    New-Item -ItemType File -Path $PROFILE -Force
    Write-Success "Created new Profile for User at $PROFILE."
  }

  # Install
  Write-Task "Checking for pre-existing chocolatey installations..."
  try { Get-Command -Name choco -ErrorAction Stop }
  catch [System.Management.Automation.CommandNotFoundException] {
    Write-Begin "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    . $PROFILE
    refreshenv
    Write-Success "Chocolatey Successfully Installed."
  }

  Write-Host "Finished Installing Chocolatey. Run Configuration script now." -ForegroundColor Green
}
