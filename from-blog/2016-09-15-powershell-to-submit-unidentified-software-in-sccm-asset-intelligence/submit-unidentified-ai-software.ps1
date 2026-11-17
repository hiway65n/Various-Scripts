<#
Source: Powershell to submit unidentified software in SCCM Asset Intelligence
Blog: https://hiway65nblog.blogspot.com/2016/09/powershell-to-submit-unidentified.html
Published: September 15, 2016
Labels: AI, Asset Intelligence, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

# Get the AI Software objects that are unknow.

$wsql = "Select * from SMS_AISoftwareList Where State = 4"
$output = Get-WmiObject -Query $wsql -Namespace "root\sms\site_code" -ComputerName "YourServer"

# Then just add your logic for looping the update.

foreach ($app in $output)
{ ([wmiclass]'\\YourServer\root\sms\site_code:SMS_AISoftwareList').SetCategorizationRequest($app.SoftwareKey)
}
