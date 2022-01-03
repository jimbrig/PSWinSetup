Function Get-CPUInfo {
    $CPU = Get-CimInstance -class Win32_Processor
    Clear-Host
    Write-Host "Processor Used:" $CPU_Used
    Write-Host "Load Percentage:"$cpu.LoadPercentage"%"
    Write-Host "Processor:" $cpu.Caption
    Write-Host "CPU Type:" $cpu.name
    Write-Host "Processor ID:" $cpu.DeviceID
    Write-Host "Clock Speed:" $cpu.CurrentClockSpeed
    Write-Host "Voltage:" $cpu.CurrentVoltage
}
