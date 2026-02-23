cls
$StartTime = (Get-Date).AddMinutes(-15)
$Alerts = @()

# Check failed logons (4625)
$Failed = Get-WinEvent -FilterHashtable @{
    LogName='Security'
    Id=4625
    StartTime=$StartTime
}

if($Failed.Count -gt 5){
    $Alerts += "Multiple failed logons detected!"
}

# Check log clearing (1102)
$LogCleared = Get-WinEvent -FilterHashtable @{
    LogName='Security'
    Id=1102
    StartTime=$StartTime
}

if($LogCleared){
    $Alerts += "Security log was cleared!"
}

# Export Report
if($Alerts.Count -gt 0){
    $Date = Get-Date -Format "yyyyMMdd_HHmm"
    $Alerts | Out-File "C:\autoTask\Alert_$Date.txt"
}
