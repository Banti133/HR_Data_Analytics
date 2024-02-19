-- -------creation of human resource database------ --
create database hr_analysis;
use hr_analysis;
-- ----select case---- --
select * from hr;
-- ---------------------------DATA CLEANING------------------------- --

-- -------changed the column name--------- --
alter table hr change column ï»¿id emp_id VARCHAR(20) NULL;
DESCRIBE hr;
select birthdate FROM hr;

SET sql_safe_updates = 0;
-- ---------birthdate format-------- --
UPDATE hr SET birthdate = (CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END);
-- --------------birthdate column modified-------- --
alter table hr modify column birthdate date;

select hire_date from hr;
-- ---------hiredate format-------- --
update hr SET hire_date = (CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END);
-- --------------hiredate column modified-------- --
alter table hr modify column hire_date date;

select termdate from hr;

alter table hr add column age INT;

update hr SET age = timestampdiff(YEAR, birthdate, CURDATE());
-- ---------displaying min and max age---------- --
select min(age) AS youngest, max(age) AS oldest from hr;
-- --------count all rows where age is less then 18------------ --
select count(*) from hr WHERE age < 18;
-- ------count where termdate is greater than currentdate------- --
select count(*) from hr where termdate > CURDATE();
-- -----show location from table---------- --
SELECT location FROM hr;