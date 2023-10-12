define _app_schema = &1

alter session set current_schema = &_app_schema;

CREATE TABLE "CUSTOMERS_P02_L"
(	"CUST_ID" NUMBER NOT NULL ENABLE,
	"CUST_FIRST_NAME" VARCHAR2(20 BYTE) NOT NULL ENABLE,
	"CUST_LAST_NAME" VARCHAR2(40 BYTE) NOT NULL ENABLE,
	"CUST_GENDER" CHAR(1 BYTE) NOT NULL ENABLE,
	"CUST_YEAR_OF_BIRTH" NUMBER(4,0) NOT NULL ENABLE,
	"CUST_MARITAL_STATUS" VARCHAR2(20 BYTE),
	"CUST_STREET_ADDRESS" VARCHAR2(40 BYTE) NOT NULL ENABLE,
	"CUST_POSTAL_CODE" VARCHAR2(10 BYTE) NOT NULL ENABLE,
	"CUST_CITY" VARCHAR2(30 BYTE) NOT NULL ENABLE,
	"CUST_CITY_ID" NUMBER NOT NULL ENABLE,
	"CUST_STATE_PROVINCE" VARCHAR2(40 BYTE) NOT NULL ENABLE,
	"CUST_STATE_PROVINCE_ID" NUMBER NOT NULL ENABLE,
	"COUNTRY_ID" NUMBER NOT NULL ENABLE,
	"CUST_MAIN_PHONE_NUMBER" VARCHAR2(25 BYTE) NOT NULL ENABLE,
	"CUST_INCOME_LEVEL" VARCHAR2(30 BYTE),
	"CUST_CREDIT_LIMIT" NUMBER,
	"CUST_EMAIL" VARCHAR2(30 BYTE),
	"CUST_TOTAL" VARCHAR2(14 BYTE) NOT NULL ENABLE,
	"CUST_TOTAL_ID" NUMBER NOT NULL ENABLE,
	"CUST_SRC_ID" NUMBER,
	"CUST_EFF_FROM" DATE,
	"CUST_EFF_TO" DATE,
	"CUST_VALID" VARCHAR2(1 BYTE),
CONSTRAINT "CUSTOMERS_P02_L_PK" PRIMARY KEY ("CUST_ID")
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "USERS"  ENABLE NOVALIDATE,
	 CONSTRAINT "CUSTOMERS_P02_L_COUNTRY_FK" FOREIGN KEY ("COUNTRY_ID")
	  REFERENCES "COUNTRIES" ("COUNTRY_ID") ENABLE NOVALIDATE
) SEGMENT CREATION IMMEDIATE
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
NOCOMPRESS LOGGING
PARTITION BY LIST (CUST_GENDER) (
 PARTITION M VALUES ('M'),
 PARTITION F VALUES ('F')
)
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "USERS";

COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_ID" IS 'primary key';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_FIRST_NAME" IS 'first name of the customer';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_LAST_NAME" IS 'last name of the customer';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_GENDER" IS 'gender; low cardinality attribute';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_YEAR_OF_BIRTH" IS 'customer year of birth';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_MARITAL_STATUS" IS 'customer marital status; low cardinality attribute';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_STREET_ADDRESS" IS 'customer street address';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_POSTAL_CODE" IS 'postal code of the customer';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_CITY" IS 'city where the customer lives';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_STATE_PROVINCE" IS 'customer geography: state or province';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."COUNTRY_ID" IS 'foreign key to the countries table (snowflake)';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_MAIN_PHONE_NUMBER" IS 'customer main phone number';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_INCOME_LEVEL" IS 'customer income level';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_CREDIT_LIMIT" IS 'customer credit limit';
COMMENT ON COLUMN "CUSTOMERS_P02_L"."CUST_EMAIL" IS 'customer email id';
COMMENT ON TABLE "CUSTOMERS_P02_L"  IS 'dimension table';

CREATE BITMAP INDEX "CUSTOMERS_P02_L_GENDER_BIX" ON "CUSTOMERS_P02_L" ("CUST_GENDER")
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "USERS"
LOCAL;

CREATE BITMAP INDEX "CUSTOMERS_P02_L_MARITAL_BIX" ON "CUSTOMERS_P02_L" ("CUST_MARITAL_STATUS")
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "USERS"
LOCAL;

CREATE BITMAP INDEX "CUSTOMERS_P02_L_YOB_BIX" ON "CUSTOMERS_P02_L" ("CUST_YEAR_OF_BIRTH")
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "USERS"
LOCAL;

INSERT INTO "CUSTOMERS_P02_L" SELECT * FROM "CUSTOMERS";

COMMIT;

