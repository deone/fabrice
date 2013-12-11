#!/bin/sh

# Send mail with attached provisioning rejection commands and response.

# Fetch environment variables
if [ "$OSTYPE" == "linux-gnu" ]; then
    . ~/.bash_profile
else
    . ~/.profile
fi

# Source config file
. $(dirname $0)/reports.cfg

sql_results=$results_dir/provisioning_rejections.out
email=$emails_dir/provisioning_rejections.mail
attachment=$files_dir/provisioning_rejections.txt

addresses="Billing&Charging@mtn.com.gh;dtenartey@mtn.com.gh;rjmalm@mtn.com.gh;soakoto@mtn.com.gh;vkdzineku@mtn.com.gh"
cc="$culprits;ganesh.giri@tecnotree.com;balamurugan.palaniswamy@tecnotree.com;Adetimilehin.Hammed@tecnotree.com"

date=`TZ=GMT+24 date +%d%h%Y`

sqlplus -s $conn_string > $sql_results << EOF
set lines 10000;
set pages 50000;
set serveroutput on;

DECLARE
CURSOR C1
IS
SELECT CHRONO_NUM_N,SERVICE_ID_V,CAI_CMD_REQ_STRING,SUBSTR(CAI_CMD_RESP_STRING,28,9) AS CAI_CMD_RESP,ACTION_CODE_V,PS.DESCRIPTION
FROM PS_ACTION PS , CB_SUBS_PROVISIONING CSP
WHERE ACTION_DATE_DT BETWEEN TRUNC(SYSDATE) -1 AND TRUNC(SYSDATE)
AND PS.ACTION_CODE = CSP.ACTION_CODE_V
AND STATUS_V='R'
AND nvl(scheme_Ref_code_n,0) not in (2004,2005,2006)
ORDER BY ACTION_CODE_V;

BEGIN
DBMS_OUTPUT.PUT_LINE('CHRONO_NUM_N'||'|'||
                     'SERVICE_ID_V'||'|'||
                     'CAI_CMD_REQ_STRING'||'|'||
                     'CAI_CMD_RESP'||'|'||
                     'ACTION_CODE_V'||'|'||
                     'DESCRIPTION');
FOR I IN C1 LOOP
DBMS_OUTPUT.PUT_LINE(I.CHRONO_NUM_N||'|'||
                     I.SERVICE_ID_V||'|'||
                     I.CAI_CMD_REQ_STRING||'|'||
                     I.CAI_CMD_RESP||'|'||
                     I.ACTION_CODE_V||'|'||
                     I.DESCRIPTION);
END LOOP;
END;
/
EXIT;
EOF

cat $sql_results|grep -v "^$"|grep -v "PL/SQL procedure"  > $attachment

cat << EOF > $email
Dear Team,
Please find attached PROVISIONING Rejection file for $date.

Note: Birthday Promo Rejections have been excluded.

Thanks,
Tecnotree MSO Team.
EOF

mutt -a $attachment -s "PROVISIONING REJECTIONS for $date" -c $cc $addresses < $email
