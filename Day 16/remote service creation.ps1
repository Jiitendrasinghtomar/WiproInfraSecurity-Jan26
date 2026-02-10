cls
#Invoke-Command -ComputerName $comp -ScriptBlock{
    Get-WinEvent -FilterHashtable @{
        logName = "System"
        Id = 7045
    } -MaxEvents 1 | ft -AutoSize -Wrap
#}