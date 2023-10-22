--transact-sql

select *
from student
where St_Address='alex'


select top(2)*
from Student

select top(2)*
from student
where St_Address='alex'


select top(5) st_fname
from Student

Select max(salary)
from Instructor

Select top(2) salary
from Instructor
order by salary desc

Select top(3) *
from Student
order by st_age desc

Select top(5) with ties *
from Student
order by st_age desc

--full path
--ServerName.DBname.SchemaName.ObjectName

select *
from student

Select *
from [DESKTOP-VF50P25].[ITI].dbo.student

Select *
from Company_SD.dbo.project

Select dept_name
from Department
union all
select dname
from Company_SD.dbo.Departments

--DDL  ==>create table
Select * into tab2
from Student

Select * into tab3
from Student

Select * into company_sd.dbo.student
from Student


Select st_id,st_fname into tab4
from Student
where st_address='alex'

Select * into tab5
from Student
where 1=2   ---false condtion

--simple insert
insert into student(st_id,st_fname)
values(444,'ahmed')

--insert constrcutor
insert into student(st_id,st_fname)
values(441,'ahmed'),(333,'ali'),(999,'omar')

--insert based on select   --DML
insert into tab4
select st_id,st_fname
from Student
where St_Address='cairo'

--bulk insert   [file]
bulk insert tab4
from 'd:\ITIStudentdata.txt'
with (fieldterminator=',')


--insert based on Execute   [stored procedure]
---------------------------------------------------
create table test
(
 eid int primary key identity,  --auto_increament
 ename varchar(20)
)

drop table test


insert into test
values('omar')

select * from test

delete from test

create table test2
(
 eid int identity,  --auto_increament
 SSN int primary key,
 ename varchar(20)
)

insert into test2
values(11122,'ali'),(33333,'omar'),(55555,'ahmed')

select * from test2

drop table student   --data & metadata --ddl
-------------------------------------------
delete from student    --data  --parent&child --where --dml --slower --log file
where 

truncate table student --data  --child --reset identity --ddl --faster

--------------------------
select newid()  --GUID   --unique (server)

select *,newid()
from student

select *
from student
order by newid()

select top(3)*
from student
order by newid()

select top(1)*
from student
order by newid()

Select ins_name,salary
from Instructor

Select ins_name,salary,
         case
		   when salary>=3000 then 'high salary'
		   when salary<3000 then 'low'
		   else 'No Data'
		 end as newsal
from Instructor

Select ins_name,iif(Salary>=3000,'high','low')
from Instructor

update Instructor
	set salary=salary*1.20


update Instructor
	set salary=
	         case
			    when salary>=3000 then salary*1.20
				else salary*1.10
			 end

select sum(salary)
from Instructor
having sum(salary)>10000

select dept_id,sum(salary)
from Instructor
group by dept_id
having sum(salary)>100000

select st_fname+' '+st_lname as fullname
from student
order by fullname

select st_fname+' '+st_lname as fullname
from student
where fullname='ahmed ali'

select st_fname+' '+st_lname as fullname
from student
where st_fname+' '+st_lname='ahmed ali'

Select *
from (select st_fname+' '+st_lname as fullname
      from student) as newtable
where fullname='ahmed ali'

--execution order
--from
--join
--on
--where 
--group
--having
--select
--order by
--top
select *
from (Select *,row_number() over(order by st_age desc) as RN
      from student) as newtable
where RN=1


select *
from (Select *,dense_Rank() over(order by st_age desc) as DR
      from student) as newtable
where DR=1


select *
from (Select *,row_number() over(partition by dept_id order by st_age desc) as RN
      from student) as newtable
where rn=1




select *
from (Select *,dense_Rank() over(partition by dept_id order by st_age desc) as DR
      from student) as newtable
where dr=1


---Setup (services & application)
--Default instance      named instance
--types of authentication
--transact-sql
top
select into
insert based on select
bulk insert
newid
drop delete truncate
identity
case iif
execution order
Ranking




























--ranking functions


