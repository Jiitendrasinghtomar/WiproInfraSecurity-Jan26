cls
$prc = Get-NetTCPConnection | `
        Where-Object {$_.RemotePort -eq 443} | `
        Select-Object LocalAddress, RemoteAddress, OwningProcess 
foreach($p in $prc){
    if($p.owningprocess -ne 0){
        $pron = (Get-Process -Id $p.OwningProcess).ProcessName
    }
Write-host $p.LocalAddress " ---> " $p.RemoteAddress  " --->  "  $pron
}