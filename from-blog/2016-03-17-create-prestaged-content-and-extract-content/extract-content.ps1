<#
Source: Create Prestaged Content and Extract Content
Blog: https://hiway65nblog.blogspot.com/2016/03/create-prestaged-content-and-extract.html
Published: March 17, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$Folder = "Packages"
$FolderToSaveTo = "I:\PrestageContent\_Done"

if(!(Test-Path $FolderToSaveTo\$Folder)) {New-Item -ItemType Directory -Path $FolderToSaveTo\$Folder}
if(!(Test-Path I:\PrestageContent\$Folder\DoIt)) {New-Item -ItemType Directory -Path I:\PrestageContent\$Folder\DoIt}

(Get-ChildItem -Path I:\PrestageContent\$Folder -Recurse -Include *.pkgx).Name | ForEach-Object {
#$Name = $_
Write-Host "`n" "Files Left: " ((Get-ChildItem -Path I:\PrestageContent\$Folder -Recurse -Include *.pkgx) | Measure-Object).Count "`n"
& Write-Host $_.TrimEnd(".pkgx") "`n"
& Move-Item I:\PrestageContent\$Folder\$_ I:\PrestageContent\$Folder\DoIt
& 'I:\SMS_DP$\sms\Tools\ExtractContent.exe' /P:I:\PrestageContent\$Folder\DoIt /F
& Move-Item I:\PrestageContent\$Folder\DoIt\$_ $FolderToSaveTo\$Folder
If (((Get-ChildItem -Path I:\PrestageContent\$Folder -Recurse -Include *.pkgx) | Measure-Object).Count -eq 0) {Remove-Item -Path I:\PrestageContent\$Folder -Force -Recurse}
}
