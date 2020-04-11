$VMBuild = "PackerTestVM"
$ResouceGroup = "PackerGroup"
$username = "4ba6c94a-5ee2-4de1-b558-c739f52a51d1@rahamathoutlook.onmicrosoft.com"

#$pass = Get-Content "C:\GitHub\Test\Password.txt" | ConvertTo-SecureString -Verbose
$Pass = ConvertTo-SecureString “NA2xk@5W.7fcNZm6[QhfqjLrjizIIYM=” -AsPlainText -Force
$cred = New-Object -TypeName pscredential –ArgumentList "a0cdbf8e-57ce-4f3c-a387-5a10b681ba11@rahamathoutlook.onmicrosoft.com", $pass

# login non-interactive
Login-AzAccount -Credential $cred -ServicePrincipal –TenantId "05c575ab-b007-47e7-a0ea-f8f2564e6097" -Verbose



If (!(Get-AzResourceGroup -Name $ResouceGroup)) {
    New-AzResourceGroup -Name $ResouceGroup -Location "East Asia"
}

$password = ConvertTo-SecureString “Passw0rd1234” -AsPlainText -Force
$Cred1 = New-Object System.Management.Automation.PSCredential (“vagrantuser1”, $password)

Write-Host "Creating new VM"
New-AzVm -ResourceGroupName $ResouceGroup -Name $VMBuild -Image "MyWindowsOSImage" `
    -Location "East Asia" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIP" `
    -OpenPorts 80,3389 `
    -Credential $Cred1 | Out-Null

Write-Host "VM creation completed"


