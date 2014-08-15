--1. Run query for offer removal
-- ./bulk/messenger.sh bulk/sql/cs5_offer_cancel.sql

--2. Upload file on @billity

--3. Perform checks for executed and rejected offers.
-- Status should be Q, then P if file has been processed.
select * from cb_upload_request ur 
where ur.INT_FILE_NAME_V='cs5_offer_cancel_15082014_01.csv';
-- Status is initially U after upload, 
-- should change to I if file is successfully processed, R if there are rejections.
select * from cb_upload_status us 
where us.FILENAME_V='cs5_offer_cancel_15082014_01.csv';
-- Entries in this table should have status as E if executed and R if rejected. 
-- The reasons for the rejections are present in the REJECTED_REASON_V field.
select * from tmp_upload_dtls ud 
where ud.FILE_NAME_V='cs5_offer_cancel_15082014_01.csv';

--4. Do some updates for rejected offers
-- These 3 queries must return the same row count 
-- indicating the number of executions in the uploaded file.

select * from CB_SUBS_PROVISIONING sp 
where sp.STATUS_V='R' and sp.ACCOUNT_LINK_CODE_N in 
(select distinct s.ACCOUNT_LINK_CODE_N 
from  TMP_CS5_AFFECTED_SERVICES s 
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
(select distinct s.ACCOUNT_LINK_CODE_N from  TMP_CS5_AFFECTED_SERVICES s 
where DATE_D>=trunc(sysdate) and sps.SERVICE_KEY_CODE_V='OFFC' 
and sps.STATUS_OPTN_V='Q')));

commit;

--5. Run query for offer insertion
-- ./bulk/messenger.sh bulk/sql/cs5_offer_addition.sql

--6. Upload file on @billity

--7. Perform checks for executed and rejected offers.
-- Status should be Q, then P if file has been processed.
select * from cb_upload_request ur 
where ur.INT_FILE_NAME_V='cs5_offer_addition_15082014_01a.csv';
-- Status is initially U after upload, 
-- should change to I if file is successfully processed, R if there are rejections.
select * from cb_upload_status us 
where us.FILENAME_V='cs5_offer_addition_15082014_01a.csv';
-- Entries in this table should have status as E if executed and R if rejected. 
-- The reasons for the rejections are present in the REJECTED_REASON_V field.
select * from tmp_upload_dtls ud 
where ud.FILE_NAME_V='cs5_offer_addition_15082014_01a.csv';

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

-- Add IP addresses to file like this; 240012312,APNSD,ADD VAS,172.22.119.9,

-- Remove treated numbers from tmp_cs5_affected_services
delete from tmp_cs5_affected_services
where account_link_code_n in (
select account_link_code_n from gsm_service_mast where mobl_num_voice_v in (
'240011616',
'240313595',
'240012355',
'240012429',
'240012258',
'240012606',
'240012721',
'240012173',
'240012604',
'240011675',
'240012009',
'240012633',
'240012321',
'240012474',
'240011656',
'240012468',
'240012679',
'240314516',
'240012318',
'240012312',
'240012446',
'240012481',
'240012482',
'240012292',
'240012457',
'240012618',
'240012105',
'240012435',
'240012486',
'240012550'
)
);
commit;