-- Script to check whether account profile allows only Accounts
select cam.ACCOUNT_CODE_N,cam.STATUS_CODE_V,cam.ADD_ACC_SERV_FLAG_V
from cb_account_master cam
where cam.ACCOUNT_CODE_N in (200024346)
and cam.ADD_ACC_SERV_FLAG_V='A';
 
--Script to update profile wherein service can be added
--The record count should match the count retreived in the above query
 
UPDATE cb_account_master cam
SET cam.ADD_ACC_SERV_FLAG_V='S'
where cam.ACCOUNT_CODE_N in (200024346)
AND cam.ADD_ACC_SERV_FLAG_V='A';

commit;
