@@commands_txt.sql

prompt MSISDN | Offer | Status | Action Date | Request | Response

SELECT service_id_v, co.offer_desc_v, 
DECODE(cp.STATUS_V, 'P', 'Processed', 'Q', 'Pending', 'W', 'Waiting', 'R', 'Rejected'), 
TRUNC(cp.ACTION_DATE_DT), cp.cai_cmd_req_string, 
cp.cai_cmd_resp_string 
FROM cb_subs_provisioning cp, cb_offers co
WHERE action_code_v = 'OFFC' 
AND TRUNC(action_date_dt) = TRUNC(SYSDATE) -1 
AND CO.CONTRACT_TYPE_N = 'N' 
AND cp.scheme_ref_code_n = co.scheme_ref_code_n;

exit;
