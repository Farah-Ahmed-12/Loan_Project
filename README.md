Loan Default & Credit Risk Analysis

Project Overview

An end-to-end data analysis project focused on analyzing customer financial and credit information to identify patterns associated with loan default risk.
The project uses SQL Server for data preparation and cleaning, followed by Power BI for data analysis, visualization, and insight generation.
The dataset contains 753 unique records after data consolidation and duplicate removal.

Tools & Technologies
SQL
Power BI
DAX
Power Query


The project started with three CSV files representing different versions of the dataset:
LoanData_Raw_v1.0.csv
LoanData_Preprocessed_v1.1.csv
LoanData_Preprocessed_v1.2.csv

The three files contain the same business fields but different column orders and overlapping records.

Main Variables
Column	Description
age	Applicant age
employ	Years of employment
address	Years at current address
income	Annual income in thousands of dollars
debtinc	Debt-to-income ratio
creddebt	Credit debt
othdebt	Other debt
education_level	Education level
default	Loan default status
Data Preparation & SQL Cleaning

SQL Server was used to consolidate and prepare the three source files before analysis.

1. Data Consolidation
The three CSV datasets were imported into SQL Server as separate tables and then consolidated into a single table:
LoanData_Raw

The data was combined using UNION ALL to preserve all source records before the duplicate-cleaning stage.
A source_file column was also added to maintain the origin of each record.

Initial row count:
1,885 records

2. Missing Value Analysis
Missing values were checked across all variables using SQL.

Initial missing values were identified in:
age
income
education_level

No missing values were found in the other variables.

After duplicate removal, the dataset contained:

20 missing age values
37 missing income values
20 missing education level values

The missing values were intentionally retained rather than imputed or removed to avoid introducing assumptions into the original data.

3. Duplicate Detection

Exact duplicate records were identified by grouping records across all analytical columns.
The analysis showed substantial overlap between the three dataset versions, indicating that they were different versions containing many of the same records rather than three independent datasets.

Duplicates were removed using ROW_NUMBER() with all analytical columns as the partition criteria.

Only one copy of each identical record was retained.

After deduplication:

1,885 → 753 records

4. Data Validation
Minimum and maximum values were examined for the numerical variables to identify potential data-quality issues.

The following variables were validated:
Age
Employment years
Address years
Annual income
Debt-to-income ratio
Credit debt
Other debt
Education level
Default status

Business-rule checks were then applied to identify invalid values.

5. Invalid Age Handling

An age value of 136 was identified as outside the defined valid range.
A valid age range of 18–100 years was applied.

The invalid value was converted to NULL rather than deleting the entire record, preserving the remaining information in that row.

6. Default Status Cleaning

The default field contained formatting characters in some records, such as quotation marks and colons.
These characters were removed using SQL string replacement functions.
The column was then converted to an integer data type.
The final validation confirmed that the default status values were restricted to:

0 = No Default
1 = Default

7. Data Type Validation
Data types were reviewed and adjusted where necessary to support reliable analysis.
The final dataset uses appropriate numeric data types for:
Age
Employment years
Address years
Income
Debt-to-income ratio
Credit debt
Other debt
Education level
Default status
Cleaned SQL View

After completing the cleaning and validation process, a dedicated SQL view was created for analysis:

vw_LoanData_Cleaned

The view provides business-friendly column names:
Original Column	Cleaned Column
age	age
employ	employment_years
address	address_years
income	annual_income
debtinc	debt_income_ratio
creddebt	credit_debt
othdebt	other_debt
education_level	education_level
default	default_status



