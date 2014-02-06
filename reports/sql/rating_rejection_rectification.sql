@@commands.sql

prompt Error Code, Count 

SELECT COUNT(1), ERROR_CODE_N FROM CB_UPLOAD_REJECTED_CDRS
WHERE CALL_DATE_DT BETWEEN TRUNC(SYSDATE) -1 AND TRUNC(SYSDATE)
AND CORRECTED_STATUS_V = 'R'
GROUP BY ERROR_CODE_N;

exit;
