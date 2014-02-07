@@commands_csv.sql

prompt Recipient, Donor, MSISDN, Agent, Date, Status, Given Name, Last Name, ID Number

SELECT   recipient_operator_v, donor_operator_v,
         mobile_number_v,
         NVL (agent_name_v, (SELECT login_name_v
                               FROM cb_users a
                              WHERE a.user_code_n = b.user_code_n)),
         TO_CHAR (action_date_dt, 'mm/dd/yyyy hh24:mi'),
         DECODE (status_v,
                 'X', 'ABORTED',
                 'Q', 'Awaiting Authentication',
                 'I', 'PORT IN COMPLETED',
                 'F', 'FAILED',
                 'R', 'REJECTED',
                 status_v
                ) status,
         first_name_v, last_name_v, id_number_v 
    FROM cb_tt_mnp_int_api_log b
   WHERE action_code_v = 'MNP_PRT_IN'
     AND (execution_date_dt BETWEEN TRUNC (SYSDATE - 1) AND TRUNC (SYSDATE))
ORDER BY mobile_number_v, action_date_dt;

EXIT;
