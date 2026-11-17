<#
Source: PS Script to convert a PS1 into a HTA that creates and executes a PS1
Blog: https://hiway65nblog.blogspot.com/2016/02/ps-script-to-convert-ps1-into-hta-that.html
Published: February 5, 2016
Labels: HTA, Powershell
#>

$a = Get-Content "c:\temp\original.ps1"
$b = "c:\temp\original.hta"
"<head>"| Out-File -FilePath $b
"<title>Application Installation Helper Triggering Script- `${number}</title>"| Out-File -FilePath $b -Append
"<HTA:APPLICATION "| Out-File -FilePath $b -Append
"APPLICATIONNAME=""Application Triggering Script"""| Out-File -FilePath $b -Append
"SCROLL=""yes"""| Out-File -FilePath $b -Append
"SINGLEINSTANCE=""yes"""| Out-File -FilePath $b -Append
">"| Out-File -FilePath $b -Append
"</head>"| Out-File -FilePath $b -Append
"<body>"| Out-File -FilePath $b -Append
"<h3>Your request will be processed shortly.</h3>"| Out-File -FilePath $b -Append
"<h3>Thank You</h3>"| Out-File -FilePath $b -Append
"</body>"| Out-File -FilePath $b -Append
"<script language=""VBScript"">"| Out-File -FilePath $b -Append
"set fso = CreateObject(""Scripting.FileSystemObject"")"| Out-File -FilePath $b -Append
"Set oShell = CreateObject(""WScript.Shell"")"| Out-File -FilePath $b -Append
"CurrentDirectory = oShell.ExpandEnvironmentStrings(""%temp%"")"| Out-File -FilePath $b -Append
"sFilePath = CurrentDirectory & ""\ServiceNowCatalog.ps1"""| Out-File -FilePath $b -Append
"Set objFSO = CreateObject(""Scripting.FileSystemObject"")"| Out-File -FilePath $b -Append
"Set objTextFile = objFSO.CreateTextFile(sFilePath, True)"| Out-File -FilePath $b -Append
foreach ($i in $a)
    {
    $i = $i -replace """", """"""
    "objTextFile.Write (""$i""& vbNewLine)" | Out-File -FilePath $b -Append
    }
"objTextFile.Close"| Out-File -FilePath $b -Append
"command_string = ""-ExecutionPolicy ByPass "" & sFilePath"| Out-File -FilePath $b -Append
"set objShell = CreateObject(""shell.application"")"| Out-File -FilePath $b -Append
"powersehllexe = oShell.ExpandEnvironmentStrings(""%windir%"") & ""\sysnative\WindowsPowerShell\v1.0\powershell.exe """| Out-File -FilePath $b -Append
"If not fso.fileexists(powersehllexe) then powersehllexe=oShell.ExpandEnvironmentStrings(""%windir%"") & ""\system32\WindowsPowerShell\v1.0\powershell.exe """| Out-File -FilePath $b -Append
"objShell.ShellExecute powersehllexe, command_string,"""", """", 0"| Out-File -FilePath $b -Append
"Self.Close()"| Out-File -FilePath $b -Append
"</script>"| Out-File -FilePath $b -Append
