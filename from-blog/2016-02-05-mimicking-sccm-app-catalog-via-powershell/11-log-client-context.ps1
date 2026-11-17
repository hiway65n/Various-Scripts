<#
Source: Mimicking SCCM App Catalog via Powershell
Blog: https://hiway65nblog.blogspot.com/2016/02/mimicking-sccm-app-catalog-via.html
Published: February 5, 2016
Labels: Application Catalog, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

sendl ("This Computer's Name: " + $env:computername)
sendl ("OS Version: " + [environment]::OSVersion.VersionString )
sendl ("x64 OS: " + [environment]::Is64BitOperatingSystem )
sendl ("x64 Process: " + [environment]::Is64BitProcess )
$users = get-wmiobject -query "SELECT UserSID FROM CCM_UserLogonEvents WHERE LogoffTime = NULL" -namespace "ROOT\ccm"
sendl ("User running script: " + [Environment]::UserName)
foreach ($z in $users)
{
$objSID = New-Object System.Security.Principal.SecurityIdentifier($z.UserSID)
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
sendl ("User SCCM Client thinks is the active logged in user: " + $objUser.Value)
}
