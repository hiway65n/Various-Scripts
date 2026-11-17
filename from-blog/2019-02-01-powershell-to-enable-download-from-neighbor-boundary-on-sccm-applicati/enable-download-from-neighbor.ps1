<#
Source: Powershell to enable "Download from Neighbor Boundary" on SCCM Applications
Blog: https://hiway65nblog.blogspot.com/2019/02/powershell-to-enable-download-from.html
Published: February 1, 2019
Labels: Powershell, SCCM, SCCM 2012, SCCM Current Branch, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$OutFileName = "C:\EnterLogNameHere.log"

$AllApps = Get-CMApplication

$Agent99 = $AllApps | Where-Object {$_.LocalizedDisplayName -like "*IfYouWantToLimitIt*"}

foreach($appType1 in $Agent99)
{
$allTypes1 = Get-CMDeploymentType -ApplicationName $appType1.LocalizedDisplayName
forEach($appType in $allTypes1)
{

If ($appType.Technology -contains "MSI")
{
#"MSI"
$appType.LocalizedDisplayName +";"+ $appType.Technology +";"+ "Updated to Download" | Out-File $OutFileName -Append
Set-CMMsiDeploymentType -ApplicationId $appType1.CI_ID -DeploymentTypeName $appType.LocalizedDisplayName -SlowNetworkDeploymentMode Download
}
elseif ($appType.Technology -contains "Script")
{
#"Script"
$appType.LocalizedDisplayName +";"+ $appType.Technology +";"+ "Updated to Download" | Out-File $OutFileName -Append
Set-CMScriptDeploymentType -ApplicationId $appType1.CI_ID -DeploymentTypeName $appType.LocalizedDisplayName -SlowNetworkDeploymentMode Download
}
else
{
#"Other"
$appType.LocalizedDisplayName +";"+$appType.Technology+";"+"Untouched" | Out-File $OutFileName -Append
}
}
}
