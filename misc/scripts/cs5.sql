--1. Run query for offer removal
-- ./bulk/messenger.sh bulk/sql/cs5_offer_cancel.sql

--2. Upload file on @billity

--3. Perform checks for executed and rejected offers.
-- Status should be Q, then P if file has been processed.
select * from cb_upload_request ur 
where ur.INT_FILE_NAME_V='cs5_offer_cancel_08072014_01.csv';
-- Status is initially U after upload, 
-- should change to I if file is successfully processed, R if there are rejections.
select * from cb_upload_status us 
where us.FILENAME_V='cs5_offer_cancel_08072014_01.csv';
-- Entries in this table should have status as E if executed and R if rejected. 
-- The reasons for the rejections are present in the REJECTED_REASON_V field.
select * from tmp_upload_dtls ud 
where ud.FILE_NAME_V='cs5_offer_cancel_08072014_01.csv';

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
where ur.INT_FILE_NAME_V='cs5_offer_addition_08072014_01.csv';
-- Status is initially U after upload, 
-- should change to I if file is successfully processed, R if there are rejections.
select * from cb_upload_status us 
where us.FILENAME_V='cs5_offer_addition_08072014_01.csv';
-- Entries in this table should have status as E if executed and R if rejected. 
-- The reasons for the rejections are present in the REJECTED_REASON_V field.
select * from tmp_upload_dtls ud 
where ud.FILE_NAME_V='cs5_offer_addition_08072014_01.csv';

--8.
delete from tmp_cs5_affected_services;
commit;