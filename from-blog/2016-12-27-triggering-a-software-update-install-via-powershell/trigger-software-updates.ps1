<#
Source: Triggering a software update install via Powershell
Blog: https://hiway65nblog.blogspot.com/2016/12/triggering-software-update-install-via.html
Published: December 27, 2016
Labels: Powershell, SCCM, SCCM 2012, Software Updates, System Center Configuration Manager, System Center Configuration Manager 2012
Several separate snippets from one post: scan, install all, install selected, check whether updates are running, and list missing updates. Narrative lines between them are comments.
#>

# Triggering an update scan on a client:
([wmiclass]'ROOT\ccm:SMS_Client').TriggerSchedule('{00000000-0000-0000-0000-000000000113}')

# Trigger install of all updates:
([wmiclass]'ROOT\ccm\ClientSDK:CCM_SoftwareUpdatesManager').InstallUpdates()

# Here is a nice addition if you only want to install specific update(s) you just have to modify the select statement:
([wmiclass]'ROOT\ccm\ClientSDK:CCM_SoftwareUpdatesManager').InstallUpdates([System.Management.ManagementObject[]] (get-wmiobject -query 'SELECT * FROM CCM_SoftwareUpdate' -namespace 'ROOT\ccm\ClientSDK'))

# If you would like to see if there are updates applying, if true they are running:
$CCMUpdate = get-wmiobject -query "SELECT * FROM CCM_SoftwareUpdate" -namespace "ROOT\ccm\ClientSDK"
if(@($CCMUpdate | where { $_.EvaluationState -eq 2 -or $_.EvaluationState -eq 3 -or $_.EvaluationState -eq 4 -or $_.EvaluationState -eq 5 -or $_.EvaluationState -eq 6 -or $_.EvaluationState -eq 7 -or $_.EvaluationState -eq 11 }).length -ne 0) { $SCCMUpdate = $true } else {$SCCMUpdate = $false }

# If you are interested in seeing which updates are missing:
get-wmiobject -query "SELECT * FROM CCM_SoftwareUpdate WHERE ComplianceState = 0" -namespace "ROOT\ccm\ClientSDK"
