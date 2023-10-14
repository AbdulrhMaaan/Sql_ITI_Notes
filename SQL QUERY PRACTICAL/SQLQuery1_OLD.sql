
select YEAR(GETDATE())
select Month(GETDATE())
select Day(GETDATE())
select SUSER_NAME()
select DB_NAME()

---1.	Display all the employees Data.
select * 
from Employee


----2.	Display the employee First name, last name, Salary and Department number.
select Fname,Lname,Salary,Dno
from Employee


---3.	Display all the projects names, locations and the department which is responsible about it.
select Pname,Plocation,Dnum
from Project


--4.	If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
select Fname+'  '+Lname +'  '+ CONVERT(varchar(10),Salary*.1) as "alias"
from Employee

---5.	Display the employees Id, name who earns more than 1000 LE monthly.

select SSN,Fname,Salary
from Employee
where Salary>1000


----6.	Display the employees Id, name who earns more than 10000 LE annually.
select SSN,Fname,Salary
from Employee
where Salary*12 >1000


---7.	Display the names and salaries of the female employees 
select Fname,Lname,Salary
from Employee
where Sex='F'

----8.	Display each department id, name which managed by a manager with id equals 968574.
select Dname,Dnum
from Departments
where MGRSSN=968574


----9.	Dispaly the ids, names and locations of  the pojects which controled with department 10.
select Pname,Pnumber,Plocation,Dnum
from Project
where Dnum=10


----1.	Display the Department id, name and id and the name of its manager.
select Dnum,Dname , Fname+'  ' +Lname as Name,SSN
from Departments , Employee
where SSN=MGRSSN

---2.	Display the name of the departments and the name of the projects under its control.
select D.Dname,p.Pname
from  Departments D ,Project P
where D.Dnum=P.Dnum


---3.	Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select Dependent.*
from   Dependent,Employee 
where ESSN=SSN


----4.	Display the Id, name and location of the projects in Cairo or Alex city.
select Pnumber,Pname,Plocation ,City
from Project
where City = 'Cairo' or City = 'Alex'


---5.	Display the Projects full data of the projects with a name starts with "a" letter.
select *
from Project
where Pname like 'a%'


-----6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select DISTINCT  Fname ,Salary,Dno
from Employee,Departments
where Dno=30 AND Salary between 1000 and 2000


----7.	Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
select DISTINCT Fname+' '+Lname 
from Employee Inner join Departments
ON  Dno=10 
INNER JOIN  
Project
ON Pname='AL Rabwah'
INNER JOIN 
Works_for
ON Hours>=10



---8.	Find the names of the employees who directly supervised with Kamel Mohamed.
select Y.Fname +' ' + Y.Lname As Emploer
from Employee X , Employee Y
where  Y.SSN=X.Superssn  AND   X.Fname='Kamel' And X.Lname='Mohamed'

---9.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select    Fname+'  '+Lname  
from Employee , Project ,Works_for
where SSN=ESSN  and Pno=Pnumber
order by Pname 

----10.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.

select Pnumber,Project.Dnum,Lname,Address,Bdate
from Project  inner join Departments
On  Project.Dnum=Departments.Dnum  And City='Cairo'
inner join
Employee
On SSN=MGRSSN



----11.	Display All Data of the mangers
select *
from Employee,Departments
where SSN=MGRSSN


----12.	Display All Employees data and the data of their dependents even if they have no dependents
select Distinct Employee.*
from Employee full outer join Dependent
on SSN=ESSN

---1.	Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO Employee (Fname,Lname,SSN,Bdate,Sex,Salary,Dno,Superssn)
Values('Abdo','Arafa',102672,'2000-09-29','M',3000,30,112233)
select * from Employee where Fname='Abdo'


----2.	Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or manager number to him.
INSERT INTO Employee (Fname,Lname,SSN,Sex,Dno)
Values('Anas','Khalid',102660,'M',30)
select * from Employee where Fname='Anas'

----3.	Upgrade your salary by 20 % of its last value.
update Employee
set Salary=Salary+(Salary*.2)
where SSN=102672
select * from Employee where Fname='Abdo'




---8.	Try to get the max 2 salaries using subquery

-- this to find only the second one 
select max(Salary) 
from Employee
where Salary not in (select MAX(Salary)  from Employee )

---this is to find the two max salary 
select MAX(Salary)as First   FROM Employee 
select MAX(Salary)as second  FROM Employee 
where Salary NOT IN (SELECT MAX(Salary) FROM Employee )


--- this is using top 
select top(3) Salary
from Employee
order by Salary desc 


---- to represent them at only one sheet     so  only one seleect 
select 
(select Max (Salary) from Employee )  First ,
(select MAX (Salary) from Employee where Salary not in (select MAX(Salary) from Employee) )Second


---1.	Display (Using Union Function)
---a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
---b.	 And the male dependence that depends on Male Employee
select Dependent_name, Dependent.Sex
from Dependent
where Dependent.Sex='F'
UNION ALL
select Dependent_name, Dependent.Sex
from Dependent
where Dependent.Sex='M'


---2.	For each project, list the project name and the total hours per week (for all employees) spent on that project.
select Pname, Hours
from Project ,Works_for
where Pnumber=pno

---3.	Display the data of the department which has the smallest employee ID over all employees' ID.
select *
from Departments 
where MGRSSN IN (select min(SSN)  from   Employee   group by Dno )



----4.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select MIN(Salary) as min,MAX(Salary) as max ,Avg(Salary)as Avg,(select Dname from Departments where Dnum=Dno) Deptname
from Employee
group by Dno


---5.	List the last name of all managers who have no dependents.
select Lname 
from Employee
where SSN not IN (SELECT ESSN from Dependent )

----6.For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.

select Dname,Dnum,(select COUNT(Dno) from Employee where Dno=Dnum group by Dno)
from Departments ,Employee
where Dno=Dnum
Group by Dnum,Dname
Having AVG(Salary)  < (select avg(Salary) from Employee)

---TA7777
select Departments.Dname, Departments.Dnum, count(Employee.Dno) ,AVG(Employee.Salary)
from Departments, Employee
where Employee.Dno=Departments.Dnum
group by Departments.Dname, Departments.Dnum
having AVG(Employee.Salary)<(select AVG(Employee.Salary) from Employee)



-----7.	Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.
select Fname,Lname,Pname
from Employee e ,Project p ,Works_for w
where w.pno=p.Pnumber and w.ESSn=e.SSN
order by Dno ,Lname,Fname


---9.	Get the full name of employees that is similar to any dependent name
select e.Fname ,d.Dependent_name
from Employee e , Dependent d 
where e.SSN=d.ESSN  and  d.Dependent_name like '%'+e.Fname+'%'

