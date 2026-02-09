# last 2Hrs login/logout events
cls
$start = (Get-Date).AddHours(-2)
Get-WinEvent -FilterHashtable @{
    Logname = "Security"
    Id = 4634,4624,4647
    starttime = $start
#} | Format-Table -AutoSize -Wrap
} | Out-GridView