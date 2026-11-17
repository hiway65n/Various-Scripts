<#
Source: Redistribute Specific Package on Specific DP
Blog: https://hiway65nblog.blogspot.com/2016/03/redistribute-specific-package-on.html
Published: March 17, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

Import-Module -Name "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
cd DEV:

$a = Get-Content "i:\temp\temp.txt"

foreach ($i in $a)
    {
    $distpoints = Get-WmiObject -Namespace "\\bvlsccmcas\root\SMS\Site_CAS" -Query "Select * From SMS_DistributionPoint WHERE PackageID='$i' AND ServerNALPath like '%PER%'"
    foreach ($dp in $distpoints)
         {
                 $dp.RefreshNow = $true
                 $dp.Put()
         }
    }
