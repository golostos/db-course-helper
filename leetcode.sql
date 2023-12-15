-- 262. Trips and Users

WITH T AS (
    SELECT Trips.*, 
    	CASE 
    		WHEN status IN ('cancelled_by_driver','cancelled_by_client') THEN 1 
    		ELSE 0 
    	END AS canceled
    FROM Trips
    JOIN Users c ON Trips.client_id = c.users_id
    JOIN Users d ON Trips.driver_id = d.users_id
    WHERE c.banned = 'No' AND d.banned = 'No'
)
SELECT request_at AS 'Day', ROUND(R.total_canceled / R.total, 2) AS 'Cancellation Rate' FROM (
    SELECT *,
        COUNT(*) OVER(PARTITION BY T.request_at) AS total,
        SUM(T.canceled) OVER(PARTITION BY T.request_at) AS total_canceled,
        ROW_NUMBER() OVER(PARTITION BY T.request_at) AS num
    	-- COUNT(CASE WHEN status IN ('cancelled_by_driver','cancelled_by_client') THEN 1 ELSE NULL END) OVER(PARTITION BY request_at) TotalCancelRequest
    FROM T
) AS R
WHERE R.num = 1 AND R.request_at BETWEEN '2013-10-01' AND '2013-10-03'

-- 262. Trips and Users

SELECT request_at Day,
    ROUND(SUM(IF(status = 'cancelled_by_driver' OR status = 'cancelled_by_client', 1,0)) / COUNT(*),2) 
    AS "Cancellation Rate"
FROM Trips
WHERE 
    client_id NOT IN (SELECT users_id FROM Users WHERE banned = "Yes") AND
    driver_id NOT IN (SELECT users_id FROM Users WHERE banned = "Yes") AND
    request_at BETWEEN "2013-10-01" AND "2013-10-03"
GROUP BY request_at