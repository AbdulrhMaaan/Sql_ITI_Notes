Select *
from student
where st_id=4

Select *
from Student
where st_fname='ahmed'

create nonclustered index i2
on student(st_fname)

create nonclustered index i3
on student(st_address)

--primary key constraint ===> Clustered index
--unique constraint      ===> nonclustered index

create table test4
(
 id int primary key,
 name varchar(20),
 sal int unique,
 overtime int unique
)

create unique index i4    --create unique constraint + nonclustered index
on student(St_age)

Select * from Student where st_age=20

select * from student where dept_id=10
------------------------------------------------
--Top with DML
--after using it with select 
--insert with top
INSERT INTO test
	SELECT TOP (3) St_Id,St_Fname
	FROM Student

INSERT top(3) INTO test
	SELECT St_Id,St_Fname
	FROM Student

--update with top
update top(2) Department
set Dept_Location = 'alex'

--Top with delete
--Delete with top
delete Top(5) from test

--delete 2.5% from the data
DELETE TOP (25) PERCENT
FROM Production.ProductInventory;
----------------------------------------------
--rollup , cube  , grouping sets   pivot  unpivot

use test

create table sales
(
ProductID int,
SalesmanName varchar(10),
Quantity int
)
truncate table sales

insert into sales
values  (1,'ahmed',10),
		(1,'khalid',20),
		(1,'ali',45),
		(2,'ahmed',15),
		(2,'khalid',30),
		(2,'ali',20),
		(3,'ahmed',30),
		(4,'ali',80),
		(1,'ahmed',25),
		(1,'khalid',10),
		(1,'ali',100),
		(2,'ahmed',55),
		(2,'khalid',40),
		(2,'ali',70),
		(3,'ahmed',30),
		(4,'ali',90),
		(3,'khalid',30),
		(4,'khalid',90)
		
select ProductID,SalesmanName,quantity
from sales

select SalesmanName as Name,sum(quantity) as Qty
from sales
group by SalesmanName
union
select 'Total Values',sum(quantity)
from sales


Select isnull(Name,'Total'),Qty
from ( 
select SalesmanName as Name,sum(quantity) as Qty
from sales
group by rollup(SalesmanName)
) as t




select SalesmanName as Name,sum(quantity) as Qty
from sales
group by rollup(SalesmanName)
		

select SalesmanName as Name,Count(quantity) as Qty
from sales
group by rollup(SalesmanName)
		

--order by ProductID,SalesmanName
select ProductID,sum(quantity) as "Quantities"
from sales
group by rollup(ProductID)




select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by ProductID,SalesmanName

select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by rollup(ProductID,SalesmanName)


select SalesmanName,ProductID,sum(quantity) as "Quantities"
from sales
group by rollup(SalesmanName,ProductID)

select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by Cube(ProductID,SalesmanName)


select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by cube(ProductID,SalesmanName)

--order by ProductID,SalesmanName


select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by cube(ProductID,SalesmanName)
--order by ProductID,SalesmanName

--grouping sets
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by grouping sets(ProductID,SalesmanName)


----Pivot and Unpivot OLAP
--if u have the result of the previouse query
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by SalesmanName,ProductID

SELECT *
FROM sales 
PIVOT (SUM(Quantity) FOR SalesmanName IN ([Ahmed],[Khalid],[ali])) as PVT

SELECT *
FROM sales 
PIVOT (SUM(Quantity) FOR ProductID IN ([1],[2],[3],[4])) as Newtable


SELECT *
FROM sales 
PIVOT (SUM(Quantity) FOR SalesmanName IN ([Ahmed],[Khalid])) as PVT

SELECT *
FROM sales 
PIVOT (SUM(Quantity) FOR productid IN ([1],[2],[3],[4])) as PVT

Select * from newpivot


select * from newtable


--how to get the table
SELECT * FROM newtable 
UNPIVOT (qty FOR salesname IN ([Ahmed],[Khalid],[Ali])) UNPVT

---------------------------------------------------------
--views

select * from student

Create view Vstuds
as
   select * from student


Select * from Vstuds

alter view Vcairo(id,sname,sadd)
with encryption
as
	select st_id,st_fname,st_address
	from student
	where st_address='cairo'

Select * from vcairo

select sname from vcairo

sp_helptext 'vcairo'

alter schema hr transfer vcairo

Select * from hr.vcairo

alter schema dbo transfer hr.vcairo

Create view Valex
as
	select st_id,st_fname,st_address
	from student
	where st_address='alex'

select * from valex

create view vCandA
as
select * from vcairo
union all
select * from valex

Select * from vcanda

--Complex queries

Create view vjoin(sid,sname,did,dname)
as
select st_id,st_fname,d.dept_id,dept_name
from department d inner join student s
    on d.dept_id=s.dept_id


select * from vjoin

Select sname,dname from vjoin

Create view vgrades
as
Select sname,dname,grade
from vjoin v inner join stud_course sc
     on v.sid = sc.st_id

Select * from vgrades

--DmL + view
----------view ==?one table
alter view Vcairo(id,sname,sadd)
with encryption
as
	select st_id,st_fname,st_address
	from student
	where st_address='cairo'
with check option

insert into vcairo
values(57,'ali','cairo')

insert into vcairo
values(58,'ali','alex')

select * from vcairo



----------view ==?multi tables

Create view vjoin(sid,sname,did,dname)
as
select st_id,st_fname,d.dept_id,dept_name
from department d inner join student s
    on d.dept_id=s.dept_id

---Delete XxXXXXXX
--insert & update    --affected one table
insert into vjoin
values(61,'emad',100,'Cloud')

insert into vjoin(sid,sname)
values(61,'emad')

insert into vjoin(did,dname)
values(1000,'Cloud')

Update vjoin 
	set sname='ahmed'
where sid=1

--index
--Pivoting
--View
--Merge

Create table LastTransaction
(
 id int,
 name varchar(20),
 myval int
)

Create table DailyTransaction
(
 did int,
 dname varchar(20),
 dval int
)

Merge into Lasttransaction as T
using Dailytransaction     as S
on T.id = S.did

when Matched then
    update 
	    Set T.myval = S.dval
when not Matched then               --not matched by target
    insert  
    values(S.did,S.dname,S.dval)      ;





