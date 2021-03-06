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

get_query_results ${sql_dir}/${sql_file_name}.sql $temp_file

file_header=$(create_file_header $key $temp_file)

if [ "$dir" != "checklists" ]; then
  file=$(serialize_file_name $results_root_dir/$dir $sql_file_name)
else
  file="$results_root_dir/$dir/${sql_file_name}_$date_string.csv"
fi

echo $file_header > $file
cat $temp_file >> $file
