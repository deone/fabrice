select * from CB_SUBS_PROVISIONING sp where sp.STATUS_V='R'
and sp.ACTION_DATE_DT>=trunc(sysdate)
and sp.ACTION_CODE_V='INST'
and sp.CAI_CMD_RESP_STRING like '%3005;';

select distinct mobile_number_v 
from tmp_vehical_track where trunc(date_d)>=trunc(sysdate) and flag='N';

-- 1. Update table
UPDATE CB_SUBS_PROVISIONING 
SET cai_cmd_req_string = SUBSTR(cai_cmd_req_string,0,204)||';', STATUS_V='Q' 
WHERE STATUS_V='R'
AND ACTION_CODE_V='INST'
AND ACTION_DATE_DT >= TRUNC(SYSDATE)
AND CAI_CMD_RESP_STRING LIKE '%3005;';

commit;

-- 2. Select offers to be deleted
-- ./bulk/messenger.sh bulk/sql/veht_offer_cancel.sql
	  
-- 3. Upload offers on Abillity

-- 4. Check whether file has been processed
select * from cb_upload_request ur 
where ur.INT_FILE_NAME_V='cs5_offer_cancel_21072014_05.csv';

-- 5. Check file upload status, STATUS_V should be 'Q'
select * from cb_upload_Status us 
where us.FILENAME_V='veht_offer_cancel_08072014_01.csv';

-- 6. Check status of individual offers, STATUS_V above should have changed to 'U' or 'I'
select * from tmp_upload_dtls ud 
where ud.FILE_NAME_V='veht_offer_cancel_08072014_01.csv';

-- 7. This query should return an empty result or pending VHT_PRO records
select * from CB_SUBS_OFFER_Details sod 
where sod.ACCOUNT_LINK_CODE_N in ( 
select gsm.account_link_code_n 
from gsm_service_mast gsm WHERE status_code_v IN ('AC', 'SP')
      AND contract_type_v = 'N'
      AND activation_date_d >= TRUNC (SYSDATE)                     -- -1/24
      AND tariff_code_v = 'VEHT')
and status_optn_v='A'
and offer_code_v in ('VEHT MO','VEHT MT','VHT_PRO');

-- 8. Run both these queries to update the pending VHT_PRO records in 6.
-- Rerun 7. to confirm. Result should be empty.
update cb_subs_pos_services sps1 set sps1.STATUS_OPTN_V='Q'
where sps1.rowid in (
select sps.rowid from cb_subs_pos_Services sps where sps.SERV_ACC_LINK_CODE_N in (
 select gsm.account_link_code_n 
from gsm_service_mast gsm WHERE status_code_v IN ('AC', 'SP')
      AND contract_type_v = 'N'
      AND activation_date_d >= TRUNC (SYSDATE)                        -- -1/24
      AND tariff_code_v = 'VEHT')
      and sps.SERVICE_KEY_CODE_V='OFFC'
      and sps.STATUS_OPTN_V='PR');
	  
update cb_schedules cs1 set cs1.STATUS_OPTN_V='Q'
where cs1.rowid in (     
select cs.rowid from cb_schedules cs where cs.SCHDL_LINK_CODE_N in
 (select sps.SCHDL_LINK_CODE_N from cb_subs_pos_Services sps where sps.SERV_ACC_LINK_CODE_N in (
 select gsm.account_link_code_n 
from gsm_service_mast gsm WHERE status_code_v IN ('AC', 'SP')
      AND contract_type_v = 'N'
      AND activation_date_d >= TRUNC (SYSDATE)                        -- -1/24
      AND tariff_code_v = 'VEHT')
      and sps.SERVICE_KEY_CODE_V='OFFC'
      and sps.STATUS_OPTN_V='Q'));
	  
commit;

-- 9. Prepare offer commands
-- ./bulk/messenger.sh bulk/sql/veht_offer_addition.sql

-- 10. Check whether file has been processed
select * from cb_upload_request ur 
where ur.INT_FILE_NAME_V='cs5_offer_cancel_21072014_05.csv';

-- 11. Check file upload status, STATUS_V should be 'Q'
select * from cb_upload_Status us 
where us.FILENAME_V='veht_offer_cancel_08072014_01.csv';

-- 12. Check status of individual offers, STATUS_V above should have changed to 'U' or 'I'
select * from tmp_upload_dtls ud 
where ud.FILE_NAME_V='veht_offer_cancel_08072014_01.csv';

-- 13. Update tmp table
UPDATE tmp_vehical_track set flag='Y' where trunc(date_d)>=trunc(sysdate);
commit;