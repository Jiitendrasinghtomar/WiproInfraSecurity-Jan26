# list all the login/logout failed events
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} | ft -AutoSize -Wrap

# list only single (1) login/logout failed events with customizations.
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 1 | `
Select-Object Timecreated, Id, MachineName, Message | Format-Table -AutoSize -Wrap

