<#
Source: Stuck @ "Waiting for user logon"
Blog: https://hiway65nblog.blogspot.com/2016/03/stuck-waiting-for-user-logon.html
Published: March 17, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$CITask = get-wmiobject -query "select * from CCM_CITask where TaskState != ' PendingSoftReboot' AND TaskState != 'PendingHardReboot' AND TaskState != 'InProgress'" -namespace root\ccm\CITasks
if ($CITask -ne $NULL)
{
$CITask | remove-wmiobject -Whatif
$CITask | remove-wmiobject
}
ELSE
{
"CCM_CITasks is empty. Nothing to do"
}
