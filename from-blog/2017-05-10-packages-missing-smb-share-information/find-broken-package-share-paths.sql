-- Source: Packages missing SMB share information
-- Blog: https://hiway65nblog.blogspot.com/2017/05/packages-missing-smb-share-information.html
-- Published: May 10, 2017
-- Labels: DP Share, SCCM, SCCM 2012, SQL, System Center Configuration Manager, System Center Configuration Manager 2012

-- Broken Packages
select cdpm.SiteCode, ContentID,ServerName,AccessType,URL,URLSubPath,URLProtocol,vpkg.Name from ContentDPMap as cdpm
join v_Package as vpkg on vpkg.PackageID = cdpm.ContentID
where cdpm.AccessType = 2 --UNCProtocol
and cdpm.URLSubPath = '\' --Packages with issues only have a '\'
and vpkg.PkgFlags = (vpkg.PkgFlags | 0x80) --Limit to only show packages with the 'Copy To Package Share' flag set
