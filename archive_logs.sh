#!/bin/bash

#Create a menu for heart rate, temperature and water usage.

echo "Select the log to archive: "
menu=( "Heart rate" "Temperature" "Water Usage" )
PS3="Enter choice (1-3): "

 archi_dir=~/Coding-lab_Group-epsilon/hospital_data/archived_logs
 active_dir=~/Coding-lab_Group-epsilon/hospital_data/active_logs



 select menu in "${menu[@]}"; do 
  case $REPLY in 
   1)
       file_log="heart_rate.log"
       arch_dir="$archi_dir/heart_data_archive"
       break
       ;;
   
   2)
      file_log="temperature.log"
      arch_dir="$archi_dir/temperature_data_archive"
      break
      ;;

   3) 
      file_log="water_usage.log"
      arch_dir="$archi_dir/water_usage_data_archive"
      break
      ;;
   4) 
      echo " Invalid input"
      exit 0
      ;;

   *)
      echo " Please enter a valid number"
      ;;

  esac
 
 done

#First find if file log exists.
  log_path="$active_dir/$file_log"

  if ! test -f $log_path ; then
    echo " The log file $log_path doesn't exist "

  fi 

# See if directory archive exists and has no issue.

   if ! test -d $arch_dir ; then
    echo " Archive directory doesn't exist "
    fi

# then change find the time and change the file name eg; heart_rate_+%Y-%m-%d_%H-%M-%S.log
  timestamp=$(date '+%Y-%m-%d_%H:%M:%S')
  log_name="${file_log%.log}_$timestamp.log"

 #Move the active log file from active directory to archive directory.
 
 
  mv "$log_path" "$arch_dir/$log_name"
  echo -e "\n Archiving $file_log...." 
  echo -e "Successfully archived to $arch_dir/$log_name.\n" 
 
  touch "$log_path" # Empty log file for continous monitoring
  
  
