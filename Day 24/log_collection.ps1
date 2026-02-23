cls

$date = Get-Date -Format "yyyyMMdd"

New-Item -ItemType Directory -Path "c:\" -Name "log" -Force

Get-WinEvent -LogName security -MaxEvents 20 | 
Export-Csv "c:\log\security-log-$date.csv" -NoTypeInformation

