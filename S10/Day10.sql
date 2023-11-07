declare c1 Cursor
for Select st_id,st_fname
    from student
    where st_address='alex'
for read only   --update

declare @id int,@name varchar(10)
open c1
fetch c1 into @id,@name           --counter=0
while  @@FETCH_STATUS=0
	begin
	    Select @id,@name
		fetch c1 into @id,@name   --Counter++
	end
close c1
deallocate c1

Select distinct st_fname
from Student
where st_fname is not null

--one cell    ahmed,ali,amr,fady............

declare c1 cursor
for Select distinct st_fname
	from Student
	where st_fname is not null
for read only

declare @name varchar(15),@all_names varchar(300)=''
open c1
fetch c1 into @name
while @@FETCH_STATUS=0
	begin
	   set @all_names=concat(@all_names,',',@name)
	   fetch c1 into @name
	end
select substring(@all_names,2,len(@all_names))
close c1
deallocate c1

declare c1 cursor
for Select salary
    from Instructor
for update  

declare @sal int
open c1
fetch c1 into @sal
while @@FETCH_STATUS=0
	begin
	     if @sal<=3000
			update Instructor
				set salary= @sal*1.20
			where current of c1
		 else
		     update Instructor
				set salary=@sal*1.30
			  where current of c1
	
		fetch c1 into @sal
	end
close c1
deallocate c1

-----------------------------------
declare c1 cursor
for select st_fname
    from student
for read only

declare @name varchar(20),@counter int=0,@flag int =0
open c1
fetch c1 into @name
while @@FETCH_STATUS=0
	begin
		if @name='ahmed'
				set @flag=1
		if @name='amr'
			if @flag=1
					begin
						set @Counter+=1
						set @flag=0
					end
      fetch c1 into @name
	end
select @counter
close c1
deallocate c1


Create function summydata(@x int,@y int)
returns int
begin
	return @x+@y
end


Select dbo.summydata(2,7)

select dbo.sum2values(3,9)

select dbo.sum2values(st_id,dept_id)
from Student


sp_configure 'clr_enable',1
go
reconfigure 

Create table myshapes
(
 sh_id int,
 _desc varchar(20),
 sh_coords Circle    --string    x,y,rad     10,20,30
)


Select _desc
from myshapes
where sh_coords.rad<10

Select sh_coords.x,sh_coords.y
from myshapes


--SQLCLR

Create table locations
(
 Lid int,
 Lcity varchar(20),
 myPlace Point    --x,y   100,30   100,50
)


drop table locations


Select lcity ,convert(varchar(50), myPlace)
from locations
where Myplace.x<100
----------------------------------------

--cursor
--SQLCLR
--Backup&retsore
--snapshot


Create database snapITI    --read only DB 
on
(
 name='iti',
 filename='f:\mysnap.ss'
)
as snapshot of ITI


Select * from Student


Select * from Student

restore database iti
from database_snapshot='snapiti'

















