use AdventureWorks2012

select * from Product

select * from dbo.Product

select * from Production.Product

create schema HR

Create schema sales

alter schema hr transfer student

alter schema hr transfer instructor

alter schema sales transfer  department

Select * from student

Select * from hr.student

Select * from sales.department

create table student
(
 sid int,
 sname varchar(20)
)

create table sales.student
(
 sid int,
 sname varchar(20)
)

--create login (Dev1)  password   --->SQL authentication
--create user
--authorization (persmissions)
--grant    select  insert      tables(student,instructor)
--deny     update delete

--------------------------------------------------------
--Batch

insert
update
delete

--Script   --ddl
create table
go
drop table
go
alter table



--backup

--transaction
--set of queries
--execute as single unit of work

insert
update
delete
 

create table parent(pid int primary key)

create table child(cid int foreign key references parent(pid))

insert into parent values(1)
insert into parent values(2)
insert into parent values(3)
insert into parent values(4)

insert into child values(1)
insert into child values(22)
insert into child values(3)

select * from child
delete from child

begin transaction
	insert into child values(1)
	insert into child values(22)
	insert into child values(3)
commit

begin transaction
	insert into child values(1)
	insert into child values(2)
	insert into child values(3)
rollback

begin try
	begin transaction
		insert into child values(1)
		insert into child values(22)
		insert into child values(3)
	commit
end try
begin catch
	rollback
	select ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER()
end catch

select * from child
delete from child

--transaction  ---ACID

----------DB Integrity
create table Depts
(
did int primary key,
dname varchar(20)
)

create table employees
(
 eid int identity(1,1),
 ename varchar(20) ,
 eadd varchar(20) default 'alex',
 hirdate date default getdate(),
 BD date,
 age as year(getdate())-year(bd),
 sal int ,
 overtime int,
 netsal as(isnull(sal,0)+isnull(overtime,0)) persisted,
 hour_rate int not null,
 gender varchar(1),
 dnum int,
 constraint c1 primary key(eid,ename),
 constraint c2 unique(sal),
 constraint c3 unique(overtime),
 constraint c4 check(sal>1000),
 constraint c5 check(overtime between 100 and 500),
 constraint c6 check(eadd in('cairo','mansoura','alex')),
 constraint c7 check(gender='M' or gender='F'),
 constraint c8 foreign key(dnum) references depts(did)
             on delete set null  on update cascade
)

alter table employees drop constraint c5

alter table employees add constraint c9 check(hour_rate>1000)

--constraint    ====>new data XXXXXX
--constraint    ====>shared between tables
--new datatype  ===>constraint xxXXXXX

alter schema dbo transfer hr.student

alter table instructor add constraint c100 check(salary>1000)


--rule
create rule r1 as @x>1000

sp_bindrule r1,'instructor.salary'

sp_bindrule r1,'employees.overtime'

sp_unbindrule 'instructor.salary'

sp_unbindrule 'employees.overtime'

drop rule r1

create default def1 as 5000

sp_bindefault def1,'instructor.salary'

sp_unbindefault 'instructor.salary'

drop default def1

-------------
--new datatype   int     value>1000    default 5000
sp_addtype complexDt,'int'

create rule r1 as @x>1000

create default def1 as 5000

sp_bindrule r1,complexdt

sp_bindefault def1,complexdt


create table testing
(
 eid int,
 ename varchar(20),
 sal complexdt  --constraint default
)

--DB Creation   + SChema +Security
--batch   script   transaction
--DB Integrity   [constraints & rules]
--identity
-------------------------------------------------------------------------------------------------------
------------------------------------Advanced Queries--------------------------------------------------
--identity column with insert	
--only one identity column in the table not allowed for mutiple identities
CREATE TABLE dbo.T1 ( column_1 int, column_2 VARCHAR(30),
					column_3 int IDENTITY primary key);
GO

SELECT * FROM T1

delete from t1 where column_3 between 2 and 6

truncate table t1


INSERT T1 VALUES (1,'omar');

INSERT T1 (column_2) VALUES ('khalid');
GO
SET IDENTITY_INSERT T1 ON;
SET IDENTITY_Insert T1 off;
GO
INSERT INTO T1 (column_3,column_1,column_2)  VALUES 
(9,1, 'Explicit identity value');
GO

SELECT * FROM T1

dbcc checkident(t1,RESEED,1)



delete


truncate

begin transaction
	insert
	truncate   --log
	update   --error
rollback


--sysnonym ???
--display constraint ???







