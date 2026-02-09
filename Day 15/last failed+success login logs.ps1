# latest successful logins
cls
Get-WinEvent -FilterHashtable @{
    Logname = "Security"
    Id = 4624
} -MaxEvents 1 | Format-Table -AutoSize -Wrap

# latest failed logins
cls
Get-WinEvent -FilterHashtable @{
    Logname = "Security"
    Id = 4625
} -MaxEvents 1 | Format-Table -AutoSize -Wrap

# last 2 logoff events
cls
Get-WinEvent -FilterHashtable @{
    Logname = "Security"
    Id = 4634,4624
} -MaxEvents 2 | Format-Table -AutoSize -Wrap