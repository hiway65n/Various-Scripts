<#
Source: Add Computers to AD Group
Blog: https://hiway65nblog.blogspot.com/2016/03/add-computers-to-ad-group.html
Published: March 17, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

Import-Module ActiveDirectory

$ADGroup = "AdGroup"
$Members = Get-ADGroupMember -Identity $ADGroup
$Machines = get-content "E:\Powershell Script\AddMachinesToADGroup.txt"

$Failures = @()
$Added = @()
$Existing = @()

Foreach ($Machine in $Machines)
{
    if ($Machine -in $Members.SAMAccountName)
    {
        $Existing += $Machine
    }
    else
    {
        try {
            $Machine += "$"
            "Trying to Add $($Machine)"
            Add-ADGroupMember -Identity $ADGroup -Members $Machine
            $Added += $Machine
        }
        catch { $Failures += $Machine }
    }
}
