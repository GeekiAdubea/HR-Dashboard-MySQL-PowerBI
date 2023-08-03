## SQL DATA ANALYSIS

-- 1. What is the gender distribution?
SELECT gender, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown?
SELECT race, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race;

-- 3. What is the age distribution?
SELECT 
min(age) AS youngest,
max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
		ELSE '65+'
	END AS age_group, gender,
    count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
		ELSE '65+'
	END AS age_group,
    count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

-- 4. How many employees work at HQ VS remote?
SELECT location, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the avg length of employment for employees terminated?
SELECT 
	round(avg(datediff(termdate, hire_date))/365,0) AS avg_emp_length
FROM hr
WHERE termdate <> '0000-00-00' AND age >=18 AND termdate <= curdate();

-- 6. How does the gender distribution vary acress depts and job titles?
SELECT
	department, jobtitle, gender, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

SELECT
	department, gender, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles?
SELECT jobtitle, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle;

-- 8. What department has the highest employee turnover rate?
SELECT 
	department, count(*) AS count
FROM hr
WHERE termdate <> '0000-00-00' AND age >=18 AND termdate <= curdate()
GROUP BY department
ORDER BY count(*) DESC
LIMIT 1;

SELECT 
	department,
    total_count, 
    terminated_count, 
    terminated_count/total_count AS term_rate
FROM (
	SELECT 
		department,
        count(*) AS total_count,
        SUM(CASE WHEN termdate != '0000-00-00' AND termdate <= curdate()
			THEN 1
            ELSE 0
            END) AS terminated_count
	FROM hr
    WHERE age >= 18
    GROUP BY department
    ) AS sub
ORDER BY term_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, count(*) AS count
from hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
	year,
    hires, 
    terminations,
    hires-terminations as net_change,
    round((hires-terminations)/hires * 100, 2) AS net_change_percent
FROM (
	SELECT 
		year(hire_date) as year,
        count(*) as hires,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() 
			THEN 1
            ELSE 0
            END) AS terminations
	FROM hr
	WHERE age >= 18
    GROUP BY year
	) AS sub
ORDER BY year;


-- 11. What is the tenure dictribution for each department?
SELECT department, round(avg(datediff(termdate, hire_date)/365), 0) as avg_tenure
FROM hr
WHERE termdate <> '0000-00-00' AND termdate <= curdate() AND age >= 18
GROUP BY department
ORDER BY department;




