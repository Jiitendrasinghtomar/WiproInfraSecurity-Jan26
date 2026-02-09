cls
Get-WinEvent -FilterHashtable @{Logname='Security'; ID=4688} -MaxEvents 10 |
ForEach-Object {
    [PSCustomObject]@{
        TimeCreate  = $_.TimeCreated
        NewProcess  = $_.Properties[5].Value
    }
}