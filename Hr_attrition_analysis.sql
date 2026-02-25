
-- Total number of employees and attrition rate?
select count(*) as total_employees,
	   sum(case when Attrition ='Yes' then 1 else 0 end) as total_attrition,
       round(100 * sum(case when Attrition ='Yes' then 1 else 0 end) / count(*),2) as attrition_rate
       from employees;


-- Department-wise attrition rate?
select department,
       round(100 * sum(case when Attrition ='Yes' then 1 else 0 end) / count(*),2) as attrition_rate
 from employees
 group by Department;


-- Average salary of employees who left vs stayed?
select Attrition,
     round(avg(MonthlyIncome),2) as monthly_income
 from employees
 group by Attrition;


-- Is attrition higher among employees who work overtime?
select OverTime,
      round(100*sum(case when Attrition ='Yes' then 1 else 0 end)/count(*),2 ) as attrition_rate
from employees
group by OverTime;       


-- Does low job satisfaction lead to higher attrition?
select JobSatisfaction,
      round(100*sum(case when Attrition ='Yes' then 1 else 0 end)/count(*),2 ) as attrition_rate
from employees
group by JobSatisfaction
order by JobSatisfaction;


-- Impact of years since last promotion on attrition?
select YearsSinceLastPromotion,
      round(100*sum(case when Attrition ='Yes' then 1 else 0 end)/count(*),2 ) as attrition_rate
from employees
group by YearsSinceLastPromotion
order by YearsSinceLastPromotion;


-- Work-life balance vs attrition trend?
select WorkLifeBalance,
      round(100*sum(case when Attrition ='Yes' then 1 else 0 end)/count(*),2 ) as attrition_rate
from employees
group by WorkLifeBalance
order by WorkLifeBalance;


-- Identify top high-risk employees
-- (low salary + overtime + no promotion)
select * 
from employees
where MonthlyIncome<(select avg(MonthlyIncome)
                     from employees
                     )
          and
 OverTime='Yes'
      and
JobSatisfaction<=2  ;   


-- Salary percentile vs attrition 
select Attrition,
salary_quartile,
count(*)
from(
select  Attrition,
ntile(4) over(order by MonthlyIncome) as salary_quartile
from employees)t
group by Attrition,salary_quartile
order by salary_quartile desc;


-- Department retention ranking 
with dept_retention as (
select department,
       round(100 * sum(case when Attrition ='Yes' then 1 else 0 end) / count(*),2) as attrition_rate
 from employees
 group by Department)
 select *,
 rank() over(order by attrition_rate desc) as dept_ret_rnk
 from dept_retention;


-- Years-at-company threshold where attrition spikes?
select YearsAtCompany,
       round(100 * sum(case when Attrition ='Yes' then 1 else 0 end) / count(*),2) as attrition_rate
 from employees
 group by YearsAtCompany
 order by attrition_rate;












