define _app_schema = &1

alter session set current_schema = &_app_schema;

CREATE TABLE "SALES_R10_S"
(	"ID" NUMBER NOT NULL ENABLE,
    "PROD_ID" NUMBER NOT NULL ENABLE,
	"CUST_ID" NUMBER NOT NULL ENABLE,
	"TIME_ID" DATE NOT NULL ENABLE,
	"CHANNEL_ID" NUMBER NOT NULL ENABLE,
	"PROMO_ID" NUMBER NOT NULL ENABLE,
	"QUANTITY_SOLD" NUMBER(10,2) NOT NULL ENABLE,
	"AMOUNT_SOLD" NUMBER(10,2) NOT NULL ENABLE,
	 CONSTRAINT "SALES_R10_S_PK" PRIMARY KEY ("TIME_ID", "ID")
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "USERS"  ENABLE NOVALIDATE,
CONSTRAINT "SALES_R10_S_CUSTOMER_FK" FOREIGN KEY ("CUST_ID")
	  REFERENCES "CUSTOMERS" ("CUST_ID") ENABLE NOVALIDATE,
	 CONSTRAINT "SALES_R10_S_PRODUCT_FK" FOREIGN KEY ("PROD_ID")
	  REFERENCES "PRODUCTS" ("PROD_ID") ENABLE NOVALIDATE,
	 CONSTRAINT "SALES_R10_S_TIME_FK" FOREIGN KEY ("TIME_ID")
	  REFERENCES "TIMES" ("TIME_ID") ENABLE NOVALIDATE,
	 CONSTRAINT "SALES_R10_S_CHANNEL_FK" FOREIGN KEY ("CHANNEL_ID")
	  REFERENCES "CHANNELS" ("CHANNEL_ID") ENABLE NOVALIDATE,
	 CONSTRAINT "SALES_R10_S_PROMO_FK" FOREIGN KEY ("PROMO_ID")
	  REFERENCES "PROMOTIONS" ("PROMO_ID") ENABLE NOVALIDATE
) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
STORAGE(
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "USERS";

CREATE BITMAP INDEX "SALES_R10_S_CHANNEL_BIX" ON "SALES_R10_S" ("CHANNEL_ID")
PCTFREE 10 INITRANS 2 MAXTRANS 255
STORAGE(
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT);

CREATE BITMAP INDEX "SALES_R10_S_CUST_BIX" ON "SALES_R10_S" ("CUST_ID")
PCTFREE 10 INITRANS 2 MAXTRANS 255
STORAGE(
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT);

CREATE BITMAP INDEX "SALES_R10_S_PROD_BIX" ON "SALES_R10_S" ("PROD_ID")
PCTFREE 10 INITRANS 2 MAXTRANS 255
STORAGE(
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT);

CREATE BITMAP INDEX "SALES_R10_S_PROMO_BIX" ON "SALES_R10_S" ("PROMO_ID")
PCTFREE 10 INITRANS 2 MAXTRANS 255
STORAGE(
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT);

CREATE BITMAP INDEX "SALES_R10_S_TIME_BIX" ON "SALES_R10_S" ("TIME_ID")
PCTFREE 10 INITRANS 2 MAXTRANS 255
STORAGE(
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT);

