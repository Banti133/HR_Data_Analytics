-- ---------EXPLORATORY DATA ANALYSIS------------- --
-- ---Questions--- --

-- -----------What is the gender breakdown of employees in the company?------------ --
select gender, COUNT(*) AS count FROM hr WHERE age >= 18 group by gender;

-- ----------What is the race/ethnicity breakdown of employees in the company?------- --
select race, COUNT(*) AS count FROM hr WHERE age >= 18 group by race order by count desc;

-- ----------What is the age distribution of employees in the company?--------- --
select MIN(age) AS youngest, MAX(age) AS oldest FROM hr WHERE age >= 18;
select FLOOR(age/10)*10 AS age_group, COUNT(*) AS count FROM hr WHERE age >= 18 group by FLOOR(age/10)*10;
select (CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END) AS age_group, COUNT(*) AS count FROM hr WHERE age >= 18 group by age_group order by age_group;
  
select (CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END) AS age_group, gender,COUNT(*) AS count
FROM hr WHERE age >= 18 GROUP BY age_group, gender order by age_group, gender;

-- --------------How many employees work at headquarters versus remote locations?------------- --
select location, COUNT(*) as count FROM hr WHERE age >= 18 group by location;

-- --------------What is the average length of employment for employees who have been terminated?------- --
select round(avg(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment
FROM hr WHERE termdate <> '' AND termdate <= CURDATE() AND age >= 18;

select round(avg(DATEDIFF(termdate, hire_date)),0)/365 AS avg_length_of_employment
FROM hr WHERE termdate <= CURDATE() AND age >= 18;

-- ---------How does the gender distribution vary across departments?-------- --
select department, gender, COUNT(*) as count FROM hr WHERE age >= 18 group by department, gender order by department;

-- ---------------What is the distribution of job titles across the company?--------- --
select jobtitle, COUNT(*) as count FROM hr WHERE age >= 18 group by jobtitle order by jobtitle desc;

-- ----------Which department has the highest turnover rate?--------- --
select department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '' THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr WHERE age >= 18 group by department order by termination_rate desc;

-- ---------What is the distribution of employees across locations by state?-------- --
select location_state, COUNT(*) as count FROM hr WHERE age >= 18 group by location_state order by count desc;

-- --------How has the company's employee count changed over time based on hire and term dates?------- --
select 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> '' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> '' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate <> '' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM hr WHERE age >= 18 group by  YEAR(hire_date) order by  YEAR(hire_date) ASC;

select 
    year, 
    hires, 
    terminations, 
    (hires - terminations) AS net_change,
    ROUND(((hires - terminations) / hires * 100), 2) AS net_change_percent
FROM (
    select 
        YEAR(hire_date) AS year, 
        COUNT(*) AS hires, 
        SUM(CASE WHEN termdate <> '' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
FROM hr WHERE age >= 18 group by YEAR(hire_date)) subquery order by year ASC;

-- -------What is the tenure distribution for each department?----- --
select department, round(avg(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr WHERE termdate <= CURDATE() AND termdate <> '' AND age >= 18 group by department;