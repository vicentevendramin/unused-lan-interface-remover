Write-Host "------------------------------------------------------"
Write-Host "| This script will remove all unused LAN Interfaces. |"
Write-Host "------------------------------------------------------"
Read-Host -Prompt "Press any key to continue or CTRL+C to quit" | Out-Null

Get-PnpDevice -class net | ? Status -eq Unknown | Select FriendlyName,InstanceId | Out-File -FilePath C:\lan_log.txt
$Devs = Get-PnpDevice -class net | ? Status -eq Unknown | Select FriendlyName,InstanceId
ForEach ($Dev in $Devs) {
    $RemoveKey = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($Dev.InstanceId)"
    Get-Item $RemoveKey | Select-Object -ExpandProperty Property | %{ Remove-ItemProperty -Path $RemoveKey -Name $_ -Verbose }
}

Pause
Write-Host "System restart is required to complete changes."
Read-Host -Prompt "Press any key to reboot or CTRL+C to quit" | Out-Null
Restart-Computer