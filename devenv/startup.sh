#!/bin/bash
echo "root:${PASSWORD}" | chpasswd
service ssh restart
cron
cd /sites
# Start redock service in background
/usr/local/bin/redock-service.sh &
# Keep SSH running in foreground
/usr/sbin/sshd -D
bash && dockerd