@@commands_csv.sql

prompt Action, Total, Success, Fail, % Success, Failure %, Average (HH:MM:SS), Minimum (HH:MM:SS), Maximum (HH:MM:SS)

SELECT  
description action,  
total,  
(total - fail) success, fail,concat(round(((100*(total - fail))/total)), '%') "% Success", 
      concat(round(((100*(fail))/total)), '%') "Failure %", 
       SUBSTR (AVG, -8, 8) "Average (HH:MM:SS)",
       SUBSTR (MIN, 11, 9) "Minimum (HH:MM:SS)",
       SUBSTR (MAX, 11, 9) "Maximum (HH:MM:SS)"
  FROM (SELECT   module, description, 
                 DECODE (action_code, 
                         'V', 'VIEW', 
                         'I', 'INSERT', 
                         'U', 'UPDATE', 
                         'NO ACTION' 
                        ) action, 
                 COUNT (1) total, SUM (success_failure) fail, 
                 SUM (DECODE (success_failure, NULL, 1)) "NULL", 
                 TO_CHAR 
                    (  TRUNC (SYSDATE) 
                     + AVG (  TO_DATE (TO_CHAR (endtime, 
                                                'DD/MM/YYYY HH24:MI:SS' 
                                               ), 
                                       'DD/MM/YYYY HH24:MI:SS' 
                                      ) 
                            - TO_DATE (TO_CHAR (starttime, 
                                                'DD/MM/YYYY HH24:MI:SS' 
                                               ), 
                                       'DD/MM/YYYY HH24:MI:SS' 
                                      ) 
                           ), 
                     'DD HH24:MI:SS' 
                    ) AS AVG, 
                 MIN (TO_CHAR (endtime - starttime)) MIN, 
                 MAX (TO_CHAR (endtime - starttime)) MAX 
            FROM tbl_audit_logs 
           WHERE effective_date>=trunc(sysdate)-1 and effective_date<trunc(sysdate)
                    -- and description in ('View Service Information','Get available points','View SIM Swap', 'Request for Value voucher refill','Request for Standard voucher refill', 'View Me2U transactions', 'View Add/Remove VAS Details', 'Initial Page of GSM Service Creation', 'Hard Suspension','Soft suspension/revoke') 
                    GROUP BY module, description, action_code 
        ORDER BY 4 DESC) 
WHERE ROWNUM < 20;

EXIT;
