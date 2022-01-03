<#
.SYNOPSIS
    Uses MDM Bridge Provider to configure pinned folders next to the Power button in Windows 11 start menu.
.DESCRIPTION
    Configures the pinned folder next to the Power button in Windows 11 using the MDM Bridge Provider.
    The configured pinned folders will be enforced and can not be disabled by the user (grayed out).
    Credit to Peter van der Woude for his great template for updating MDM policy settings:
    https://www.petervanderwoude.nl/post/windows-10-mdm-bridge-wmi-provider-settings-template/
.PARAMETER AllowPinnedFolder
    Switch paramters that specifies which folders that should be pinned/unpinned.
    All parameters use default CSP policy name but aliases can be used to shorten their names.
    For example using -AllowPinnedFolderDocuments, -PinDocuments or -Documents will achieve the same results.
.PARAMETER Configure
    Specifies how the folders should be configured: Enabled (default), Disabled or NotConfigured.
.EXAMPLE
    PinStartFolders.ps1 -AllowPinnedFolderDownloads -PinFileExplorer -Settings
.EXAMPLE
    PinStartFolders.ps1 -AllowPinnedFolderDownloads -PinFileExplorer -Settings -Configure NotConfigured
.NOTES
    Version 1.0 (2021-10-11) - Sassan Fanai
    Version 1.1 (2021-10-17) - Sassan Fanai
        Added $Configure parameter
 
#>
[CmdletBinding()]
param (
    [Alias("PinDocuments","Documents")]
    [switch]$AllowPinnedFolderDocuments,
    [Alias("PinDownloads","Downloads")]
    [switch]$AllowPinnedFolderDownloads,
    [Alias("PinFileExplorer","FileExplorer")]
    [switch]$AllowPinnedFolderFileExplorer,
    [Alias("PinHomeGroup","HomeGroup")]
    [switch]$AllowPinnedFolderHomeGroup,
    [Alias("PinMusic","Music")]
    [switch]$AllowPinnedFolderMusic,
    [Alias("PinNetwork","Network")]
    [switch]$AllowPinnedFolderNetwork,
    [Alias("PinPersonalFolder","PersonalFolder")]
    [switch]$AllowPinnedFolderPersonalFolder,
    [Alias("PinPictures","Pictures")]
    [switch]$AllowPinnedFolderPictures,
    [Alias("PinSettings","Settings")]
    [switch]$AllowPinnedFolderSettings,
    [Alias("PinVideos","Videos")]
    [switch]$AllowPinnedFolderVideos,
    [ValidateSet("Enabled","Disabled","NotConfigured")]
    [string]$Configure = "Enabled"
)
 
function Update-PolicySetting {
    <#
    .SYNOPSIS
        A simple function to update policy settings by using MDM WMI Bridge
    .DESCRIPTION
        This function provides the capability to adjust policy settings by using the MDM WMI Bridge.
        It supports the capabilities to create, update and remove an instance
    .PARAMETER className
        This parameter is required for the name of the WMI class
    .PARAMETER parentID
        This parameter is required for the name of the parent node of the OMA-URI
    .PARAMETER instanceID
        This parameter is required for the name of the WMI instance, which is the node of the OMA-URI
    .PARAMETER configureProperty
        This parameter is required when configuring a setting and is the name of the property
    .PARAMETER valueProperty
        This parameter is required when configuring a setting and is the value of the property
    .PARAMETER removeInstance
        This switch is used to indicate that the specified variables are used for deleting the WMI instance
    .EXAMPLE
        Update-PolicySetting -className 'MDM_Policy_Config01_Start02' -parentID './Vendor/MSFT/Policy/Config' -instanceID 'Start' -configureProperty 'HideAppList' -valueProperty 1
        This example will run the function and configure a the property to hide the app list in Start
    .EXAMPLE
        Update-PolicySetting -className 'MDM_Policy_Config01_Start02' -parentID './Vendor/MSFT/Policy/Config' -instanceID 'Start' -removeInstance
        This example will run the function and remove the instance of Start
    .NOTES
        Author: Peter van der Woude
        Contact: pvanderwoude@hotmail.com
    #>
        param (
            [Parameter(Mandatory=$true)]$className,
            [Parameter(Mandatory=$true)]$parentID,
            [Parameter(Mandatory=$true)]$instanceID,
            [Parameter(Mandatory=$false)]$configureProperty,
            [Parameter(Mandatory=$false)]$valueProperty,
            [Parameter(Mandatory=$false)][Switch]$removeInstance
        )
        try {
            #Get a specific instance
            $instanceObject = Get-CimInstance -Namespace 'root\cimv2\mdm\dmmap' -ClassName $className -Filter "ParentID='$parentID' and InstanceID='$instanceID'" -ErrorAction Stop
        }
        catch {
            Write-Host $_ | Out-String
        }
 
        #Verify the action
        if ($removeInstance -eq $false) {
            #Verify if the additional required parameters are provided
            if ($PSBoundParameters.ContainsKey('configureProperty') -and ($PSBoundParameters.ContainsKey('valueProperty'))) {
                #Verify if the instance already exists
                if ($null -eq $instanceObject) {
                    try {
                        #Create a new instance
                        New-CimInstance -Namespace 'root\cimv2\mdm\dmmap' -ClassName $className -Property @{ InstanceID=$instanceID; ParentID=$parentID; $configureProperty=$valueProperty } -ErrorAction Stop
                        Write-Output "Successfully created the instance of '$instanceID'"
                    }
                    catch {
                        Write-Host $_ | Out-String
                    }
                }
                else {
                    try {
                        #Adjust a specific property
                        $instanceObject.$configureProperty = $valueProperty
 
                        #Modify an existing instance
                        Set-CimInstance -CimInstance $instanceObject -ErrorAction Stop
                        Write-Output "Successfully adjusted the instance of '$instanceID'"
                    }
                    catch {
                        Write-Host $_ | Out-String
                    }
                }
            }
            else {
                Write-Output ">> Make sure to provide a value for configureProperty and valueProperty when creating or adjusting an instance <<"
            }
        }
        elseif ($removeInstance -eq $true) {
            #Verify if the instance already exists
            if ($null -ne $instanceObject) {
                try {
                    #Remove a specific instance
                    Remove-CimInstance -InputObject $instanceObject -ErrorAction Stop
                    Write-Output "Successfully removed the instance of '$instanceID'"
                }
                catch {
                    Write-Host $_ | Out-String
                }
            }
            else {
                Write-Output "No instance available of '$instanceID'"
            }
        }
    }
 
switch ($Configure) {
    'Enabled' {
        [int]$Value = 1
    }
    'Disabled' {
        [int]$Value = 0
    }
    'NotConfigured' {
        [int]$Value = 65535
    }
}
 
$PSBoundParameters.Remove('Configure') | Out-Null
 
if ($PSBoundParameters.Keys.Count -ge 1) {
    $PSBoundParameters.Keys | ForEach-Object {
        Update-PolicySetting -className 'MDM_Policy_Config01_Start02' -parentID './Vendor/MSFT/Policy/Config' -instanceID 'Start' -configureProperty $PSitem -valueProperty $Value
    }
}
else {
    "No folders will be pinned/unpinned. No parameters were specified."
}