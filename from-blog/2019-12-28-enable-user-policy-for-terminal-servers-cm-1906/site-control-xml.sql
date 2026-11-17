-- Source: Enable User Policy for Terminal Servers CM 1906
-- Blog: https://hiway65nblog.blogspot.com/2019/12/enable-user-policy-for-terminal-servers.html
-- Published: December 28, 2019
-- Labels: sccm cm memcm 1906 terminal services user policy
-- The rest of the post is a wbemtest procedure for Request User Policy On TS, not a script.

SELECT SiteControl FROM vSMS_SC_SiteControlXML WHERE SiteCode = 'SiteCode'
