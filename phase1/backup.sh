#!/bin/bash

# This is a Bacup script
# Usage: ./backup.sh <source dir> <backup_name>

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

