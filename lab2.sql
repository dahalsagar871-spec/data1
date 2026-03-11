-- =========================
-- Reset Database
-- =========================
DROP DATABASE IF EXISTS techsolution_db;
CREATE DATABASE techsolution_db;
USE techsolution_db;

-- =========================
-- Department Table
-- =========================
CREATE TABLE DEPT (
    DEPT_ID INT PRIMARY KEY,
    DNAME VARCHAR(50),
    LOC VARCHAR(50)
);

INSERT INTO DEPT VALUES
(1,'HR','Kathmandu'),
(2,'IT','Pokhara'),
(3,'Finance','Lalitpur'),
(4,'Marketing','Bhaktapur'),
(5,'Sales','Chitwan');

-- =========================
-- Employee Table
-- =========================
CREATE TABLE EMPLOYEE (
    EMPID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER VARCHAR(10),
    SALARY DECIMAL(10,2),
    HIREDATE DATE,
    DEPT_ID INT,
    FOREIGN KEY (DEPT_ID) REFERENCES DEPT(DEPT_ID)
);

INSERT INTO EMPLOYEE VALUES
(101,'Ram','Sharma','Male',50000,'2022-01-10',1),
(102,'Sita','Karki','Female',60000,'2021-05-15',2),
(103,'Hari','Thapa','Male',55000,'2023-02-20',3),
(104,'Gita','Adhikari','Female',52000,'2022-09-01',4),
(105,'Suman','Gurung','Male',58000,'2020-12-12',5);

-- =========================
-- Project Table
-- =========================
CREATE TABLE PROJECT (
    PROJECT_ID INT PRIMARY KEY,
    PROJECT_NAME VARCHAR(50),
    START_DATE DATE,
    END_DATE DATE,
    BUDGET DECIMAL(10,2)
);

INSERT INTO PROJECT VALUES
(201,'Website Development','2024-01-01','2024-06-01',100000),
(202,'Mobile App','2024-02-15','2024-08-30',150000),
(203,'Database System','2024-03-10','2024-07-20',120000),
(204,'Network Setup','2024-04-01','2024-09-15',90000),
(205,'Software Testing','2024-05-05','2024-10-10',80000);

-- =========================
-- Works_On Table
-- =========================
CREATE TABLE WORKS_ON (
    EMPID INT,
    PROJECT_ID INT,
    HOURS_WORKED INT,
    PRIMARY KEY (EMPID, PROJECT_ID),
    FOREIGN KEY (EMPID) REFERENCES EMPLOYEE(EMPID),
    FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT(PROJECT_ID)
);

INSERT INTO WORKS_ON VALUES
(101,201,40),
(102,202,35),
(103,203,30),
(104,204,25),
(105,205,45);

-- =========================
-- Update salary of EMPID 102 by 10%
-- =========================
UPDATE EMPLOYEE
SET SALARY = SALARY * 1.10
WHERE EMPID = 102;

-- =========================
-- Delete Project 205 and related WORKS_ON entries
-- =========================
DELETE FROM WORKS_ON
WHERE PROJECT_ID = 205;

DELETE FROM PROJECT
WHERE PROJECT_ID = 205;

-- =========================
-- Queries
-- =========================

-- 1. Employees earning more than 50,000, descending order by salary
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > 50000
ORDER BY SALARY DESC;

-- 2. Employees in IT department
SELECT E.FIRST_NAME, E.LAST_NAME, E.SALARY, D.DNAME AS DEPARTMENT
FROM EMPLOYEE E
JOIN DEPT D ON E.DEPT_ID = D.DEPT_ID
WHERE D.DNAME = 'IT';

-- 3. Total employees per department
SELECT D.DNAME AS DEPARTMENT, COUNT(E.EMPID) AS TOTAL_EMPLOYEES
FROM EMPLOYEE E
JOIN DEPT D ON E.DEPT_ID = D.DEPT_ID
GROUP BY D.DNAME;

-- 4. Employees hired after Jan 2022
SELECT FIRST_NAME, LAST_NAME, HIREDATE
FROM EMPLOYEE
WHERE HIREDATE > '2022-01-31';

-- 5. Employees with their department names
SELECT E.FIRST_NAME, E.LAST_NAME, D.DNAME AS DEPARTMENT
FROM EMPLOYEE E
JOIN DEPT D ON E.DEPT_ID = D.DEPT_ID;

-- 6. Employees and the projects they are working on
SELECT E.FIRST_NAME, E.LAST_NAME, P.PROJECT_NAME
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.EMPID = W.EMPID
JOIN PROJECT P ON W.PROJECT_ID = P.PROJECT_ID;

-- 7. Project name with total hours worked
SELECT P.PROJECT_NAME, SUM(W.HOURS_WORKED) AS TOTAL_HOURS
FROM PROJECT P
JOIN WORKS_ON W ON P.PROJECT_ID = W.PROJECT_ID
GROUP BY P.PROJECT_NAME;

-- 8. Display all projects
SELECT * FROM PROJECT;

-- 9. Display updated employee with EMPID 102
SELECT * FROM EMPLOYEE WHERE EMPID = 102;

-- =========================
-- New Queries
-- =========================

-- 10. Average salary of employees in each department
SELECT D.DNAME AS DEPARTMENT, AVG(E.SALARY) AS AVERAGE_SALARY
FROM EMPLOYEE E
JOIN DEPT D ON E.DEPT_ID = D.DEPT_ID
GROUP BY D.DNAME;

-- 11. Department with the highest number of employees
SELECT D.DNAME AS DEPARTMENT, COUNT(E.EMPID) AS TOTAL_EMPLOYEES
FROM EMPLOYEE E
JOIN DEPT D ON E.DEPT_ID = D.DEPT_ID
GROUP BY D.DNAME
ORDER BY TOTAL_EMPLOYEES DESC
LIMIT 1;

-- 12. Employees whose salary is greater than the average salary
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);



CREATE VIEW HighSalaryEmployee AS
SELECT *
FROM Employee
WHERE Salary > 60000;

SELECT * FROM HighSalaryEmployee;

CREATE INDEX idx_employee_lastname
ON Employee (LastName);