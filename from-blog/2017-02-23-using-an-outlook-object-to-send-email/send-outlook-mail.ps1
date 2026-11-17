<#
Source: Using an Outlook Object to send email
Blog: https://hiway65nblog.blogspot.com/2017/02/using-outlook-object-to-send-email.html
Published: February 23, 2017
Labels: Outlook, Powershell
#>

$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)

$Mail.To = $Address
If (!([string]::IsNullOrWhiteSpace($CCAddress)))
{
    $Mail.CC = $CCAddress
}

$Mail.Subject = $Subject
$Mail.HTMLBody = $HtmlBody
$Mail.Send()
