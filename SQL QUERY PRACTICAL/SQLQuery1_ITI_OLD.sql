---1.	Retrieve number of students who have a value in their age. 
select *
from Student
where St_Age is not null


---2.	Get all instructors Names without repetition
select DISTINCT Ins_Name
from Instructor

---3.	Display student with the following Format (use isNull function)
select St_Id , isnull ( (St_Fname + ''+St_Lname ) ,'NO NAME' )as Fullname  , Dept_Name 
from Student s ,Department d
where s.Dept_Id=d.Dept_Id


----4.	Display instructor Name and Department Name   Note: display all the instructors if they are attached to a department or not
select  Ins_Name , Dept_Name
from Instructor i , Department d
where i.Dept_Id = d.Dept_Id


----5.	Display student full name and the name of the course he is taking For only courses which have a grade  

select (St_Fname + ' '+St_Lname ) as fullname, Crs_name
from Course c ,Student s ,Stud_Course sc
where  c.Crs_Id=sc.Crs_Id and s.St_Id=sc.St_Id  and Grade is not null

----6.	Display number of courses for each topic name
select Count(Crs_Name) , Crs_Name
from Course
group by Crs_Name

---7.	Display max and min salary for instructors
select min(Salary) , MAX(Salary)
from Instructor


---8.	Display instructors who have salaries less than the average salary of all instructors.
select * 
from Instructor 
where Salary < (select AVG(Salary) from Instructor)

----9.	Display the Department name that contains the instructor who receives the minimum salary.
select *
from Department 
where Dept_id =  (select Dept_Id  from Instructor where Salary =(select  min(Salary)  FROM Instructor ) )


--- constraint 
alter table Instructor add constraint c1 check(salary>=1000)  --- will work  because , all salaries>=1000 

--- constraint 
alter table Instructor add constraint c2 check(salary>1000)  --- will not work  because , there are an old value in the table 1000 ,so chcker will not work 

--- to solve this , will use a rule to able to apply constraint on new data olny , however the old data accept this check or not 
create rule r1 as @x>1000
sp_bindrule r1 , 'Instructor.salary'  --- now it works , if u try to write value 1000 it will not accept this value beacause its not >1000
                                      ---- however there are a vlue 1000  but it is old vaku
----- Delect constraint 
alter table Instructor drop constraint c1


---- Create Defualt value to column
create default def1 as 5000
sp_bindefault def1 ,'Instructor.salary'  - -- - now if u try to enter the values of new row and dont witre the salary it will be 5000


---- CREATE NEW DATATYPE  called arf  , its int  and default val 5000 and chech if values enter >1000 or not 

----1- create rule
create rule r2  as @x>1000
---2- create default
create default def2 as 5000
----3- create datatype 
sp_addtype arf,int
--4,5 aplly constraints on the new datatype 
sp_bindrule r2,arf
sp_bindefault def2,arf

------------NOW YOU HAVE A DATATYPE WITH CONSTRAINT , AND YOU CAN USE IT IN ANNNNNNY TABLE  (can find it in   Types --- user Defiend Data types)


--- now u can use this instruc_shot_cut at any time at any where 
create synonym instruc_shot_cut
for dbo.Instructor
---- المفيد هنا اني لو واقف في سكيما معينه و عاوز انده جدول اخر ولكن مش في الاسكيما بتاعتي اعمل اي ؟ خد شورت كات و استخدمته في اي حته 


select name from sys.tables where name='student' ------ sys. tables , allcolumns  --- to get the metadata info of the system (DB)

-- control Flow 
-- if else using multi lines (Begin end )
declare @x int =5    --- declare Varaible 
update Instructor set  Salary+=100
select @x=@@ROWCOUNT
if @x >0 
	begin 
	select 'MULTI VALUED EFFECTED'
	select 'Done'
	end
else 
	select 'Nothing Rows Effected'


--- if exists , not exist 

if exists (select Ins_Name from Instructor where salary =12000) 
	select 'there is returned Value'
else
	select 'NONE'

if exists (select Ins_Name from Instructor where salary =1200) 
	select 'there is returned Value'
IF not exists (select Ins_Name from Instructor where salary =1200)
	select 'NONE'


if not exists (select name from sys.tables where name='Instructor')
	create table Instructor 
	(
	id int , name nvarchar(50)
	)

		
--- try  catch 

 
begin try 
	delete from Department where Dept_Id=10
end try 
begin catch 
	select 'Cant do it , this parent has a child  if u want to delete chage the properittes of relation between table dept , inst  and dept,student '
end catch


---- while 
declare @x int =10
while @x<20
	begin 
	set @x+=1
	if @x=14 
	   continue
	if @x=16
	   break
	select @x
	end 

--- executte use to convert string to  order can be executed 
declare @col varchar(20)='salary',@tab varchar(20)='instructor'
execute('select '+@col+' from '+@tab)



---- Create table to use 
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


--math functions
sin cos tan log power

--Aggregate functions
count max min avg sum
-------------------------------

---scalar func
-- create function  nameoffunc (@paramter type)
-- returns  datatype
-- begin 
--body of func 
-- return 
--end 

create function get_name(@id int)
returns varchar(50)
begin 
declare @name varchar(50) 
select @name=St_Fname from Student where St_Id=@id
return @name
end
--- call 
select dbo.get_name(2)



---inline table valued function
---create function namoffunc(@paramter type)
---returns table 
---as
---return (

---)

create function get_list(@did int)
returns table 
as
return (
  select Ins_Name ,Salary*12  as ttalsalary
  from Instructor
  where Dept_Id=@did
)

--calll 
select * from get_list(10)
select Ins_Name  from get_list(10)
select sum(ttalsalary)  from get_list(10)


----- multi statment 
----create function getstudents(@format varchar(20))
--@t this is a table i will store info in it 
-----returns @t table  
-----(
-----id  int , 
-----ename varchar(20)
-------) 
	
-----as
-----begin
-----return
-----end 

create function getstudents(@format varchar(20))
--@t this is a table i will store info in it 
returns @t table  
  (
  id  int , 
  ename varchar(20)
   ) 
	
as
begin
	if @format='first'
	insert into @t select  st_id,St_Fname from student 
	else if @format='second'
	insert into @t select  st_id,St_Lname from student 
	else if @format='full'
	insert into @t select  st_id,St_Fname+St_Lname from student 
	return
end 

select * from getstudents('first')
select * from getstudents('second')
select * from getstudents('full')

