#!/bin/sh

###################################################
# Send portions of log file based on specified hour
###################################################

# Get $today_log / file that matches date.
# Read $last_run_hour from file.
# Compute $new_run_hour as "$last_run_hour + 2" except $last_run_hour is 23 in which case it $new_run_hour should be 1
# grep $today_log with "grep '00:$new_run_hour' $today_log" > $new_run_hour.txt
# Write $new_run_hour to file.
# Mail $new_run_hour.txt

if [[ "$OSTYPE" == "darwin13" ]]; then
  export FABRICE_DEBUG="true"
  export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  export FABRICE_DEBUG="false"
  export FABRICE_PATH="/home/pm_client/fabrice"
fi

if [[ "$FABRICE_DEBUG" == "true" ]]; then
  logs_directory="$FABRICE_PATH/log_processing/logs_dir"
  recipients="adetimilehin.hammed@tecnotree.com;solomon.annan@tecnotree.com"
else
  logs_directory="/data5/log/FTP/NRTRDEOUT"
  recipients="kessien@mtn.com.gh;rjmalm@mtn.com.gh;vasare@mtn.com.gh;soakoto@mtn.com.gh;sathisha.hegde@tecnotree.com;adetimilehin.hammed@tecnotree.com;solomon.annan@tecnotree.com"
fi

today_log=`ls -Art $logs_directory | tail -n 1`
hour_file="$FABRICE_PATH/log_processing/hour_file.txt"
last_run_hour=`cat $hour_file`

if [[ $last_run_hour == 23 ]]; then
  let new_run_hour=1
else
  let new_run_hour=$last_run_hour+2
fi

if [[ ${#new_run_hour} == 1 ]]; then
  string="0$new_run_hour:00"
else
  string="$new_run_hour:00"
fi

log_file_name=`echo $today_log | cut -d '.' -f 1`
out_file=$FABRICE_PATH/log_processing/out/${log_file_name}_${string}.txt

grep $string $logs_directory/$today_log | grep 'successfully transferred' > $out_file
wc -l $out_file >> $out_file

echo $new_run_hour > $hour_file

email=$FABRICE_PATH/log_processing/email.txt

mutt -s "NRTRDEOUT FTP Logs" -c osikoya.oladayo@tecnotree.com -a $out_file -- $recipients < $email
