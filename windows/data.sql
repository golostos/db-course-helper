-- Path: data.sql
START TRANSACTION;

INSERT INTO employee.department (id, name) VALUES (1, 'IT'), (2, 'HR');

INSERT INTO employee.employee 
(name, salary, age, departmentId) 
VALUES 
('John Doe', 4000.00, 30, 1), 
('Jane Doe', 2000.00, 35, 2), 
('Richard Roe', 3000.00, 40, 1), 
('Janet Roe', 4000.00, 45, 2),
('John Smith', 5000.00, 50, 1), 
('Jane Smith', 6000.00, 55, 2), 
('Richard Smith', 7000.00, 60, 1), 
('Janet Smith', 6000.00, 65, 2),
('John Major', 5000.00, 40, 1), 
('Jane Major', 4000.00, 45, 2), 
('Richard Major', 3000.00, 40, 1), 
('Janet Major', 5000.00, 85, 2);

COMMIT;