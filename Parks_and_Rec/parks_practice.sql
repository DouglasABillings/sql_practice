SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT first_name, last_name, birth_date, age, (age + 10) * 10
FROM parks_and_recreation.employee_demographics;
# PEMDAS

SELECT DISTINCT first_name, gender
FROM parks_and_recreation.employee_demographics;

SELECT *
FROM employee_salary
WHERE first_name = 'Leslie';

SELECT *
FROM employee_salary
WHERE salary <= 50000;

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01';

-- AND OR NOT -- Logical Operators

select *
from employee_demographics
where birth_date > '1985-01-01'
or gender = 'male';

select *
from employee_demographics
where (first_name = 'Leslie' AND age = 44) OR age > 55;

-- % and _ -- LIKE Statement
select *
from employee_demographics
where first_name LIKE 'A%';

select *
from employee_demographics
where first_name like 'a___';

select *
from employee_demographics
where birth_date like '1989%';

-- Group By

select gender
from employee_demographics
group by gender;

SELECT gender, avg(age)
from employee_demographics
group by gender;

SELECT gender, AVG(age), MAX(age)
FROM employee_demographics
GROUP BY gender;

-- Order By

SELECT *
FROM employee_demographics
ORDER BY first_name DESC;

SELECT *
FROM employee_demographics
ORDER BY gender, age DESC;

-- Having and Where

SELECT *
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;

-- Aliasing

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender;

-- Joins

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT demo.employee_id, age, occupation
FROM employee_demographics AS demo
JOIN employee_salary AS sal
	ON demo.employee_id = sal.employee_id;
    
SELECT *
FROM employee_demographics AS demo
LEFT JOIN employee_salary AS sal
	ON demo.employee_id = sal.employee_id;
    
    
-- Self Join

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id;

-- Join Multiple Tables

SELECT *
FROM employee_demographics AS demo
JOIN employee_salary AS sal
	ON demo.employee_id = sal.employee_id
JOIN parks_departments pd
	ON sal.dept_id - pd.department_id;
    
SELECT *
FROM parks_departments;

-- Unions

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name, last_name, 'OLD MAN' AS Label
FROM employee_demographics
WHERE age > 40 AND gender LIKE 'M%'
UNION
SELECT first_name, last_name, 'OLD WOMAN' AS Label
FROM employee_demographics
WHERE age > 40 AND gender LIKE 'F%'
UNION
SELECT first_name, last_name, 'HIGH SAL' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;


-- String Functions

SELECT length('skyfall');

SELECT first_name, UPPER(first_name) AS characters
FROM employee_demographics
ORDER BY characters;

SELECT TRIM('  SKYFALL  ');

SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name, 3, 2),
SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a', '3')
FROM employee_demographics;

SELECT LOCATE('g', 'Doug');

SELECT first_name, LOCATE('An', first_name)
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;

-- Case Statements

SELECT first_name, last_name,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'OLD'
END AS Age
FROM employee_demographics;

-- Pay Increase and Bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10%
SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary + (salary * 0.07)
END AS New_Salary
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary;


-- Subqueries


SELECT *
FROM employee_demographics
WHERE employee_id IN
	(SELECT employee_id
    FROM employee_salary
    WHERE dept_id = 1);

SELECT first_name, salary,
	(SELECT AVG(salary)
    FROM employee_salary)
FROM employee_salary;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT AVG(maximum)
FROM (SELECT gender, AVG(age) AS average, MAX(age) AS maximum, MIN(age) AS minimum, COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Agg_Table;

-- Window Functions

SELECT gender, AVG(salary) AS average_salary
FROM employee_demographics demo
JOIN employee_salary sal
	ON demo.employee_id = sal.employee_id
GROUP BY gender;


SELECT demo.first_name, demo.last_name, gender,
SUM(salary) OVER(PARTITION BY gender ORDER BY demo.employee_id) AS Rolling_Total
FROM employee_demographics demo
JOIN employee_salary sal
	ON demo.employee_id = sal.employee_id;

SELECT demo.employee_id, demo.first_name, demo.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics demo
JOIN employee_salary sal
	ON demo.employee_id = sal.employee_id;

-- CTEs Preferred
WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS (
SELECT gender, AVG(salary) average_sal, MAX(salary) maximum_sal, MIN(salary) minimum_sal, COUNT(salary) count_sal
FROM employee_demographics demo
JOIN employee_salary sal
	ON demo.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example;


SELECT AVG(average_sal)
FROM(SELECT gender, AVG(salary) average_sal, MAX(salary) maximum_sal, MIN(salary) minimum_sal, COUNT(salary) count_sal
FROM employee_demographics demo
JOIN employee_salary sal
	ON demo.employee_id = sal.employee_id
GROUP BY gender
) example_subquery;

WITH CTE_Example AS (
SELECT employee_id, gender, birth_date
FROM employee_demographics demo
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS (
SELECT *
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id;

-- Temporary Tables

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);
SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES('Alex', 'Freberg', 'Lord of the Rings: The Two Towers');

SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;


-- Stored Procedures

CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();


DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;


CALL large_salaries3();

-- Perameters

DELIMITER $$
CREATE PROCEDURE large_salaries4(identification_number INT)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = identification_number;
END $$
DELIMITER ;

CALL large_salaries4(1);

-- Triggers and Events

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;
    
INSERT INTO employee_salary(employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Pope', 'Leo', 'Religious Order', '10000', NULL);
    
-- EVENTS

SELECT *
FROM employee_demographics;


DELIMITER $$
CREATE EVENT retire_employees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
	FROM employee_demographics
    WHERE age >= 60;

END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';
