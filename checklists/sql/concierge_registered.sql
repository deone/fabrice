SELECT MOBL_NUM_VOICE_V||','||'PAM2'||','||'ADD VAS'||','||',' 
FROM gsm_service_mast a
WHERE mobl_num_voice_V IN
(SELECT mobile_number_v 
FROM GSM_SIM_REGISTRATION_DETAILS 
WHERE REGISTRATION_DATE_DT>=TRUNC(SYSDATE)-5
AND activity_type_v='SIM'
AND registration_done_by_n 
NOT IN (3482,3481) 
AND status_v='S')
AND NOT EXISTS (SELECT 1 FROM cb_subs_offer_details b 
WHERE a.account_link_code_n=b.account_link_code_n
AND offer_code_v='PAM2')
union
SELECT MOBL_NUM_VOICE_V||','||'PROMO'||','||'ADD VAS'||','||',' 
FROM gsm_service_mast a
WHERE mobl_num_voice_V IN
(SELECT mobile_number_v 
FROM GSM_SIM_REGISTRATION_DETAILS 
WHERE REGISTRATION_DATE_DT>=TRUNC(SYSDATE)-5
AND activity_type_v='SIM'
AND registration_done_by_n 
NOT IN (3482,3481) 
AND status_v='S')
AND NOT EXISTS (SELECT 1 FROM cb_subs_offer_details b 
WHERE a.account_link_code_n=b.account_link_code_n
AND offer_code_v='PROMO')
union
SELECT MOBL_NUM_VOICE_V||','||'SOFF10'||','||'ADD VAS'||','||',' 
FROM gsm_service_mast a
WHERE mobl_num_voice_V IN
(SELECT mobile_number_v 
FROM GSM_SIM_REGISTRATION_DETAILS 
WHERE REGISTRATION_DATE_DT>=TRUNC(SYSDATE)-5 
AND activity_type_v='SIM'
AND registration_done_by_n 
NOT IN (3482,3481) 
AND status_v='S')
AND NOT EXISTS (SELECT 1 FROM cb_subs_offer_details b 
WHERE a.account_link_code_n=b.account_link_code_n
AND offer_code_v='SOFF10');

EXIT;
