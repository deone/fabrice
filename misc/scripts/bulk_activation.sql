-- check whether range has been used
select * from gsm_service_mast 
where sim_num_v between '8923301001002897279' and '8923301001002897519';

-- 1. Update fields for SIM range
update gsm_sims_master
set switch_num_n = 1, sim_category_code_v = 'NORN', pre_post_sim_v = 'N'
where sim_num_v between '8923301001002897279' 
and '8923301001002897519';

commit;

-- 2. Select SIMs.
select 
-- *
sim_num_v 
from gsm_sims_master
where -- status_v = 'F' and
sim_num_v between '8923301001002897279' 
and '8923301001002897519';

select * from gsm_service_mast where sim_num_v='8923301001002846276';

select * from tmp_upload_dtls where file_name_v like 'BXC%' 
and gen_string_9_v='8923301001002846276';

-- 3. Fetch mobile numbers
select mobile_number_v from gsm_mobile_master where category_code_v = 'APN01'
and status_v = 'F' and rownum < 251
order by 1 desc;

-- 4. Get subscriber_code for use on @billity
select subscriber_code_n from cb_account_master where account_code_n=1006637095;

-- Check file progress
select * from cb_upload_request cur where cur.int_file_name_v = 'ECG_10092014_2.csv';
select * from cb_upload_status cus where cus.filename_v = 'ECG_10092014_2.csv';
select status_v, rejected_reason_v
from tmp_upload_dtls tud 
where tud.file_name_v = 'ECG_10092014_2.csv';
-- and rejected_reason_v is not null;

--- to check (or update) the provisioning status of 
--- various actions like INST,OFFC,OFFI
-- update cb_subs_provisioning set status_v='Q'
select service_id_v, cai_cmd_resp_string 
from CB_SUBS_PROVISIONING csp 
where ACCOUNT_LINK_CODE_N 
in
(select account_link_code_n from gsm_service_mast
where mobl_num_voice_v in
(select gen_string_13_v from tmp_upload_dtls
where file_name_v 
in ('ECG_29082014_1.csv')))
and ACTION_CODE_V='INST'
and STATUS_V='P';

-- commit;

---- to prepare the bulk activation report
select gsm.ACCOUNT_CODE_N,gsm.MOBL_NUM_VOICE_V,gsm.SIM_NUM_V,gsm.IMSI_NUM_N,
(select cp.package_name_v from cb_package cp 
where cp.PACKAGE_CODE_V=gsm.package_codE_v ) PACKAGE_V,
od.IP_ADDRESS_V
from gsm_Service_mast gsm,CB_SUBS_OFFER_IP_DTLS od 
 where gsm.MOBL_NUM_VOICE_V in ( 
select ud.gen_string_13_V from tmp_upload_dtls ud where ud.FILE_NAME_V 
in (
'BXC28082014_1.csv', 
'BXC_03092014_1.csv', 
'BXC28082014_2.csv', 
'BXC_29082014_1.csv',
'BXC_04092014_1.csv',
'BXC_04092014_2.csv',
'BXC_05092014_3.csv'
))
and gsm.MOBL_NUM_VOICE_V=od.MOBILE_NUMBER_V;

---- to create the bulk offer cancelation file
select gen_string_13_v||',BXC10MB,DELETE' from tmp_upload_dtls
where file_name_v='BXCA3a.csv';

---- to create the bulk offer addition file
select
sod.MOBILE_NUMBER_V||',BXC10MB,ADD VAS,'||sod.IP_ADDRESS_V||','
from cb_subs_offer_ip_dtls sod,
gsm_service_mast gsm
where sod.SERV_ACC_LINK_CODE_N=gsm.ACCOUNT_LINK_CODE_N
and gsm.MOBL_NUM_VOICE_V in
(select gen_string_13_v from tmp_upload_dtls
where file_name_v='BXCA3a.csv');
-- OR
select mobile_number_v||',BXC10MB,ADD VAS,'||ip_address_v||',' 
from cb_subs_offer_ip_dtls where mobile_number_v in (
select gen_string_13_v from tmp_upload_dtls where file_name_v='BXCAUG11a.csv'
);

---- to check the service level status of offer addition and cancelation
select * from cb_subs_pos_services pos
where pos.SERV_ACC_LINK_CODE_N in
(select account_link_code_n from gsm_service_mast
where mobl_num_voice_v in
(select gen_string_13_v from tmp_upload_dtls
where file_name_v='BXCAUG11a.csv'))
and pos.SERVICE_KEY_CODE_V='OFFC'
and pos.STATUS_OPTN_V='E';

---- only for offer cancelation
update cb_subs_pos_services pos
set pos.STATUS_OPTN_V='Q'
where pos.SERV_ACC_LINK_CODE_N in
(select account_link_code_n from gsm_service_mast
where mobl_num_voice_v in
(select gen_string_13_v from tmp_upload_dtls
where file_name_v='BXCAUG11a.csv'))
and pos.SERVICE_KEY_CODE_V='OFFC'
and pos.STATUS_OPTN_V='PR';

commit;

---- only for offer cancellation
update cb_schedules cs
set cs.STATUS_OPTN_V='Q'
where cs.SCHDL_LINK_CODE_N in
(select SCHDL_LINK_CODE_N from cb_subs_pos_services pos
where pos.SERV_ACC_LINK_CODE_N in
(select account_link_code_n from gsm_service_mast
where mobl_num_voice_v in
(select gen_string_13_v from tmp_upload_dtls
where file_name_v='BXCAUG11a.csv'))
and pos.SERVICE_KEY_CODE_V='OFFC'
and pos.STATUS_OPTN_V='PR');

---- to update free ips to blocked status so that they can be picked. this should be done immediately after offer cancellation
update isp_ip_address isp
set isp.STATUS_V='B'
where isp.IP_ADDRESS_V in
(select ip_address_v from cb_scheme_ip_address_list
where scheme_ref_code_n=2994)
and isp.STATUS_V='F';

commit;

-- Advance rental things
select * from cb_package where package_code_v = 'BXC10MB';

select * from cb_package_offers where package_v = 'BXC10MB'
and offer_flag_v = 'F';

select * from cb_advance_rental where scheme_ref_code_n = 2993;

select * from adv_rent_bulact_bkp;

insert into adv_rent_bulact_bkp
select * from cb_advance_rental where scheme_ref_code_n = 2993;

delete from cb_advance_rental where scheme_ref_code_n = 2993;
commit;