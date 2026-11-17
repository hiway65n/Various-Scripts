<#
Source: Prestaging/Extracting Content
Blog: https://hiway65nblog.blogspot.com/2016/04/prestagingextracting-content.html
Published: April 14, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

if ([Environment]::Is64BitProcess) {Read-Host "This must be run from 32-bit Powershell";exit}

$SiteCode = "PRI"
$Server = "PrimaryServer"
$DP = "DistributionPointServer"
$FolderToSaveTo = "C:\PrestageContent"
Import-Module "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
#$Overwrite = $true
$Overwrite = $false

$Namespace = "root\SMS\site_" + $SiteCode
$SiteDrive = $SiteCode + ":\"
if ($FolderToSaveTo.EndsWith("\")) {$FolderToSaveTo = $FolderToSaveTo.SubString(0,$FolderToSaveTo.Length - 1)}
if(!(Test-Path $FolderToSaveTo)) {New-Item -ItemType Directory -Path $FolderToSaveTo}
if((!(Test-Path "$FolderToSaveTo\Applications")) -and (Test-Path $FolderToSaveTo\Applications.txt)) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Applications"}
if((!(Test-Path "$FolderToSaveTo\Packages")) -and (Test-Path $FolderToSaveTo\Packages.txt)) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Packages"}
if((!(Test-Path "$FolderToSaveTo\Software_Update_Packages")) -and (Test-Path $FolderToSaveTo\Software_Update_Packages.txt)) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Software_Update_Packages"}
if((!(Test-Path "$FolderToSaveTo\Boot_Image_Packages")) -and (Test-Path $FolderToSaveTo\Boot_Images.txt)) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Boot_Image_Packages"}
if((!(Test-Path "$FolderToSaveTo\OS_Images")) -and (Test-Path $FolderToSaveTo\OS_Images.txt)) {New-Item -ItemType Directory -Path "$FolderToSaveTo\OS_Images"}
if((!(Test-Path "$FolderToSaveTo\OS_Upgrades")) -and (Test-Path $FolderToSaveTo\OS_Upgrades.txt)) {New-Item -ItemType Directory -Path "$FolderToSaveTo\OS_Upgrades"}
if((!(Test-Path "$FolderToSaveTo\Drivers")) -and (Test-Path $FolderToSaveTo\Drivers.txt)) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Drivers"}

If (Test-Path -Path $FolderToSaveTo\Applications.txt) {
Get-Content -Path $FolderToSaveTo\Applications.txt | ForEach-Object {
    #$Query = Get-WmiObject -Query "Select * from SMS_Application where ISLatest='true' and LocalizedDisplayName='$_'" -ComputerName $Server -Namespace $Namespace
 #$AppID = $Query.CI_UniqueID
 $AppName = $_
    $AppFileName = $AppName -replace '/', '_'
    $AppFileName = $AppFileName -replace [regex]::Escape('\'), '_'
    $AppFileName = $AppFileName -replace [regex]::Escape(':'), '_'
    $AppFileName = $AppFileName -replace [regex]::Escape('*'), '_'
    $AppFileName = $AppFileName -replace [regex]::Escape('?'), '_'
    $AppFileName = $AppFileName -replace [regex]::Escape('*'), '_'
    $AppFileName = $AppFileName -replace [regex]::Escape('#'), '_'
    $AppFileName = $AppFileName -replace '<', '_'
    $AppFileName = $AppFileName -replace '>', '_'
    $AppFileName = $AppFileName -replace [regex]::Escape('|'), '_'
 $FileName = "$FolderToSaveTo\Applications\$AppFileName.pkgx"
 $Skip = $false
 if ($Overwrite -eq $false) {if (Test-Path $FileName) {$Skip = $true}}
 if ($Skip -eq $false) {
  if (Test-Path $FileName) {Remove-Item $FileName -Force}
  CD "$SiteDrive"
        Write-Host 'Application: ' $AppName
        Publish-CMPrestageContent -ApplicationName $AppName -DisableExportAllDependencies -FileName $FileName -DistributionPointName $DP
 }
}
Rename-Item -Path $FolderToSaveTo\Applications.txt $FolderToSaveTo\Applications.txt.DONE
}

If (Test-Path -Path $FolderToSaveTo\Packages.txt) {
Get-Content -Path $FolderToSaveTo\Packages.txt | ForEach-Object {
    #$Query = Get-WmiObject -Query "Select * from SMS_Package" -ComputerName $Server -Namespace $Namespace
    $PackageID = $_
 $FileName = "$FolderToSaveTo\Packages\$PackageID.pkgx"
 CD "C:\"
 $Skip = $false
 if ($Overwrite -eq $false) {if (Test-Path $FileName) {$Skip = $true}}
 if ($Skip -eq $false) {
  if (Test-Path $FileName) {Remove-Item $FileName -Force}
  CD "$SiteDrive"
        Write-Host 'Package: ' $PackageID
  Publish-CMPrestageContent -PackageID $PackageID -FileName $FileName -DistributionPointName $DP
 }
}
Rename-Item -Path $FolderToSaveTo\Packages.txt $FolderToSaveTo\Packages.txt.DONE
}

If (Test-Path -Path $FolderToSaveTo\Boot_Image_Packages.txt) {
Get-Content -Path $FolderToSaveTo\Boot_Image_Packages.txt | ForEach-Object {
    #$Query = Get-WmiObject -Query "SELECT * FROM SMS_BootImagePackage WHERE ActionInProgress!=3" -ComputerName $Server -Namespace $Namespace
    $PackageID = $_
 $FileName = "$FolderToSaveTo\Boot_Image_Packages\$PackageID.pkgx"
 CD "C:\"
 $Skip = $false
 if ($Overwrite -eq $false) {if (Test-Path $FileName) {$Skip = $true}}
 if ($Skip -eq $false) {
  if (Test-Path $FileName) {Remove-Item $FileName -Force}
  CD "$SiteDrive"
        Write-Host 'Boot Image: ' $PackageID
  Publish-CMPrestageContent -BootImageID $PackageID -FileName $FileName -DistributionPointName $DP
 }
}
Rename-Item -Path $FolderToSaveTo\Boot_Image_Packages.txt $FolderToSaveTo\Boot_Image_Packages.txt.DONE
}

If (Test-Path -Path $FolderToSaveTo\OS_Images.txt) {
Get-Content -Path $FolderToSaveTo\OS_Images.txt | ForEach-Object {
    #$Query = Get-WmiObject -Query "SELECT * FROM SMS_ImagePackage WHERE ActionInProgress!=3" -ComputerName $Server -Namespace $Namespace
    $PackageID = $_
 $FileName = "$FolderToSaveTo\OS_Images\$PackageID.pkgx"
 CD "C:\"
 $Skip = $false
 if ($Overwrite -eq $false) {if (Test-Path $FileName) {$Skip = $true}}
 if ($Skip -eq $false) {
  if (Test-Path $FileName) {Remove-Item $FileName -Force}
  CD "$SiteDrive"
        Write-Host 'OS Image: ' $PackageID
  Publish-CMPrestageContent -OperatingSystemImageID $PackageID -FileName $FileName -DistributionPointName $DP
 }
}
Rename-Item -Path $FolderToSaveTo\OS_Images.txt $FolderToSaveTo\OS_Images.txt.DONE
}

If (Test-Path -Path $FolderToSaveTo\OS_Upgrades.txt) {
Get-Content -Path $FolderToSaveTo\OS_Upgrades.txt | ForEach-Object {
    #$Query = Get-WmiObject -Query "SELECT * FROM SMS_OperatingSystemInstallPackage WHERE ActionInProgress!=3" -ComputerName $Server -Namespace $Namespace
    $PackageID = $_
 $FileName = "$FolderToSaveTo\OS_Upgrades\$PackageID.pkgx"
 CD "C:\"
 $Skip = $false
 if ($Overwrite -eq $false) {if (Test-Path $FileName) {$Skip = $true}}
 if ($Skip -eq $false) {
  if (Test-Path $FileName) {Remove-Item $FileName -Force}
  CD "$SiteDrive"
        Write-Host 'OS Installer: ' $PackageID
  Publish-CMPrestageContent -OperatingSystemInstallerID $PackageID -FileName $FileName -DistributionPointName $DP
 }
}
Rename-Item -Path $FolderToSaveTo\OS_Upgrades.txt $FolderToSaveTo\OS_Upgrades.txt.DONE
}

If (Test-Path -Path $FolderToSaveTo\Drivers.txt) {
Get-Content -Path $FolderToSaveTo\Drivers.txt | ForEach-Object {
    #$Query = Get-WmiObject -Query "Select * from SMS_DriverPackage" -ComputerName $Server -Namespace $Namespace
    $PackageID = $_
 $FileName = "$FolderToSaveTo\Drivers\$PackageID.pkgx"
 CD "C:\"
 $Skip = $false
 if ($Overwrite -eq $false) {if (Test-Path $FileName) {$Skip = $true}}
 if ($Skip -eq $false) {
  if (Test-Path $FileName) {Remove-Item $FileName -Force}
  CD "$SiteDrive"
        Write-Host 'Driver Package: ' $PackageID
  Publish-CMPrestageContent -DriverPackageID $PackageID -FileName $FileName -DistributionPointName $DP
 }
}
Rename-Item -Path $FolderToSaveTo\Drivers.txt $FolderToSaveTo\Drivers.txt.DONE
}

If (Test-Path -Path $FolderToSaveTo\Software_Update_Packages.txt) {
Get-Content -Path $FolderToSaveTo\Software_Update_Packages.txt | ForEach-Object {
    #$Query = Get-WmiObject -Query "SELECT * FROM SMS_SoftwareUpdatesPackage WHERE ActionInProgress!=3" -ComputerName $Server -Namespace $Namespace
    $PackageID = $_
    $FileName = "$FolderToSaveTo\Software_Update_Packages\$PackageID.pkgx"
 CD "C:\"
 $Skip = $false
 if ($Overwrite -eq $false) {if (Test-Path $FileName) {$Skip = $true}}
 if ($Skip -eq $false) {
  if (Test-Path $FileName) {Remove-Item $FileName -Force}
  CD "$SiteDrive"
        Write-Host 'Software Update Package: ' $PackageID
  Publish-CMPrestageContent -DeploymentPackageID $PackageID -FileName $FileName -DistributionPointName $DP
 }
}
Rename-Item -Path $FolderToSaveTo\Software_Update_Packages.txt $FolderToSaveTo\Software_Update_Packages.txt.DONE
}
