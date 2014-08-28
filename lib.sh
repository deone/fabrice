
date_string=`date +'%d%m%Y'`
conn_string="tt_mso/ttmso1@TTPROD"

sql_dir="${FABRICE_PATH}/bulk/sql"
results_root_dir="/Users/deone/bulk_files"

temp_file="temp.txt"

create_file_header() {
  upload_key=$1
  file=$2

  wc=`wc -l $file`
  count=`echo $wc | cut -d ' ' -f 1`

  echo "$upload_key,$count"
}

serialize_file_name()  {
  directory=$1
  prefix=$2

  wildcard="$directory/${prefix}_${date_string}_"

  today_file_count=$(ls $wildcard* | wc -l)
  serial_no=$(( $today_file_count+1 ))

  echo "${wildcard}${serial_no}.csv"
}
