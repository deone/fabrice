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
exit;
