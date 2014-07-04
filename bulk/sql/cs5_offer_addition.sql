@@commands.sql

select gsm.MOBL_NUM_VOICE_V||','||s.OFFER_CODE_V||',ADD VAS,,' 
from TMP_CS5_AFFECTED_SERVICES s,gsm_service_mast gsm 
where s.ACCOUNT_LINK_CODE_N=gsm.ACCOUNT_LINK_CODE_N;

EXIT;
