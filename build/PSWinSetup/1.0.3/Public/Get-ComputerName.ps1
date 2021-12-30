#Requires -Modules Microsoft.PowerShell.Management

Function Get-ComputerName {
    <#
    .SYNOPSIS
        Returns the name of the Computer
    .DESCRIPTION
        Returns the name of the Computer
    .EXAMPLE
        PS> Get-ComputerName
    #>
    [OutputType([string])]
  
    $info = Get-ComputerInfo
    $info.CsDNSHostName
  }
  