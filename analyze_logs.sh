#!/bin/bash

# creating variables for directory path
active_dir_path="hospital_data/active_logs"
destination="hospital_data/reports/analysis_report.txt"

# make sure report directory exists
mkdir -p "$destination"

# loading animation
echo -e "	*************************"
echo -ne "	loading logs."
for i in {1..4}; do
  echo -n "."
  sleep 0.5
done

sleep 0.5
echo -ne "\r                                            \r"


echo -e "\n	 Select log file to analyze:"
echo -e "       1. Heart Rate (heart_rate.log)"
echo -e "       2. Temperature (temperature.log)"
echo -e "       3. Water Usage (water_usage.log)"
echo -e "       *************************"
read -p "	Please Enter choice (1-3): " choice

# Handle choice
case "$choice" in
  1)
    echo -n "	Analysing heart_rate.log"
    for i in {1..5}; do echo -n "."; sleep 0.5; done
    sleep 0.2
    echo -ne "\r                                         \r"
    file_path="$active_dir_path/heart_rate_log.log"
    ;;
  2)
    echo -n "	Analysing temperature_log.log"
    for i in {1..5}; do echo -n "."; sleep 0.5; done
    sleep 0.2
    echo -ne "\r                                         \r"
    file_path="$active_dir_path/temperature_log.log"
    ;;
  3)
    echo -n "	Analysing water_usage.log"
    for i in {1..5}; do echo -n "."; sleep 0.5; done
    sleep 0.2
    echo -ne "\r                                         \r"
    file_path="$active_dir_path/water_usage_log.log"
    ;;
  *)
    echo -n "	Processing selection"
    for i in {1..5}; do echo -n "."; sleep 0.5; done
    sleep 0.2
    echo -ne "\r                                         \r"
    echo "<<<<<<<<< ERROR >>>>>>>>>>>"
    echo -e "Please select from options given (1-3)"
    exit 
    ;;
esac

# Checking if file exists
if [ ! -f "$file_path" ]; then
  echo -e "<<<<<<<<<<< ERROR! >>>>>>>>>>>>\nFile does not exist, please check your file path.\n"
 
  exit 
fi

# Ensuring destination file exists if not it will be created
if [ ! -f "$destination" ]; then
  echo -e "	Destination file not found. Creating it now..."
  mkdir -p "$(dirname "$destination")"
  touch "$destination"
fi


# Counting devices and collecting their timestamps
device_counts=$(awk '{print $3}' "$file_path" | sort | uniq -c | awk '{print $2": "$1}')
first_times=$(head -n 1 "$file_path" | awk '{print $1}')
last_times=$(tail -n 1 "$file_path" | awk '{print $1}')

# Appending analysis report
{
  echo -ne "	Log Analysis Report"
  echo -ne "	Date: $(date)"
  echo -e "\n	Analyzed File: $file_path"
  echo
  echo "	Device Counts:"
  echo "	$device_counts"
  echo
  echo "	First Entry Timestamp: $first_times"
  echo "	Last Entry Timestamp : $last_times"
} >> "$destination"

echo -e "	Analysis complete! Results appended to $destination\n"
