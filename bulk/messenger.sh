#!/bin/bash

. $FABRICE_PATH/lib.sh

sql_file_name=`echo $@ | rev | cut -d '/' -f 1  | rev | cut -d '.' -f 1`
action=`echo $sql_file_name | rev | cut -d '_' -f 1 | rev`
dir=`echo $sql_file_name | cut -d '_' -f 1`

if [ "$action" == "addition" ]; then
  key="BULOFFI"
else
  key="BULOFFC"
fi

sqlplus -S $conn_string @${sql_dir}/${sql_file_name}.sql > $temp_file

file_header=$(create_file_header $key $temp_file)
file=$(serialize_file_name $results_root_dir/$dir $sql_file_name)

echo $file_header > $file
cat $temp_file >> $file
