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

. ~/.bash_profile

if [[ "$OSTYPE" == "darwin13" ]]; then
  logs_directory="$FABRICE_PATH/log_processing/logs_dir"
  recipients="adetimilehin.hammed@tecnotree.com;solomon.annan@tecnotree.com"
  date=`date -v -0d +"%Y%m%d"`
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  logs_directory="/data5/log/FTP/NRTRDEOUT"
  recipients="kessien@mtn.com.gh;rjmalm@mtn.com.gh;vasare@mtn.com.gh;soakoto@mtn.com.gh;sathisha.hegde@tecnotree.com;adetimilehin.hammed@tecnotree.com;solomon.annan@tecnotree.com;sajantuah@mtn.com.gh;EODwamena@mtn.com.gh"
  date=`date +"%Y%m%d" -d today`
fi

today_log=FTP_NRTRDEOUT_${date}.log
hour_file=$FABRICE_PATH/log_processing/hour_file.txt
last_run_hour=`cat $hour_file`

if [[ $last_run_hour == 23 ]]; then
  let new_run_hour=1
else
  let new_run_hour=$last_run_hour+2
fi

if [[ ${#new_run_hour} == 1 ]]; then
  string="0$new_run_hour:"
else
  string="$new_run_hour:"
fi

log_file_name=`echo $today_log | cut -d '.' -f 1`
out_file=$FABRICE_PATH/log_processing/out/${log_file_name}_${string}00.txt

grep " "$string $logs_directory/$today_log | grep 'successfully transferred' > $out_file
wc -l $out_file | awk '{print $1}' >> $out_file

echo $new_run_hour > $hour_file

email=$FABRICE_PATH/log_processing/email.txt

mutt -s "NRTRDEOUT FTP Logs" -c osikoya.oladayo@tecnotree.com -a $out_file -- $recipients < $email
