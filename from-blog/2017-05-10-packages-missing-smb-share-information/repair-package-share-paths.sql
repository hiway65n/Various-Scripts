-- Source: Packages missing SMB share information
-- Blog: https://hiway65nblog.blogspot.com/2017/05/packages-missing-smb-share-information.html
-- Published: May 10, 2017
-- Labels: DP Share, SCCM, SCCM 2012, SQL, System Center Configuration Manager, System Center Configuration Manager 2012
-- The post marks this UPDATE as something to hand to Microsoft support rather than run in production.

DECLARE @DriveLetter CHAR
SET @DriveLetter = 'I'
UPDATE CDPM
SET URL = N'\\'+ServerName+'\SMSPKG' + @DriveLetter + '$\' + ContentID + N'\', URLSubPath = N'\SMSPKG' + @DriveLetter + '$\' + ContentID + N'\'
FROM ContentDPMap CDPM
JOIN v_Package VPKG ON VPKG.PackageID = CDPM.ContentID
WHERE cdpm.AccessType = 2 --UNCProtocol
AND CDPM.URLSubPath = '\' --Packages with issues only have a '\'
AND vpkg.PkgFlags = (VPKG.PkgFlags | 0x80) --Limit to only show packages with the 'Copy To Package Share' flag set

and cdpm.ContentID NOT IN ('insert bad package paths') -- Excluded 'bad' package paths or you can modify this to only target a specific package.
