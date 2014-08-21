--1. Run query for offer removal
-- ./bulk/messenger.sh bulk/sql/cs5_offer_cancel.sql

--2. Upload file on @billity

--3. Perform checks for executed and rejected offers.
-- Status should be Q, then P if file has been processed.
select * from cb_upload_request ur 
where ur.INT_FILE_NAME_V='cs5_offer_cancel_21082014_02.csv';
-- Status is initially U after upload, 
-- should change to I if file is successfully processed, R if there are rejections.
select * from cb_upload_status us 
where us.FILENAME_V='cs5_offer_cancel_21082014_02.csv';
-- Entries in this table should have status as E if executed and R if rejected. 
-- The reasons for the rejections are present in the REJECTED_REASON_V field.
select status_v, rejected_reason_v from tmp_upload_dtls ud 
where ud.FILE_NAME_V='cs5_offer_cancel_21082014_02.csv';

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
where ur.INT_FILE_NAME_V='cs5_offer_addition_21082014_02.csv';
-- Status is initially U after upload, 
-- should change to I if file is successfully processed, R if there are rejections.
select * from cb_upload_status us 
where us.FILENAME_V='cs5_offer_addition_21082014_02.csv';
-- Entries in this table should have status as E if executed and R if rejected. 
-- The reasons for the rejections are present in the REJECTED_REASON_V field.
select * from tmp_upload_dtls ud 
where ud.FILE_NAME_V='cs5_offer_addition_21082014_02.csv';

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

select * from gsm_service_mast where account_link_code_n = 38651535;

-- Add IP addresses to file like this; 240012312,APNSD,ADD VAS,172.22.119.9,

-- Remove treated numbers from tmp_cs5_affected_services
delete from tmp_cs5_affected_services
where account_link_code_n in (
select account_link_code_n from gsm_service_mast where mobl_num_voice_v in (
'240014617',
'240015263',
'240014596',
'240014338',
'240015219',
'240014408',
'240014463',
'240014496',
'240014487',
'240014346',
'240014384',
'240014498',
'240014458',
'240014792',
'240014934',
'240016285',
'240016252',
'240014358',
'240014791',
'240015962',
'240014614',
'240016004',
'240014310',
'240016063',
'240014870',
'240014465',
'240014649',
'240014859',
'240014981',
'240014609',
'240014589',
'240014711',
'240015735',
'240015921',
'240014331',
'240015492',
'240015554',
'240014811',
'240015117',
'240015319',
'240015307',
'240014532',
'240016038',
'240017121',
'240015385',
'240014373',
'240014661'
)
);
commit;