# creating a folder
New-Item -ItemType Directory -Path c:\ -Name autoTask -Force

# creating a script
New-Item -ItemType File -Path C:\autoTask -Name monitor.ps1    #or
#notepad.exe C:\autoTask\monitor.ps1

############ AUTOMATING THE SCRIPT ####################

# create ACTION
$action = New-ScheduledTaskAction -Execute "Powershell.exe" `
-Argument "-ExecutionPolicy Bypass -file C:\autoTask\monitor.ps1"

# create TRIGGER
$trigger = New-ScheduledTaskTrigger -Once -At (Get-date).AddMinutes(1) `
-RepetitionInterval (New-TimeSpan -Minutes 15) `
-RepetitionDuration (New-TimeSpan -Days 365)

# schedule the task in task schedular
Register-ScheduledTask -TaskName "MonitorMySystem" `
-Action $action `
-Trigger $trigger `
-User "SYSTEM" `
-RunLevel Highest

# to verify
Get-ScheduledTask -TaskName MonitorMySystem