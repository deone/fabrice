@@commands.sql

prompt Called Number, Calling Number, Date, Duration, Charge

SELECT mobile_number_v, called_calling_number_v, 
call_date_time_dt, duration_n, charge_amount_n / 1000 
FROM cb_upload_all_cdrs
WHERE mobile_number_v LIKE '540118%'
AND bill_cycl_full_code_n = &1;

EXIT;
