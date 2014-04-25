set verify off

-- Column status_v should be 'F'
select mobile_number_v, status_v from gsm_mobile_master gm where gm.MOBILE_NUMBER_V = '&1';

exit;
