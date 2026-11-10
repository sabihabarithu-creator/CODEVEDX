-- HR ANALYTICS USING SQL
-- Student project sample dataset
-- Database: hr_analytics
-- Table: employees
--
-- This script is designed to be safely re-run:
-- CREATE TABLE IF NOT EXISTS avoids recreating the table.
-- INSERT ... ON CONFLICT DO NOTHING avoids duplicate employee rows.
-- Salary UPDATE restores the final sample salary values.

-- =========================================================
-- 1. CREATE EMPLOYEES TABLE
-- =========================================================

CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    department VARCHAR(50),
    job_role VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    experience_years INT
);

-- =========================================================
-- 2. INSERT SAMPLE EMPLOYEE DATA
-- =========================================================

INSERT INTO employees
(employee_id, employee_name, age, gender, department, job_role, salary, hire_date, experience_years)
VALUES
(1, 'Arun', 25, 'Male', 'IT', 'Developer', 45000, '2023-01-10', 3),
(2, 'Priya', 28, 'Female', 'HR', 'HR Executive', 35000, '2022-06-15', 4),
(3, 'Rahul', 30, 'Male', 'Finance', 'Accountant', 50000, '2021-03-20', 5),
(4, 'Divya', 24, 'Female', 'IT', 'Tester', 30000, '2024-02-12', 2),
(5, 'Karthik', 32, 'Male', 'Sales', 'Sales Executive', 40000, '2020-08-05', 6),
(6, 'Meena', 27, 'Female', 'HR', 'Recruiter', 32000, '2023-05-18', 3),
(7, 'Vijay', 35, 'Male', 'IT', 'Manager', 75000, '2019-04-02', 8),
(8, 'Anitha', 29, 'Female', 'Finance', 'Analyst', 48000, '2022-09-25', 4),
(9, 'Suresh', 26, 'Male', 'Sales', 'Sales Executive', 38000, '2023-11-10', 3),
(10, 'Kavya', 31, 'Female', 'IT', 'Developer', 55000, '2021-07-14', 5),
(11, 'Ramesh', 28, 'Male', 'HR', 'HR Executive', 36000, '2022-01-08', 4),
(12, 'Nila', 23, 'Female', 'Finance', 'Accountant', 33000, '2024-06-20', 1)
ON CONFLICT (employee_id) DO NOTHING;

-- =========================================================
-- 3. UPDATE FINAL SAMPLE SALARIES
-- =========================================================

UPDATE employees
SET salary = CASE employee_id
    WHEN 1 THEN 50000
    WHEN 2 THEN 58000
    WHEN 3 THEN 75000
    WHEN 4 THEN 38000
    WHEN 5 THEN 90000
    WHEN 6 THEN 45000
    WHEN 7 THEN 150000
    WHEN 8 THEN 60000
    WHEN 9 THEN 42000
    WHEN 10 THEN 70000
    WHEN 11 THEN 55000
    WHEN 12 THEN 30000
END
WHERE employee_id BETWEEN 1 AND 12;

-- =========================================================
-- 4. HR ANALYSIS QUERIES
-- =========================================================

-- Query 1: Total number of employees
SELECT COUNT(*) AS total_employees
FROM employees;

-- Query 2: Department-wise employee count
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department
ORDER BY employee_count DESC;

-- Query 3: Average salary by department
SELECT department,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY department
ORDER BY average_salary DESC;

-- Query 4: Highest-paid employee
SELECT employee_name, department, job_role, salary
FROM employees
ORDER BY salary DESC
LIMIT 1;

-- Query 5: Department-wise total salary expense
SELECT department,
       SUM(salary) AS total_salary_expense
FROM employees
GROUP BY department
ORDER BY total_salary_expense DESC;

-- Query 6: Gender-wise employee count
SELECT gender,
       COUNT(*) AS employee_count
FROM employees
GROUP BY gender;

-- Query 7: Experience-wise employee details
SELECT employee_name, department, experience_years
FROM employees
ORDER BY experience_years DESC;

-- Query 8: Year-wise employee hiring count
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year,
       COUNT(*) AS employee_count
FROM employees
GROUP BY hire_year
ORDER BY hire_year;

-- Query 9: Overall salary ranking
SELECT employee_name, department, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- Query 10: Highest-paid employee in each department
SELECT department, employee_name, salary
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY department
               ORDER BY salary DESC
           ) AS salary_rank
    FROM employees
) ranked_employees
WHERE salary_rank = 1;

-- Query 11: Employees earning above the overall average salary
SELECT employee_name, department, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- Query 12: Salary ranking within each department
SELECT employee_name, department, salary,
       RANK() OVER (
           PARTITION BY department
           ORDER BY salary DESC
       ) AS department_salary_rank
FROM employees;

-- Query 13: Experience-level analysis
SELECT
    CASE
        WHEN experience_years >= 6 THEN 'Senior'
        WHEN experience_years >= 3 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS experience_level,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY experience_level
ORDER BY average_salary DESC;

-- Query 14: Department-wise minimum and maximum salary
SELECT department,
       MIN(salary) AS minimum_salary,
       MAX(salary) AS maximum_salary
FROM employees
GROUP BY department
ORDER BY maximum_salary DESC;

-- Query 15: Overall salary gap
SELECT employee_name, department, salary,
       MAX(salary) OVER() - MIN(salary) OVER() AS overall_salary_gap
FROM employees;

-- Query 16: Total monthly salary expense and average salary
SELECT SUM(salary) AS total_monthly_salary_expense,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees;

-- Query 17: Salary-range-wise employee count
SELECT
    CASE
        WHEN salary >= 100000 THEN 'Above 1 Lakh'
        WHEN salary >= 50000 THEN '50K - 99K'
        WHEN salary >= 30000 THEN '30K - 49K'
        ELSE 'Below 30K'
    END AS salary_range,
    COUNT(*) AS employee_count
FROM employees
GROUP BY salary_range
ORDER BY MIN(salary) DESC;

-- Query 18: Experience-wise average salary
SELECT experience_years,
       COUNT(*) AS employee_count,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY experience_years
ORDER BY experience_years DESC;

-- Query 19: Annual salary of each employee
SELECT employee_name, department,
       salary AS monthly_salary,
       salary * 12 AS annual_salary
FROM employees
ORDER BY annual_salary DESC;

-- Query 20: Employees hired before 2023
SELECT employee_name, department, hire_date, experience_years
FROM employees
WHERE hire_date < '2023-01-01'
ORDER BY hire_date;

-- Query 21: Job role-wise employee count and average salary
SELECT job_role,
       COUNT(*) AS employee_count,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY job_role
ORDER BY employee_count DESC;

-- Query 22: Employees with more than 3 years of experience
SELECT employee_name, department, job_role,
       experience_years, salary
FROM employees
WHERE experience_years > 3
ORDER BY experience_years DESC;

-- Query 23: Display all employee records
SELECT *
FROM employees
ORDER BY employee_id;

-- End of HR Analytics SQL script.
