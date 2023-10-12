gluent_binds = {"customer_activity_key": 6322225068724170365465484510870, "account_number": 1477094575422982}
gluent_pred_push_tokens = [{"token": ".PAYPAL_CAK_TO_INT64", "occurs": true}, {"token": "CUSTOMER_ACTIVITY_KEY", "occurs": true},{"token": "ACCOUNT_NUMBER", "occurs": 1}]

SELECT /*+ monitor &_pq &_qre &_test_name gluent_query_monitor */ TRANSACTION_FACT.TRANSACTION_ID AS TRANSACTION_ID
,      TRANSACTION_FACT.ENCRYPTED_TRANSACTION_ID AS ENCRYPTED_TRANSACTION_ID 
FROM   TRANSACTION_FACT 
WHERE  CUSTOMER_ACTIVITY_KEY = :customer_activity_key
AND    ACCOUNT_NUMBER = :account_number 
AND    (   (TRANSACTION_TYPE_CODE='U' AND TRANSACTION_SUBTYPE_CODE IN ('L','O') AND DEBIT_CREDIT_CODE='CR') 
        OR (TRANSACTION_TYPE_CODE='U' AND TRANSACTION_SUBTYPE_CODE='X' AND DEBIT_CREDIT_CODE='DR'))
