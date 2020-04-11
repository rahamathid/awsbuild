$VMBuild = "PackerTestVM"
$ResouceGroup = "PackerGroup"
$username = "258d2509-d846-4e42-966c-425da28d4f8c@rahamathoutlook.onmicrosoft.com"

#$pass = Get-Content "C:\GitHub\Test\Password.txt" | ConvertTo-SecureString -Verbose
$Pass = ConvertTo-SecureString “AEab3__nAJ7a@0D1JUqXrxx@ZH/VnGZR” -AsPlainText -Force

$cred = New-Object -TypeName pscredential –ArgumentList "258d2509-d846-4e42-966c-425da28d4f8c@rahamathoutlook.onmicrosoft.com", $pass

# login non-interactive
Login-AzAccount -Credential $cred -ServicePrincipal –TenantId "05c575ab-b007-47e7-a0ea-f8f2564e6097"

Write-Host "Deleting VM"
Remove-AzVM -name $VMbuild -ResourceGroupName $Vm.ResourceGroupName -Force | Out-Null

Write-host "Disassociate NIC card"
$nic = Get-AzNetworkInterface -Name $VMBuild -ResourceGroup $ResouceGroup
$nic.IpConfigurations.publicipaddress.id = $null
Set-AzNetworkInterface -NetworkInterface $nic | Out-Null
Remove-AzVirtualNetwork -Name myVnet -ResourceGroupName $ResouceGroup -Force
