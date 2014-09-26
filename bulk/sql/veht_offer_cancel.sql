@@commands.sql

select mobl_num_voice_v||',VEHT MT,DELETE' 
from gsm_service_mast gsm WHERE status_code_v IN ('AC', 'SP')
      AND contract_type_v = 'N'
      AND activation_date_d >= TRUNC(SYSDATE)-1
      AND tariff_code_v = 'VEHT'
Union all 
select mobl_num_voice_v||',VHT_PRO,DELETE' 
from gsm_service_mast gsm WHERE status_code_v IN ('AC', 'SP')
      AND contract_type_v = 'N'
      AND activation_date_d >= TRUNC(SYSDATE)-1
      AND tariff_code_v = 'VEHT' 
Union all
select mobl_num_voice_v||',VEHT MO,DELETE' 
from gsm_service_mast gsm WHERE status_code_v IN ('AC', 'SP')
      AND contract_type_v = 'N'
      AND activation_date_d >= TRUNC(SYSDATE)-1
      AND tariff_code_v = 'VEHT';

EXIT;
