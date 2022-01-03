Function Write-Log
{
    <#
    .SYNOPSIS
    Easily write to a log file within your scripts. 
    .DESCRIPTION
    Allows a programmer to create consistant, organized 
    log entries. Outputs timestamp and tags for entry 
    type (ie: info, error)
    .PARAMETER FilePath
    Location of the log file. 
    .PARAMETER Content
    The message contents to add to the log file. 
    .PARAMETER TimestampFormat
    Define the datestamp string, defaults to 'yyyy\-MM\-dd\_HH\:mm\:ss'
    .PARAMETER EntryType
    Type of message, allowed are DEBUG, INFO*, WARN, ERROR, FAIL
    .EXAMPLE
    $LogSplat = @{
        FilePath = 'C:\Temp\Log.txt'
        TimestampFormat = 'yyyy\-MM\-dd\_HH\:mm\:ss'
        EntryType = 'INFO'
    }
    [string]$var | log @LogSplat 
    .EXAMPLE
    [string]$var | log @LogSplat -EntryType Error
    .INPUTS
    The message contents to add to the log file can be piped 
    into the function as a single string value. 
    #>
    [CmdletBinding()]
    [Alias('log')]
    Param
    (
        # Location of the log file
        [Parameter(Mandatory=$true,
                  Position=0)]
        [ValidatePattern('.+\.log|.+\.txt')]
        [string]
        $FilePath,

        # The message contents to add to the log file
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=1)]
        [Alias('Message')]
        [string]
        $Content,

       # Define the datestamp string, defaults to DiDictionary
       [string]
       [ValidateNotNull()]
       [ValidateNotNullOrEmpty()]
       $TimestampFormat = 'yyyy-MM-dd_HH:mm:ss',

       # Type of message, allowed are DEBUG, INFO*, WARN, ERROR, FAIL, etc
       [Parameter()]
       [ValidateSet("DEBUG", "VERBOSE", "INFO", "WARN", "ERROR", "FAIL", "CRITICAL")]
       [ValidateNotNull()]
       [ValidateNotNullOrEmpty()]
       [string]
       $EntryType = 'INFO'
    )

    Begin
    {
    }
    Process
    {
        $EntryType = $EntryType.ToUpper()
        
        # Make sure the file exists
        if(Test-Path $FilePath){}else{
            New-Item -ItemType File -Path $FilePath -Force | 
                Out-Null
        }

        # Build the string, starting with the date and type
        [string]$strContent = $null
        $strContent = $strContent + "$((Get-Date).ToString($TimestampFormat)) "
        $strContent = $strContent + "[$($EntryType)]: "
        $strContent = $strContent + $env:USERNAME + '@'
        $strContent = $strContent + $env:COMPUTERNAME + '.'
        $strContent = $strContent + $env:USERDNSDOMAIN + ' '
        $strContent = $strContent + $Content

        # Add Content to the file.
        Try{
            $Splat = @{
                Value = $strContent
                Path = $FilePath
                Force = $true
                ErrorAction = 'Stop'
                ErrorVariable = 'LogError'
            }
            Add-Content @Splat
        }
        Catch{
            
            if(!$WriteLogErrorHappened){
                Write-Host "Logging error:" -ForegroundColor Gray
                Write-Host "$($LogError.ErrorRecord)`n" -ForegroundColor DarkCyan
                Set-Variable -Name 'WriteLogErrorHappened' -Scope Global -Value $true
            }
        }

    }
    End
    {
    }
}

# Function Write-Log2 {
#     <#
#     .SYNOPSIS
#     Write a log to a designated location on the local file system.
#     .DESCRIPTION
#     This function is used to write application specific logs to a log file.
#     .PARAMETER logPath
#     Directory where logs are stored: defaults to "$env:APPDATA\powershell\Logs".
#     .PARAMETER logFileName
#     Filename of the log to be appended after the date: defaults to "PSWinSetup".
#     .PARAMETER deleteAfterDays
#     Number of days to retain logs for.
#     .PARAMETER Type
#     One of DEBUG, INFO, WARNING, ERROR
#     .PARAMETER Text
#     Text to write to log.
#     .EXAMPLE
#     Write-Log -Type INFO -Text Script Started
#     Write-Log -Type ERROR -Text Script Failed    
#     #>
#     [CmdletBinding()]
#     param (
#         [string]$logPath = "$env:APPDATA\powershell\Logs",
#         [string]$logFileName = "PSWinSetup",
#         [int]$deleteAfterDays = $null,
#         [Parameter(Mandatory=$true)]
#         [ValidateSet('DEBUG', 'INFO', 'WARNING', 'ERROR', IgnoreCase = $true, ErrorMessage="Value '{0}' is invalid. Try one of: '{1}'")]
#         [string]$Type,
#         [string]$Text
#     )

#     if (!(Test-Path -Path $logPath)) { New-Item -Path $logPath -ItemType Directory -Force }
    
#     [string]$logFile = '{0}\{1}_{2}.log' -f $logPath, $(Get-Date -Format 'yyyy-MM-dd'), $logfileName
#     If (!(Test-Path -Path $logFile)) { New-Item -Path $logFile -ItemType File -Force }
#     $logEntry = '{0}: <{1}> {2}' -f $(Get-Date -Format 'yyyy-MM-dd HH:MM:ss'), $Type, $Text
#     Add-Content -Path $logFile -Value $logEntry

#     $limit = (Get-Date).AddDays(-$deleteAfterDays)
#     Get-ChildItem -Path $logPath -Filter "*$logfileName.log" | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
# }

# Function Open-Logs {
#     param()
#     code-insiders "$env:APPDATA\powershell\Logs"    
# }