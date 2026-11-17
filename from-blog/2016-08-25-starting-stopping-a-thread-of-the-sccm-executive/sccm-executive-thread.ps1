<#
Source: Starting/Stopping a thread of the SCCM executive
Blog: https://hiway65nblog.blogspot.com/2016/08/startingstopping-sccm-executive-thread.html
Published: August 25, 2016
Labels: SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
#>

param(
[string] $thread = "SMS_DMP_DOWNLOADER",
[string] $action = "Start"
)

$registryPath = "HKLM:\Software\Microsoft\SMS\Components\SMS_Executive\Threads\$thread"
$registryName = "Requested Operation"

#$key = Get-ItemProperty -Path $registryPath -Name $registryName

Set-ItemProperty -Path $registryPath -Name $registryName -Value $action
