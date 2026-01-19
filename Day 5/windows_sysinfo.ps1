cls
# ================== Styling ==================
function Write-LabelValue {
    param (
        [string]$Label,
        [string]$Value,
        [ConsoleColor]$LabelColor = "Cyan",
        [ConsoleColor]$ValueColor = "White"
    )

    Write-Host "$($Label): " -NoNewline -ForegroundColor $LabelColor
    Write-Host "$Value" -ForegroundColor $ValueColor
}

# ================== Functions ==================

function Get-Hostname {
    $env:COMPUTERNAME
}

function Get-IP {
    (Get-NetIPAddress -AddressFamily IPv4 `
        | Where-Object { $_.IPAddress -notlike "169.254*" -and $_.IPAddress -ne "127.0.0.1" } `
        | Select-Object -ExpandProperty IPAddress) -join ", "
}

function Get-KernelVersion {
    (Get-CimInstance Win32_OperatingSystem).Version
}

function Get-InternetStatus {
    if (Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet) {
        return "Yes"
    } else {
        return "No"
    }
}

function Get-ProcessorCount {
    (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
}

function Get-ProcessorModel {
    (Get-CimInstance Win32_Processor | Select-Object -First 1).Name
}

function Get-BIOSVersion {
    (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion
}

function Get-BootDeviceSize {
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    "{0:N2} GB" -f ($disk.Size / 1GB)
}

function Get-DefaultLanguage {
    (Get-WinSystemLocale).Name
}

function Get-TotalRAM {
    "{0:N2} GB" -f ((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
}

function Get-SwapSpace {
    "{0:N2} GB" -f ((Get-CimInstance Win32_PageFileUsage).AllocatedBaseSize / 1024)
}

function Get-DriverCount {
    (Get-CimInstance Win32_SystemDriver).Count
}

function Get-RunningTasks {
    (Get-Process).Count
}

function Get-StartupCount {
    (Get-CimInstance Win32_StartupCommand).Count
}

function Get-EnvVarCount {
    (Get-ChildItem Env:).Count
}

function Get-LastLoginFailure {
    $event = Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        Id      = 4625
    } -MaxEvents 1 -ErrorAction SilentlyContinue

    if ($event) {
        $event.TimeCreated
    } else {
        "None Found"
    }
}

function Get-LoggedInUsers {
    (query user 2>$null | Select-Object -Skip 1 | ForEach-Object { ($_ -split '\s+')[0] }) -join ", "
}

function Get-LoggedInUsername {
    $env:USERNAME
}

# ================== Output ==================

Write-Host "========== SYSTEM INFORMATION SUMMARY ==========" -ForegroundColor Yellow

Write-LabelValue "Hostname" (Get-Hostname)
Write-LabelValue "IP Address" (Get-IP)
Write-LabelValue "Windows kernel version" (Get-KernelVersion)
Write-LabelValue "Connected to internet" (Get-InternetStatus) -ValueColor Green
Write-LabelValue "Number of Processor" (Get-ProcessorCount)
Write-LabelValue "Processor Model name" (Get-ProcessorModel)
Write-LabelValue "BIOS version" (Get-BIOSVersion)
Write-LabelValue "OS disk size" (Get-BootDeviceSize)
Write-LabelValue "Default language" (Get-DefaultLanguage)
Write-LabelValue "Total installed RAM (in GBs)" (Get-TotalRAM)
Write-LabelValue "Swap Space (in GBs)" (Get-SwapSpace)
Write-LabelValue "Total number of system drivers" (Get-DriverCount)
Write-LabelValue "Running tasks" (Get-RunningTasks)
Write-LabelValue "Total number of startup programs" (Get-StartupCount)
Write-LabelValue "Total number of environment variables" (Get-EnvVarCount)
Write-LabelValue "Last login failure" (Get-LastLoginFailure)
Write-LabelValue "Currently logged in users" (Get-LoggedInUsers)
Write-LabelValue "Logged in username" (Get-LoggedInUsername)

Write-Host "===============================================" -ForegroundColor Yellow
