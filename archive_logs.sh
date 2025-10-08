#!/bin/bash

# Base Directories
BASE_DIR="hospital_data"
ACTIVE_DIR="$BASE_DIR/active_logs"
ARCHIVE_DIR="$BASE_DIR/archived_logs"

#Menu
echo "choose a running log file to archive:"
echo "1) Heart Rate"
echo "2) Temperature"
echo "3) Water usage"
read -p "Enter choice (1-3): " choice

#Timestamp
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

case $choice in
1)
logfile="heart_rate_log.log"
archivefolder="heart_data_archive"
;;
2)
logfile="temperature_log.log"
archivefolder="temperature_data_archive"
;;
3)
logfile="water_usage_log.log"
archivefolder="water_usage_data_archive"
;;
*)
echo "❌ Invalid choice: Please select 1, 2, or 3."
exit 1
;;
esac

#Path
src="$ACTIVE_DIR/$logfile"
dest="$ARCHIVE_DIR/$archivefolder/${logfile%.log}_$timestamp.log"

#Check if file exists
if [[ ! -f $src ]]; then
	echo "❌ Log file $src does not exist!"
	exit 1
fi

# Create archive folder if it doesn't exist
mkdir -p "$ARCHIVE_DIR/$archivefolder"

#Move and create new log (only touch new log if move succeeds)
if mv "$src" "$dest"; then
	touch "$src"
	echo "✅ Archived $logfile to $dest"
else
	echo "❌ Failed to archive $logfile to $dest" >&2
	exit 1
fi
