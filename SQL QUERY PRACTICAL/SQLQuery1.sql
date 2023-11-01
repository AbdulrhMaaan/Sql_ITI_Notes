USE ITI 

Create Table tester 
(
testid int PRIMARY KEY , 
testname nvarchar(20),
testdate date  default getdate()

)


insert into tester (testid,testname)
values (1,'ali')

select * from tester


alter table tester add sa int 
alter table tester alter column sa tinyint 
alter table tester drop column sa

update  tester 
set testname='ola'


delete from tester  -- delete all data  from table ?
drop table tester    --- delete all data and Metadata    Metadata is the Columns


select * from student 
where St_Age between 10 and 100   AND  St_super is not null




select S.St_Fname , c.Crs_Name
from Student S , Stud_Course SC ,Course C
WHERE C.Crs_Id = SC.Crs_Id AND  SC.St_Id=S.St_Id
ORDER BY S.St_Age

--- == --- 

select S.St_Fname , c.Crs_Name ,SC.Grade
from Student S , Stud_Course SC ,Course C
WHERE C.Crs_Id = SC.Crs_Id AND  SC.St_Id=S.St_Id
ORDER BY S.St_Age

---  inner join work only in 2 tables and create another table  , where we can inner join it  with third table

select S.St_Fname , c.Crs_Name ,SC.Grade
from Student S inner join Stud_Course SC 
	ON   SC.St_Id=S.St_Id
	inner join Course C
	 ON  C.Crs_Id = SC.Crs_Id 
ORDER BY S.St_Age



----- DML WITH JOINS 

UPDATE Stud_Course
set Grade+=10 
	select Grade
	from Stud_Course sc , Student s 
	where s.St_Id=sc.St_Id and s.St_Address='Alex'
 
 --- SAME 
 UPDATE Stud_Course
set Grade-=10 
where Grade in (select Grade
		from Stud_Course sc , Student s 
		where s.St_Id=sc.St_Id and s.St_Address='Alex')



---- AGGREGATE fUNCTION
select SUM(St_Id) , d.Dept_Name
from Student s inner join Department d
On s.Dept_Id =d.Dept_Id
where d.Dept_Name in ('EL','java')
group by Dept_Name
Having Count(Dept_Location) >=3


--sub query
select Dept_Name
from Department
where Dept_Id in (select Dept_Id from Student where Dept_Id is not NULL)


select Dept_Name,(select Count(St_Id) from Student where Student.Dept_Id=Department.Dept_Id)
from Department


--- Union Family 
(
select St_Fname
from Student
union all 
select ('-------------Instructor---------')
)
union all
select Ins_Name
from Instructor



--Comments
--	Double-hyphen comments 
--	"�" comment one line
--	Slash-asterisk comments
--	"/*     */" comment multi lines

select *	
--T-SQL And ANSI SQL
--history of SQL 
----1)Square language (first text based query language) 
----2)SEQUEL (Structure English query language) 
----3)SQL (Structure query language)

--T-SQL(5 categories)
--1)DDL
--2)DML
--3)DCL
--4)TCL
--5)DQL

--DDL
use ITI2

create table test
(
id int,
name nvarchar(50)
)

create table test
(
id int identity(1,1) primary key,
name nvarchar(50),
sal int default 1000
)

alter table test
drop column name

alter table test 
add name nvarchar(50)

alter table test
ALTER COLUMN name NVARCHAR(60)

drop table test


--DML
--Insert Statment
Insert into Department
values(100,'DBA','database Administrator','cairo',107)

--using null and default in insert
Insert into Department
values(100,'DBA',null,'cairo',default)

--order , set of columns 
--other columns (allow null values,calculated,identity,default value) 
Insert into Department(Dept_Id,Dept_Name)
values(200,'ERP')

--Insert data using the new row constructors
INSERT INTO PayRates 
VALUES (1, 40.00, 5),
	   (2, 45.50, 4), 
	   (3, 39.50, 6);

--Insert based on select
insert into test
select st_id,st_fname from Student
where St_Address='cairo'

--insert based on exexute (with Stored procedure)

--using select into

--Update Statment
update Department
set Dept_Location = 'alex'
where Dept_Name='erp'

--using null and default with update
update Department
set Dept_Location = DEFAULT
where Dept_Name='erp'

--update more than one column

--update with joins
update stud_course
set grade +=10
from stud_course sc,course c
where sc.crs_id=c.crs_id 
	  and top_id=(select top_id
				  from topic
				  where top_name='programming')

				  Update Course

--Delete Statment
delete from test
where name='ahmed'

--Truncate Statment
--You cannot use TRUNCATE TABLE on tables thatare referenced by a FOREIGN KEY constraint
truncate table test

--Delete Drop Truncate
----sentax
----result and where
----performane and log
----space and shrink db

--DQL
--Select Statment
--ServerName.DatabaseName.Schema.Object
Select * From  "rami\myserver".ITI2.dbo.student

Select St_fname,st_lname from Student
Select * from student

--alias name and dealing with space in the column names
Select St_fname+' '+st_lname as [full name] from Student
Select * from student

--is null and IS NOT NULL with where clause
select * from Course
where Crs_Duration = null    --null is not a value

select * from Course
where Crs_Duration is not null

--Null Function
--ISNULL function  
select ISNULL(st_age,20) from Student

--COALESCE() � Queries where NULL values may exist and you wish to substitute one of several possibilities into a column of the result set.
SELECT COALESCE(hour_rate * 40 ,  salary, 
   Bonus )  AS 'Total Salary' 
FROM instructor

--NULLIF() � queries that you want to offer a more meaningful value in place of the NULL keyword being displayed in the result.
select nullif(st_age,dept_id)
from student
where st_id=14

--operators > , < ,()
-- or, and, and not
Select St_fname,st_lname from Student
where St_Age=25 or St_age=30

--In Statment
Select St_fname,st_lname from Student
where St_Age in(25,26,27)

--select into
select st_fname,st_age 
into test2
from Student

select st_fname,st_age 
into test3
from Student
where 1=2

--like
Select St_fname,st_lname from Student
where st_fname like 'A%'

Select St_fname,st_lname from Student
where st_fname like '_A%'

Select St_fname,st_lname from Student
where st_fname like '[_]A%'

Select St_fname,st_lname from Student
where st_fname like '___' 

select title_id, title
	from titles
	where title_id like "MC302[13579]"
--Means MC302 + any characters of the following 1,3,5,7,9

select title_id, title
	from titles
	where title_id like "MC302[^13579]"
--Means MC302 + any characters except  the following 1,3,5,7,9

select st_fname
	from student
	where st_fname like '[a-h]%'

--order by desc asc (default asc)
--Order by can by followed by numbers not column names [order by 1 Asc,2 Desc]
select * from Student
order by St_Id desc

select * from Student
order by 1,2 

--we can sort with more than one column

--Between

--joins
	--joins is faster than subqueries if the number of tables is smaller
	--and if there is indexes
--cross join

--Inner join and equi join
select st_fname,dept_name
from student s inner join department d
on s.dept_id=d.dept_id

select st_fname,dept_name
from student s,department d
where s.dept_id=d.dept_id

--inner with 3 tables
select st_fname,dept_name,ins.ins_name
from student s inner join department d
on s.dept_id=d.dept_id inner join instructor ins
on ins.dept_id=d.dept_id
order by ins_name

--Outer join ===> left, right and full
select st_fname,dept_name
from student s left outer join department d
on s.dept_id=d.dept_id

select st_fname,dept_name
from student s right outer join department d
on s.dept_id=d.dept_id

select st_fname,dept_name
from student s full outer join department d
on s.dept_id=d.dept_id

--Cross join or Cartsian product
select st_fname,dept_name
from student s cross join department d

--A Cartesian Product
select st_fname,dept_name
from student s , department d

--Self join
select stud.st_fname,super.st_fname as "supervisor Name"
from student super,student stud
where super.st_id=stud.st_super
 
--aggregate functions
--used in select, having

--count avg sum max min
select MAX(crs_duration) from Course

select COUNT(st_fname) from student
 
select COUNT(*) from student

SELECT AVG(ST_AGE) FROM Student
 
SELECT AVG(ISNULL(ST_AGE,0)) FROM Student

--group by
select COUNT(st_id),Dept_Id from Student
group by Dept_Id


--having
select COUNT(st_id),Dept_Id from Student
group by Dept_Id
having COUNT(st_id)>2

--having without group by 
--u should use aggregate in select close
select COUNT(*) from student
having Count(*)<25


--sub queries
--the problem
Select St_fname,st_lname from Student
where St_Age> AVG(st_age)

--solusion
Select St_fname,st_lname from Student
where St_Age> (select AVG(st_age) from Student)

Select ins_name 
from instructor
where Ins_Id in (select dept_manager from Department where Dept_Manager is not null)

--Exists 
select Ins_Name from Instructor
where exists 
(select dept_manager from Department where Dept_Manager is not null)
--inner query returns true or false
--no date returned or processed


--Joins Vs Subqueries
--Joins can yield better performance in some cases where existence must be checked
--Joins are performed faster by SQL Server than subqueries
--Subqueries can often be rewritten as joins
--SQL Server 2008 query optimizer is intelligent enough to covert a subquery into a join if it can be done
--A scalar subquery returns a single row of data, while a tabular subquery returns multiple rows of data

--Distinct
select distinct st_fname
from Student

--If a query contains more than one column, distinct filters out only the rows in which the entire combination of values appears more than once
select distinct st_fname,st_lname
from Student

--Top
select Top 4 * 
from student

--Top with ties
select Top 4 witH ties * 
from student
order by st_age

--Top randomized
SELECT TOP(5) *
FROM student
ORDER BY NEWID();

--table sample and top
SELECT TOP (5)
	st_fname, st_LName
FROM Student

SELECT st_fname, st_LName
FROM Student
TABLESAMPLE (70 PERCENT)

--Union [all] AND Rules
select St_Fname from Student
union all
select Ins_Name from Instructor
--Intersect and except operators
--Compares the results of 2 queries and returns the distinct values

--Template Explorer (it is a template for all queries)
--When u use template explorer and drag anything u can fill parameters 
--(Query menu ->specify values for template parameters ) 
--also I can add new template to template explore 
--(right click->new folder->right click->new template-> <nikename,name,default value>)


select Ins_Name,salary,
     case 
	 when Salary>=3000 then 'High Sal'
	 when Salary<3000 then 'Low Sal'
	 else 'No val'
	 end   as Newsal
from Instructor
	
select Ins_Name , iif(Salary<3000 and Ins_Degree ='Master', 'Low','High')
from Instructor

update Instructor 
set Salary=
case 
when Salary<3000 then Salary+1000
end   


-Numeric DT
bit 0-1 
tinyint 1Byte 0-255
smallint 2Byte -32.767 to 32.768
int 4Byte 2Millare 
bigint 8Byte 9999999999

--Floating DT
money 8 byte 4digits only 0.0000
smallmoney 4byte 4digits only 0.0000
real 4byte 8digit only and round up 0.000000000
float 8byte up to 32 digit 0.00000000000000000000000000
decimal(7,4) 8byte
Numeric(7,4) Old

--Date DT
Date
Time
datetime 1753 to 9999 any decimal
smalldatetime 1990 to 2050 no seconds
datetime2 seconds up to 7 decimal
datetimeoffset +2,

--string DT
char(10) 8000 char,
varchar(50),
nvarchar(50),
varchar(max),
Text old

--binary
binary(100) 4 byte,
varbinary(500) 8 byte,
image

--Others
--XML
--sql_variant




----Ranking Function rank_

select * into table_Testing_
from (select *,ROW_NUMBER() over (order by St_age) as RN 
              ,DENSE_RANK() over (order by St_age) as DR
			  from Student
              )as NewTable


Drop table  table_Testing

select *,ROW_NUMBER() over (order by St_age desc) as RN  from Student
select * ,DENSE_RANK() over (partition by Dept_Id order by St_age ) as DR from Student
select *,Ntile(4) over ( order by St_age desc) as NT from Student



create schema arafa_schema

alter schema dbo Transfer arafa_schema.student


Create Synonym s for student 
select * from s




SESSION 6

USE [ITI]
GO

/****** Object:  Rule [rule1]    Script Date: 10/31/2023 12:55:05 AM ******/
CREATE RULE [dbo].[rule1] 
AS
@x in ('ali','soha','mona')
GO


sp_bindrule rule1 , 'test.ename'


alter table test add sal arafa_DT

create rule rule_new_datatype as  @y > 1000
create default default_new_datatype    as 5000

sp_addtype arafa_DT,int

sp_bindrule rule_new_datatype , arafa_DT

sp_bindefault default_new_datatype , arafa_DT



Session 7 

declare @x int 

select @x = 50 
set @x = 20 
select @x

declare @x int 
select St_Address , @x=Dept_Id
from Student
where St_Lname='Hassan'

declare @y int  = 100
select @y


declare @x int 
update Student  set St_Lname='Hasssan' , @x=Dept_Id
where St_Lname='Hassan'

select @x 

select @@ROWCOUNT
select @@SERVERNAME
select @@VERSION
select @@ERROR
insert into Student(St_Fname,St_Lname,Dept_Id) values ('fsdf','sdfsd',20)
select @@IDENTITY

declare @x table(age int , addre varchar(20) )  
insert into  @x
select St_Age , St_Address from Student
select * from @x



if (select St_Age from Student where St_Id=1 ) >0 
select 'Yes'
else 
select 'No'

select 'select * from Student'
execute ('select * from Student')


begin try 
	begin transaction 
		insert into Student(Dept_Id) values(10)
		insert into Student(Dept_Id) values(500)
		insert into Student(Dept_Id) values(30)
				commit
end try 

begin catch 
	select 'Error ya 3rafa'
	rollback
end catch 


use ITI

--- select the Highest Name of Length 
select top(1) * 
from
(select len(St_Fname) as m, St_Fname
from Student
) as n
order by LEN(St_Fname) desc 



--- another sol
select top(1) st_fname
from student 
order by LEN(St_Fname) desc


--scalar Functio return One Value Only
create function get_names_of_student (@id int)
returns varchar(20)
begin 
	declare @name varchar(20)
	select @name=st_fname from student where St_Id = @id
	return @name
end

-- Must Assing Schema
select dbo.get_names_of_student(1)



---inline Function   -return table   but body have only Select without if or while ....    

create Function get_info_of_department(@id int)
returns table 
as 
return 
(
select ins_name , Salary *12 as salary
from Instructor
where Dept_Id =@id
)
go
select * from dbo.get_info_of_department(10)



--- multi  --- return table  use if body has if or while or case  or any logical function
--- return id, name of student based on user need
create function get_name_and_id_of_student (@format varchar(20))
returns @t  table 
			(
			id int , namee varchar(20)
			)
as
begin
		if @format ='first'
		 insert into @t 
		 select St_Id ,St_Fname from Student
		else if @format ='second'
		 insert into @t 
		 select St_Id ,St_lname from Student
		else if @format ='full'
		 insert into @t 
		 select St_Id ,St_Fname+''+St_lname from Student

		return 
end

select * from dbo.get_name_and_id_of_student('')
select * from dbo.get_name_and_id_of_student('full')


