$StartTime = (Get-Date).AddHours(-2)
$Report = @()
Write-Host "Starting Mini SIEM Analysis..." -ForegroundColor Cyan
# --- Function to create alert ---
function Add-Alert {
    param(
        $Time,
        $EventID,
        $Source,
        $Severity,
        $Message
    )
    $Report += [PSCustomObject]@{
        Time      = $Time
        EventID   = $EventID
        Source    = $Source
        Severity  = $Severity
        Message   = $Message.Substring(0, [Math]::Min(200, $Message.Length))
    }
}
# --- Security Log Monitoring ---
$SecurityEvents = Get-WinEvent -FilterHashtable @{
    LogName='Security'
    StartTime=$StartTime
}
foreach ($event in $SecurityEvents) {
    switch ($event.Id) {
        4625 { Add-Alert $event.TimeCreated 4625 "Security" "Medium" $event.Message }
        4720 { Add-Alert $event.TimeCreated 4720 "Security" "High" $event.Message }
        7045 { Add-Alert $event.TimeCreated 7045 "System" "High" $event.Message }
        1102 { Add-Alert $event.TimeCreated 1102 "Security" "Critical" $event.Message }
        4688 {
            if ($event.Message -match "powershell.exe") {
                Add-Alert $event.TimeCreated 4688 "Security" "High" $event.Message
            }
        }
    }
}
# --- Defender Log Monitoring ---
$DefenderEvents = Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" -ErrorAction SilentlyContinue
foreach ($event in $DefenderEvents) {
    Add-Alert $event.TimeCreated $event.Id "Defender" "High" $event.Message
}
# --- Output Results ---
if ($Report.Count -gt 0) {
    Write-Host "`n⚠ Alerts Detected:" -ForegroundColor Red
    $Report | Format-Table -AutoSize

    $Report | Export-Csv "C:\Temp\MiniSIEM_Report.csv" -NoTypeInformation
    Write-Host "`nReport exported to C:\Temp\MiniSIEM_Report.csv"
}
else {
    Write-Host "`nNo suspicious events detected." -ForegroundColor Green
} 

