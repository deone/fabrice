#!/bin/bash

. $FABRICE_PATH/lib.sh

if [[ -z "$@" || -z "$2" || -z "$3" ]]; then
  echo "Usage: ./bulk/get_sims_numbers.sh ECG 8923301001002873270 8923301001002874260"
  exit
fi

echo "set feedback off
update gsm_sims_master
set switch_num_n = 1, sim_category_code_v = 'NORN', pre_post_sim_v = 'N'
where sim_num_v between '$2' 
and '$3';
commit;" | sqlplus -S $conn_string

sims=$results_root_dir/sims.txt
numbers=$results_root_dir/numbers.txt

echo "set pagesize 0
set feedback off
select sim_num_v from gsm_sims_master
where status_v = 'F' and
sim_num_v between '$2' and '$3';" | sqlplus -S $conn_string > $sims

echo "set pagesize 0
set feedback off
select mobile_number_v from gsm_mobile_master where category_code_v = 'APN01'
and status_v = 'F' and rownum < 101
order by 1 desc;" | sqlplus -S $conn_string > $numbers

today=`date "+%-d/%-m/%Y"`

# if [[ -s $sims || -s $numbers ]]; then
  # echo "Please check either SIMs or numbers"
  # exit
# else
if [[ "$1" == "ECG" ]]; then
  awk -v a="N,$1,.,1,1006637095,E,N,N," -v b=",NORN,M,APN01," -v c=",N,IAPNECG,N,,N,,E,1,p.o.box 8839 accra,p.o.box 8839 accra,p.o.box 8839 accra,p.o.box 8839 accra,AC,GHA,,0,0,4/6/2011,$today,31/12/2099,,31/12/2099,D,Y,Y,CCMD,ICT,ICTT,POSTPAID,GSM,4130,M,20/7/1981,GHANAIAN,1,1006637095,30/12/2099,,,,Y,N,N,D,N,$today,B,$1,1006637095,3021238662,3021238662,3021238662,Y,N,N,N,N,N,,N" 'NR==FNR{d[NR]=$1; next} {print a d[FNR] b $1 c}' $sims $numbers > temp.txt
fi

if [[ "$1" == "BXC" ]]; then
  awk -v a="N,$1,.,1,1006775194,E,N,N," -v b=",NORN,M,APN01," -v c=",N,BXC10MB,N,,N,,E,1,1,P . O. BOX 281 TRADE FAIR,P . O. BOX 281 TRADE FAIR,P . O. BOX 281 TRADE FAIR,AC,GHA,,0,0,23/6/2012,$today,31/12/2099,,31/12/2099,V,Y,Y,CCMD,ICT,ICT,POSTPAID,GSM,508,M,7/19/1981,,1,1006775194,30/12/2099,,,,Y,N,N,D,N,$today,B,$1,1006775194,,,,Y,N,N,N,N,N,,N" 'NR==FNR{d[NR]=$1; next} {print a d[FNR] b $1 c}' $sims $numbers > $temp_file
fi

file_header=$(create_file_header "BULACT4" $FABRICE_PATH/temp.txt)
file=$(serialize_file_name $results_root_dir/$1 $1)

echo $file_header > $file
cat $temp_file >> $file
# fi
