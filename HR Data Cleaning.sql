## SQL DATA CLEANING

CREATE DATABASE projects;

## Specify which database to use
USE projects;

##View database
SELECT * FROM hr;

## Change column header
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

## Check data types
DESCRIBE hr;

## Clean birthdate
SELECT birthdate FROM hr;

## To get around security
SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

SELECT birthdate FROM hr;

## Change data type of birthdate column
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

## Update hire_date
SELECT hire_date FROM hr;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

SELECT hire_date FROM hr;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

## Update termdate
SELECT termdate FROM hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

## Creating an age column
ALTER TABLE hr ADD COLUMN age INT;

SELECT * FROM hr;

## set age column
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

## FETCH MINIMUM AND MAX AGES
SELECT 
	min(age) AS youngest, 
    max(age) AS oldest
FROM hr;

## COUNT ALL WHO ARE LESS THAN 18
SELECT count(*) 
FROM hr 
WHERE age < 18;