cls
# ==========================
# CONFIGURATION
# ==========================
$LogName = "Security"
$EventID = 4688

$SuspiciousProcesses = @(
    "powershell.exe",
    "pwsh.exe",
    "cmd.exe",
    "wscript.exe",
    "cscript.exe",
    "rundll32.exe",
    "mshta.exe",
    "certutil.exe",
    "bitsadmin.exe",
    "regsvr32.exe"
)

$AlertLog = "C:\SecurityAlerts\4688-alerts.log"

# ==========================
# PREPARE ALERT DIRECTORY
# ==========================
$AlertDir = Split-Path -Parent $AlertLog
if (-not (Test-Path $AlertDir)) {
    New-Item -ItemType Directory -Path $AlertDir -Force | Out-Null
}

# ==========================
# INITIALIZE RECORD TRACKING
# ==========================
$LastRecordId = (Get-WinEvent -LogName $LogName -MaxEvents 1).RecordId

Write-Host "[+] Monitoring Event ID 4688 (Polling Mode)..." -ForegroundColor Cyan

# ==========================
# LIVE MONITOR LOOP
# ==========================
while ($true) {

    $Events = Get-WinEvent -FilterHashtable @{
        LogName = "security"
        Id      = "4688"
    } | Where-Object { $_.RecordId -gt $RecordId }

    foreach ($Event in $Events) {

        # Update last processed record
        $RecordId = $Event.RecordId

        $Time       = $Event.TimeCreated
        $User       = $Event.Properties[1].Value
        $NewProcess = $Event.Properties[5].Value
        $Command    = $Event.Properties[8].Value

        foreach ($Suspicious in $SuspiciousProcesses) {

            if ($NewProcess -match [regex]::Escape($Suspicious)) {

                $Alert = @"
[ALERT] Suspicious Process Execution Detected
Time        : $Time
User        : $User
Process     : $NewProcess
CommandLine : $Command
---------------------------------------------------
"@

                Write-Host $Alert -ForegroundColor Red
                Add-Content -Path $AlertLog -Value $Alert
                break
            }
        }
    }

    Start-Sleep -Seconds 3
}
