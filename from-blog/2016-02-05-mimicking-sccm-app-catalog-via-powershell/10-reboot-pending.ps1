<#
Source: Mimicking SCCM App Catalog via Powershell
Blog: https://hiway65nblog.blogspot.com/2016/02/mimicking-sccm-app-catalog-via.html
Published: February 5, 2016
Labels: Application Catalog, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$rebootPending = $false
$SoftRebootPending = ([wmiclass]'root/ccm/clientSDK:CCM_ClientUtilities').DetermineIfRebootPending().RebootPending
sendl ("SCCM Soft Reboot Pending: " + $SoftRebootPending)
$HardRebootPending = ([wmiclass]'root/ccm/clientSDK:CCM_ClientUtilities').DetermineIfRebootPending().IsHardRebootPending
sendl ("SCCM Hard Reboot Pending: " + $HardRebootPending)
if($SoftRebootPending -eq $true) {$rebootPending = $true}
if($HardRebootPending -eq $true) {$rebootPending = $true}
sendl ("SCCM Reboot Pending: " + $rebootPending)
