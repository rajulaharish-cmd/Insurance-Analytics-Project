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

--- question 1
select `account executive`, count(meeting_date) as No_of_meetings
from meeting
group by `account executive`;

--- Question no2(a) cross sell target achvd
select concat(round((sum(brokerage.amount) + sum(fees.amount))/1000),"k") as cross_sell_Achvd_target from brokerage
inner join fees on fees.`Account Exe ID`=brokerage.`Account Exe ID`
where brokerage.income_class="cross sell";

--- Question no2(b) New target achvd
select concat(round((sum(brokerage.amount) + sum(fees.amount))/1000),"k") as new_Achvd_target from brokerage
inner join fees on fees.`Account Exe ID`=brokerage.`Account Exe ID`
where brokerage.income_class="new";


--- Question no2(c) Renewal target achvd
select concat(round((sum(brokerage.amount) + sum(fees.amount))/1000),"k") as Renewal_Achvd_target from brokerage
inner join fees on fees.`Account Exe ID`=brokerage.`Account Exe ID`
where brokerage.income_class="Renewal";



--- question 3(a) Renewal achvd%
select concat(round((sum(brokerage.amount) + sum(fees.amount))/sum(individual_budgets.`Renewal Budget`)*100,2), "%")
 as Renewal_Achvd_targtperc from brokerage
inner join fees on fees.`Account Exe ID`=brokerage.`Account Exe ID`
inner join individual_budgets on individual_budgets.`Account Exe ID`=brokerage.`Account Exe ID`
where brokerage.income_class="Renewal";


--- question 3(b) cross sell achvd%
select concat(round((sum(brokerage.amount) + sum(fees.amount))/sum(individual_budgets.`Cross sell bugdet`)*100,2), "%")
 as crosssell_Achvd_perc from brokerage
inner join fees on fees.`Account Exe ID`=brokerage.`Account Exe ID`
inner join individual_budgets on individual_budgets.`Account Exe ID`=brokerage.`Account Exe ID`
where brokerage.income_class='Cross Sell' and fees.income_class='Cross Sell';

--- question 3(c)New achvd



--- question 4 Yearly meeting count
select year(meeting_date) as year,count(year(meeting_date)) as meeting_count
from meeting
group by year(meeting_date);
 
-- question 5 No of Invoice by Account Exec

select `employee name`, invoice.income_class, count(income_class) as `no_of_invoice_by_Accnt_Exec`
from individual_budgets inner join invoice
on invoice.`Account Exe ID`=individual_budgets.`Account Exe ID`
group by `employee name`, invoice.income_class
order by invoice.income_class desc,`no_of_invoice_by_Accnt_Exec` desc;

--- -- question 6 crosssell , renewal , new target
select sum(`new budget`) as `new budget target`,sum(`Cross sell bugdet`) as cross_sell_target,
sum(`renewal budget`) as renewal_budget_target
from individual_budgets;

---- question no 7 Open Oppty 
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
