gluent_binds = {"B1": -200, "B2": 200, "B3": -200, "B4": 200, "B5": "to_date('2011-01-01 00:34:07','YYYY-MM-DD HH24:MI:SS')", "B6": "to_date('2011-01-02 20:34:07','YYYY-MM-DD HH24:MI:SS')", "B7": 14976, "B8": 1}

SELECT /*+ monitor &_pq &_qre &_test_name*/ T.CT_TRACKED_OFFENDER_ID, T.TRACK_DATE, T.CT_TRACKED_OFFENDER_TRACK_ID, T.LATITUDE TRC_LATITUDE, T.LONGITUDE TRC_LONGITUDE
FROM TRACKED_OFFENDER_TRACK T
WHERE T.TRACK_MONTH_ID = :B8
AND T.TRACK_DATE_ID = :B7
AND T.TRACK_DATE BETWEEN :B6 AND :B5
AND T.LATITUDE BETWEEN :B4 AND :B3
AND T.LONGITUDE BETWEEN :B2 AND :B1
AND T.IS_VALID_GPS_FLAG = 'N'
ORDER BY T.CT_TRACKED_OFFENDER_ID, T.TRACK_DATE
