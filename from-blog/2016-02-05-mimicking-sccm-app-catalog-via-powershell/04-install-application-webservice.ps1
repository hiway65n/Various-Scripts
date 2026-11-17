<#
Source: Mimicking SCCM App Catalog via Powershell
Blog: https://hiway65nblog.blogspot.com/2016/02/mimicking-sccm-app-catalog-via.html
Published: February 5, 2016
Labels: Application Catalog, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$WebServiceResults = $service.InstallApplication($appid, $deviceid, $null)
#I used the results of the webservice for logging
sendl ("IsAppModelApplication: " + $WebServiceResults.IsAppModelApplication)
sendl ("PolicyVersion: " + $WebServiceResults.PolicyVersion)
sendl ("PolicyModelName: " + $WebServiceResults.PolicyModelName)
