#!/bin/sh

# DB
if [[ "$report_name" == "concierge_performance" ]]; then
    conn_string="concierge_app_gha/concierge_app_gha@TTPROD"
else
    conn_string="abillity_view/abillity_view@TTPROD"
fi

# files
reports_out_path="${FABRICE_PATH}reports/out/"
reports_sql_path="${FABRICE_PATH}reports/sql/"

emails_dir="${reports_out_path}emails"
results_dir="${reports_out_path}results"
files_dir="${reports_out_path}files"

mailcfg="${FABRICE_PATH}reports/mail.cfg.txt"
period=`awk -v r=$report_name '{ if ($1 == r) print $3; }' $mailcfg`

if [[ "$FABRICE_DEBUG" == "false" ]]; then
    date_flag="-d "$period
else
    if [[ "$period" == "yesterday" ]]; then
	date_flag="-v -1d"
    elif [[ "$period" == "last-month" ]]; then
	date_flag="-v -1m"
    else
	date_flag="-v -0d"
    fi
fi

# date
if [[ "$FABRICE_DEBUG" == "true" ]]; then
    query_date=`date $date_flag +"%Y%m"`
    if [[ "$period" == "last-month" ]]; then
	text_date=`date $date_flag +"%B %Y"`
	_text_date_=`date $date_flag +"%B_%Y"`
    else
	text_date=`date $date_flag +"%d %B %Y"`
	_text_date_=`date $date_flag +"%d_%B_%Y"`
    fi
else
    query_date=`date +"%Y%m" $date_flag`
    if [[ "$period" == "last-month" ]]; then
	text_date=`date +"%B %Y" $date_flag`
	_text_date_=`date +"%B_%Y" $date_flag`
    else
	text_date=`date +"%d %B %Y" $date_flag`
	_text_date_=`date +"%d_%B_%Y" $date_flag`
    fi
fi

# email
recipients="osikoya.oladayo@tecnotree.com"
cc="alwaysdeone@gmail.com"

live_cc="souvik.choudhury@tecnotree.com;jegadeesan.velusamy@tecnotree.com;osikoya.oladayo@tecnotree.com;adetimilehin.hammed@tecnotree.com;chandra.mohan@tecnotree.com;eeswar.jagadisan@tecnotree.com;solomon.annan@tecnotree.com;sathisha.hegde@tecnotree.com"
