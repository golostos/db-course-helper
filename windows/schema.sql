START TRANSACTION;

CREATE SCHEMA IF NOT EXISTS employee DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS employee.department (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    INDEX name (name ASC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS employee.employee (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    age INT UNSIGNED NOT NULL,
    departmentId INT UNSIGNED NOT NULL,    
    PRIMARY KEY (id),
    INDEX departmentId (departmentId ASC),
    INDEX name (name ASC),
    CONSTRAINT fk_departmentId FOREIGN KEY (departmentId) REFERENCES employee.department(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

COMMIT;
