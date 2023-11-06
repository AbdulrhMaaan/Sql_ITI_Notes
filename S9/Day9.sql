select * from student

Create procedure setstud
as
 select * from student

 setstud
 execute setstud
 exec setstud

 alter schema hr transfer setstud
 
 hr.setstud

 Create proc getstbyadd @add varchar(20)
 as
    select st_id,st_fname,st_address
	from Student
	where St_Address=@add

getstbyadd 'cairo'
getstbyadd 'alex'

insert into Student(st_id,st_fname)
values(67,'ahmed')

alter proc Inststud @id int,@name varchar(20)
as
  if not exists(select st_id from student where st_id=@id)
    insert into Student(st_id,st_fname)
    values(@id,@name) 
  else
    select 'Duplicate id'


Inststud 69,'ahmed'

alter proc sumdata @x int=200,@y int=100
as
   select @x+@y

Sumdata 3,6         --Sending Parameters by position
sumdata @y=10,@x=8  --sending parameters by name

Sumdata 
Sumdata 20

---return values

create proc getstuds @did int
as
   select st_id,st_fname
   from student
   where dept_id=@did

--insert based on select
--insert based on execute


insert into test4(id,name)
execute getstuds 20

declare @t table(id int,ename varchar(20))
insert into @t
execute getstuds 10
select count(*) from @t


Create proc getdata @id int
as
   declare @age int
		select @age=st_age from Student
		where st_id=@id
   return @age

declare @x int
set @x=execute getdata 4
select @x

alter proc getdata @id int,@age int output,@name varchar(20) output
as
  		select @age=st_age,@name=st_fname from Student
		where st_id=@id
   
declare @x int,@y varchar(20)
execute getdata 1,@x output,@y output
select @x,@y
----------------------------------------------------------SQL injection
alter proc getdata @age int output,@name varchar(20) output
with encryption
as
  		select @age=st_age,@name=st_fname 
		from Student
		where st_id=@age
   
declare @x int=1,@y varchar(20)
execute getdata @x output,@y output
select @x,@y


sp_helptext 'getdata'







Create proc getvalues @col varchar(20),@t varchar(20),@cond varchar(20)
as
   execute('select '+@col+' from '+@t+' where '+@cond)


getvalues '*','student','st_id=1'

getvalues '*','instructor','salary>1000'
------------------------------------
--3 types of SP
--user defined SP
getsbyadd getstuds sumdata getvalues
--Built in SP
SP_bindrule sp_bindefault sp_addtype sp_helpconstraint sp_rename sp_who
--Trigger
-----can't call
-----can't send paramerters
------triggers table 
------code listen event    [insert update delete]
--implicit code [automatic firing] 

insert into student(st_id,st_fname)
values(73,'ahmed')

update student set st_age+=1

create trigger myt1
on student
after insert
as 
	select 'welcome to ITI'


insert into student(st_id,st_fname)
values(73,'ahmed')

create trigger myt2
on student
for update
as
	select getdate(),suser_name()

update student set st_age+=1

Create trigger myt3
on student
instead of delete
as
	select 'Not allowed for user= '+suser_name()


delete from student where st_id=73

create trigger myt4
on department
instead of insert,update,delete
as
	select 'not allowed'

drop trigger myt4

alter table department disable trigger myt4
alter table department enable trigger myt4



update Department set Dept_Name='cloud' where dept_id=10

alter trigger myt5
on course
after update
as
    if update(crs_name)
	   select 'welcome to ITI'


update course set crs_duration=100 where crs_id=100


create trigger myt7
on course
after update
as
	Select * from inserted
	select * from deleted


update course set crs_name='Angular',crs_duration=100,top_id=4
where crs_id=100

update course set crs_name='html5',crs_duration=30,top_id=1
where crs_id=300


create trigger t11
on course
instead of delete
as
	Select 'not allowed to delete crs name='+(select crs_name from deleted)


delete from course where crs_id=2


create trigger t12
on student
after delete
as
	if format(getdate(),'dddd')='friday'
		begin
		  select 'not allowed'
			insert into student
			select * from deleted
		end

create trigger t12
on student
instead of delete
as
	if format(getdate(),'dddd')!='friday'
		begin
		  delete from student where st_id= (select st_id from deleted)
		end


Create table history
(
 _user varchar(50),
 _date date,
 _oldid int,
 _newid int
)

Create trigger t20
on topic
instead of update
as
	if update(top_id)
		begin
		    declare @old int,@new int
			Select @old=top_id from deleted
			select @new=top_id from inserted
			insert into history
			values(suser_name(),getdate(),@old,@new)
		end
----------------------------------------
--output????   --runtime trigger


update student
	set st_address='alex',st_id=46
output suser_name(),getdate(),deleted.st_id,inserted.st_id into history
where st_id=555


delete from Student 
output deleted.st_fname
where st_id=61


insert into student(st_id,st_fname,st_age)
output 'welcome to ITI'
values(333,'ahmed',22)


insert into student(st_id,st_fname,st_age)
values(34,'ahmed',22)
-------------------------------------------------
--XML
--XML
--For XML
--raw [simple order group]
--auto [join]
--explicit     [Mixed Tages]
--path         [Mixed Tages]

--The FOR XML clause is central to XML data retrieval in SQL Server 2005. This clause
--instructs the SQL Server query engine to return the data as an XML stream rather than
--as a rowset

--The FOR XML clause has four modes to control XML Formate:
--1)RAW
--Transforms each row in the result set into an XML element

select * from Student
for xml raw


select * from Student
for xml raw('Stud')

select * from Student
for xml raw('Student'),ELEMENTS


select * from Student
for xml raw('Student'),ELEMENTS,ROOT


select * from Student
for xml raw('Student'),ELEMENTS,ROOT('ITI_studs')

--how to show null values in xml
select * from Student
for xml raw('Student'),ELEMENTS xsinil,ROOT('STUDENTS')

--RAW mode queries can include aggregated columns and GROUP BY clauses.
select * from Student
order by St_Address
for xml raw('Student'),ELEMENTS,ROOT('STUDENTS')

select St_Address,COUNT(st_id) from Student
group by St_Address
for xml raw('Student'),ELEMENTS,ROOT('STUDENTS')

--u can only present data as elemets or attributes
--using For XML Path is the solution for representing mixed "elemets and attributes"
--for each separate row

--JOIN problem
select topic.Top_Id,Top_Name,Crs_Id,Crs_Name 
from Topic ,Course 
where topic.Top_Id=course.Top_Id
order by top_name
for xml auto,ELEMENTS

--should be nested topic includes courses
--using For XML Auto is the solution for this problem

--2)AUTO
--Returns query results in a simple, nested XML tree. Each table in the FROM clause 
--for which at least one column is listed in the SELECT clause is represented as an XML 
--element. The columns listed in the SELECT clause are mapped to the appropriate element attributes.
select Topic.Top_Id,Top_Name,Crs_Id,Crs_Name 
from Topic ,Course 
where topic.Top_Id=Course.Top_Id
for xml raw,elements

select * 
from Student as st
for xml auto

select * 
from Student 
for xml auto,elements

select * 
from Student 
for xml auto,elements,root('ALLstudents')

--Benifets of For XML Auto
--1)Each row returned by the query is represented by an XML element with the same name
--2)the child elements are collated correctly with their parent
--3)Each column in the result set is represented by an attribute, unless the ELEMENTS option is specified
	select Topic.Top_Id,Top_Name,Crs_Id,Crs_Name 
	from Topic ,Course 
	where topic.Top_Id=Course.Top_Id
	for xml auto,elements,root('Courses_Inside_Topics')
--4)Aggregated columns and GROUP BY clauses are not supported in AUTO mode
--queries (although you use an AUTO mode query to retrieve aggregated data
--from a view that uses a GROUP BY clause).


--5)if u want to display topic data as attributes and course data as elements
--use Type option
select Topic.Top_Id,Top_Name,
	   (select Crs_Id,Crs_Name 
	    from Course 
		where topic.Top_Id=Course.Top_Id
		for xml auto,type,elements
	   ) 
from Topic
for xml auto

--in old versions error
--nested query returns data as characters but i need result as XML
--So i should use Type option
select Topic.Top_Id,Top_Name,
	   (select Crs_Id,Crs_Name 
	    from Course 
		where topic.Top_Id=Course.Top_Id
		for xml auto,type,elements
	   ) 
from Topic
for xml auto

--3)EXPLICIT
--Tabular representations of XML documents
--A custom format specified in the query formats the resulting XML data.
--Allow complete control of XML format
select 1 as tag,NULL as parent,
       Top_id as [Topic!1!TopicID],
       Top_name as [Topic!1!Name!element]
from Topic
for xml explicit

------------------------------------------------------------------------
--  Tag  --  Parent  -- Topic!1!TopicID  --  Topic!1!Name!element
--   1   --   NULL   --        1         --           Ahmed
--   1   --   NULL   --        2         --           Ali
------------------------------------------------------------------------

--if u want to control display of topics and courses data as we do with "auto,type"
--use Explicit with union all
--Note u must use order by in this case
select 1 as tag,NULL as parent,
      Topic.Top_Id as [topic!1!topID],
      Top_Name as [topic!1!TopicName],
      Null as [Course!2!CourseID!element],
      null as [Course!2!CourseName!element] 
	from Topic
union all
select 2 as tag,1 as parent,topic.Top_Id,null,Crs_Id,Crs_Name
from Topic ,Course 
where topic.Top_Id=Course.Top_Id
order by [topic!1!topID],[Course!2!CourseID!element]
for xml explicit
 
--4)PATH
--Provides a simpler way to mix elements and attributes, and to 
--introduce additional nesting for representing complex properties.
--Easier than Explicit mode

select st_id "X",
	   St_Fname "Y",
	   St_Lname "Z",
	   St_Address "M"	
from Student

--xpath expressions

select st_id "@SID",
	   St_Fname "StudentName/FirstName",
	   St_Lname "StudentName/LastName",
	   St_Address "Address"	
from Student
for xml path('student')

select st_id "@StudentID",
	   St_Fname "StudentName/@FirstName",
	   St_Lname "StudentName/LastName",
	   St_Address "Address"	
from Student
for xml path('Student'),root('Students')

select Topic.Top_Id "@TopicID" ,Top_Name "Name",
	   (select Crs_Id "CourseID",Crs_Name "CourseName"  
	    from Course 
		where topic.Top_Id=Course.Top_Id
		for xml pATH('Course'),TYPE,root('Courses')
	   ) 
from Topic
for xml path('Topic'),root('Topic_Courses')


--The FOR XML clause has four modes and some options:
--1)ELEMENTS

--2)BINARY BASE64 option 
--Returns binary data fields, such as images, as base-64-encoded binary.
select * from Student
for xml raw('Student'),ELEMENTS,BINARY BASE64

--3)ROOT option

--4)TYPE option 
--Returns the query results as the xml data type.

declare @x xml=(
select * from Student
for xml raw('Student'),ELEMENTS,ROOT
)
select @x

--5)XMLDATA option 
--Returns an inline XML-Data Reduced (XDR) schema.

--6)XMLSCHEMA option 
--Returns an inline World Wide Web Consortium (W3C) XML Schema (XSD).

-------------------------------------------------------------------------------------
--XML Shredding   --open xml
--The process of transforming XML data to a rowset is known as “shredding” the XML data.

--Processing XML data as a rowset involves the following five steps:
--1)create proc processtree
declare @docs xml =
				'<Students>
				 <Student StudentID="1">
					<StudentName>
						<First>AHMED</First>
						<Second>ALI</Second>
					</StudentName>
					<Address>CAIRO</Address>
				</Student>
				<Student StudentID="2">
					<StudentName>
						<First>OMAR</First>
						<Second>SAAD</Second>
					</StudentName>
					<Address>ALEX</Address>
				</Student>
				</Students>'

--2)declare document handle
declare @hdocs int

--3)create memory tree
Exec sp_xml_preparedocument @hdocs output, @docs

--4)process document 'read tree from memory'
--OPENXML Creates Result set from XML Document

SELECT * into XMLtable
FROM OPENXML (@hdocs, '//Student')  --levels  XPATH Code   get all child tags [student]
WITH (StudentID int '@StudentID',
	  Address varchar(10) 'Address', 
	  StudentFirst varchar(10) 'StudentName/First',
	  StudentSECOND varchar(10) 'StudentName/Second'
	  )
--5)remove memory tree
Exec sp_xml_removedocument @hdocs


Select * from XMLtable


-----------------------------------------------------------------------------------
--Example 
drop table xmlstudent
--1)create table
CREATE TABLE xmlstudent
(StudentID INT,First VARCHAR(50),Second VARCHAR(50),Address VARCHAR(50))

--2)declare XML Container
declare @docs xml =
				'<Students>
				 <Student StudentID="1">
					<StudentName>
						<First>AHMED</First>
						<Second>ALI</Second>
					</StudentName>
					<Address>CAIRO</Address>
				</Student>
				<Student StudentID="2">
					<StudentName>
						<First>OMAR</First>
						<Second>SAAD</Second>
					</StudentName>
					<Address>ALEX</Address>
				</Student>
				</Students>'

--3)declare document handle
declare @hdocs int

--4)create memory tree
Exec sp_xml_preparedocument @hdocs output, @docs

--5)process document 'read tree from memory'
--OPENXML Creates Result set from XML Document
INSERT INTO xmlstudent
SELECT * FROM OPENXML (@hdocs, '/Students/Student') 
WITH xmlstudent

--5)remove memory tree
Exec sp_xml_removedocument @hdocs

Select * from xmlstudent


--XQuery
--Query language to indentify nodes in XML
--Query, Value, Exist, Modify and Nodes methods in XQuery

--Examples:
<InvoiceList>
	<Invoice InvoiceNo="1">
		<Customer CID="1">ahmed</Customer>
		<InvoiceTotal>300<\InvoiceTotal>
	</Invoice>
	
	<Invoice InvoiceNo="2">
		<Customer CID="2">ahmed</Customer>
		<InvoiceTotal>100<\InvoiceTotal>
	</Invoice>
	
	<Invoice InvoiceNo="3">
		<Customer CID="3">ahmed</Customer>
		<InvoiceTotal>500<\InvoiceTotal>
	</Invoice>
</InvoiceList>

--/InvoiceList/Invoice
--All Invoice elements immediately contained within the root InvoiceList element

--(/InvoiceList/Invoice) [2] 
--The second Invoice element within the root InvoiceList element

--(InvoiceList/Invoice/@InvoiceNo) [1]
--The InvoiceNo attribute of the first Invoice element in the root InvoiceList element

--(InvoiceList/Invoice/Customer/text())[1]
--The text of the first Customer element in an Invoice element in the InvoiceList root element

--/InvoiceList/Invoice[@InvoiceNo=1000]
--All Invoice elements in the InvoiceList element that have an InvoiceNo attribute with the value 1000

 CREATE TABLE customerData
 (
        customerDocs xml NOT NULL,
 ) 

INSERT INTO customerData(customerDocs)
       VALUES(N'<?xml version="1.0"?>
       <customers>
              <customer FirstName="Bob" LastName="Hayes" Zipcode="91126" status="current">
                     <order ID="12221" Date="July 1, 2006">Laptop</order>
              </customer>
              <customer FirstName="Judy" LastName="Amelia" Zipcode="23235" status="current">
                     <order ID="12221" Date="April 6, 2006">Workstation</order>
              </customer>
              <customer FirstName="Howard" LastName="Golf" Zipcode="20009" status="past due">
                     <order ID="3331122" Date="December 8, 2005">Laptop</order>
              </customer>
              <customer FirstName="Mary" LastName="Smith" Zipcode="12345" status="current">
                     <order ID="555555" Date="February 22, 2007">Server</order>
              </customer>
       </customers>')


Select customerDocs.query('/customers/customer')
from customerData 

Select customerDocs.query('(/customers/customer)[1]')
from customerData 

Select customerDocs.query('/customers/customer/order')
from customerData 

Select customerDocs.query('(/customers/customer/order)[1]')
from customerData



-- FLWOR with LET operator
--Query language to indentify nodes in XML
--Statments
-------------
--1)for 
--Used to iterate through a group of nodes at the same level in an XML document.
--is like (select from) in sql

--2)where 
--Used to apply filtering criteria to the node iteration. XQuery includes
--functions such as count that can be used with the where statement.
--like where clause in sql

--3)return 
--Used to specify the XML returned from within an iteration.
--is like select in sql

--4)let is used for issignment

--5)order used for order by

-- FLWOR simple example

SELECT customerDocs.query('
       for $order in /customers/customer/order
        where $order/@ID >=555555
       return $order/text()')
FROM customerData


SELECT customerDocs.query('
       <CustomerOrders> {
       for $i in //customer
       let $name := concat($i/@FirstName, " ", $i/@LastName)
       order by $i/@LastName
       return
              <Customer Name="{$name}">
              {
              $i/order
              }
              </Customer>
       }
       </CustomerOrders>')
FROM customerData
------------------------------------------------------------------------------------ 
 								/*Typed */

CREATE XML SCHEMA COLLECTION BookIndex
AS
N'<xs:schema attributeFormDefault="unqualified"
    elementFormDefault="qualified"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="index">
        <xs:complexType>
            <xs:sequence>
                <xs:element maxOccurs="unbounded" name="keyword">
                    <xs:complexType>
                        <xs:simpleContent>
                            <xs:extension base="xs:string">
                                <xs:attribute name="page" type="xs:int" use="required" />
                            </xs:extension>
                        </xs:simpleContent>
                    </xs:complexType>
                </xs:element>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>'


create table Books
(
	ISBN char(13) primary key not null,
	Title nvarchar(200) not null,
	BookIndex1 xml(dbo.BookIndex) 
)

Insert into dbo.Books
(ISBN,Title,BookIndex1)
VALUES
('1-59059-589-4','Vxxxxxxxxxxxxxx',
Cast('
<index>
    <keyword page="15">AppDomain</keyword>
    <keyword page="319">DataTable</keyword>
    <keyword page="328">DataSet</keyword>
    <keyword page="149">Encrypt</keyword>
    <keyword page="167">File IO</keyword>
    <keyword page="27">GAC</keyword>
    <keyword>Generics</keyword>

</index>' as XML) )

select * from dbo.Books

declare @xml xml(dbo.BookIndex)
set @xml ='<index>
    <keyword page="1">Chapter1</keyword>
    <keyword page="50">Chapter2</keyword>
    <keyword page="100">Chapter3</keyword>
    <keyword page="200">Chapter4</keyword>
    <keyword page="220">Chapter5</keyword>
    <keyword page="379">Chapter6</keyword>
    <keyword page="1919">Chapter7</keyword>
</index>' 
insert into dbo.Books
(ISBN,Title,BookIndex)
VALUES ('1-11111-111-1','SQL Server 2008',@xml)


drop table books

--HOW TO SHOW SCHEMA CONTENT
select XML_SCHEMA_NAMESPACE('dbo','BookIndex')

drop xml schema collection dbo.BookIndex

select name
from sys.XML_SCHEMA_COLLECTIONS
order by create_date

--CREATE PRIMARY XML INDEX idx_XML_Primary_Books_BookIndex
--ON dbo.Books(BookIndex)--need a clustered index in the table

-------------------------------------------------------------------------
							/*UnTyped*/ 
						--without Schema
CREATE TABLE docs 
(
	pk int PRIMARY KEY, 
	xCol XML
)
----------------------------------------------
INSERT INTO docs 
VALUES 
(1,'<book genre="security" publicationdate="2002" ISBN="0-7356-1588-2">
   <title>Writing Secure Code</title>
   <author>
      <first-name>Michael</first-name>
      <last-name>Howard</last-name>
   </author>
   <author>
      <first-name>David</first-name>
      <last-name>LeBlanc</last-name>
   </author>
   <price>39.99</price>
</book>')

select * from docs
------------------------------------------------------------
/*
to retrieve the stored size in bytes of 
the XML instances in the XML column 
*/
SELECT DATALENGTH (xCol)
FROM    docs



-----------------------------------

--xml & Pluralsights
--xml is used to solve multivalued problem
--xml is a complex type but DB is a single type or scalar
--xml start from sql 2000
--new in sql2005 (xml data type, xml schema collection, xquery, xpath)
--sql2008 & sql2012 built a set of schemas for its own tools & code i found it in the following path
--c:\\programfiles\sqlserver\100\tools\bin\schemas\sqlserver\2004\sqltypes

--1) open xml file
CREATE TABLE invovice (x XML)

INSERT INTO invovice 
SELECT OPENROWSET(BULK 'c:\invoice.xml' SINGLE_BLOB)  
--openrowset is a function , bulk is the provider and single_blob is encoding menthod

--2) if u have aschema in afile and u want to create schema collection ofrom it

DECLARE @x XML
SET @x=(SELECT OPENROWSET(BULK 'c:\invoice.xsd' SINGLE_BLOB) as)

CREATE XML SCHEMA COLLECTION invoice_type AS @x



--how to show null values in xml
select * from Student
for xml raw('Student'),ELEMENTS xsinil,ROOT('STUDENTS')


---using xml and xquery togather

CREATE FUNCTION getid(@data XML)
RETURNS int

AS
BEGIN
RETURN @data.value('/Student[1]/@StudentID','itnt')
END


CREATE TABLE mydata
(
XMLDATA XML,
Stud_ID AS dbo.getid(XMLDATA) 
)

INSERT INTO mydata(XMLDATA) VALUES('<Student StudentID="1">
										<StudentName>
											<First>AHMED</First>
											<Second>ALI</Second>
										</StudentName>
										<Address>CAIRO</Address>
									   </Student>')

SELECT * FROM mydata


--openxml -> if u enter xml with the same structure of the table


----XQuery
 CREATE TABLE customerData
 (
        customerDocs xml NOT NULL,
 ) 

INSERT INTO customerData(customerDocs)
       VALUES(N'<?xml version="1.0"?>
       <customers>
              <customer FirstName="Bob" LastName="Hayes" Zipcode="91126" status="current">
                     <order ID="12221" Date="July 1, 2006">Laptop</order>
              </customer>
              <customer FirstName="Judy" LastName="Amelia" Zipcode="23235" status="current">
                     <order ID="12222" Date="April 6, 2006">Workstation</order>
              </customer>
              <customer FirstName="Howard" LastName="Golf" Zipcode="20009" status="past due">
                     <order ID="3331122" Date="December 8, 2005">Laptop</order>
              </customer>
              <customer FirstName="Mary" LastName="Smith" Zipcode="12345" status="current">
                     <order ID="555555" Date="February 22, 2007">Server</order>
              </customer>
       </customers>')

--Query, Value, Exist, Modify and Nodes methods in XQuery
--query method retuens xml data type
--value method returns ->scalar one
--exist method used for check
--nodes method return an array
--modify method is used for insert and update and delete from xml
Select customerDocs.query('/customers/customer')
from customerData 

Select customerDocs.query('(/customers/customer)[1]')
from customerData 

Select customerDocs.value('(/customers/customer/@FirstName)[1]','varchar(50)')
from customerData 

Select customerDocs.value('(/customers/customer/@FirstName)[1]','varchar(50)')
from customerData 

Select customerDocs.query('count(//customer)')
from customerData 




--Stored Procedures
--Trigger
--Output
--XML




















