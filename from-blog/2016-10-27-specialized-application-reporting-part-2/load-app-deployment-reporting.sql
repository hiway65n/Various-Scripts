-- Source: Specialized Application Reporting - Part 2
-- Blog: https://hiway65nblog.blogspot.com/2016/10/specialized-application-reporting-part-2.html
-- Published: October 27, 2016
-- Labels: Reporting, SCCM, SCCM 2012, SQL, System Center Configuration Manager, System Center Configuration Manager 2012

-- Step #1 - Update the vAppDeploymentResultsPerClient table

USE [INSERT DB NAME HERE]

DECLARE @AppName varchar(max)
DECLARE @CollectionName1 varchar(max)
DECLARE @CollectionName2 varchar(max)
SET @AppName = '[ApplicationName]'
SET @CollectionName1 = '[CollectionName]'
SET @CollectionName2 = '[CollectionName]'

delete from vAppDeploymentResultsPerClient where descript like @AppName

insert into vAppDeploymentResultsPerClient
select dep.*
from [PRIMARYSERVER].[CM_DATABASENAME].dbo.vAppDeploymentResultsPerClient dep inner join [PRIMARYSERVER].[CM_DATABASENAME].dbo.v_Collection col on dep.TargetCollectionID = col.CollectionID
where dep.descript like @AppName and (col.Name like @CollectionName1 or col.Name like @CollectionName2)

-- Step #2 - Remove data from temporary table

USE [INSERT DB NAME HERE]

DECLARE @AppName varchar(max)
SET @AppName = '[ApplicationName]'

delete from AppDeployment_temp where descript like @AppName

-- Step #3 - Insert new data into temporary table

USE [INSERT DB NAME HERE]

DECLARE @CollectionName1 varchar(max)
DECLARE @CollectionName2 varchar(max)
DECLARE @AppName varchar(max)
SET @CollectionName1 = '[CollectionName]'
SET @CollectionName2 = '[CollectionName]'
SET @AppName = '[ApplicationName]'

INSERT INTO appdeployment_temp
select distinct sys.Name0 as 'PC Name',
CASE
 WHEN col.Name = '[CollectionName1]' THEN 'Custom Deployment Name 1' --This can be used for in reporting to represent different stages of your deployment.
 WHEN col.Name = '[CollectionName2]' THEN 'Custom Deployment Name 2'
 WHEN col.Name = '[CollectionName3]' THEN 'Custom Deployment Name 3'
 ELSE col.Name
END as 'Deployment', errdet.ErrorCode as 'Error_Code', dep.Descript,
CASE
 WHEN dep.EnforcementState >= 1000 and dep.EnforcementState < 2000 THEN 'Success'
 WHEN dep.EnforcementState >= 2000 and dep.EnforcementState < 3000 THEN 'In Progress'
 WHEN dep.EnforcementState >= 4000 and dep.EnforcementState < 5000 THEN 'Offline'
 WHEN dep.EnforcementState >= 5000 and dep.EnforcementState < 6000 THEN 'Error'
 WHEN dep.EnforcementState >= 3000 and dep.EnforcementState < 4000 THEN 'Requirements Not Met'
END as 'Error Status',
CASE
 WHEN dep.EnforcementState = 1001 THEN 'Already Compliant'
 WHEN dep.EnforcementState >= 1000 and dep.EnforcementState < 2000 and dep.EnforcementState <> 1001 THEN 'Success'
 WHEN dep.EnforcementState >= 2000 and dep.EnforcementState < 3000 and dep.EnforcementState not in (2000, 2009) THEN ec.EnforcementCategory
 WHEN dep.EnforcementState >= 2000 and dep.EnforcementState < 3000 THEN 'In Progress'
 WHEN dep.EnforcementState >= 4000 and dep.EnforcementState < 5000 THEN 'Offline'
 WHEN dep.EnforcementState >= 5000 and dep.EnforcementState < 6000 THEN ed.ErrorStatus
 WHEN dep.EnforcementState >= 3000 and dep.EnforcementState < 4000 THEN 'Requirements Not Met'
END as 'Error Description', usr.Full_User_Name0 as 'User Name', sys.User_Name0 as 'User ID', usr.Mail0 as 'Email Address'

from vAppDeploymentResultsPerClient dep inner join [PRIMARYSERVER].[CM_DATABASENAME].dbo.v_R_System sys on dep.ResourceID = sys.ResourceID
left join [PRIMARYSERVER].[CM_DATABASENAME].dbo.vAppDeploymentAssetDetails appdet on (dep.PolicyModelID = appdet.PolicyModelID and dep.ResourceID = appdet.MachineID)
left join [PRIMARYSERVER].[CM_DATABASENAME].dbo.vAppDeploymentErrorAssetDetails errdet on (dep.PolicyModelID = errdet.PolicyModelID and dep.ResourceID = errdet.MachineID)
left join [PRIMARYSERVER].[CM_DATABASENAME].dbo.v_R_User usr on sys.User_Name0 = usr.User_Name0
inner join [PRIMARYSERVER].[CM_DATABASENAME].dbo.v_Collection col on dep.TargetCollectionID = col.CollectionID
left join Enforcement_Categories ec on dep.EnforcementState = ec.EnforcementState
left join Error_Descriptions ed on errdet.ErrorCode = ed.ErrorCode

where (col.Name like @CollectionName1 or col.Name like @CollectionName2) and
dep.Descript like @AppName
and (errdet.ErrorCode <> 0 or errdet.ErrorCode is NULL)
and dep.ResourceID not in (select dep.ResourceID from vAppDeploymentResultsPerClient dep
  inner join [PRIMARYSERVER].[CM_DATABASENAME].dbo.v_Collection col on dep.TargetCollectionID = col.CollectionID left join [PRIMARYSERVER].[CM_DATABASENAME].dbo.vAppDeploymentErrorAssetDetails errdet on (dep.PolicyModelID = errdet.PolicyModelID and dep.ResourceID = errdet.MachineID)
  where (col.Name like @CollectionName or col.Name like @CollectionName2) and dep.EnforcementState >= 5000 and dep.EnforcementState < 6000 and errdet.ErrorCode IS NULL)

-- Step #4 - Remove data from production table

 USE [INSERT DB NAME HERE]

 DECLARE @AppName varchar(max)
 SET @AppName = '[ApplicationName]'

 delete from AppDeployment where descript like @AppName

-- Step #5 - Insert new data into production table

 USE [INSERT DB NAME HERE]

 DECLARE @AppName varchar(max)
 SET @AppName = '[ApplicationName]'

 INSERT INTO appdeployment
 select * from appdeployment_temp
 where descript like @AppName

-- ------------------------------------------------------------------------------
