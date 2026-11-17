<#
Source: DP Content Location Request Powershell
Blog: https://hiway65nblog.blogspot.com/2019/02/dp-content-location-request-powershell.html
Published: February 1, 2019
Labels: Distribution Point, DP Share, Powershell, SCCM Current Branch, System Center Configuration Manager
#>

[void] [Reflection.Assembly]::LoadWithPartialName("System.Diagnostics")
[void] [Reflection.Assembly]::LoadFile("c:\Microsoft.ConfigurationManagement.Messaging.dll")

$ManagementPointSiteCode = "COP"
$ManagementPoint = "Server.FQDN.local"
$PackageID = "PackageID"
$PackageVersion = "PackageVersion"
$myDomain = "Domain.Whatever"
$myForest = "Forest"
$myCustomAdSite = "ADSite"

# Set up the objects
$httpSender = New-Object -TypeName Microsoft.ConfigurationManagement.Messaging.Sender.Http.HttpSender

$clr = New-Object -TypeName Microsoft.ConfigurationManagement.Messaging.Messages.ConfigMgrContentLocationRequest

$cmReply = New-Object -TypeName Microsoft.ConfigurationManagement.Messaging.Messages.ContentLocationReply

# Discover (the try/catch is in case the ADSI COM
# object cannot be loaded (WinPE).
try
{
   $clr.Discover()
}
catch
{
   $clr.LocationRequest.ContentLocationInfo.IPAddresses.DiscoverIPAddresses()
   $clr.LocationRequest.ContentLocationInfo.ADSite.DiscoverADSite()
   $clr.LocationRequest.Domain = New-Object -TypeName Microsoft.ConfigurationManagement.Messaging.Messages.ContentLocationDomain
   $clr.LocationRequest.Domain.Name = $myDomain
   $clr.LocationRequest.Forest = New-Object -TypeName Microsoft.ConfigurationManagement.Messaging.Messages.ContentLocationForest
   $clr.LocationRequest.Forest.Name = $myForest
}

# Define our SCCM Settings for the message
$clr.SiteCode = $ManagementPointSiteCode
$clr.Settings.HostName = $ManagementPoint
$clr.LocationRequest.Package.PackageId = $PackageID
$clr.LocationRequest.Package.Version = $PackageVersion

# If we want to "spoof" a request from a different
# AD Site, we can just pass that AD Site in here.
if ($myCustomAdSite -ne $null)
{
   $clr.LocationRequest.ContentLocationInfo.ADSite = $myCustomAdSite
}

# Validate
$clr.Validate([Microsoft.ConfigurationManagement.Messaging.Framework.IMessageSender]$httpSender)

# Send the message
$cmReply = $clr.SendMessage($httpSender)

# Get response
$response = $cmReply.Body.Payload.ToString()

while($response[$response.Length -1] -ne '>')
{
   $response = $response.TrimEnd($response[$response.Length -1])
}

 Write-Output $response
