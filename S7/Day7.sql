use iti

declare @x int=(select avg(st_age) from student)

Set @x=9

Select @x=20

select @x

declare @y int
select @y=st_age from Student where st_id=7
select @y


declare @y int=100
select @y=st_age from Student where st_id=1
select @y

declare @y int=100
select @y=st_age from Student where st_address='alex'
select @y

declare @t table(col1 int)
insert into @t
select st_age from Student where st_address='alex'
select count(*) from @t

declare @t table(col1 int)
insert into @t
select st_age from Student where st_address='alex'
select * from @t


declare @t table(col1 int,col2 varchar(20))
insert into @t
select st_age,st_fname from Student where st_address='alex'
select * from @t

declare @y int,@name varchar(20)
select @y=st_age,@name=st_fname from Student where st_id=5
select @y,@name

declare @z int
update student set st_fname='omar',@z=dept_id
where st_id=3
select @z

select @@SERVERNAME

Select @@version

update Student set st_age+=1
select @@ROWCOUNT

select * from student where St_Address='cairo'
select @@ROWCOUNT

update Student set st_age+=1    --14 rows
select @@ROWCOUNT
select @@ROWCOUNT

update Studen set st_age+=1  
go
select @@error

select @@identity

create table mytable
(
 id int primary key identity,
 ename varchar(20)
)

insert into mytable values('omar')
select * from mytable
-------------------------------------------------
--control of flow statements
--if
declare @x int
update Instructor set Salary+=100
select @x=@@ROWCOUNT
if @x>0 
	begin
	select 'many rows affected'
	select 'welcome to iTI'
	end
else 
	begin
	select 'no rows affected'
	end
--begin
--end
--if exists   if not exists

if exists(select name from sys.tables where name='student')
   select 'table is found'
else
	create table student
	(
	id int,
	name varchar(20)
	)

if exists(select name from sys.tables where name='staff')
   select 'table is found'
else
	create table staff
	(
	id int,
	name varchar(20)
	)

if not exists(select top_id from course where top_id=6)
	delete from topic where top_id=6
else
	select 'table has relation'

begin try
	delete from topic where top_id=2
end try
begin catch
    select 'error'
end catch


--while
declare @x int=10
while @x<=20
	begin
		set @x+=1
		if @x=14
			continue
		if @x=16 
			break
		select @x
	end

--continue
--break
--case iif
--choose
--waitfor
----------------------------------------
declare @x int=5

select top(@x) *
from Student

--variables +dynamic query
declare @col varchar(20)='salary',@tab varchar(20)='instructor'
execute('select '+@col+' from '+@tab)


select 'select * from student'

execute('select * from student')

declare @col varchar(20)='*',@tab varchar(20)='instructor',@id varchar(20)=1
execute('select '+@col+' from '+@tab+' where ins_id='+@id)


select s.st_id as sid,st_fname as sname,grade,crs_name as Cname into grades
from Student s,Stud_Course sc,Course c
where s.St_Id=sc.St_Id and c.Crs_Id=sc.Crs_Id

select * from grades

--ranking 
--windowing function
--lead lag first_value  last_value

SELECT sname,grade,
	  prev= lAG(grade) OVER(ORDER BY grade),
	  Next= LEAD(grade) OVER(ORDER BY grade)
FROM grades

SELECT sname,grade,
	  X= lAG(sname) OVER(ORDER BY grade),
	  Y= LEAD(sname) OVER(ORDER BY grade)
FROM grades

SELECT sname,grade,
	   Prod_prev=lAG(sname) OVER(ORDER BY grade),
	   Prod_Next=LEAD(sname) OVER(ORDER BY grade)
FROM grades


SELECT sname,grade,cname,
	  prev= lAG(grade) OVER(ORDER BY grade),
	  Next= LEAD(grade) OVER(ORDER BY grade)
FROM grades




SELECT sname,grade,cname,
	   Prod_prev=lAG(grade) OVER(partition by Cname ORDER BY grade),
	   Prod_Next=LEAD(grade) OVER(partition by Cname ORDER BY grade)
FROM grades

SELECT sname,grade,cname,
	   Prod_prev=lAG(sname) OVER(partition by Cname ORDER BY grade),
	   Prod_Next=LEAD(sname) OVER(partition by Cname ORDER BY grade)
FROM grades

SELECT sname,grade,cname,
	   First=FIRST_VALUE(grade) OVER(ORDER BY grade),
	   last=LAST_VALUE(grade) OVER(ORDER BY grade                                  Rows BETWEEN unbounded preceding AND unbounded following)
FROM grades

SELECT sname,grade,Cname,
	    FIRST_VALUE(grade) OVER(partition by Cname ORDER BY grade),
	   LAST_VALUE(grade) OVER(partition by Cname ORDER BY grade                   Rows                  BETWEEN unbounded preceding AND unbounded following)
FROM grades

SELECT sname,grade,cname,
	   Prod_prev=lAG(grade) OVER(ORDER BY grade),
	   Prod_Next=LEAD(grade) OVER(ORDER BY grade),
	   First=FIRST_VALUE(grade) OVER(ORDER BY grade),
	   last=LAST_VALUE(grade) OVER(ORDER BY grade                                                 Rows BETWEEN unbounded preceding AND unbounded following)
FROM grades

SELECT sname,grade,Cname,
	   Prod_prev=lAG(grade) OVER(partition by Cname ORDER BY grade),
	   Prod_Next=LEAD(grade) OVER(partition by Cname ORDER BY grade),
	   First=FIRST_VALUE(grade) OVER(partition by Cname ORDER BY grade),
	   last=LAST_VALUE(grade) OVER(partition by Cname ORDER BY grade                             Rows BETWEEN unbounded preceding AND unbounded following)
FROM grades

SELECT sname,grade,Cname,
	   Prod_prev=lAG(sname) OVER(partition by Cname ORDER BY grade),
	   Prod_Next=LEAD(sname) OVER(partition by Cname ORDER BY grade),
	   First=FIRST_VALUE(sname) OVER(partition by Cname ORDER BY grade),
	   last=LAST_VALUE(sname) OVER(partition by Cname ORDER BY grade                             Rows BETWEEN unbounded preceding AND unbounded following)
FROM grades


--variables
--control of flow statements
--windowing functions

--types of fuctions
---built--in
----windowing functions   lag lead first_value  last_value
---=Raning functions    Row_number() rank() dense_rank() Ntile()
---system Functions
Select db_name()

select suser_name()
---String Functions
select upper(st_fname),lower(st_fname)
from Student

substring
len
concat
----Date
select getdate()    --year month day

--convert
select convert(varchar(20),getdate())
select cast(getdate() as varchar(50))

select convert(varchar(20),getdate(),101)
select convert(varchar(20),getdate(),102)
select convert(varchar(20),getdate(),103)
select convert(varchar(20),getdate(),104)
select convert(varchar(20),getdate(),105)

select format(getdate(),'dd-MM-yyyy')
select format(getdate(),'dddd MMMM yyyy')
select format(getdate(),'ddd MMM yy')
select format(getdate(),'dddd')
select format(getdate(),'MMMM')
select format(getdate(),'hh:mm:ss')
select format(getdate(),'hh tt')
select format(getdate(),'HH')
select format(getdate(),'dd-MM-yyyy hh:mm:ss tt')

select eomonth(getdate())

select format(eomonth(getdate()),'dd')

select format(eomonth(getdate()),'dddd')

select eomonth(getdate(),2)

select eomonth(getdate(),-2)

--NULL   isnull,coalesce
select isnull(st_fname,'')
from Student

select coalesce(st_fname,st_lname,st_address,'')
from Student

NULLIF

--math functions
sin cos tan log power

--Aggregate functions
count max min avg sum
-------------------------------

--Scalar Function
--string getsname(int id);
alter function getsname(@id int)
returns varchar(25)
	begin
		declare @name varchar(25)
			select @name=st_fname  from Student
			where st_id=@id
		return @name
	end

Select hr.getsname(1)

drop function getsname

alter schema hr transfer getsname

Select *
from company_sd.dbo.project

Create function getmanager(@dname varchar(20))
returns varchar(20)
	begin 
	   declare @manager varchar(20)
			Select @manager=ins_name
			from Instructor i inner join department d
			  on i.Ins_Id=d.dept_manager and dept_name=@dname
       return @manager
	end

select dbo.getmanager('eL')

---------------return table
--inline
create function getinsts(@did int)
returns table
as
return
	(
	 select ins_name,salary*12 as sal
	 from Instructor
	 where dept_id=@did
    )


select * from getinsts(20)

select ins_name from getinsts(20)

select sum(sal) from getinsts(20)

--multi-statment 
create function getsts(@format varchar(20))
returns @t table
           (
		    id int,
			sname varchar(20)
		   )
as
	begin
		if @format='first'
			insert into @t
			select st_id,st_fname from student
		else if @format='last'
			insert into @t
			select st_id,st_Lname from student
		else if @format='full'
			insert into @t
			select st_id,concat(st_fname,' ',st_lname) from student
		return 
	end

Select * from getsts('first')
-----------------------------
create function--
----
begin
     execute('')  XXXXXXXXXXXXXXXXXXX
end
---------------------------------------------
--types of tables
--physical table
create table exam
(
 id int,
 _desc varchar(20),
 edate date,
 numofQ int
)

drop table exam

--table variable
declare @t table(x int)
insert into  @t  values(1),(2),(2)
select * from  @t 

--local tables
create table #exam
(
 id int,
 _desc varchar(20),
 edate date,
 numofQ int
)


--global table
create table ##exam
(
 id int,
 _desc varchar(20),
 edate date,
 numofQ int
)
 
















