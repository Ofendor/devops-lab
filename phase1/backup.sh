#!/bin/bash

#############################################
# Creating an automated Backup Script
# # Date: 2026-05
#
# Purpose:
#   We will create a compressed backup of directories
#   with timestamped filenames and input validation.
#
# Usage:
#   via './backup.sh <source_directory> <backup_name>'
#
# Example:
#   ./backup.sh /home/[user]/devops-lab my-lab-backup
#
# Skills that we validate through this exercises:
#   - Shell scripting with error handling (set -e)
#   - Input validation ($# argument checking)
#   - File operations (tar compression)
#   - Variable manipulation and timestamps
#############################################

set -e #exit on error
SOURCE_DIR="$1"
BACKUP_NAME="$2"
BACKUP_DIR="/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# This validates inputs
if [ $# -ne 2 ]; then
   echo "Usage: $0 <source_dir> <backup_name>"
   exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
   echo "Error: $SOURCE_DIR does not exist"
   exit 1
fi

# Creates backup directory
sudo mkdir -p "$BACKUP_DIR"
sudo chown ${USER}:${USER}  "$BACKUP_DIR"

# Creates the backup
BACKUP_FILE="${BACKUP_DIR}/${BACKUP_NAME}_${TIMESTAMP}.tar.gz"
echo "Creating backup: $BACKUP_FILE"
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

# Verification
echo "Backup size: $(du -h $BACKUP_FILE | cut -f1)"
echo "Backup complete!"

