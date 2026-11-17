<#
Source: Using Powershell to Assign iOS devices to DEP profile
Blog: https://hiway65nblog.blogspot.com/2016/10/using-powershell-to-assign-ios-devices.html
Published: October 27, 2016
Labels: Intune, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$SiteServer = "SomeServer"
$SiteCode = "SomeCode"

$EnrollmentProfile = Get-WmiObject -Namespace "root\sms\site_$SiteCode" -Class SMS_MDMCorpEnrollmentProfiles -ComputerName $SiteServer
$ProfileID = $EnrollmentProfile.ProfileId

$MobileDevices = Get-WmiObject -Namespace "root\sms\site_$SiteCode" -Query "select * from sms_mdmcorpowneddevices where (requestenrollmentprofileid is null or requestenrollmentprofileid <> '$ProfileID') and (DeviceType = '8')" -ComputerName $SiteServer

If ($MobileDevices.Count > 0)
{
foreach ($md in $MobileDevices)
{
    $md.SerialNumber
    ([wmiclass]"root/SMS/site_$($SiteCode):SMS_MDMCorpOwnedDevices").UpdateProfileIdForDevices($ProfileID,$Md.SerialNumber)
}
}
