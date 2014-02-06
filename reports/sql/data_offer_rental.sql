@@commands_csv.sql

prompt Offer Code, Offer Description, Rental Amount

SELECT A.OFFER_CODE_V, A.OFFER_DESC_V, SUM(B.TRANS_AMT_N)/100 RENTAL_AMOUNT 
FROM CB_OFFERS A, CB_INVOICE_DETAILS B 
WHERE BILL_CYCLE_FULL_CODE_N = &1
AND A.SCHEME_REF_CODE_N=B.SCHEME_REF_CODE_N 
AND DB_CR_V='C' 
AND (B.SCHEME_REF_CODE_N,ARTICLE_CODE_V) IN
(SELECT SCHEME_REF_CODE_N,ARTICLE_CODE_V FROM CB_SUBSCRIPTION_ARTICLES  WHERE SCHEME_REF_CODE_N IN (
SELECT SCHEME_REF_CODE_N FROM CB_OFFERS WHERE (OFFER_DESC_V LIKE '%DATA%' OR OFFER_DESC_V LIKE '%BB%' 
AND CONTRACT_TYPE_N ='N')))
GROUP BY A.OFFER_CODE_V, A.OFFER_DESC_V, DB_CR_V;

EXIT;
