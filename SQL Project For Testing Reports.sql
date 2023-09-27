use hrdata;
select * from hrdata;

#Employee Count

select sum(employee_count) from hrdata;

#Attrition Count

select count(attrition) from hrdata where attrition = 'Yes';

#Attrition Rate

select round(((select count(attrition) from hrdata where attrition = 'Yes') / sum(employee_count)) *100,2) from hrdata;

#Active Employees

select sum(active_employee) from hrdata;

#Average Age

select round(avg(age),0) from hrdata;

#Attrition Count By Gender

select gender, count(attrition) from hrdata where attrition = 'Yes' 
group by gender
order by count(attrition) desc;

# Department Wise Attrition

select department, count(attrition) from hrdata where attrition = 'Yes' 
group by department
order by count(attrition) desc;

# Department Wise Attrition(Percent Value)

select department, count(attrition), round((count(attrition) / (select count(attrition) from hrdata where attrition= 'Yes')) * 100,2) as pct from hrdata
where attrition='Yes' # For applying filter use and condition after where attrition ='Yes'(where attrition ='Yes' and gender = 'Male') in both lines 
group by department 
order by count(attrition) desc;

#No. of Employees by Age Group

select age , sum(employee_count) as Employee_Count from hrdata
group by age
order by age ;

#Attrition Count by Education Field

select education_field, Count(attrition) from hrdata 
where attrition = 'Yes'
group by education_field
order by Count(attrition);

#Attrition Rate by gender for different Age Groups

select gender,age_band, count(attrition), round((count(attrition)/(select count(attrition) from hrdata where attrition = 'Yes')) *100,2) 
from hrdata
where attrition = 'Yes'
group by age_band, Gender
order by age_band, gender;

#Job Satisfaction Rating

SELECT job_role,sum(employee_count) as total, 
SUM(CASE WHEN job_satisfaction = 1 THEN employee_count else 0 END) AS 1s,
SUM(CASE WHEN job_satisfaction = 2 THEN employee_count else 0 END) AS 2s,
SUM(CASE WHEN job_satisfaction = 3 THEN employee_count else 0 END) AS 3s,
SUM(CASE WHEN job_satisfaction = 4 THEN employee_count else 0 END) AS 4s
FROM hrdata
GROUP BY job_role