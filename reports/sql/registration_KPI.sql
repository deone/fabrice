@@commands_csv.sql

prompt Month, Avg(uS), Max(uS), Count, Avg(Sec), Max(Sec)

SELECT to_char(SYSDATE-1,'MON'), AVG (diff), MAX (diff),
       COUNT (1), AVG (diff) / 1000000, 
       MAX (diff) / 1000000 
  FROM (SELECT SUBSTR(registration_complete_time_dt - registration_start_time_dt, 18, 2)
                 * 1000000
               + SUBSTR(registration_complete_time_dt - registration_start_time_dt, 21) diff
          FROM gsm_sim_registration_details
         WHERE registration_start_time_dt >= ADD_MONTHS(TRUNC(SYSDATE),-1)
           AND status_v = 'S'
           AND registration_start_time_dt <= TRUNC(SYSDATE));

EXIT;
