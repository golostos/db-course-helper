-- 58
SET @id = (SELECT id FROM Reviews ORDER BY id DESC LIMIT 1) + 1;

SET @reservation_id = (
    SELECT Reservations.id FROM Reservations
    JOIN Users ON Users.id = Reservations.user_id
    JOIN Rooms ON Rooms.id = Reservations.room_id
    WHERE name = "George Clooney" AND address = "11218, Friel Place, New York"
    LIMIT 1
);

INSERT INTO Reviews (id, reservation_id, rating)
VALUES (@id, @reservation_id, 5)


-- 60
SET @count = (SELECT COUNT(*) FROM Class WHERE name LIKE '%11%');

SELECT * FROM (
    SELECT teacher FROM Schedule
    JOIN Class ON Class.id = Schedule.class
    WHERE Class.name LIKE '%11%'
    GROUP BY teacher, name
) as s
GROUP BY s.teacher
HAVING COUNT(s.teacher) = @count

-- 68
SELECT room_id, name, end_date FROM (
    SELECT room_id, name, end_date, 
    DENSE_RANK() OVER(PARTITION BY room_id ORDER BY end_date DESC) AS rnk
    FROM Reservations
    JOIN Rooms ON Rooms.id = Reservations.room_id
    JOIN Users ON Users.id = Reservations.user_id
) AS r
WHERE r.rnk = 1

-- 69
WITH T AS (
    SELECT owner_id, total, room_id
    FROM Reservations
    RIGHT JOIN Rooms ON Rooms.id = Reservations.room_id
    JOIN Users ON Users.id = Rooms.owner_id
)

SELECT owner_id, IFNULL(SUM(total), 0) AS total_earn
FROM T
GROUP BY owner_id

-- OR

SELECT owner_id, IFNULL(SUM(total), 0) AS total_earn
FROM Rooms 
LEFT JOIN Reservations ON Rooms.id = Reservations.room_id 
JOIN Users ON Users.id = Rooms.owner_id
GROUP BY owner_id;

-- 71
WITH OwnersClients AS (
    SELECT DISTINCT owner_id FROM Rooms
    JOIN Reservations ON Reservations.room_id = Rooms.id
    UNION 
    SELECT DISTINCT user_id FROM Reservations
)
SELECT ROUND((SELECT COUNT(*) FROM OwnersClients) * 100 / (SELECT COUNT(id) FROM Users), 2) AS percent;