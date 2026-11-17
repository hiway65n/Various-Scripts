# Source: TrueNas SCALE - Rebuild NetData Metrics
# Blog: https://hiway65nblog.blogspot.com/2024/05/truenas-scale-rebuild-netdata-metrics.html
# Published: May 20, 2024
# Labels: NetData, TrueNas, TrueNAS Scale
# Commands the post says were run after the Netdata SQLite files were corrupt. The status check earlier in the post is diagnostic, not part of this sequence.

mv /var/cache/netdata/netdata-meta.db /var/cache/netdata/netdata-meta.db.old
mv /var/cache/netdata/netdata-meta.db-shm /var/cache/netdata/netdata-meta.db-shm.old
mv /var/cache/netdata/netdata-meta.db-wal /var/cache/netdata/netdata-meta.db-shm.wal
systemctl start netdata
