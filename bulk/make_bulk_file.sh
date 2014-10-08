#!/bin/bash

. $FABRICE_PATH/lib.sh

if [[ -z "$@" || -z "$1" ]]; then
  # "Usage: ./bulk/get_sims_numbers.sh last_name package_name contract_no"
  echo "Usage: ./bulk/get_sims_numbers.sh ECG ECG60 1006637095"
  exit
fi

sims=$results_root_dir/sims.txt
numbers=$results_root_dir/numbers.txt

today=`date "+%-d/%-m/%Y"`

# if [[ "$1" == "ECG" ]]; then
  # awk -v a="N,$1,.,1,1006637095,E,N,N," -v b=",NORN,M,APN01," -v c=",N,ECG60,N,,N,,E,1,p.o.box 8839 accra,p.o.box 8839 accra,p.o.box 8839 accra,p.o.box 8839 accra,AC,GHA,,0,0,4/6/2011,$today,31/12/2099,,31/12/2099,D,Y,Y,CCMD,ICT,ICTT,POSTPAID,GSM,4130,M,20/7/1981,GHANAIAN,1,1006637095,30/12/2099,,,,Y,N,N,D,N,$today,B,$1,1006637095,3021238662,3021238662,3021238662,Y,N,N,N,N,N,,N" 'NR==FNR{d[NR]=$1; next} {print a d[FNR] b $1 c}' $sims $numbers > temp.txt
# fi

# if [[ "$1" == "BXC" ]]; then
  # awk -v a="N,$1,.,1,1006775194,E,N,N," -v b=",NORN,M,APN01," -v c=",N,BXC10MB,N,,N,,E,1,1,P . O. BOX 281 TRADE FAIR,P . O. BOX 281 TRADE FAIR,P . O. BOX 281 TRADE FAIR,AC,GHA,,0,0,23/6/2012,$today,31/12/2099,,31/12/2099,V,Y,Y,CCMD,ICT,ICT,POSTPAID,GSM,508,M,7/19/1981,,1,1006775194,30/12/2099,,,,Y,N,N,D,N,$today,B,$1,1006775194,,,,Y,N,N,N,N,N,,N" 'NR==FNR{d[NR]=$1; next} {print a d[FNR] b $1 c}' $sims $numbers > $temp_file
# fi

dir=$results_root_dir/$2

if [ ! -d "$dir" ]; then
  mkdir $dir
fi

if [[ "$1" != "BXC" ]]; then
  awk -v a="N,$1,.,1,$3,E,N,N," -v b=",NORN,M,APN01," -v c=",N,$2,N,,N,,E,1,p.o.box 8839 accra,p.o.box 8839 accra,p.o.box 8839 accra,p.o.box 8839 accra,AC,GHA,,0,0,4/6/2011,$today,31/12/2099,,31/12/2099,D,Y,Y,CCMD,ICT,ICTT,POSTPAID,GSM,4130,M,20/7/1981,GHANAIAN,1,$3,30/12/2099,,,,Y,N,N,D,N,$today,B,$1,$3,3021238662,3021238662,3021238662,Y,N,N,N,N,N,,N" 'NR==FNR{d[NR]=$1; next} {print a d[FNR] b $1 c}' $sims $numbers > $temp_file
else
  awk -v a="N,$1,.,1,$3,E,N,N," -v b=",NORN,M,APN01," -v c=",N,$2,N,,N,,E,1,1,P . O. BOX 281 TRADE FAIR,P . O. BOX 281 TRADE FAIR,P . O. BOX 281 TRADE FAIR,AC,GHA,,0,0,23/6/2012,$today,31/12/2099,,31/12/2099,V,Y,Y,CCMD,ICT,ICT,POSTPAID,GSM,508,M,7/19/1981,,1,$3,30/12/2099,,,,Y,N,N,D,N,$today,B,$1,$3,,,,Y,N,N,N,N,N,,N" 'NR==FNR{d[NR]=$1; next} {print a d[FNR] b $1 c}' $sims $numbers > $temp_file
fi

file_header=$(create_file_header "BULACT4" $temp_file)
file=$(serialize_file_name $results_root_dir/$2 $2)

echo $file_header > $file
cat $temp_file >> $file
