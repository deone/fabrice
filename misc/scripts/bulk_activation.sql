-- Check fields in 2 using 'select *'. If required, run 2.
-- 1. Select SIMs.
select * from gsm_sims_master
where status_v = 'F' and
sim_num_v between '8923301001002880275' and '8923301001002881265';

-- 2. Update fields, after checking with 1.
update gsm_sims_master
set switch_num_n = 1, sim_category_code_v = 'NORN', pre_post_sim_v = 'N'
where sim_num_v between '8923301001002880275' 
and '8923301001002881265';

commit;

-- 3. Fetch mobile numbers
select mobile_number_v from gsm_mobile_master where category_code_v = 'APN01'
and status_v = 'F' and rownum < 101
order by 1 desc;

-- 4. Get subscriber_code for use on @billity
select subscriber_code_n from cb_account_master where account_code_n=1006775194;

select * from cb_package where package_code_v = 'BXC10MB';

select * from cb_advance_rental where scheme_ref_code_n = 2993;

select * from adv_rent_bulact_bkp;

insert into adv_rent_bulact_bkp
select * from cb_advance_rental where scheme_ref_code_n = 2993;

delete from cb_advance_rental where scheme_ref_code_n = 2993;
commit;

-- Check file progress
select * from cb_upload_request cur where cur.int_file_name_v = 'BXCAUG9.csv';

select * from cb_upload_status cus where cus.filename_v = 'BXCAUG9.csv';

select status_v, rejected_reason_v 
from tmp_upload_dtls tud 
where tud.file_name_v = 'BXCAUG9.csv';