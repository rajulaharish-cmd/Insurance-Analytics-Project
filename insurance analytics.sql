Create database insurance;
use insurance;
Create table Individual_Budgets(Branch Varchar(20),
Account_Exe_ID int primary key,
`Employee Name` varchar(20),
`New role` varchar(20),
`New Budget`decimal (10,2),
`Cross sell bugdet`decimal (10,2),
`Renewal Budget` decimal (10,2));

select `Employee Name` from Individual_Budgets;

Create table brokerage (client_name varchar(50),
policy_number varchar(1000),
policy_status varchar(50),
policy_start_date date,
policy_end_date date,
product_group varchar(50),
`Account Exe ID` int,
foreign key (`Account Exe ID`) references Individual_Budgets(Account_Exe_ID),
`Exe Name` varchar(50),
branch_name  varchar(50),
solution_group varchar(200),
income_class  varchar(50),
Amount decimal(10,2),
income_due_date date,
revenue_transaction_type  varchar(200),
renewal_status varchar(50),
lapse_reason varchar(200),
last_updated_date date);

select distinct(`Exe Name`) from brokerage;

create table fees(client_name varchar(100),
			       branch_name varchar(100),
                   solution_group varchar(100),
                   `Account Exe ID` int,
                   foreign key (`Account Exe ID`) references Individual_Budgets(Account_Exe_ID),
                   `Account Executive` varchar(100),
                   income_class varchar(100),
                   Amount decimal(10,2),
                   income_due_date date,
                   revenue_transaction_type varchar(100));

create table invoice(invoice_number varchar(100),
                    invoice_date date,
                    revenue_transaction_type varchar(100),
                    branch_name varchar(100),
                    solution_group varchar(100),
					`Account Exe ID` int,
                    foreign key (`Account Exe ID`) references Individual_Budgets(Account_Exe_ID),
                    `Account Executive` varchar(100),
                    income_class varchar(100),
					`Client Name` varchar(100),
                    policy_number  varchar(100),
                    Amount  decimal(10,2),
                    income_due_date date);

select `Account Exe ID`  from invoice;
                    
Create table meeting(`Account Exe ID` int,
                    foreign key (`Account Exe ID`) references Individual_Budgets(Account_Exe_ID),
                    `Account Executive` varchar(100),
                    branch_name  varchar(100),
                    global_attendees varchar(100),
                    meeting_date date);

select distinct(`Account Executive`)  from meeting;

 Create table Opportunity(opportunity_name varchar(100),
                          opportunity_id varchar(100),
                          `Account Exe Id` int,
                           foreign key (`Account Exe ID`) references Individual_Budgets(Account_Exe_ID),
						   `Account Executive` varchar(100),
                           premium_amount decimal(10,2),
                           revenue_amount decimal(10,2),
                           closing_date date,
                           stage varchar(100),
                           branch varchar(100),
                           specialty varchar(100),
						   product_group varchar(100),
                           product_sub_group varchar(100),
                           risk_details  varchar(100));
select * from  Opportunity;
select distinct(`Account Executive`)  from Opportunity;

--- No Meeting by account executive
select `Employee Name`, count(meeting_date) as No_of_meetings
from Individual_Budgets join meeting
on meeting.`Account Exe ID`= Individual_Budgets.Account_Exe_ID
group by `Employee Name`;


----  Open Oppturnities
SELECT 
    COUNT(stage) AS oppty,
    SUM(
        CASE 
            WHEN stage IN ('Qualify Opportunity', 'Propose Solution')
            THEN 1 ELSE 0 
        END
    ) AS open_oppty
FROM opportunity;

--- cross sell target achvd
select concat((select sum(amount) from brokerage where income_class = 'Cross Sell')+ 
(select sum(amount) from fees where income_class = 'Cross Sell'),"K") as new_target;

--- New target achvd
select concat((select sum(amount) from brokerage where income_class = 'new')+ 
(select sum(amount) from fees where income_class = 'new'),"K") as new_target;

--- Renewal target achvd
select concat((select sum(amount) from brokerage where income_class = 'Renewal')+ 
(select sum(amount) from fees where income_class = 'Renewal'),"K") as new_target;



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
