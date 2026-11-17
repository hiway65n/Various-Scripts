-- Source: Specialized Application Reporting - Part 3
-- Blog: https://hiway65nblog.blogspot.com/2016/10/specialized-application-reporting-part-3.html
-- Published: October 27, 2016
-- Labels: Reporting, SCCM, SCCM 2012, SQL, System Center Configuration Manager, System Center Configuration Manager 2012
-- The Power BI file linked from the post is https://drive.google.com/file/d/0B9h_SjmY-dHbb2FLU3VkLVVNbVE/view?usp=sharing and is not included here. These are the queries the post says that report uses.

SELECT * FROM v_Deployments_AppDeployments WHERE Descript = 'ExampleApp'

SELECT DISTINCT
(CAST((SELECT COUNT(DISTINCT [PC Name]) FROM v_Deployments_AppDeployments WHERE [Error Status]='Success' and Descript = 'ExampleApp') as numeric(10,2)) / CAST((SELECT COUNT(DISTINCT [PC Name]) FROM v_Deployments_AppDeployments WHERE [Error Status]<>'Offline' and Descript = 'ExampleApp')AS numeric(10,2))) * 100 'Success Percentage excluding Offline'
FROM v_Deployments_AppDeployments

-- ----------------------------------------------------------------------------
