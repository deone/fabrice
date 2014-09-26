--1. Run query for offer removal
-- ./bulk/messenger.sh bulk/sql/cs5_offer_cancel.sql

--2. Upload file on @billity

--3. Perform checks for executed and rejected offers.
-- Status should be Q, then P if file has been processed.
select * from cb_upload_request ur 
where ur.INT_FILE_NAME_V='cs5_offer_cancel_24092014_1.csv';

-- Status is initially U after upload, 
-- should change to I if file is successfully processed, R if there are rejections.
select * from cb_upload_status us 
where us.FILENAME_V='cs5_offer_cancel_24092014_1.csv';

-- Fix for 'Error while reading/parsing the file'

-- Copy file to 16 server
-- scp veht_offer_addition_24092014_2.csv abillityapp@10.139.41.16:/abilityapp/abillityapp/INTF_UPLOADS/bulk_activities/

-- Update upload tables
update cb_upload_request
set int_process_status_v = 'Q'
where int_file_name_v = 'cs5_offer_cancel_24092014_1.csv';

update cb_upload_status
set status_v = 'Q'
where filename_v = 'cs5_offer_cancel_24092014_1.csv';

commit;

-- Entries in this table should have status as E if executed and R if rejected. 
-- The reasons for the rejections are present in the REJECTED_REASON_V field.
select status_v, rejected_reason_v from tmp_upload_dtls ud 
where ud.FILE_NAME_V='cs5_offer_cancel_24092014_1.csv';

select * from cb_subs_offer_details where account_link_code_n in
(select distinct account_link_code_n from tmp_cs5_affected_services);

--4. Do some updates for rejected offers
-- These 3 queries must return the same row count 
-- indicating the number of executions in the uploaded file.

select * from CB_SUBS_PROVISIONING sp 
where sp.STATUS_V='R' and sp.ACCOUNT_LINK_CODE_N in 
(select distinct s.ACCOUNT_LINK_CODE_N 
from TMP_CS5_AFFECTED_SERVICES s 
where DATE_D>=trunc(sysdate)) and sp.ACTION_CODE_V='OFFC';

select * from cb_subs_pos_services sps 
where sps.SERV_ACC_LINK_CODE_N in 
(select distinct s.ACCOUNT_LINK_CODE_N 
from TMP_CS5_AFFECTED_SERVICES s 
where DATE_D>=trunc(sysdate)) 
and sps.SERVICE_KEY_CODE_V='OFFC' 
and sps.STATUS_OPTN_V='PR';

select * from cb_schedules cs 
where cs.SCHDL_LINK_CODE_N in 
( select sps.SCHDL_LINK_CODE_N 
from cb_subs_pos_services sps 
where sps.SERV_ACC_LINK_CODE_N in 
(select distinct s.ACCOUNT_LINK_CODE_N 
from  TMP_CS5_AFFECTED_SERVICES s 
where DATE_D>=trunc(sysdate)) 
and sps.SERVICE_KEY_CODE_V='OFFC' 
and sps.STATUS_OPTN_V='PR');

-- These 2 queries must update the same row count 
-- indicating the number of executions in the uploaded file.

update cb_subs_pos_services sps1 
set sps1.STATUS_OPTN_V='Q' where sps1.rowid in 
(select sps.rowid from cb_subs_pos_services sps 
where sps.SERV_ACC_LINK_CODE_N in 
(select distinct s.ACCOUNT_LINK_CODE_N 
from TMP_CS5_AFFECTED_SERVICES s 
where DATE_D>=trunc(sysdate) 
and sps.SERVICE_KEY_CODE_V='OFFC' 
and sps.STATUS_OPTN_V='PR'));

commit;

update cb_schedules cs1 set cs1.STATUS_OPTN_V='Q' 
where cs1.rowid in (select cs.rowid from cb_schedules cs 
where cs.SCHDL_LINK_CODE_N in ( select sps.SCHDL_LINK_CODE_N 
from cb_subs_pos_services sps where sps.SERV_ACC_LINK_CODE_N in 
(select distinct s.ACCOUNT_LINK_CODE_N from TMP_CS5_AFFECTED_SERVICES s 
where DATE_D>=trunc(sysdate) and sps.SERVICE_KEY_CODE_V='OFFC' 
and sps.STATUS_OPTN_V='Q')));

commit;

--5. Run query for offer insertion
-- ./bulk/messenger.sh bulk/sql/cs5_offer_addition.sql

--6. Upload file on @billity

--7. Perform checks for executed and rejected offers.
-- Status should be Q, then P if file has been processed.
select * from cb_upload_request ur 
where ur.INT_FILE_NAME_V='cs5_offer_addition_24092014_1.csv';
-- Status is initially U after upload, 
-- should change to I if file is successfully processed, R if there are rejections.
select * from cb_upload_status us 
where us.FILENAME_V='cs5_offer_addition_24092014_1.csv';
-- Entries in this table should have status as E if executed and R if rejected. 
-- The reasons for the rejections are present in the REJECTED_REASON_V field.

-- Fix for 'Error while reading/parsing the file'

-- Copy file to 16 server
-- scp veht_offer_addition_24092014_2.csv abillityapp@10.139.41.16:/abilityapp/abillityapp/INTF_UPLOADS/bulk_activities/

-- Update upload tables
update cb_upload_request
set int_process_status_v = 'Q'
where int_file_name_v = 'cs5_offer_addition_24092014_1.csv';

update cb_upload_status
set status_v = 'Q'
where filename_v = 'cs5_offer_addition_24092014_1.csv';

commit;

select * from tmp_upload_dtls ud 
where ud.FILE_NAME_V='cs5_offer_addition_24092014_1.csv';

select * 
from CB_SUBS_PROVISIONING csp 
where ACCOUNT_LINK_CODE_N 
in
(select account_link_code_n from gsm_service_mast
where mobl_num_voice_v in
(select gen_string_1_v from tmp_upload_dtls
where file_name_v in ('cs5_offer_addition_24092014_1.csv'))
)
and ACTION_CODE_V='OFFI'
and STATUS_V='P';

--8.
delete from tmp_cs5_affected_services;
commit;


-- For APNSD offers

-- Get scheme_ref_code_n
select scheme_ref_code_n from cb_offers where offer_code_v = 'APNSD';

-- Get IP addresses for scheme_ref_code_n
select * from isp_ip_address where ip_address_v in (
select ip_address_v from cb_scheme_ip_address_list where scheme_ref_code_n=2271
) and status_v = 'F';

-- Use this to block IP addresses for a particular offer
update isp_ip_address set status_v = 'B' where ip_address_v in (
select ip_address_v from cb_scheme_ip_address_list where scheme_ref_code_n=2271
) and status_v = 'F';

commit;

-- Get IP addresses assigned to the mobile numbers in question
select * from cb_subs_offer_ip_dtls where mobile_number_v in (
select mobl_num_voice_v from gsm_service_mast where account_link_code_n
in (select distinct account_link_code_n from tmp_cs5_affected_services)
);

select * from cb_subs_offer_ip_dtls where mobile_number_v = '240013407';
select * from tmp_cs5_affected_services;
select mobl_num_voice_v from gsm_service_mast where account_link_code_n in 
(
select account_link_code_n from tmp_cs5_affected_services
);

-- Add IP addresses to file like this; 240012312,APNSD,ADD VAS,172.22.119.9,

-- Remove treated numbers from tmp_cs5_affected_services
delete from tmp_cs5_affected_services
where account_link_code_n in (
select account_link_code_n from gsm_service_mast where mobl_num_voice_v in (
'240026056',
'240025675',
'240021035'
)
);
commit;