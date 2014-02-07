@@commands_txt.sql

prompt MSISDN

select mobl_num_voice_v 
from gsm_service_mast a, gsm_starter_pack_dtls b 
where (registration_date_d between trunc(sysdate-1) and trunc(sysdate))
and a.mobl_num_voice_v=b.mobile_number_v and a.status_code_v in ('IA','AC')
and (TRANSACTION_DATE_D between to_date('25022013','ddmmyyyy') and to_date('01062014','ddmmyyyy'))
order by registration_date_d;

exit;
