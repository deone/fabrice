@@commands.sql

prompt MSISDN, Invoice

SELECT service_info_v, (invoice_amt_n + tax_amt_n) / 100 
FROM cb_account_service_list a, cb_sub_invoice b
WHERE service_info_v LIKE '540118%'
AND b.account_link_code_n = a.account_link_code_n
AND bill_cycl_full_code_n = &1;

EXIT;
