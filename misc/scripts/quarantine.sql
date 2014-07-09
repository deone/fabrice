-- Column status_v should be 'Q'
select * from gsm_mobile_master gm where gm.MOBILE_NUMBER_V in (
'242824186'
);

-- Should produce empty result
select * from TMP_RESERVERD_NUMBER_V04 where MOBILE_NUMBER_V in (
'244317961',
'243275332',
'247521988'
);

-- Set column status_v above to 'F'
UPDATE gsm_mobile_master gm                             
SET GM.STATUS_V='F'            
WHERE gm.MOBILE_NUMBER_V in (
'244317961',
'243275332',
'247521988'
)
AND GM.STATUS_V in ('Q', '1');

commit;