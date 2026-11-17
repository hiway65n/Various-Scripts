<#
Source: Reset Inventory on SCCM client if over 7 days since report
Blog: https://hiway65nblog.blogspot.com/2016/02/reset-inventory-on-sccm-client-if-over.html
Published: February 16, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$inventoryQuery = "Select InventoryActionID, LastCycleStartedDate, LastReportDate from InventoryActionStatus"

$inventoryResult = get-wmiobject -query $inventoryQuery -namespace "root\ccm\Invagt"

$HWdate = $null
$SWdate = $null
$HWold = $true
$SWold = $true

ForEach ($iResult in $inventoryResult)
{

    $inventoryType = [convert]::ToInt32(($iResult.InventoryActionID).substring(35,2), 10)

    switch ($inventoryType)
    {

        1 {$HWdate = $iResult.LastReportDate}
        2 {$SWdate = $iResult.LastReportDate}

    }

}

$HWdate = [System.Management.ManagementDateTimeConverter]::ToDateTime($HWdate)
$SWdate = [System.Management.ManagementDateTimeConverter]::ToDateTime($SWdate)

$limit = (Get-Date).AddDays(-7)

if ($HWdate -gt $limit)
{
    $HWold = $false
}
if ($SWdate -gt $limit)
{
    $SWold = $false
}

if (($HWold -eq $true) -or ($SWold -eq $true))
{
    #HW Inventory reset and trigger
    [wmi]"ROOT\ccm\invagt:InventoryActionStatus.InventoryActionID='{00000000-0000-0000-0000-000000000001}'" | remove-wmiobject
    ([wmiclass]'ROOT\ccm:SMS_Client').TriggerSchedule('{00000000-0000-0000-0000-000000000001}')
    #SW Inventory reset and trigger
    [wmi]"ROOT\ccm\invagt:InventoryActionStatus.InventoryActionID='{00000000-0000-0000-0000-000000000002}'" | remove-wmiobject
    ([wmiclass]'ROOT\ccm:SMS_Client').TriggerSchedule('{00000000-0000-0000-0000-000000000002}')
}
