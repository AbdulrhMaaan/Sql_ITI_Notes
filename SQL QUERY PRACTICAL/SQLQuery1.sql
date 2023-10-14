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