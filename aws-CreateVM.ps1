Param (

    $AwsAccessKeyId,
    $AwsSecretKey
)

$VMname = "PackerTestVM"
$ResouceGroup = "PackerGroup"
$AWSRegion = "ap-southeast-1"
$EC2ImageName  = "mywindowsimage-Windows-2016"
$InstanceType = "t2.small"
#Import-Module AWSPowerShell


# Set up the AWS environment
Write-Host "Authenticating against AWS..."
Set-AWSCredentials -AccessKey $AwsAccessKeyId -SecretKey $AwsSecretKey -Verbose
Set-DefaultAWSRegion -Region $AWSRegion

Write-Host "Getting AWS Image..."
$Images = Get-EC2Image -Owner self

Foreach ($Image in $Images) {
   If($($Image.Name) -like "*mywindowsimage*") {
    $ami = $($Image.Imageid)
   } 
}
$ami
#Check if our AWS image is valid
If([string]::IsNullOrEmpty($ami)) {            
    throw "No Image has been found!"            
} else {            
    Write-Host ("The following image has been found: " + $ami.Name)            
}

#Creating new VM
Write-Host "Creating new AWS Instance..."
$NewVM = New-EC2Instance `
    -ImageId $ami `
    -MinCount 1 `
    -MaxCount 1 `
    -InstanceType $InstanceType `
    -ErrorAction Stop `
    -KeyName awsrdp `
    -SecurityGroupId sg-060ecaae49b1a3f09 `
    -SubnetId subnet-090e148cf11b412e3
    
 $InstanceID = $NewVM.Instances.InstanceID


#Applying VMName - also known as an AWS Tag
Write-Host "Applying new VM Name...."
New-EC2Tag -Resource $InstanceID -Tag @( @{ Key = "Name" ; Value = $VMname}) | out-Null
Write-Host ("Successfully created AWS VM: " + $VMname)

