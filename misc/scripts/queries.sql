-- 1. Fetch numbers with `active` status from a given set of numbers and retrieve their service class.
SELECT MOBL_NUM_VOICE_V, STATUS_CODE_V, BUSINESS_CLASS_CODE_V "SERVICE_CLASS" 
FROM GSM_SERVICE_MAST A, CB_SDP_DETAILS B 
WHERE CONTRACT_TYPE_V='P'
AND STATUS_CODE_V='AC'
AND MOBL_NUM_VOICE_V IN (
'241324876',
'540288875',
'241363469',
'241324834',
'544695539'
)
AND A.PACKAGE_CODE_V=B.PACKAGE_CODE_V;

-- 2. Fetch name of account and corporate account associated with a given set of numbers.
SELECT A.ACCOUNT_CODE_N, A.MOBL_NUM_VOICE_V, A.SUBS_NAME_V, B.ACCOUNT_NAME_V 
FROM GSM_SERVICE_MAST A, CB_ACCOUNT_MASTER B
WHERE A.ACCOUNT_CODE_N=B.ACCOUNT_CODE_N
AND MOBL_NUM_VOICE_V IN (
'544444249',
'544444250',
'544444262',
'544444264',
'544444269'
) 
ORDER BY MOBL_NUM_VOICE_V;

-- 3. Fetch mobile number and their respective port-out dates
select mobile_number_v, trunc(action_date_dt) from cb_tt_mnp_int_api_log where mobile_number_v in (
'542524192',
'542525802',
'542528118',
'549740695'
);

-- 4. Fetch mobile_number and status of all the numbers in a corporate account
select mobl_num_voice_v, status_code_v 
from gsm_service_mast where account_code_n='200013778';

-- 5. Fetch the statuses of a given set of numbers
select mobl_num_voice_v, status_code_v from gsm_service_mast where mobl_num_voice_v in (
'554000000'
);

-- 6. Services in ERASED status and still generating CDRs
SELECT DISTINCT MOBL_NUM_V FROM CB_UPLOAD_REJECTED_CDRS WHERE CALL_dATE_DT BETWEEN TO_DATE('20131116000000','YYYYMMDDHH24MISS')
AND TO_DATE('20131122235959','YYYYMMDDHH24MISS')
AND SWITCH_CALL_tYPE_V = '031';

-- 7. Fetch status and status description for these numbers
select a.mobl_num_voice_v, a.status_code_v, b.status_desc_v 
from gsm_service_mast a, cb_status_master b
where a.status_code_v=b.status_code_v
and a.mobl_num_voice_v in (
'244312643',
'244312656'
) order by mobl_num_voice_v;

--8. Fetch install and delete dates for a given set of numbers
select a.mobl_num_voice_v, trunc(b.from_date_d), trunc(b.to_date_d) 
from gsm_service_mast a, cb_account_service_list b
where a.account_link_code_n = b.account_link_code_n
and mobl_num_voice_v in (
'246991640',
'540987722',
'546811042',
'245861473',
'240614194'
);

--9. Check for MUL mismatch numbers
select mobile_number_v from (select distinct mobile_number_v, action_date from tmp_trow_mul_check where update_flg_v = 'N' order by action_date);
select * from tmp_trow_mul_check_his;

--10. Fetch usernames and role names of users that can perform an action
SELECT USER_NAME,DESCRIPTION FROM TBL_USER_ROLE A, TBL_USER B,TBL_ROLE_GROUP C WHERE A.USER_ID=B.CID
AND A.ROLE_ID = C.CID 
AND A.ROLE_ID IN (
SELECT CID FROM TBL_ROLE_GROUP WHERE cid IN(
SELECT ROLE_ID FROM TBL_ROLE_FEATURES WHERE FEATURE_ID='1113'
AND READ_OPTION='Y')
AND CID <> 3) 
AND ISACTIVE='Y' 
AND user_name <> 'MTNuser';

--11. Set done TROW numbers
update tmp_trow_mul_check 
set update_flg_v = 'Y' 
where mobile_number_v in (
	'93000296'
);
commit;

--12. Check provisioning statuses for all actions
select csp.STATUS_V,csp.ACTION_CODE_V,count(1)
from cb_subs_provisioning csp
where csp.ACTION_DATE_DT between to_date('04-07-2014 09:00:01','dd-mm-yyyy hh24:mi:ss') 
and to_date('04-07-2014 23:59:59','dd-mm-yyyy hh24:mi:ss')
and csp.STATUS_V='Q'
group by csp.STATUS_V,csp.ACTION_CODE_V;

--13. Select default package for a number
select * from gsm_service_mast gt
where gt.MOBL_NUM_VOICE_V='549576932';

select * from cb_package_offers 
where package_v = 'IGPRSP3' -- this is package_code_v from the preceding query result
and offer_flag_v = 'F'; -- F denotes default

--14. Check provisioning status
select * from gsm_service_mast gt
where gt.MOBL_NUM_VOICE_V='540100693';

--15. get account code, name, mobile number, status and offers
select a.account_code_n, a.subs_name_v,
a.mobl_num_voice_v, 
a.status_code_v, 
c.offer_desc_v 
from gsm_service_mast a, cb_subs_offer_details b, cb_offers c 
where account_code_n = 1006686720 
and a.account_link_code_n = b.account_link_code_n
and b.offer_code_v = c.offer_code_v
and b.status_optn_v = 'A'
and a.status_code_v <> 'ER';

select * from cb_subs_provisioning csp where csp.ACCOUNT_LINK_CODE_N=38481266
order by 3 desc;