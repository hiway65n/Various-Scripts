<#
Source: CI guts for App Catalog check
Blog: https://hiway65nblog.blogspot.com/2016/09/ci-guts-for-app-catalog-check.html
Published: September 12, 2016
Labels: Application Catalog, CI, Configuration Item, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$registryPath = "HKLM:\Software\Microsoft\SMS\PORTALWEB"
$registryName = "PortalPath"
$key = Get-ItemProperty -Path $registryPath -Name $registryName
$FilePath = $key.PortalPath+"\default.aspx"
  $ConfigFile = $key.PortalPath+"\web.config"
 $WebConfig1 = [System.IO.File]::ReadAllText($ConfigFile)
 If (!($WebConfig1.Contains("<!--<remove name=""Documentation""/>-->")))
 {
 $WebConfig1 = $WebConfig1.Replace("<remove name=""Documentation"" />","<!--<remove name=""Documentation"" />-->")
 [System.IO.File]::WriteAllText($ConfigFile, $WebConfig1)
 }
