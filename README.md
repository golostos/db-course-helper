# Helper project for DB course

## Install WSL

```bash
wsl --install
```

## Install docker

[https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

## Init MySQL via docker compose

```bash
docker-compose up -d
```

## Open phpMyAdmin

[http://localhost:8080/](http://localhost:8080/)

## Insert data from Northwind

Copy the content from the link bellow to the SQL tab in phpMyAdmin and execute it.

[https://en.wikiversity.org/wiki/Database_Examples/Northwind/MySQL](https://en.wikiversity.org/wiki/Database_Examples/Northwind/MySQL)

## Start exercises from w3schools

[https://www.w3schools.com/sql/default.asp](https://www.w3schools.com/sql/default.asp)

## Cheat sheets

### SQL basics

[https://learnsql.com/blog/sql-basics-cheat-sheet/](https://learnsql.com/blog/sql-basics-cheat-sheet/)

### SQL joins

[https://learnsql.com/blog/sql-join-cheat-sheet/](https://learnsql.com/blog/sql-join-cheat-sheet/)

### Window functions

[https://learnsql.com/blog/sql-window-functions-cheat-sheet/](https://learnsql.com/blog/sql-window-functions-cheat-sheet/)



## Types of SQL commands

* DDL - Data Definition Language - CREATE, ALTER, DROP, TRUNCATE
* DML - Data Manipulation Language - SELECT, INSERT, UPDATE, DELETE
* DCL - Data Control Language - GRANT, REVOKE
* TCL - Transaction Control Language - COMMIT, ROLLBACK, SAVEPOINT

## Data types

* Numeric - INT, FLOAT, DOUBLE, DECIMAL
* String - CHAR, VARCHAR, TEXT
* Date - DATE, DATETIME, TIMESTAMP, TIME, YEAR
* Other - BLOB, ENUM, SET, JSON

## Constraints

* NOT NULL - column cannot be NULL
* UNIQUE - column cannot contain duplicate values
* PRIMARY KEY - combination of NOT NULL and UNIQUE
* FOREIGN KEY - used to link two tables together
* CHECK - used to limit the value range
* DEFAULT - used to set a default value

## Operators

* Comparison - =, <, >, <=, >=, <>, !=
* Logical - AND, OR, NOT
* IN - used to specify multiple values for a column
* BETWEEN - used to select values within a range
* LIKE - used to search for a pattern
* IS NULL - used to test for NULL values
* EXISTS - used to test for the existence of any record in a subquery

## Functions

* Aggregate - AVG, COUNT, MAX, MIN, SUM
* String - CONCAT, SUBSTRING, TRIM, UPPER, LOWER, LENGTH, REPLACE
* Date - ADDDATE, ADDTIME, CURDATE, CURTIME, DATE, DATE_FORMAT, DAY, DAYNAME, DAYOFMONTH, DAYOFWEEK, DAYOFYEAR, HOUR, MINUTE, MONTH, MONTHNAME, NOW, SECOND, TIME, YEAR
* Other - IF, IFNULL, NULLIF, COALESCE, CASE

## Joins

* INNER JOIN - returns records that have matching values in both tables
* LEFT JOIN - returns all records from the left table and the matched records from the right table
* RIGHT JOIN - returns all records from the right table and the matched records from the left table
* FULL JOIN - returns all records when there is a match in either left or right table

## Transactions

```sql
START TRANSACTION;
SELECT * FROM table;
-- If value is incorrect, rollback the transaction  
ROLLBACK;
UPDATE table SET column = value;
COMMIT;
```

## ACID

* Atomicity - all queries are executed or none of them
* Consistency - database is in a consistent state (good state) before and after the transaction - no constraints are violated (UNIQUE, FOREIGN KEY, NOT NULL, CHECK, DEFAULT)
* Isolation - transactions are executed in isolation from each other for preventing race conditions. Serial execution of transactions is not efficient, so we have different isolation levels
* Durability - after a transaction is committed, it will remain so, even in the event of power loss, crashes, or errors

### Isolation levels

* Read uncommitted - dirty reads, changed data from other not committed transactions can be read
* Read committed - changed data from other committed transactions can be read before commit
* Repeatable read - changed data from other committed transactions can be read only after commit. State of the database is the same during the transaction - no phantom reads - snapshot of the database is taken at the beginning of the transaction. Locks are used to prevent other transactions from changing the data. 

### Read committed example

```bash
docker ps
docker exec -it mysql_container bash
mysql -u root -p
```

Create a new table

```sql
CREATE TABLE emails (
    id INT NOT NULL AUTO_INCREMENT,
    body VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);
```

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- First transaction
START TRANSACTION;
SELECT * FROM emails;
INSERT INTO emails (body) VALUES ('email 1');
SELECT * FROM emails;
  -- Second transaction
  START TRANSACTION;
  SELECT * FROM emails;
  INSERT INTO emails (body) VALUES ('email 2');
  SELECT * FROM emails;
  COMMIT;
SELECT * FROM emails;
COMMIT;
```

### Repeatable read example

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- First transaction
START TRANSACTION;
SELECT * FROM emails;
INSERT INTO emails (body) VALUES ('email 1');
SELECT * FROM emails;
  -- Second transaction
  START TRANSACTION;
  SELECT * FROM emails;
  INSERT INTO emails (body) VALUES ('email 2');
  SELECT * FROM emails;
  COMMIT;
SELECT * FROM emails;
COMMIT;
```

### MVCC - Multi Version Concurrency Control

Each transaction sees a snapshot of the database at the beginning of the transaction. The snapshot is created by copying the data from the database to the transaction. The transaction works with the data from the snapshot. Other transactions can change the data in the database, but the transaction will not see the changes. The transaction will see the changes only after commit.

### Lost update problem

```sql
create table counter(
  value INT DEFAULT 0 NOT NULL
);
insert into counter (value) values (0);
```

```sql 
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- First transaction
START TRANSACTION;
SELECT * FROM counter;
SELECT value FROM counter into @value;
UPDATE counter SET value = @value + 1;
SELECT * FROM counter;
  -- Second transaction
  START TRANSACTION;
  SELECT * FROM counter;
  SELECT value FROM counter into @value FOR UPDATE;
  UPDATE counter SET value = @value + 1;
  SELECT * FROM counter;
  COMMIT;
SELECT * FROM counter;
COMMIT;
```

### Atomic update

```sql 
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- First transaction
START TRANSACTION;
SELECT * FROM counter;
UPDATE counter SET value = value + 1;
SELECT * FROM counter;
  -- Second transaction
  START TRANSACTION;
  SELECT * FROM counter;
  -- Wait for the first transaction to finish
  UPDATE counter SET value = value + 1;
  SELECT * FROM counter;
  COMMIT;
SELECT * FROM counter;
COMMIT;
```

### Explicit locking

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- First transaction
START TRANSACTION;
SELECT * FROM counter;
SELECT value FROM counter into @value FOR UPDATE;
UPDATE counter SET value = @value + 1;
SELECT * FROM counter;
  -- Second transaction
  START TRANSACTION;
  SELECT * FROM counter;
  -- Wait for the first transaction to finish
  SELECT value FROM counter into @value FOR UPDATE;
  UPDATE counter SET value = @value + 1;
  SELECT * FROM counter;
  COMMIT;
SELECT * FROM counter;
COMMIT;
```

## Views

```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```