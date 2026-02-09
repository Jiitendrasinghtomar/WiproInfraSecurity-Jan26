cls

# 3  --> Network connection (SMB, PowerShell remoting)
# 10 --> RDP
Get-CimInstance win32_logonsession | Where-Object {$_.LogonType -in 3,10}
Get-CimInstance win32_logonsession