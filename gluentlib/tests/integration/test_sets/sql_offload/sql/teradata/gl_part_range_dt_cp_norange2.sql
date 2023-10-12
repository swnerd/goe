CREATE TABLE gl_part_range_dt_cp_norange2
( id BIGINT
, dt DATE
, ts TIMESTAMP(0)
, ts_year INTEGER
, ts_month INTEGER
, cat INTEGER
, flag CHAR(1)
, data VARCHAR(30))
NO PRIMARY INDEX
PARTITION BY(
    RANGE_N(dt BETWEEN DATE '2020-01-01' AND DATE '2025-12-31' EACH INTERVAL '1' MONTH, NO RANGE, UNKNOWN)
,   COLUMN
);

INSERT INTO gl_part_range_dt_cp_norange2
WITH v AS (
    SELECT id,  TIMESTAMP '2020-01-01 00:00:00' + NUMTODSINTERVAL(id, 'HOUR') AS ts
    FROM   generated_ids
    WHERE  id <= 24*365*2)
SELECT id
,      CAST(ts AS DATE) dt
,      ts
,      EXTRACT(YEAR FROM ts) ts_year
,      EXTRACT(MONTH FROM ts) ts_month
,      MOD(id,4) AS cat
,      SUBSTR('ABCDE',Random(1,5),1) flag
,      'blah' AS data
FROM v;

