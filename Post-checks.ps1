$VMname = "PackerTestVM"
$ResouceGroup = "PackerGroup"
$AwsAccessKeyId ="AKIAJJYBN2DYQZXIMJWA"
$AwsSecretKey = "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"
$AWSRegion = "ap-southeast-1"
Import-Module AWSPowerShell


# Set up the AWS environment
Write-Verbose "Authenticating against AWS..."
Set-AWSCredentials -AccessKey $AwsAccessKeyId -SecretKey $AwsSecretKey
Set-DefaultAWSRegion -Region $AWSRegion

$InstanceDetails = (Get-EC2Instance -Filter @(@{name='tag:Name'; values="$VMName"})).Instances

$PublicIP = $($InstanceDetails.PublicIpAddress)
$InstanceID = $($InstanceDetails.InstanceID)

$Status = $false

Write-Host "Waiting for Instance to come up"

Do {
    Start-sleep -Seconds 2
    #Write-Host "Inside loop"
    $InstanceStatus = (Get-EC2InstanceStatus -InstanceId $InstanceID)
    IF ($($InstanceStatus.Status.Status) -eq "ok" -and $($InstanceStatus.SystemStatus.Status) -eq "ok" ) {
        $Status = $True
    }
    #Write-Host $Status
} While ($Status -ne $True)

Write-Host "AWS Instance up with public $publicIP ; performing checks"

$WebReq = ""
$WebReq = Invoke-WebRequest -Uri "$PublicIP/default.html"
If ($($WebReq.Content) -like "*Rahamath*") {
    Write-Host "Server build completed sucessfully"
    Write-Host "Removing VM"
    Remove-EC2Instance -InstanceId $InstanceID -Force -Confirm | Out-Null
}
Else {
    Write-Host "Server build failed"
}