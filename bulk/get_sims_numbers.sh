#!/bin/sh

export FABRICE_PATH="/Users/deone/.virtualenvs/fabrice/fabrice"

. ${FABRICE_PATH}/bulk/config.sh

if [[ -z "$@" || -z "$2" || -z "$3" ]]; then
  echo "Usage: ./bulk/get_sims_numbers.sh 8923301001002873270 8923301001002874260 ECGAUG05.csv"
  exit
fi

echo "set feedback off
set verify off
update gsm_sims_master
set switch_num_n = 1, sim_category_code_v = 'NORN', pre_post_sim_v = 'N'
where sim_num_v between '$1' 
and '$2';" | sqlplus -S $conn_string

echo "commit;" | sqlplus -S $conn_string

echo "set pagesize 0
set feedback off
select sim_num_v from gsm_sims_master
where status_v = 'F' and
sim_num_v between '$1' and '$2';" | sqlplus -S $conn_string > $results_root_dir/sims.txt

echo "set pagesize 0
set feedback off
select mobile_number_v from gsm_mobile_master where category_code_v = 'APN01'
and status_v = 'F' and rownum < 101
order by 1 desc;" | sqlplus -S $conn_string > $results_root_dir/numbers.txt

awk -v a="N,ECG,.,1,1006637095,E,N,N," -v b=",NORN,M,APN01," -v c=",N,IAPNECG,N,,N,,E,1,p.o.box 8839 accra,p.o.box 8839 accra,p.o.box 8839 accra,p.o.box 8839 accra,AC,GHA,,0,0,4/6/2011,27/8/2014,31/12/2099,,31/12/2099,D,Y,Y,CCMD,ICT,ICTT,POSTPAID,GSM,4130,M,20/7/1981,GHANAIAN,1,1006637095,30/12/2099,,,,Y,N,N,D,N,27/8/2014,B,ECG,1006637095,3021238662,3021238662,3021238662,Y,N,N,N,N,N,,N" 'NR==FNR{d[NR]=$1; next} {print a d[FNR] b $1 c}' $results_root_dir/sims.txt $results_root_dir/numbers.txt > temp.txt

echo "BULACT4,100" > $3

grep -v 'Commit' temp.txt >> $3
