cls
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" | `
Where-Object {$_.Id -eq 4104} | `
select -Last 1 | `
Out-GridView
#ft -AutoSize -Wrap

# to list help for cmdlet within PS
Get-Help Get-WinEvent 

# to list help for cmdlet on MS website
Get-Help Get-WinEvent -Online

Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" 

Start-Service -Name BITS -WhatIf
Stop-Service -Name BITS -Confirm