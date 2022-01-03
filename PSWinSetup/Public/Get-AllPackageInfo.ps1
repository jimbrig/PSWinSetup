
function Get-AllPackageInfo {
    <#
    .SYNOPSIS
        This function gathers information about a particular installed program from 3-4 different sources:
            - The Get-Package Cmdlet fromPowerShellGet/PackageManagement Modules
            - Chocolatey CmdLine (if it is installed)
            - Windows Registry
            - The `Get-AppxPakcage` cmdlet (if the -IncludeAppx switch is used)
        All of this information is needed in order to determine the proper way to install/uninstall a program.
    .DESCRIPTION
        See .SYNOPSIS
    .NOTES
    .PARAMETER ProgramName
        This parameter is OPTIONAL.
        This parameter takes a string that represents the name of the Program that you would like to gather information about.
        The name of the program does NOT have to be exact. For example, if you have 'python3' installed, you can simply use:
            Get-AllAvailablePackages python
    .PARAMETER IncludeAppx
        This parameter is OPTIONAL.
        This parameter is a switch. If used, information about available Appx (UWP) packages will also be returned.
    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS> Get-AllPackageInfo -IncludeAppX
    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS> Get-AllPackageInfo openssh
#>
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $False,
            Position = 0
        )]
        [string]$ProgramName,

        [Parameter(Mandatory = $False)]
        [switch]$IncludeAppx
    )

    if ($ProgramName) {
        # Generate regex string to loosely match Program Name
        $PNRegexPrep = $([char[]]$ProgramName | foreach { "([\.]|[$_])+" }) -join ""
        $PNRegexPrep2 = $($PNRegexPrep -split "\+")[1..$($($PNRegexPrep -split "\+").Count)] -join "+"
        $PNRegex = "$([char[]]$ProgramName[0])+$PNRegexPrep2"
        # For example, $PNRegex string for $ProgramName 'nodejs' should be:
        #     ^n+([\.]|[o])+([\.]|[d])+([\.]|[e])+([\.]|[j])+([\.]|[s])+
    }

    #region >> Check PackageManagement/PowerShellGet for installed Programs

    # If PackageManagement/PowerShellGet is installed, determine if $ProgramName is installed
    if ([bool]$(Get-Command Get-Package -ErrorAction SilentlyContinue)) {
        $PSGetInstalledPrograms = Get-Package

        if ($ProgramName) {
            $PSGetInstalledPackageObjectsFinal = $PSGetInstalledPrograms | Where-Object { $_.Name -match $PNRegex }
        }
        else {
            $PSGetInstalledPackageObjectsFinal = $PSGetInstalledPrograms
        }
    }

    #endregion >> Check PackageManagement/PowerShellGet for installed Programs


    #region >> Check the Registry for installed Programs

    # Add some more information regarding these packages - specifically MSIFileItem, MSILastWriteTime, and RegLastWriteTime
    # This info will come in handy if there's a specific order related packages needed to be uninstalled in so that it's clean.
    # (In other words, with this info, we can sort by when specific packages were installed, and uninstall latest to earliest
    # so that there aren't any race conditions)
    try {
        [array]$CheckInstalledPrograms = @(Get-InstalledProgramsFromRegistry -ErrorAction Stop)
    }
    catch {
        Write-Error $_
        return
    }

    $WindowsInstallerMSIs = Get-ChildItem -Path "C:\Windows\Installer" -File
    $RelevantMSIFiles = foreach ($FileItem in $WindowsInstallerMSIs) {
        $MSIProductName = GetMSIFileInfo -MsiFileItem $FileItem -Property ProductName -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        if ($MSIProductName -match $PNRegex) {
            [pscustomobject]@{
                ProductName = $MSIProductName
                FileItem    = $FileItem
            }
        }
    }

    if ($CheckInstalledPrograms.Count -gt 0) {
        if ($($(Get-Item $CheckInstalledPrograms[0].PSPath) | Get-Member).Name -notcontains "LastWriteTime") {
            AddLastWriteTimeToRegKeys
        }

        foreach ($RegPropertiesCollection in $CheckInstalledPrograms) {
            $RegPropertiesCollection | Add-Member -MemberType NoteProperty -Name "LastWriteTime" -Value $(Get-Item $RegPropertiesCollection.PSPath).LastWriteTime
        }
        [System.Collections.ArrayList]$CheckInstalledPrograms = [System.Collections.ArrayList][array]$($CheckInstalledPrograms | Sort-Object -Property LastWriteTime)
        # Make sure that the LATEST Registry change comes FIRST in the ArrayList
        $CheckInstalledPrograms.Reverse()

        foreach ($Package in $PSGetInstalledPackageObjectsFinal) {
            $RelevantMSIFile = $RelevantMSIFiles | Where-Object { $_.ProductName -eq $Package.Name }
            if ($RelevantMSIFile) {
                $Package | Add-Member -MemberType NoteProperty -Name "MSIFileItem" -Value $RelevantMSIFile.FileItem
                $Package | Add-Member -MemberType NoteProperty -Name "MSILastWriteTime" -Value $RelevantMSIFile.FileItem.LastWriteTime
            }

            if ($null -ne $Package.TagId) {
                $RegProperties = $CheckInstalledPrograms | Where-Object { $_.PSChildName -match $Package.TagId }
                $LastWriteTime = $(Get-Item $RegProperties.PSPath).LastWriteTime
                $Package | Add-Member -MemberType NoteProperty -Name "RegLastWriteTime" -Value $LastWriteTime
            }
        }
        [System.Collections.ArrayList]$PSGetInstalledPackageObjectsFinal = [array]$($PSGetInstalledPackageObjectsFinal | Sort-Object -Property MSILastWriteTime)
        # Make sure that the LATEST install comes FIRST in the ArrayList
        $PSGetInstalledPackageObjectsFinal.Reverse()
    }

    if ($ProgramName) {
        $CheckInstalledProgramsFinal = $CheckInstalledPrograms | Where-Object {
            $_.InstallSource -match $PNRegex -or
            $_.DisplayName -match $PNRegex -or
            $_.InstallLocation -eq $PNRegex
        }
    }
    else {
        $CheckInstalledProgramsFinal = $CheckInstalledPrograms
    }

    #endregion >> Check the Registry for installed Programs


    #region >> Check chocolatey for installed Programs

    # If the Chocolatey CmdLine is installed, get a list of programs installed via Chocolatey
    if ([bool]$(Get-Command choco -ErrorAction SilentlyContinue)) {
        #$ChocolateyInstalledProgramsPrep = clist --local-only

        $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
        #$ProcessInfo.WorkingDirectory = $BinaryPath | Split-Path -Parent
        $ProcessInfo.FileName = $(Get-Command clist).Source
        $ProcessInfo.RedirectStandardError = $true
        $ProcessInfo.RedirectStandardOutput = $true
        $ProcessInfo.UseShellExecute = $false
        $ProcessInfo.Arguments = "--local-only"
        $Process = New-Object System.Diagnostics.Process
        $Process.StartInfo = $ProcessInfo
        $Process.Start() | Out-Null
        # Below $FinishedInAlottedTime returns boolean true/false
        $FinishedInAlottedTime = $Process.WaitForExit(15000)
        if (!$FinishedInAlottedTime) {
            $Process.Kill()
        }
        $stdout = $Process.StandardOutput.ReadToEnd()
        $stderr = $Process.StandardError.ReadToEnd()
        $AllOutput = $stdout + $stderr

        $ChocolateyInstalledProgramsPrep = $($stdout -split "`n")[1..$($($stdout -split "`n").Count - 3)]

        [System.Collections.ArrayList]$ChocolateyInstalledProgramObjects = @()

        foreach ($program in $ChocolateyInstalledProgramsPrep) {
            $programParsed = $program -split " "
            $PSCustomObject = [pscustomobject]@{
                ProgramName = $programParsed[0].Trim()
                Version     = $programParsed[1].Trim()
            }

            $null = $ChocolateyInstalledProgramObjects.Add($PSCustomObject)
        }

        if ($ProgramName) {
            $ChocolateyInstalledProgramObjectsFinal = $ChocolateyInstalledProgramObjects | Where-Object { $_.ProgramName -match $PNRegex }
        }
        else {
            $ChocolateyInstalledProgramObjectsFinal = $ChocolateyInstalledProgramObjects
        }
    }

    #endregion >> Check chocolatey for installed Programs


    #region >> Check for installed Appx Programs

    if ($IncludeAppx) {
        # Get all relevant AppX Package Info
        $AllAppxPackages = Get-AppxPackage -AllUsers
        if ($ProgramName) {
            $AppxPackagesFinal = $AllAppxPackages | Where-Object { $_.Name -match $PNRegex }
        }
        else {
            $AppxPackagesFinal = $AllAppxPackages
        }
        if ($AppxPackagesFinal.Count -gt 0) {
            $AppxPackagesFinal = $AppxPackagesFinal | foreach {
                $AppxManifest = $_.InstallLocation + "\AppxManifest.xml"
                if (Test-Path $AppxManifest) {
                    $AppxManifestContent = Get-Content $AppxManifest
                    $ApplicationIdCheck = $AppxManifestContent -match "Application Id="
                    if ($ApplicationIdCheck) {
                        $AppxId = $($ApplicationIdCheck -split '"')[1].Trim()
                        $LaunchString = 'explorer.exe shell:AppsFolder\' + $_.PackageFamilyName + '!' + $AppxId
                        $_ | Add-Member -MemberType NoteProperty -Name "LaunchString" -Value $LaunchString
                    }
                    else {
                        $_ | Add-Member -MemberType NoteProperty -Name "LaunchString" -Value "unknown"
                    }
                    $_
                }
            }
        }
    }

    #endregion >> Check for installed Appx Programs

    [pscustomobject]@{
        ChocolateyInstalledProgramObjects = $ChocolateyInstalledProgramObjectsFinal
        PSGetInstalledPackageObjects      = $PSGetInstalledPackageObjectsFinal
        AppxAvailablePackages             = $AppxPackagesFinal
        RegistryProperties                = $CheckInstalledProgramsFinal
    }
}
