#!/bin/sh
DATE=$(date +%Y-%m-%d-%H%M%S)
#BACKUP_DIR="/backups"
BACKUP_DIR="/run/media/b/Seagate Por"
#SOURCE="/etc/ /usr/local/bin /usr/local/sbin /boot/loader /home/b/Arduino /home/b/Documents /home/b/Downloads /home/b/Pictures /home/b/PycharmProjects /home/b/Vagrants /home/b/Videos"
SOURCE="/"
tar -cvzpf $BACKUP_DIR/backups/backup-$DATE-fullsystem.tar.gz $SOURCE
