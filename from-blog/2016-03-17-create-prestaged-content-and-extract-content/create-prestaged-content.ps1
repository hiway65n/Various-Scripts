<#
Source: Create Prestaged Content and Extract Content
Blog: https://hiway65nblog.blogspot.com/2016/03/create-prestaged-content-and-extract.html
Published: March 17, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

if ([Environment]::Is64BitProcess) {Read-Host "This must be run from 32-bit Powershell";exit}

$SiteCode = "PRI"
$Server = "SiteServerName"
$DP = "DPserverName"
$FolderToSaveTo = "I:\PrestageContent"
Import-Module "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
#$Overwrite = $true
$Overwrite = $false

$Namespace = "root\SMS\site_" + $SiteCode
$SiteDrive = $SiteCode + ":\"
if ($FolderToSaveTo.EndsWith("\")) {$FolderToSaveTo = $FolderToSaveTo.SubString(0,$FolderToSaveTo.Length - 1)}
if(!(Test-Path $FolderToSaveTo)) {New-Item -ItemType Directory -Path $FolderToSaveTo}
if(!(Test-Path "$FolderToSaveTo\Applications")) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Applications"}
if(!(Test-Path "$FolderToSaveTo\Packages")) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Packages"}
if(!(Test-Path "$FolderToSaveTo\Software_Update_Packages")) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Software_Update_Packages"}
if(!(Test-Path "$FolderToSaveTo\Boot_Image_Packages")) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Boot_Image_Packages"}
if(!(Test-Path "$FolderToSaveTo\OS_Images")) {New-Item -ItemType Directory -Path "$FolderToSaveTo\OS_Images"}
if(!(Test-Path "$FolderToSaveTo\Drivers")) {New-Item -ItemType Directory -Path "$FolderToSaveTo\Drivers"}

If (Test-Path -Path I:\PrestageContent\Applications.txt) {
Get-Content -Path I:\PrestageContent\Applications.txt | ForEach-Object {
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
Rename-Item -Path I:\PrestageContent\Applications.txt I:\PrestageContent\Applications.txt.DONE
}

If (Test-Path -Path I:\PrestageContent\Packages.txt) {
Get-Content -Path I:\PrestageContent\Packages.txt | ForEach-Object {
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
Rename-Item -Path I:\PrestageContent\Packages.txt I:\PrestageContent\Packages.txt.DONE
}

If (Test-Path -Path I:\PrestageContent\Boot_Image_Packages.txt) {
Get-Content -Path I:\PrestageContent\Boot_Image_Packages.txt | ForEach-Object {
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
Rename-Item -Path I:\PrestageContent\Boot_Image_Packages.txt I:\PrestageContent\Boot_Image_Packages.txt.DONE
}

If (Test-Path -Path I:\PrestageContent\OS_Images.txt) {
Get-Content -Path I:\PrestageContent\OS_Images.txt | ForEach-Object {
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
Rename-Item -Path I:\PrestageContent\OS_Images.txt I:\PrestageContent\OS_Images.txt.DONE
}

If (Test-Path -Path I:\PrestageContent\Drivers.txt) {
Get-Content -Path I:\PrestageContent\Drivers.txt | ForEach-Object {
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
Rename-Item -Path I:\PrestageContent\Drivers.txt I:\PrestageContent\Drivers.txt.DONE
}

If (Test-Path -Path I:\PrestageContent\Software_Update_Packages.txt) {
Get-Content -Path I:\PrestageContent\Software_Update_Packages.txt | ForEach-Object {
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
Rename-Item -Path I:\PrestageContent\Software_Update_Packages.txt I:\PrestageContent\Software_Update_Packages.txt.DONE
}
