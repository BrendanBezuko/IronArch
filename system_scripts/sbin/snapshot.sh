#!/bin/bash

###############################################
# Pacman LVM Snapshot Hook script
# Description: Create an LVM snapshot before updating packages.
###############################################

# Define the LVM volume and snapshot name
LV_NAME="archy-root"
SNAPSHOT_NAME="update_snapshot"

# Create an LVM snapshot
lvcreate --size 1G --snapshot --name "$SNAPSHOT_NAME" "/dev/mapper/$LV_NAME"


