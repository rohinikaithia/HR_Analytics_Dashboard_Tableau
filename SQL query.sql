select * from hrdata

--employee count
select sum(employee_count) as employee_count from hrdata
--where education = 'High School'
--where department = 'Sales'
where education_field = 'Medical'

--attrition count
select count(attrition) from hrdata
where attrition = 'Yes' and department ='R&D' and education_field='Medical' and education ='High School'

--attrition rate
select round(((select count(attrition) from hrdata where attrition ='Yes' and department = 'Sales') / 
sum(employee_count)) *100,2) from hrdata
where department = 'Sales'

--Active employee
select sum(employee_count) - (select count(attrition) from hrdata where attrition = 'Yes' and gender = 'Male') 
from hrdata 
where gender = 'Male'

--Average age
select round(avg(age),0) as avg_age from hrdata

-- attrition by gender
select gender, count(attrition) from hrdata
where attrition = 'Yes' and education= 'High School'
group by gender
ORDER BY count(attrition) DESC

--Department wise attrition
select department, count(attrition) from hrdata
where attrition= 'Yes'
GROUP BY department
ORDER BY COUNT(attrition) DESC

-- percentage of attrition department wise
select department, count(attrition),
round((cast(count(attrition) as numeric)
	  /(select count(attrition) from hrdata where attrition= 'Yes'and gender= 'Female'))*100,2) as pct --pct i.e. percentage of total
from hrdata
where attrition= 'Yes' and gender= 'Female'
GROUP BY department
ORDER BY COUNT(attrition) DESC

--No. of employees by age group
select age, sum(employee_count) from hrdata
where department ='R&D'
group by age
order by age

--Education field wise attrition
select education_field, count(attrition) from hrdata
where attrition='Yes' and department='Sales'
group by education_field
order by count(attrition) DESC

--Attrition rate by gender for different age group
select age_band, gender, count(attrition), 
round((cast(count(attrition) as numeric)/
(select count(attrition) from hrdata where attrition='Yes'))*100,2) as pct
from hrdata
where attrition='Yes' 
group by age_band, gender
order by age_band, gender

--Job satisfaction rating
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * 
FROM crosstab(
    'SELECT job_role,job_satisfaction,sum(employee_count)
	FROM hrdata
	GROUP BY job_role,job_satisfaction
	ORDER BY job_role,job_satisfaction'
	) AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
	ORDER BY job_role;




