Function Install-Git {

    <#
    .SYNOPSIS
        < A brief description of the function or script.>
    .DESCRIPTION
        <A longer description.>
    .NOTES
        <Note for the Function>
    #>
    
    # Install Git w/ Custom Parameters
    Write-Host 'Installing Git with Custom Parameters...' -ForegroundColor Yellow
    choco upgrade git.install --params '/GitAndUnixToolsOnPath /WindowsTerminal /NoShellIntegration /NoAutoCrlf' --install-arguments='/COMPONENTS="icons,assoc,assoc_sh,autoupdate,windowsterminal,scalar"'
    refreshenv

}








