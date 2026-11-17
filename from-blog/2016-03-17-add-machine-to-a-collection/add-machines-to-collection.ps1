<#
Source: Add Machine to a Collection
Blog: https://hiway65nblog.blogspot.com/2016/03/add-machine-to-collection.html
Published: March 17, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

Import-Module -Name "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"

$a = Get-Content "i:\temp\temp.txt"

foreach ($i in $a)
    {
    $i | Out-File -FilePath c:\temp\assignout.log -Append
    $device = get-cmdevice -Name $i
    Add-CMDeviceCollectionDirectMembershipRule -CollectionName "Collection Name" -Resource $device | Out-File -FilePath c:\temp\assignout.log -Append

    }
