set feedback off

declare
    l_mobile_number_v varchar2(10);
    l_account_link_code_n number(10);
    l_cr_limit_n number(10);
    l_count_n number(10);
    l_CS5_CR_LIMIT_N number(10,2);

begin

    l_mobile_number_v := '&1';

    select account_link_code_n 
    into l_account_link_code_n 
    from gsm_service_mast 
    where mobl_num_voice_v=l_mobile_number_v;

    select CR_LIMIT_N 
    into l_cr_limit_n 
    from cb_subs_information_master 
    where account_link_code_n=l_account_link_code_n;

    update CB_SUBS_INFORMATION_MASTER 
    set ADDNL_CREDIT_LIMIT_N=0 
    where account_link_code_n=l_account_link_code_n;

    update CB_SERV_WISE_CS5_DETAILS set
    TOT_RENTAL_AMT_N=(select nvl(sum(ARTICLE_AMT_N),0) 
            from CB_CYCLE_SERVICE_CHARGES a,CB_SCHEME_REFERENCE b
            where account_link_code_n=l_account_link_code_n 
            and status_optn_v='A' 
            and b.SCHEME_REF_CODE_N=a.SCHEME_REF_CODE_N 
            and b.SCHEME_TYPE_V='P')
    where account_link_code_n=l_account_link_code_n;

    update CB_SERV_WISE_CS5_DETAILS 
    set CS5_CR_LIMIT_N=floor((l_cr_limit_n/1.15)-TOT_RENTAL_AMT_N), ABL_CR_LIMIT_N=l_cr_limit_n 
    where account_link_code_n=l_account_link_code_n;
    
    update CB_SERV_WISE_CS5_DETAILS 
    set CS5_CR_LIMIT_N=0
    where account_link_code_n=l_account_link_code_n
    and floor((l_cr_limit_n/1.15)-TOT_RENTAL_AMT_N) <0;

    update CB_ADDNL_CREDIT_LIMIT 
    set cr_limit_status_v='Z' 
    where serv_acc_link_code_n=l_account_link_code_n;

    update TMP_CR_EXCL_INCL_DETAILS set status_v='Z' 
    where entity_id_v=l_mobile_number_v;

    select (CS5_CR_LIMIT_N/100) 
    into l_CS5_CR_LIMIT_N 
    from CB_SERV_WISE_CS5_DETAILS 
    where account_link_code_n=l_account_link_code_n;

    insert into tmp_text values(
       'SET:GSMSUB:MSISDN,233'||l_mobile_number_v||':DEDICATEDACCOUNT,SET,DEDICATEDACCOUNTID,11,DEDICATEDACCOUNTVALUENEW,'||
    l_cs5_cr_limit_n||',DEDICATEDACCOUNTUNIT,1:ACCUMULATOR,SET,ACCUMULATORID,6,ACCUMULATORVALUEABSOLUTE,'||
    l_cs5_cr_limit_n||':SHAREACCOUNT,SET,UTID,1,UTMVALUENEW,'||l_cs5_cr_limit_n||';'
    );

    /* commit; */

end;
/
exit;
