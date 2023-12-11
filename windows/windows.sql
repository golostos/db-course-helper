-- Path: windows.sql

USE employee;

-- MAX

SELECT *, MAX(salary) OVER() AS maxSalary FROM employee;

SELECT *, MAX(salary) OVER(PARTITION BY departmentId) AS maxSalary FROM employee;

SELECT e.* FROM employee e,
    (SELECT departmentId, MAX(salary) AS maxSalary FROM employee GROUP BY departmentId) m
WHERE e.departmentId = m.departmentId AND e.salary = m.maxSalary;

SELECT *
FROM (
  SELECT e.*, MAX(salary) OVER(PARTITION BY departmentId) AS maxSalary
  FROM employee e
) subquery
WHERE salary = maxSalary;

-- ROW_NUMBER

SELECT *, ROW_NUMBER() OVER() AS num FROM employee;

SELECT *, ROW_NUMBER() OVER(PARTITION BY departmentId) AS num FROM employee;

SELECT *, ROW_NUMBER() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS num FROM employee;

SELECT d.name as Department, m.name as Employee, salary as Salary FROM department d, (
  SELECT *,
  ROW_NUMBER() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS num 
  FROM employee e
) m
WHERE d.id = m.departmentId AND m.num < 3;

-- RANK

SELECT *, RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS rnk FROM employee;

-- Leetcode 185. Department Top Three Salaries

-- Sliding window
SELECT d.name as Department, e.name AS Employee, e.salary AS Salary
FROM (
    SELECT *, DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS rnk FROM employee 
) e 
JOIN department d ON d.id = e.departmentId
WHERE e.rnk < 4

-- Subquery with count
select d.name as Department, e.name as Employee, salary as Salary
from department d 
join employee e on d.id = e.departmentId
where (
    select count(distinct e2.salary)
    from employee e2
    where e2.departmentId = d.id and e2.salary > e.salary
) <= 2

-- LAG and LEAD

SELECT *, LAG(salary) OVER(PARTITION BY departmentId ORDER BY salary) AS prevSalary FROM employee;

SELECT *, LEAD(salary) OVER(PARTITION BY departmentId ORDER BY salary) AS nextSalary FROM employee;

SELECT *, salary - LAG(salary) OVER(PARTITION BY departmentId ORDER BY salary) AS diffSalary FROM employee;

SELECT *, salary - LEAD(salary) OVER(PARTITION BY departmentId ORDER BY salary) AS diffSalary FROM employee;