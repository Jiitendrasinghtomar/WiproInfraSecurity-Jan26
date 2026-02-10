cls
Get-WinEvent -FilterHashtable @{
    LogName='Security'
    ID=4688
} | Where-Object {$_.Message -match "lsass.exe"}
