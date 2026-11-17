<#
Source: Hard to reach Registry Hive
Blog: https://hiway65nblog.blogspot.com/2018/02/hard-to-reach-registry-hive.html
Published: February 28, 2018
Labels: Powershell, Registry
#>

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
