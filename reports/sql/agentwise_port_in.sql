@@commands_csv.sql

prompt Agent, Count

SELECT AGENT, COUNT(1) 
    FROM (SELECT NVL (agent_name_v,
                      (SELECT login_name_v
                         FROM cb_users a
                        WHERE a.user_code_n = b.user_code_n)
                     ) "AGENT"
            FROM cb_tt_mnp_int_api_log b
           WHERE action_code_v = 'MNP_PRT_IN'
             AND status_v = 'I'
             AND execution_date_dt >= ADD_MONTHS (TRUNC (SYSDATE), -1)
             AND execution_date_dt < TRUNC (SYSDATE))
GROUP BY AGENT;

EXIT;
