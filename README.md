# Various Scripts

Scripts and queries pulled from the [Technology Log](https://hiway65nblog.blogspot.com/) blog.
Each folder under `from-blog` is one post. `SOURCE.md` and the header of each file record the post title, link, and original publish date.

| Published | Post | Files |
| --- | --- | --- |
| February 5, 2016 | [Mimicking SCCM App Catalog via Powershell](https://hiway65nblog.blogspot.com/2016/02/mimicking-sccm-app-catalog-via.html) | `01-web-service-proxy.ps1`<br>`02-get-application-details.ps1`<br>`03-get-device-id.ps1`<br>`04-install-application-webservice.ps1`<br>`05-refresh-client-policy.ps1`<br>`06-wait-for-policy.ps1`<br>`07-trigger-install.ps1`<br>`08-check-applicability.ps1`<br>`09-check-installed.ps1`<br>`10-reboot-pending.ps1`<br>`11-log-client-context.ps1` |
| February 5, 2016 | [PS Script to convert a PS1 into a HTA that creates and executes a PS1](https://hiway65nblog.blogspot.com/2016/02/ps-script-to-convert-ps1-into-hta-that.html) | `ps1-to-hta.ps1` |
| February 5, 2016 | [Updating SCCM Application OS Requirement Rules](https://hiway65nblog.blogspot.com/2016/02/updating-sccm-application-os.html) | `update-os-requirement-rules.ps1` |
| February 16, 2016 | [Reset Inventory on SCCM client if over 7 days since report](https://hiway65nblog.blogspot.com/2016/02/reset-inventory-on-sccm-client-if-over.html) | `reset-stale-inventory.ps1` |
| March 17, 2016 | [Add Computers to AD Group](https://hiway65nblog.blogspot.com/2016/03/add-computers-to-ad-group.html) | `add-computers-to-ad-group.ps1` |
| March 17, 2016 | [Add Machine to a Collection](https://hiway65nblog.blogspot.com/2016/03/add-machine-to-collection.html) | `add-machines-to-collection.ps1` |
| March 17, 2016 | [Create Prestaged Content and Extract Content](https://hiway65nblog.blogspot.com/2016/03/create-prestaged-content-and-extract.html) | `extract-content.ps1`<br>`create-prestaged-content.ps1` |
| March 17, 2016 | [Create RDL files in mass](https://hiway65nblog.blogspot.com/2016/03/create-rdl-files-in-mass.html) | `download-ssrs-rdl.ps1` |
| March 17, 2016 | [Redistribute Specific Package on Specific DP](https://hiway65nblog.blogspot.com/2016/03/redistribute-specific-package-on.html) | `redistribute-package-on-dp.ps1` |
| March 17, 2016 | [Stuck @ "Waiting for user logon"](https://hiway65nblog.blogspot.com/2016/03/stuck-waiting-for-user-logon.html) | `clear-stuck-ci-tasks.ps1` |
| April 14, 2016 | [Prestaging/Extracting Content](https://hiway65nblog.blogspot.com/2016/04/prestagingextracting-content.html) | `prestage-all-content.ps1`<br>`extract-all-content.ps1` |
| August 25, 2016 | [Starting/Stopping a thread of the SCCM executive](https://hiway65nblog.blogspot.com/2016/08/startingstopping-sccm-executive-thread.html) | `sccm-executive-thread.ps1` |
| September 12, 2016 | [CI guts for App Catalog check](https://hiway65nblog.blogspot.com/2016/09/ci-guts-for-app-catalog-check.html) | `app-catalog-wsdl-detection.ps1`<br>`app-catalog-wsdl-remediation.ps1` |
| September 15, 2016 | [Powershell to submit unidentified software in SCCM Asset Intelligence](https://hiway65nblog.blogspot.com/2016/09/powershell-to-submit-unidentified.html) | `submit-unidentified-ai-software.ps1` |
| September 28, 2016 | [Computer Monitor Inventory Data Query](https://hiway65nblog.blogspot.com/2016/09/computer-monitor-inventory-data-query.html) | `monitor-inventory-by-ad-site.sql` |
| October 27, 2016 | [Specialized Application Reporting - Part 1](https://hiway65nblog.blogspot.com/2016/10/specialized-application-reporting-part-1.html) | `create-reporting-tables.sql`<br>`enforcement-categories.txt`<br>`error-descriptions.txt` |
| October 27, 2016 | [Specialized Application Reporting - Part 2](https://hiway65nblog.blogspot.com/2016/10/specialized-application-reporting-part-2.html) | `load-app-deployment-reporting.sql` |
| October 27, 2016 | [Specialized Application Reporting - Part 3](https://hiway65nblog.blogspot.com/2016/10/specialized-application-reporting-part-3.html) | `deployment-report-queries.sql` |
| October 27, 2016 | [Using Powershell to Assign iOS devices to DEP profile](https://hiway65nblog.blogspot.com/2016/10/using-powershell-to-assign-ios-devices.html) | `assign-ios-devices-to-dep-profile.ps1` |
| December 27, 2016 | [Triggering a software update install via Powershell](https://hiway65nblog.blogspot.com/2016/12/triggering-software-update-install-via.html) | `trigger-software-updates.ps1` |
| February 23, 2017 | [Using an Outlook Object to send email](https://hiway65nblog.blogspot.com/2017/02/using-outlook-object-to-send-email.html) | `send-outlook-mail.ps1` |
| May 10, 2017 | [Packages missing SMB share information](https://hiway65nblog.blogspot.com/2017/05/packages-missing-smb-share-information.html) | `find-broken-package-share-paths.sql`<br>`repair-package-share-paths.sql` |
| May 15, 2017 | [Trigger Manual DEP Sync With Powershell](https://hiway65nblog.blogspot.com/2017/05/trigger-manual-dep-sync-with-powershell.html) | `trigger-dep-full-sync.ps1`<br>`verify-account-action-results.sql` |
| September 1, 2017 | [Intune Hybrid - NDES Cert Issue](https://hiway65nblog.blogspot.com/2017/09/intune-hybrid-ndes-cert-issue.html) | `export-computer-my-store.cmd` |
| January 9, 2018 | [Additional Information using COM object to send email from Powershell](https://hiway65nblog.blogspot.com/2018/01/additional-information-using-com-object.html) | `send-email-on-behalf.ps1` |
| February 28, 2018 | [Hard to reach Registry Hive](https://hiway65nblog.blogspot.com/2018/02/hard-to-reach-registry-hive.html) | `map-hkcr.ps1` |
| July 25, 2018 | [Machine collection based on user AD group](https://hiway65nblog.blogspot.com/2018/07/machine-collection-based-on-user-ad.html) | `machine-collection-from-user-ad-group.wql` |
| January 30, 2019 | [Citrix App Layer VDI causing Multiple GUIDs in SCCM](https://hiway65nblog.blogspot.com/2019/01/citrix-app-layer-vdi-causing-multiple.html) | `citrix-profile-guid-cleanup.txt` |
| February 1, 2019 | [DP Content Location Request Powershell](https://hiway65nblog.blogspot.com/2019/02/dp-content-location-request-powershell.html) | `dp-content-location-request.ps1` |
| February 1, 2019 | [Move and Resize BranchCache Hash/Data Cache on Distribution Point](https://hiway65nblog.blogspot.com/2019/02/move-and-resize-branchcache-hashdata.html) | `move-branchcache.ps1` |
| February 1, 2019 | [Powershell to enable "Download from Neighbor Boundary" on SCCM Applications](https://hiway65nblog.blogspot.com/2019/02/powershell-to-enable-download-from.html) | `enable-download-from-neighbor.ps1` |
| December 28, 2019 | [Enable User Policy for Terminal Servers CM 1906](https://hiway65nblog.blogspot.com/2019/12/enable-user-policy-for-terminal-servers.html) | `site-control-xml.sql` |
| March 7, 2022 | [Outlook "Work Offline" Mode](https://hiway65nblog.blogspot.com/2022/03/outlook-work-offline-mode.html) | `outlook-online-offline.ps1` |
| May 20, 2024 | [TrueNas SCALE - Rebuild NetData Metrics](https://hiway65nblog.blogspot.com/2024/05/truenas-scale-rebuild-netdata-metrics.html) | `rebuild-netdata-metrics.sh` |

## Posts with no script

These posts were read and do not contain a script or query to extract.

- November 5, 2026: [The journey to make PetChatz device work again](https://hiway65nblog.blogspot.com/2026/11/the-journey-to-make-petchatz-device.html). Write-up pointing at the petchatzOpenServer repo. No script in the post.
- May 7, 2025: [I Wrote a Book!](https://hiway65nblog.blogspot.com/2025/05/i-wrote-book.html). Book announcement. No script.
- December 17, 2023: [ChurchApps - Open Source Software](https://hiway65nblog.blogspot.com/2023/12/churchapps-open-source-software.html). Link to churchapps.org. No script.
- May 2, 2023: [Other Dabblings](https://hiway65nblog.blogspot.com/2023/05/other-dabblings.html). Pointer to the other blog. No script.
- December 26, 2021: [NFT](https://hiway65nblog.blogspot.com/2021/12/nft.html). Link to an OpenSea collection. No script.
- November 15, 2021: [Pfsense Multi-Lan Simple](https://hiway65nblog.blogspot.com/2021/11/pfsense-multi-lan-simple.html). Lab note that the simplest pfSense path was any-to-any rules on LAN1 and OPTx. No config script.
- April 13, 2021: [MEMCM Console Extension Node GUID](https://hiway65nblog.blogspot.com/2021/04/memcm-console-extension-node-guid.html). Link to another blog for console-node GUIDs. No script.
- December 6, 2016: [Some reports break in SSRS after SQL 2012 to 2014 upgrade](https://hiway65nblog.blogspot.com/2016/12/some-reports-break-in-ssrs-after-sql.html). Link to a write-up about rssrvpolicy.config after a SQL upgrade. No script.
- September 14, 2016: [Using Powershell for automating Software Updates](https://hiway65nblog.blogspot.com/2016/09/using-powershell-for-automating.html). Link to another blog about automating software-update deployments. No script.
