<#
Source: Trigger Manual DEP Sync With Powershell
Blog: https://hiway65nblog.blogspot.com/2017/05/trigger-manual-dep-sync-with-powershell.html
Published: May 15, 2017
Labels: Intune, SCCM, System Center Configuration Manager
#>

$wmidate = new-object -com Wbemscripting.swbemdatetime
$date = get-date -format g
$wmidate.SetVarDate($date,$true)

[void] ($thisInstance = ([wmiclass]"\\localhost\root\sms\site_COP:SMS_ActionAccountResult").createinstance() )
[void] ($thisInstance.ActionID = 1)
[void] ($thisInstance.StartTime = $wmidate.value)
[void] ($thisInstance.Put())

$date = get-date -format g
$wmidate.SetVarDate($date,$true)

[void] ($thisInstance = ([wmiclass]"\\localhost\root\sms\site_COP:SMS_ActionAccountResult").createinstance() )
[void] ($thisInstance.ActionID = 2)
[void] ($thisInstance.ActionData = 'syncType,fullSync')
[void] ($thisInstance.StartTime = $wmidate.value)
[void] ($thisInstance.Put())
