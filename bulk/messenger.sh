#!/bin/sh

sql_file_name=`echo $@ | rev | cut -d '/' -f 1  | rev | cut -d '.' -f 1`
action=`echo $sql_file_name | rev | cut -d '_' -f 1 | rev`
dir=`echo $sql_file_name | cut -d '_' -f 1`

if [ "$action" == "addition" ]; then
  key="BULOFFI"
else
  key="BULOFFC"
fi

export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice"

# Config
. ${FABRICE_PATH}/bulk/config.sh

sqlplus -S $conn_string @${sql_dir}/${sql_file_name}.sql > $temp_file

# Make this into a function
rowcount=`wc -l $temp_file`
rowcount_number=`echo $rowcount | cut -d ' ' -f 1`
line="$key,$rowcount_number"

results="${results_root_dir}/$dir/${sql_file_name}_${date_string}.csv"

echo $line > $results
cat $temp_file >> $results

# find ${results_dir} -name '*.csv' -mtime +1 -exec rm -f {} \;
