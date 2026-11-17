<#
Source: Mimicking SCCM App Catalog via Powershell
Blog: https://hiway65nblog.blogspot.com/2016/02/mimicking-sccm-app-catalog-via.html
Published: February 5, 2016
Labels: Application Catalog, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

$conapp = new-object -comobject "CPApplet.CPAppletMgr"
$actions = $conapp.GetClientActions()
Foreach ( $act in $actions)
{
If ( $act.ActionId -eq "{3A88A2F3-0C39-45fa-8959-81F21BF500CE}" ) { $act.PerformAction() | out-null}
If ( $act.ActionId -eq "{8EF4D77C-8A23-45c8-BEC3-630827704F51}" ) { $act.PerformAction() | out-null}
}
