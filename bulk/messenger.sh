#!/bin/sh

# Automate all items in bulk record items in the checklist.

sql_file_name=`echo $@ | rev | cut -d '/' -f 1  | rev | cut -d '.' -f 1`

# Config
. ${FABRICE_PATH}bulk/config.sh

sqlplus -S $conn_string @${sql_dir}/${sql_file_name}.sql > $temp_file

# Make this into a function
rowcount=`wc -l $temp_file`
rowcount_number=`echo $rowcount | cut -d ' ' -f 1`
line="BULOFFI, $rowcount_number"

if [ "$sql_file_name" == "ported_in" ] || [ "$sql_file_name" == "concierge_registered" ] || [ "$sql_file_name" == "eocn" ]; then
  results="${results_root_dir}/checklists/${sql_file_name}_${date_string}.csv"
  echo $line > $results
  cat $temp_file >> $results
fi

# find ${results_dir} -name '*.csv' -mtime +1 -exec rm -f {} \;
