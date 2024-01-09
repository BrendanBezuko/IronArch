#!/bin/bash

cat <<- EOF > /etc/systemd/system/backup.timer
[Unit]
Description=Backup Timer

[Timer]
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat <<- EOF > /etc/systemd/system/backup.service
[Unit]
Description=Backup Service

[Service]
Type=simple
ExecStart=/usr/local/bin/bk.sh
EOF

echo '#!/bin/sh
DATE=$(date +%Y-%m-%d-%H%M%S)
BACKUP_DIR="/backups"
SOURCE="/home/ /etc/ /usr/local/bin /usr/local/sbin /boot/loader"
tar -cvzpf $BACKUP_DIR/backup-$DATE.tar.gz $SOURCE' > /usr/local/sbin/bk.sh

chmod 0770 /usr/local/sbin/bk.sh
mkdir /backups

systemctl daemon-reload
systemctl enable backup.timer
systemctl start backup.timer
systemctl status backup.timer
