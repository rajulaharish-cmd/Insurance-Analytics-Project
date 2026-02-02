# Insurance Analytics Project

## 📌 Project Overview
This project focuses on analyzing insurance data to identify trends in premiums,
claims, customer behavior, and business performance using data analytics tools.

## 🛠 Tools & Technologies
- Power BI: Built interactive dashboards with KPI cards, trend analysis, and DAX measures to analyze premiums, claims, loss ratio, and retention by importing data fron mysql.
-  Tableau: Developed visual dashboards for performance comparison, trend analysis,segment-level insights and using filter.
-  Microsoft Excel: Performed data cleaning, validation, and exploratory analysis using pivot tables and formulas.
-  MySQL: Extracted and prepared data using joins, aggregations, and filters to support reporting and dashboard development.


## 📊 Key Analysis
- Cross sell, Renewal, New Target insights
- KPI dashboards for business decisions
- Revenue by employees analysis
- Revenue by product insights 
- Claims ratio and loss analysis
- Customer segmentation insights


### Technical Highlights
- Designed a star schema data model in Power BI to support scalable and accurate reporting
- Created DAX measures for critical KPIs including Total Premium, Claims Ratio, and Loss Ratio
- Built SQL queries using joins and aggregations for data extraction, validation, and transformation
- Developed Calculated Fields and Parameters in Tableau to enable dynamic filtering and interactive analysis
- Implemented Parameters in Power BI to support scenario-based analysis and flexible KPI views

## 📂 Repository Structure
- PowerBI/        → Power BI dashboards (.pbix)
- Tableau/        → Tableau workbooks & public links
- Excel/          → Excel analysis files
- SQL/            → MySQL queries
- Screenshots/    → Dashboard images


- Tableau Link
https://public.tableau.com/views/InsuranceAnalyticsKPI/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

  ![Power BI](https://github.com/user-attachments/assets/e8c25a9a-1580-4195-aee6-e5f6c01325ac)
[Analytics SQL.sql](https://github.com/user-attachments/files/25020625/Analytics.SQL.sql)
Create database insurance_analytics;
use insurance_analytics;
select * from brokerage;
describe brokerage;
Alter table brokerage 
modify policy_start_date date,
modify policy_end_date date,
modify last_updated_date date,
modify amount decimal (10,2);
Alter table brokerage modify income_due_date date;

select * from fees;
select * from individual budgets;
select * from invoice;
describe invoice;
describe fees;
Alter table invoice 
modify invoice_date date,
modify income_due_date date;

Alter table fees 
modify income_due_date date;

select * from meeting;
select * from opportunity;
describe meeting;
describe opportunity;

Alter table meeting
 modify meeting_date date;
 
Alter table opportunity modify closing_date date;

select * from individual_budgets;
rename table `individual budgets`to individual_budgets;

--- No Meeting by account executive
select `account executive`, count(meeting_date) as No_of_meetings
from meeting
group by `account executive`;

--- cross sell target achvd
select concat((select sum(amount) from brokerage where income_class = 'Cross Sell')+ 
(select sum(amount) from fees where income_class = 'Cross Sell'),"K") as new_target;

--- New target achvd
select concat((select sum(amount) from brokerage where income_class = 'new')+ 
(select sum(amount) from fees where income_class = 'new'),"K") as new_target;

--- Renewal target achvd
select concat((select sum(amount) from brokerage where income_class = 'Renewal')+ 
(select sum(amount) from fees where income_class = 'Renewal'),"K") as new_target;


--- Renewal achvd%
select concat(round((sum(brokerage.amount) + sum(fees.amount))/sum(individual_budgets.`Renewal Budget`)*100,2), "%")
 as Renewal_Achvd_targtperc from brokerage
inner join fees on fees.`Account Exe ID`=brokerage.`Account Exe ID`
inner join individual_budgets on individual_budgets.`Account Exe ID`=brokerage.`Account Exe ID`
where brokerage.income_class="Renewal";


--- cross sell achvd%
select concat(round((sum(brokerage.amount) + sum(fees.amount))/sum(individual_budgets.`Cross sell bugdet`)*100,2), "%")
 as crosssell_Achvd_perc from brokerage
inner join fees on fees.`Account Exe ID`=brokerage.`Account Exe ID`
inner join individual_budgets on individual_budgets.`Account Exe ID`=brokerage.`Account Exe ID`
where brokerage.income_class='Cross Sell' and fees.income_class='Cross Sell';

--- New achvd



--- Yearly meeting count
select year(meeting_date) as year,count(year(meeting_date)) as meeting_count
from meeting
group by year(meeting_date);
 
-- No of Invoice by Account Exec

select `employee name`,count(income_class) as `no_of_invoice_by_Accnt_Exec`
from individual_budgets inner join invoice
on invoice.`Account Exe ID`=individual_budgets.`Account Exe ID`
group by `employee name`
order by `no_of_invoice_by_Accnt_Exec` desc;

--- -- crosssell , renewal , new target
select sum(`new budget`) as `new budget target`,sum(`Cross sell bugdet`) as cross_sell_target,
sum(`renewal budget`) as renewal_budget_target
from individual_budgets;

----  Open Oppty 
SELECT 
    COUNT(stage) AS oppty,
    SUM(
        CASE 
            WHEN stage IN ('Qualify Opportunity', 'Propose Solution')
            THEN 1 ELSE 0 
        END
    ) AS open_oppty
FROM opportunity;


select * from brokerage;
select * from fees;
select * from individual_budgets;
select * from invoice;
select * from meeting;
select * from opportunity;


<img width="1366" height="730" alt="Tableau jpg" src="https://github.com/user-attachments/assets/049ab972-d4b3-4ba2-896a-72bbf6f6ef99" />

