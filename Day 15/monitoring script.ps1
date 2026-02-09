# failed login/logout 
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} | ft -AutoSize -Wrap

# to view active web connections.
Get-NetTCPConnection    # displays everything

# connection to HTTP port
Get-NetTCPConnection | Where-Object {$_.RemotePort -eq 80}   

# connection to HTTPS port
Get-NetTCPConnection | Where-Object {$_.RemotePort -eq 443} 

# connection to HTTPS or HTTP port 
Get-NetTCPConnection | Where-Object {$_.RemotePort -eq 80 -or $_.RemotePort -eq 443 }

# mapping the connection to the process
Get-NetTCPConnection | `
Where-Object {$_.RemotePort -eq 443} | `
Select-Object LocalAddress, RemoteAddress, OwningProcess

# resolving the process
Get-Process -Id 2644
Get-Process -Id 11048
Get-Process -Id 10712