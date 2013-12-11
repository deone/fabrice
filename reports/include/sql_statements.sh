#!/bin/sh

if [ "$FABRICE_DEBUG" == "true" ]; then
    month=`date -v -1m +%m`
else
    month=`date +%m -d last-month`
fi

data_offer_rental_items="
SELECT A.OFFER_CODE_V, A.OFFER_DESC_V, SUM(B.TRANS_AMT_N)/100 RENTAL_AMOUNT 
FROM CB_OFFERS A, CB_INVOICE_DETAILS B 
WHERE BILL_CYCLE_FULL_CODE_N =101000001${year}${month}0 
AND A.SCHEME_REF_CODE_N=B.SCHEME_REF_CODE_N 
AND DB_CR_V='C' 
AND (B.SCHEME_REF_CODE_N,ARTICLE_CODE_V) IN
(SELECT SCHEME_REF_CODE_N,ARTICLE_CODE_V FROM CB_SUBSCRIPTION_ARTICLES  WHERE SCHEME_REF_CODE_N IN (
SELECT SCHEME_REF_CODE_N FROM CB_OFFERS WHERE (OFFER_DESC_V LIKE '%DATA%' OR OFFER_DESC_V LIKE '%BB%' 
AND CONTRACT_TYPE_N ='N')))
GROUP BY A.OFFER_CODE_V, A.OFFER_DESC_V, DB_CR_V;
"

data_offer_rental_count="
SELECT  COUNT(DISTINCT (SERV_ACC_LINK_CODE_N)) 
FROM CB_OFFERS A, CB_INVOICE_DETAILS B 
WHERE BILL_CYCLE_FULL_CODE_N =101000001${year}${month}0
AND A.SCHEME_REF_CODE_N=B.SCHEME_REF_CODE_N 
AND TRANS_AMT_N > 0 
AND DB_CR_V='C' 
AND (B.SCHEME_REF_CODE_N,ARTICLE_CODE_V) IN
(SELECT SCHEME_REF_CODE_N,ARTICLE_CODE_V FROM CB_SUBSCRIPTION_ARTICLES  WHERE SCHEME_REF_CODE_N IN (
SELECT SCHEME_REF_CODE_N FROM CB_OFFERS WHERE (OFFER_DESC_V LIKE '%DATA%' OR OFFER_DESC_V LIKE '%BB%') AND CONTRACT_TYPE_N ='N'));
"

invoice="
SELECT ACCOUNT_CODE_N \"Account Code\", ACCOUNT_NAME_V \"Account Name\", 
INVOICE_AMT_N/100+INVOICE_TAX_N/100 \"Invoice Amt Inc. Tax\", B.SUBSCRIBER_CATEGORY_V \"Subscriber Category\", 
B.SUBSCRIBER_SUB_CATEGORY_V \"Subscriber Sub Category\" 
FROM CB_INVOICE A, CB_ACCOUNT_MASTER B 
WHERE A.ACCOUNT_LINK_CODE_N=B.ACCOUNT_LINK_CODE_N 
AND SUBSCRIBER_CATEGORY_V='CORP' 
AND BILL_CYCL_FULL_CODE_N=101000001${year}${month}0;
"

package_rental="
SELECT '233'||b.SERVICE_INFO_V \"Mobile Number\", SUM(a.TRANS_AMT_N)/100 \"Rental Amount - Package\" 
FROM cb_invoice_details a, cb_account_Service_list b
WHERE bill_cycle_full_Code_n=101000001${year}${month}0
AND a.serv_acc_link_code_n=b.account_link_code_n
AND (article_code_V,scheme_Ref_code_n) IN (
SELECT article_code_v, cs.scheme_ref_code_n
FROM cb_subscription_articles cs, cb_package cp WHERE cs.scheme_ref_code_n=cp.scheme_Ref_code_n)
AND trans_amt_n >0
GROUP BY '233'||b.SERVICE_INFO_V;
"

offer_rental="
SELECT '233'||b.SERVICE_INFO_V \"Mobile Number\", SUM(a.TRANS_AMT_N)/100 \"Rental Amount - Offer\" 
FROM cb_invoice_details a, cb_account_Service_list b
WHERE bill_cycle_full_Code_n=101000001${year}${month}0
AND a.serv_acc_link_code_n=b.account_link_code_n
AND (article_code_V,scheme_Ref_code_n) IN (
SELECT article_code_v, cs.scheme_ref_code_n
FROM cb_subscription_articles cs, cb_offers cp WHERE cs.scheme_ref_code_n=cp.scheme_Ref_code_n)
AND trans_amt_n >0
GROUP BY '233'||b.SERVICE_INFO_V;
"
