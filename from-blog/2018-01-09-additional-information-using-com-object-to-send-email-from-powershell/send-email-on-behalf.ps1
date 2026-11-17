<#
Source: Additional Information using COM object to send email from Powershell
Blog: https://hiway65nblog.blogspot.com/2018/01/additional-information-using-com-object.html
Published: January 9, 2018
Labels: Email, Powershell
#>

function Send-Email([string] $Address, [string] $CCAddress, [string] $BCCAddress,
[string] $Subject, [string] $HTMLBody, [string] $FromAddress)
{
$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)

If(!([string]::IsNullOrWhiteSpace($FromAddress)))
{
$Mail.SentOnBehalfOfName = $FromAddress
}
If (!([string]::IsNullOrWhiteSpace($CCAddress)))
{
$Mail.CC = $CCAddress
}
If (!([string]::IsNullOrWhiteSpace($BCCAddress)))
{
$Mail.BCC = $BCCAddress
}

$Mail.To = $Address
$Mail.Subject = $Subject
$Mail.HTMLBody = $HtmlBody
$Mail.Send()
}
