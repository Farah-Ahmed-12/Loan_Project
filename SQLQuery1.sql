select count(*) as Toatal_Rows
from dbo.LoanData_Raw;

select count(*) as Total_Rows ,
	sum(case when  age is null then 1 else 0 end ) as age_missing,
	sum(case when employ is null then 1 else 0 end ) as employee_missing,
	sum(case when address is null then 1 else 0 end) as address_missing,
	sum(case when income is null then 1 else 0 end ) as income_missing,
	sum(case when debtinc is null then 1 else 0 end ) as debtinc_missing,
	sum(case when creddebt is null then 1 else 0 end ) as creddebt_missing,
	sum(case when othdebt is null then 1 else 0 end ) as othdebt_missing,
	sum(case when education_level is null then 1 else 0 end ) as education_level_missing,
	sum(case when nullif (trim([default]),'') is null then 1 else 0 end ) as default_missing

	from LoanData_Raw;
	
select * from LoanData_Raw;

--duplicated values--
select age , employ , address , income , debtinc , creddebt , othdebt , education_level , [default],
COUNT(*) AS duplicated_count 
from LoanData_Raw 
group by age , employ , address , income , debtinc , creddebt , othdebt , education_level , [default]
having count(*)>1 
ORDER BY duplicated_count DESC;

SELECT
    source_file,
    COUNT(*) AS row_count
FROM LoanData_Raw
GROUP BY source_file
ORDER BY source_file;

--remove duplicated values--
WITH DuplicateRows AS (
    SELECT *,
    ROW_NUMBER() OVER (
    PARTITION BY
                age,
                employ,
                address,
                income,
                debtinc,
                creddebt,
                othdebt,
                education_level,
                [default]
            ORDER BY source_file
    ) AS rn
    FROM LoanData_Raw
)
DELETE FROM DuplicateRows
WHERE rn > 1;

--check duplected values--
SELECT
    age,
    employ,
    address,
    income,
    debtinc,
    creddebt,
    othdebt,
    education_level,
    [default],
    COUNT(*) AS duplicate_count
FROM LoanData_Raw
GROUP BY
    age,
    employ,
    address,
    income,
    debtinc,
    creddebt,
    othdebt,
    education_level,
    [default]
HAVING COUNT(*) > 1;

select count(*) as Total_Rows ,
	sum(case when  age is null then 1 else 0 end ) as age_missing,
	sum(case when employ is null then 1 else 0 end ) as employee_missing,
	sum(case when address is null then 1 else 0 end) as address_missing,
	sum(case when income is null then 1 else 0 end ) as income_missing,
	sum(case when debtinc is null then 1 else 0 end ) as debtinc_missing,
	sum(case when creddebt is null then 1 else 0 end ) as creddebt_missing,
	sum(case when othdebt is null then 1 else 0 end ) as othdebt_missing,
	sum(case when education_level is null then 1 else 0 end ) as education_level_missing,
	sum(case when nullif (trim([default]),'') is null then 1 else 0 end ) as default_missing

	from LoanData_Raw;
	
select * from LoanData_Raw;

select
    min(age) as min_age ,max(age) as max_age ,
    min(employ) as min_employ ,max(employ) as max_employ ,
    min(address) as min_address ,max(address) as max_address ,
    min(income) as min_income ,max(income) as max_income ,
    min(debtinc) as min_debtinc ,max(debtinc) as max_debtinc ,
    min(creddebt) as min_creddebt ,max(creddebt) as max_creddebt ,
    min(othdebt) as min_othdebt ,max(othdebt) as max_othdebt ,
    min(education_level) as min_education_level ,max(education_level) as max_education_level 
   from LoanData_Raw;

--cleaning data--
Update LoanData_Raw
set age = null 
where age <18 or age >100

update LoanData_Raw 
set [default] = REPLACE([default],'''','');
update LoanData_Raw 
set [default] = REPLACE([default],':','');
Alter table LoanData_Raw Alter column [default] int; 

--check invalid values--
select count(*) as Total_Rows,
    sum(case when employ <0 or employ>50 then 1 else 0 end ) as invalid_employ ,
    sum(case when address <0 or address>50 then 1 else 0 end ) as invalid_address,
    sum(case when income <=0  then 1 else 0 end ) as invalid_income,
    sum(case when debtinc <0 or debtinc>100 then 1 else 0 end ) as invalid_debtinc,
    sum(case when creddebt <0 then 1 else 0 end ) as invalid_creddebt,
    sum(case when othdebt <0  then 1 else 0 end ) as invalid_othdebt,
    sum(case when education_level NOT BETWEEN 1 AND 5 then 1 else 0 end) AS invalid_education,
    sum(case when TRY_CAST([default] AS int) NOT IN (0,1)THEN 1 ELSE 0 end) AS invalid_default
    from LoanData_Raw;

--create cleaned view--
CREATE VIEW vw_LoanData_Cleaned AS
SELECT
    age,
    employ AS employment_years,
    address AS address_years,
    income AS annual_income,
    debtinc AS debt_income_ratio,
    creddebt AS credit_debt,
    othdebt AS other_debt,
    education_level,
    [default] AS default_status
FROM LoanData_Raw;    
