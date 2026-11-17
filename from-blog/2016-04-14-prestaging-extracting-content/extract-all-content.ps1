<#
Source: Prestaging/Extracting Content
Blog: https://hiway65nblog.blogspot.com/2016/04/prestagingextracting-content.html
Published: April 14, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$FolderToSaveTo = "C:\PrestageContent\_Done"
$WorkingFolder = "C:\PrestageContent"

If (((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\SMS\Setup)."Installation Directory") -ne $NULL) {$ExtractContentPath = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\SMS\Setup)."Installation Directory"+"\bin\X64\extractcontent.exe"}

(Get-WmiObject Win32_LogicalDisk -Filter "DriveType = 3").DeviceID | ForEach-Object {
If (Test-Path "$_\SMS_DP$\sms\Tools\ExtractContent.exe") {$ExtractContentPath = "$_\SMS_DP$\sms\Tools\ExtractContent.exe"}
}

(Get-ChildItem -Path $WorkingFolder -Directory).Name | ForEach-Object {
$Folder = $_

#if(!(Test-Path $FolderToSaveTo\$Folder)) {New-Item -ItemType Directory -Path $FolderToSaveTo\$Folder}
if(!(Test-Path $WorkingFolder\$Folder\DoIt)) {New-Item -ItemType Directory -Path $WorkingFolder\$Folder\DoIt}

(Get-ChildItem -Path $WorkingFolder\$Folder -Recurse -Include *.pkgx).Name | ForEach-Object {
#$Name = $_
Write-Host "`n" "Files Left: " ((Get-ChildItem -Path $WorkingFolder\$Folder -Recurse -Include *.pkgx) | Measure-Object).Count "`n"
& Write-Host $_.SubString(0,$_.Length - 5) "`n"
& Move-Item $WorkingFolder\$Folder\$_ $WorkingFolder\$Folder\DoIt
& $ExtractContentPath /P:$WorkingFolder\$Folder\DoIt /F
#& Move-Item $WorkingFolder\$Folder\DoIt\$_ $FolderToSaveTo\$Folder
& Remove-Item $WorkingFolder\$Folder\DoIt\$_
If (((Get-ChildItem -Path $WorkingFolder\$Folder -Recurse -Include *.pkgx) | Measure-Object).Count -eq 0) {Remove-Item -Path $WorkingFolder\$Folder -Force -Recurse}
}
}
