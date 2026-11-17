<#
Source: Outlook "Work Offline" Mode
Blog: https://hiway65nblog.blogspot.com/2022/03/outlook-work-offline-mode.html
Published: March 7, 2022
Labels: 1E, Microsoft, Outlook, Powershell, Tachyon
#>

#Check if Outlook is online or offline mode
$Outlook = New-Object -ComObject Outlook.Application;
$State = if ($outlook.session.offline) {"Outlook has been set to work offline mode." } else { "Healthy - Outlook is in online mode." };
$State;

#Toggle Outlook to online mode
Try {
  $Outlook = New-Object -ComObject Outlook.Application
  $State = "Toggle"
  if ($outlook.session.offline)
  {
  $Outlook.ActiveExplorer().CommandBars.ExecuteMSO("ToggleOnline")
  }
  else
  {
  "Outlook already in online mode."
  }
  ConvertTo-Json($State)
  }
  Catch
  {
  If ($_.Exception.Message.Contains("Class not registered"))
  {
  ConvertTo-Json("No Outlook Registered")
  }
  Else
  {
   ConvertTo-Json("Unknown Outcome")
  }
  }
