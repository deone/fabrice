#!/bin/sh

# Automate all items in bulk record items in the checklist.

sql_file_name=`echo $@ | rev | cut -d '/' -f 1  | rev | cut -d '.' -f 1`

# Config
. ${FABRICE_PATH}bulk/config.sh

if [[ "$sql_file_name" == "ported_in" ]]; then
  results="${results_root_dir}/checklists/${sql_file_name}_${date_string}.csv"
fi

# find ${results_dir} -name '*.csv' -mtime +1 -exec rm -f {} \;

sqlplus -S $conn_string @${sql_dir}/${sql_file_name}.sql > $results
