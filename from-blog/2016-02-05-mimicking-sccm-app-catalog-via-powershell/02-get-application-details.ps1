<#
Source: Mimicking SCCM App Catalog via Powershell
Blog: https://hiway65nblog.blogspot.com/2016/02/mimicking-sccm-app-catalog-via.html
Published: February 5, 2016
Labels: Application Catalog, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$appid = #This is the ScopeID of the applicaiton for example if should look like ScopeId_21231C19-3346-4860-BA36-E8885D305E7A/Application_272b6fff-64e6-409f-a73a-2e36a999bba2
$WebServiceAppInfo = $service.GetApplicationDetails($appid, $null);
#sendl is my logging method, I used one I found from a web search.
sendl ("App Name: " + $WebServiceAppInfo.Name)
sendl ("App Version: " + $WebServiceAppInfo.AppVersion)
sendl ("App Publisher: " + $WebServiceAppInfo.Publisher)
