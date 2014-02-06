@@commands_csv.sql

prompt SERV_ACC_LINK_CODE_N, SERVICE_KEY_CODE_V

SELECT SERV_ACC_LINK_CODE_N, SERVICE_KEY_CODE_V 
FROM CB_SCHEDULES 
WHERE PROCESS_ON_DATE_D BETWEEN TRUNC(SYSDATE) -1 AND TRUNC(SYSDATE)
AND STATUS_OPTN_V = 'R'
AND (SERV_ACC_LINK_CODE_N,SERVICE_KEY_CODE_V) IN (
SELECT ACCOUNT_LINK_CODE_N ,  ACTION_CODE_V FROM CB_SUBS_PROVISIONING
WHERE  STATUS_V = 'P');

exit;