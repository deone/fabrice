#!/bin/sh

sql_file_name=`echo $@ | rev | cut -d '/' -f 1  | rev | cut -d '.' -f 1`

. ${FABRICE_PATH}cs5/config.sh


results="${results_dir}/Bulk_${sql_file_name}_${date_string}.csv"

sqlplus -S $conn_string @${sql_dir}/${sql_file_name}.sql > $results
