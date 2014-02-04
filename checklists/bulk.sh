#!/bin/sh

# Automate all items in bulk record items in the checklist.

sql_file_name=`echo $@ | rev | cut -d '/' -f 1  | rev | cut -d '.' -f 1`

# Config
. ${FABRICE_PATH}checklists/checklists.cfg.sh

results_dir="/Users/deone/Documents/Work/bulk_files"
results="${results_dir}/Bulk_${sql_file_name}_${date_string}.csv"

yesterday=`date -v -1d +"%d"`

find ${results_dir} -name '*.csv' -mtime +1 -exec rm -f {} \;

sqlplus -S $conn_string @${sql_dir}/${sql_file_name}.sql > $results
