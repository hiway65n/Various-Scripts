-- Source: Specialized Application Reporting - Part 1
-- Blog: https://hiway65nblog.blogspot.com/2016/10/specialized-application-reporting-part-1.html
-- Published: October 27, 2016
-- Labels: Reporting, SCCM, SCCM 2012, SQL, System Center Configuration Manager, System Center Configuration Manager 2012

CREATE TABLE [dbo].[AppDeployment](
 [PC Name] [nvarchar](256) NULL,
 [Deployment] [nvarchar](255) NOT NULL,
 [Error_Code] [bigint] NULL,
 [Descript] [nvarchar](513) NULL,
 [Error Status] [varchar](20) NULL,
 [Error Description] [varchar](max) NULL,
 [User Name] [nvarchar](256) NULL,
 [User ID] [nvarchar](256) NULL,
 [Email Address] [nvarchar](256) NULL
)

-- Create AppDeployment_Temp Table
CREATE TABLE [dbo].[AppDeployment_temp](
 [PC Name] [nvarchar](256) NULL,
 [Deployment] [nvarchar](255) NOT NULL,
 [Error_Code] [bigint] NULL,
 [Descript] [nvarchar](513) NULL,
 [Error Status] [varchar](20) NULL,
 [Error Description] [varchar](max) NULL,
 [User Name] [nvarchar](256) NULL,
 [User ID] [nvarchar](256) NULL,
 [Email Address] [nvarchar](256) NULL
)

CREATE VIEW [dbo].[v_Deployments_AppDeployments] AS (
select
[PC Name],
[Deployment],
[Error_Code] 'Error Code',
[Descript],
[Error Status],
[Error Description],
[User Name],
[User ID],
[Email Address]
from AppDeployment
)

CREATE TABLE [dbo].[vAppDeploymentResultsPerClient](
 [CI_ID] [int] NULL,
 [ParentID] [int] NULL,
 [TargetCollectionID] [nvarchar](8) NULL,
 [AssignmentID] [int] NOT NULL,
 [PolicyModelID] [int] NOT NULL,
 [ResourceID] [int] NULL,
 [UserResource] [int] NOT NULL,
 [Descript] [nvarchar](513) NULL,
 [StartTime] [datetime] NULL,
 [LastModificationTime] [datetime] NULL,
 [ComplianceState] [tinyint] NULL,
 [EnforcementState] [smallint] NULL,
 [OfferTypeID] [int] NULL,
 [Revision] [int] NULL
)

CREATE TABLE [dbo].[Enforcement_Categories](
 [EnforcementState] [smallint] NULL,
 [EnforcementCategory] [varchar](max) NULL
)

CREATE TABLE [dbo].[Error_Descriptions](
 [ErrorCode] [bigint] NULL,
 [ErrorStatus] [varchar](max) NULL
)

-- ----------------------------------------------------------------------------------
