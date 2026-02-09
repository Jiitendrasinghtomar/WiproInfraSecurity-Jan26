# list all enabled logs 
Get-WinEvent -ListLog *
Get-WinEvent -ListLog * | Where-Object {$_.isenabled -eq $true}
Get-WinEvent -ListLog system | Format-List *

