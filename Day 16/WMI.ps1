Get-WmiObject -Class win32_bios
Get-WmiObject -Class win32_ComputerSystem
Get-WmiObject -Class win32_OperatingSystem
Get-WmiObject -Class win32_LogicalDisk | ft

<#
    WMI
        - Windows Managment Instrumentation
        - WMI can fetch the information for:
            - hardware
            - software
            - firmware
            - process
            - service
            - registry
            - file system
            - local + remote system
        - WMI is the Microsoft implementation of CIM
            - CIM = Common Information Model (opensource)
#>