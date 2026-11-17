<#
Source: Mimicking SCCM App Catalog via Powershell
Blog: https://hiway65nblog.blogspot.com/2016/02/mimicking-sccm-app-catalog-via.html
Published: February 5, 2016
Labels: Application Catalog, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$checkResult = get-wmiobject -query $appCheck -namespace "ROOT\ccm\ClientSDK"
 if($checkResult -ne $null)
{
foreach ($b in $checkResult)
{
if ($b.InstallState.ToLower() -eq 'installed' -and $alreadyInstalled -eq $false)
{
$alreadyInstalled = $true
sendl "Software already installed"
}
}
