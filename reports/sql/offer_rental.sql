@@commands_csv.sql

prompt Mobile Number, Rental Amount - Offer

SELECT '233'||b.SERVICE_INFO_V, SUM(a.TRANS_AMT_N)/100 
FROM cb_invoice_details a, cb_account_Service_list b
WHERE bill_cycle_full_Code_n=&1
AND a.serv_acc_link_code_n=b.account_link_code_n
AND (article_code_V,scheme_Ref_code_n) IN (
SELECT article_code_v, cs.scheme_ref_code_n
FROM cb_subscription_articles cs, cb_offers cp WHERE cs.scheme_ref_code_n=cp.scheme_Ref_code_n)
AND trans_amt_n >0
GROUP BY '233'||b.SERVICE_INFO_V;

EXIT;
