Function Add-PathVariable {
    <#
    .SYNOPSIS
        Adds a specified value to System %PATH% variable.
    .DESCRIPTION
        Adds a specified value to System %PATH% variable.
    .EXAMPLE
        PS> Add-PathVariable "C:\bin"
    #>
    [CmdletBinding()]
    param (
      [string]$addPath
    )
    if (Test-Path $addPath) {
      $regexAddPath = [regex]::Escape($addPath)
      $arrPath = $env:Path -split ';' | Where-Object { $_ -notMatch
        "^$regexAddPath\\?" }
      $env:Path = ($arrPath + $addPath) -join ';'
    }
    else {
      Throw "'$addPath' is not a valid path."
    }
  }
