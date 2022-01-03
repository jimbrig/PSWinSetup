Function Test-IsAdmin {
    <#
    .SYNOPSIS
    Determines if the current shell has administrative priveledges or not.
    .EXAMPLE
    Test-IsAdmin
    #>
    (
        [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator"
    )
}