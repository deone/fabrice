set verify off

-- Should produce empty result
-- select * from TMP_RESERVERD_NUMBER_V04 where MOBILE_NUMBER_V in ('545715433');

-- Set column status_v above to 'F'
UPDATE gsm_mobile_master gm
SET GM.STATUS_V='F'
WHERE gm.MOBILE_NUMBER_V = '&1'
AND GM.STATUS_V in ('Q', '1');

exit;
