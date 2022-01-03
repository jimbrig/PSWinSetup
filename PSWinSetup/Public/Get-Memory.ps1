Function Get-Memory {
    $RAM = Get-CimInstance -Query "SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem"

$totalRAM = [math]::Round($RAM.TotalVisibleMemorySize/1MB, 2)
$freeRAM = [math]::Round($RAM.FreePhysicalMemory/1MB, 2)
$usedRAM = [math]::Round(($RAM.TotalVisibleMemorySize - $RAM.FreePhysicalMemory)/1MB, 2)

Write-Host "Total Memory: $totalRAM"
Write-Host "Used Memory: $usedRAM"
Write-Host "Free Memory: $freeRAM"
}