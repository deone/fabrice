set linesize 1000
set colsep ,
set pagesize 0
set feedback off

select mobile_number_v from (select distinct mobile_number_v, action_date from tmp_trow_mul_check where update_flg_v = 'N' order by action_date);

EXIT;
