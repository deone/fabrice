@@commands_txt.sql

prompt Chrono Number | Service ID | CAI Command Request String | CAI Command Response | Action Code | Description

SELECT CHRONO_NUM_N, SERVICE_ID_V, CAI_CMD_REQ_STRING, SUBSTR(CAI_CMD_RESP_STRING,28,9) AS CAI_CMD_RESP, ACTION_CODE_V, PS.DESCRIPTION
FROM PS_ACTION PS, CB_SUBS_PROVISIONING CSP
WHERE ACTION_DATE_DT BETWEEN TRUNC(SYSDATE) -1 AND TRUNC(SYSDATE)
AND PS.ACTION_CODE = CSP.ACTION_CODE_V
AND STATUS_V='R'
AND nvl(scheme_Ref_code_n,0) not in (2004,2005,2006)
AND CSP.user_code_n not in (642, 583, 497)
ORDER BY ACTION_CODE_V;

exit;
