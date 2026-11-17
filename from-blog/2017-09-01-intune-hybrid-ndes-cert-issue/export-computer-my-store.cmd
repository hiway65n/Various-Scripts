:: Source: Intune Hybrid - NDES Cert Issue
:: Blog: https://hiway65nblog.blogspot.com/2017/09/intune-hybrid-ndes-cert-issue.html
:: Published: September 1, 2017
:: Labels: CRP, Intune, NDES, SCCM, SCCM 2012, SCCM Current Branch, System Center Configuration Manager, System Center Configuration Manager 2012
:: The post is a troubleshooting write-up. This is the only command it gives, used to find an archived NDES client-auth certificate.

Certutil -v -store MY >> %computername%_MY.txt
