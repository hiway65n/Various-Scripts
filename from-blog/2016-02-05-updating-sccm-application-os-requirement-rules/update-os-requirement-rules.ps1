<#
Source: Updating SCCM Application OS Requirement Rules
Blog: https://hiway65nblog.blogspot.com/2016/02/updating-sccm-application-os.html
Published: February 5, 2016
Labels: Application Requirement Rules, Powershell, SCCM, SCCM 2012, System Center Configuration Manager, System Center Configuration Manager 2012
The post presents these as the useful portions of a longer script. sendl, sendl2, and sendl3 are the author's logging functions and are not defined here.
#>

# Load SCCM Assemblies
function Import-SCCMAssemblies
{
 [CmdletBinding()]
    param
 (
  [Parameter(Mandatory = $false,
       ValueFromPipeline = $true,
       ValueFromPipelineByPropertyName = $true,
       ValueFromRemainingArguments = $true,
       HelpMessage = 'Path to the AdminConsole\Bin directory.')]
  [Alias('Path')]
  [System.String]
  $ConsolePath = $Env:SMS_ADMIN_UI_PATH.Substring(0, $Env:SMS_ADMIN_UI_PATH.Length - 5)
 )
 Begin
 {

 }
 Process
 {
  if (Test-Path $ConsolePath)
  {
   $files = Get-ChildItem "$ConsolePath\*.dll" -File
   ForEach ($file in $files)
   {
                   if ($file.Name -eq 'ServicingNode.dll') { continue }

    Write-Verbose "Importing Assembly: $($file.FullName)"
    $Assembly = [System.IO.Path]::Combine($ConsolePath, $file)
    [void][Reflection.Assembly]::LoadFrom($Assembly)
   }
  }
  else
  {
   sendl "$ConsolePath not found."
  }
 }
 End
 {

 }
}

# Gets the Global Condition from WMI
function Get-SCCMGlobalCondition
{
 [CmdletBinding()]
 param
 (
  [Parameter(Mandatory = $true,
       ValueFromPipeline = $true,
       ValueFromPipelineByPropertyName = $true,
       Position = 0)]
  [Alias('ServerName')]
  [Alias('SiteServer')]
  [System.String]
  $SCCMServer,
  [Parameter(Mandatory = $true,
       ValueFromPipeline = $true,
       ValueFromPipelineByPropertyName = $true,
       Position = 1)]
  [Alias('SiteCode')]
  [System.String]
  $SCCMSiteCode,
  [Parameter(Mandatory = $true,
       ValueFromPipeline = $true,
       ValueFromPipelineByPropertyName = $true,
       Position = 2)]
  [Alias('ConditionName')]
  [System.String]
  $GlobalConditionName
 )
 Begin
 {

 }
 Process
 {
  $Filter = "LocalizedDisplayName = '$GlobalConditionName'"
  $Condition = Get-WmiObject -ComputerName $SCCMServer -Namespace "root\sms\Site_$SCCMSiteCode" -Class SMS_GlobalCondition -Filter $Filter | Where IsLatest -eq $True
  Write-Output $Condition
 }
 End
 {

 }

}

# Create new Global Condition Rule
Function New-SCCMGlobalConditionsRule
{
 [CmdletBinding(SupportsShouldProcess = $True)]
 Param (
  [Parameter(Mandatory = $true, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
  [string]$SCCMServer,

  [Parameter(Mandatory = $true, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
  [string]$SCCMSiteCode,

  [Parameter(Mandatory = $true, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
  [string]$GlobalConditionName,

  [Parameter(Mandatory = $true)]
  [string]$Operator,

  [Parameter(Mandatory = $true)]
  [string]$Value
 )

 Process
 {
  $GlobalCondition = Get-SCCMGlobalCondition -SCCMServer $SCCMServer -SCCMSiteCode $SCCMSiteCode -GlobalConditionName $GlobalConditionName

  $gcTmp = $GlobalCondition.ModelName.Split("/")
  $gcScope = $gcTmp[0]
  $gcLogicalName = $gcTmp[1]
  $gcDataType = $GlobalCondition.DataType
  $gcExpressionDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::GetDataTypeFromTypeName($gcDataType)

  $arg = @(
   $gcScope,
   $gcLogicalName,
   $gcExpressionDataType,
   "$($gcLogicalName)_Setting_LogicalName",
   ([Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM)
  )
  $reqSetting = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.GlobalSettingReference -ArgumentList $arg

  $arg = @(
   $Value,
   $gcExpressionDataType
  )
  $reqValue = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValue -ArgumentList $arg

  $operands = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
  $operands.Add($reqSetting) | Out-Null
  $operands.Add($reqValue) | Out-Null

  $Expoperator = Invoke-Expression [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::$operator

  if ($GlobalCondition.DataType -eq "OperatingSystem")
  {
   $operands = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.RuleExpression]]"
            $values = $value -split ";"

   foreach ($os in $values)
   {
                   $operands.Add($os)
   }

   $arg = @(
    $Expoperator,
    $operands
   )
   $expression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.OperatingSystemExpression -ArgumentList $arg

  }
  else
  {
   $arg = @(
    $Expoperator,
    $operands
   )
   $expression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression -ArgumentList $arg

  }

  $anno = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Annotation
  if ($GlobalCondition.DataType -eq "OperatingSystem")
  {
   # Annotation display name
   $osvalues = $Value.Split(";")
   $localizedOSNames = @()
   foreach ($os in $osvalues) {
    $Filter = "CI_UniqueId = '$os'"
    $localizedOSNames += (Get-WmiObject -ComputerName $SCCMServer -Namespace "root\sms\Site_$SCCMSiteCode" -Class SMS_ConfigurationItem -Filter $Filter | Where IsLatest -eq $True).LocalizedDisplayName
   }

   $localizedDisplayName = "{"
   foreach ($name in $localizedOSNames) { $localizedDisplayName += $name + ", " }
   $localizedDisplayName = $localizedDisplayName.Substring(0, $localizedDisplayName.Length - 2)
   $localizedDisplayName += "}"

   if ($operator -eq "OneOf") {
    $annodisplay = "Operating system One of $localizedDisplayName" }
   else {
    $annodisplay = "Operating system $operator $value"
   }

  }
  else
  {
   $annodisplay = "$GlobalConditionName $operator $value"
  }

  $arg = @(
   "DisplayName",
   $annodisplay,
   $null
  )
  $anno.DisplayName = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.LocalizableString -ArgumentList $arg

  $arg = @(
   ("Rule_" + [Guid]::NewGuid().ToString()),
   [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.NoncomplianceSeverity]::None,
   $anno,
   $expression
  )
  $rule = New-Object "Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Rule" -ArgumentList $arg

  return $rule
 }#End Process Block
}

<#
NOTICE from the post:
On the following method, OS rules were limited to desktop operating systems.
sendl / sendl2 / sendl3 are the author's logging method and are not defined in this post.
#>

# Adds Operating System One of ... condition to the App.
Function Add-GlobalConditionToApp
{
    [CmdletBinding(SupportsShouldProcess = $True)]
  Param (
   [Parameter(Mandatory = $true)]
   [string]$ApplicationName,
   [Parameter(Mandatory = $true)]
   [string]$GlobalConditionName,
            [Parameter(Mandatory = $true)]
   [string]$GlobalConditionOperator,
            [Parameter(Mandatory = $true)]
   [string]$GlobalConditionValue
  )

  Process
  {
            sendl("Checking Global Condition Rules to : "+$ApplicationName)
            $App = Get-WmiObject -ComputerName $SCCMServer -Namespace "root\sms\Site_$SCCMSiteCode" -Query "Select * From SMS_Application Where CI_ID = '$ApplicationName' And IsLatest = 'True'"
            $App.Get();

            $ApplicationName = $App.LocalizedDisplayName
            sendl("Application Name: "+$ApplicationName)

   $AppObject = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::DeserializeFromString($App.SDMPackageXML)
   # $App.SDMPackageXML

            ForEach ($DeploymentType in $AppObject.DeploymentTypes) {

        $ContainsOSRules = $False
        $DoPut = $False
        $AdditionalLog = $True

            ForEach ($rule in $DeploymentType.Requirements.Expression)
            {
                $z = 0
                If ($rule.GetType().Name -eq "OperatingSystemExpression")
                {
                    sendl ("# > " + $ApplicationName +" > " + $DeploymentType.Title.ToString() + " > " + $App.CI_ID + " > " + $rule.Operands.RuleID)
                    If (($rule.Operands.RuleID -like "*server*") -or ($rule.Operands.RuleID -like "*android*")-or ($rule.Operands.RuleID -like "*ipad*")-or ($rule.Operands.RuleID -like "*iphone*")-or ($rule.Operands.RuleID -like "*mobile*")-or ($rule.Operands.RuleID -like "*handheld*")-or ($rule.Operands.RuleID -like "*windows*10*"))
                    {
                        sendl ($DeploymentType.Title.ToString())
                        sendl "Contains Non Desktop OS"
                    }
                    Else
                    {
                        sendl "Found existing"
                        sendl ($DeploymentType.Title.ToString())
                        $ContainsOSRules = $True
                        sendl "Removing Rule"
                     $DeploymentType.Requirements.RemoveAt($z)
                        $DoPut = $True
                    }
                }
                Else
                {
                    sendl ($DeploymentType.Title.ToString())
                    sendl "No OS Rule Found"
                    sendl2($ApplicationName +" > " + $DeploymentType.Title.ToString() + " > " + $App.CI_ID + " > " + "No OS Rule Found")
                    $AdditionalLog = $False
                }
                $z = $z+1
            }
            If ($ContainsOSRules -eq $True)
            {
            sendl "Creating new"
              $rule = New-SCCMGlobalConditionsRule -SCCMServer $SCCMServer -SCCMSiteCode $SCCMSiteCode -GlobalConditionName $GlobalConditionName -Operator $GlobalConditionOperator -Value $GlobalConditionValue

                 if (!($DeploymentType.Requirements | Where Name -eq $rule.Name))
                        {
                         $DeploymentType.Requirements.Add($rule)
                            $DoPut = $True
                     }

            }
            If ($DoPut -eq $True)
                {
                    $App.SDMPackageXML = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::Serialize($AppObject)
                    #$App.SDMPackageXML
                    sendl "Attempting Put"
                    $App.Put()
                    sendl3($ApplicationName +" > " + $DeploymentType.Title.ToString() + " > " + $App.CI_ID + " > " + " Put Complete")
                }
            Else
                {
                    sendl "No Put Attempted"
                    #add output to another file for manual review
                    If ($AdditionalLog -eq $True)
                    {
                        sendl2($ApplicationName +" > " + $DeploymentType.Title.ToString() + " > " + $App.CI_ID + " > " + " No Put")
                    }
                }
            }
        }
}
