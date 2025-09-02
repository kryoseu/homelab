#!/bin/bash
# A script to back up the Immich library using Restic.
# It initializes the repository if it doesn't exist,
# backs up the specified source directory,
# and prunes old backups to keep the last 14 daily snapshots.
# I store it in and execute it from /usr/local/bin/restic-immich-library-backup.sh.
# Logs are appended to /var/log/restic-backup.log.
# Ensure that the Restic environment variables are set in /root/.restic-env.
# I currently only set RESTIC_REPOSITORY and RESTIC_PASSWORD in that file.
# Make sure to run this script with appropriate permissions.
# Set executable permission with: chmod +x scripts/immich-backup.sh
# Run this script as a cron job for regular backups.
# Example cron entry to run daily at midnight:
# 0 0 * * * /path/to/scripts/immich-backup.sh
# Adjust the BACKUP_SRC variable to point to your Immich library location.
# Ensure that the log file directory exists and is writable.
# Check Restic documentation for more options and configurations.
# This script assumes Restic is installed and configured properly.
# For more information, visit: https://restic.readthedocs.io/
# Ensure that the backup source directory exists and is accessible.
# Modify the retention policy in the forget command as needed.
# Test the script manually before scheduling it with cron.
set -euo pipefail

source /root/.restic-env

BACKUP_SRC="/tank/home-apps/encrypted/immich-library"

LOGFILE="/var/log/restic-backup.log"

{
  echo "========== $(date) =========="

  restic snapshots >/dev/null 2>&1 || restic init

  restic backup "$BACKUP_SRC"

  restic forget --keep-daily 14 --prune

  echo "Backup finished at $(date)"
  echo
} >>"$LOGFILE" 2>&1
