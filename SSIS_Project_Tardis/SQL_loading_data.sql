---- Loading Data using SSMS applying logic from SSIS

USE TARDIS
GO
drop table TARDIS.dbo.employee
Create Table employee 
(
	empid int primary key, 
	Name varchar(100) not null, 
	Salary money not null,
	Tax int not null, 
	City varchar(50) not null,
	Gender char(1) not null
	)

Insert into Tardis.dbo.employee Values (1, 'Richard', 1200, 12,'NYC', 'M') 
Insert into Tardis.dbo.employee Values (2, 'Allison', 1500, 15,'LA', 'F')
Insert into Tardis.dbo.employee Values (3, 'Simon', 2000, 18,'NYC', 'M')
Insert into Tardis.dbo.employee Values (4, 'Sonya', 2200, 24,'Massachusets', 'F')
Insert into Tardis.dbo.employee Values (5, 'Robert', 2500, 17,'Massachusets', 'M')

select * from Tardis.dbo.employee

use Stage_Tardis
drop Table Stage_employee 

Create Table Stage_employee 
(
	empid int primary key, 
	Name varchar(100) not null, 
	Salary money not null,
	Tax int not null, 
	City varchar(50) not null, 
	Gender char(1) not null
	)

-------in SSIS 
--- Loaded Data from Source to Staging 
--- Loaded the Data from Staging to Datawarehouse 

-- Loading the data from Source into Staging table


-- Structure of inserting data from one table to another table 
	--insert into Dest_table 
	--select * from Source_Table 

truncate table Stage_employee --- to prevent duplicates if the package is run several times 

insert into Stage_employee
select * from Tardis.dbo.employee

Drop Proc ETL_Loading_to_Staging

CREATE PROC ETL_Loading_To_Staging
AS 
Begin
---Deleting all rows from staging 
	truncate table Stage_employee 
---- Data Insertion 
	insert into Stage_employee
	select * from Tardis.dbo.employee
END

--- Loaded the Data 
exec ETL_Loading_to_Staging

-- Reading the Data 
select * from Stage_employee 

--USE TARDISDW_SP
--DROP Table DimEmployee
-- Loading the data from Staging table into Datawarehouse table 
Create Table TARDISDW_SP.dbo.DimEmployee 
(
	empid int primary key, 
	Name varchar(100) not null, 
	Salary money not null,
	Tax int not null, 
	City varchar(50) not null 
)
---Truncate table DimEmployee

Insert into DimEmployee (empid
						,Name 
						,salary
						,tax
						,City)
Select   empid
		,Name 
		,salary
		,18 as tax
		,City 
from Stage_Tardis.dbo.Stage_employee

--Drop Table CityRef

Create table CityRef (Id int, name varchar(30)) 

Insert into CityRef Values (10, 'LA'), (20, 'NYC'), (30, 'Massachusets')

-- Inner Join 
-- Outer Join 
	-- Right Outer Join 
	-- Left Outer Join 
	-- Full Outer Join 

Drop Proc ETL_Load_DimEmp_Incr_Loading

Create Proc ETL_Load_DimEmp_Incr_Loading 
AS 
Begin
--Business Rule:
--Look up on dbo.CityRef based on City and get Id fro CityRef table 
-- Incremental Loading 
	Insert into DimEmployee (empid, Name, Salary, Tax, City)
	Select   se.empid -- Wont change -> Business Key 
			,se.Name -- Might Change 
			,se.Salary -- Might Change 
			,18 as Tax -- Wont change -> Default value 
			,CAST(c.Id as varchar(20)) City -- Wont Change -> lookup on different table and bringing data here 
	from Stage_Tardis.dbo.Stage_employee se
	Inner Join CityRef c on se.City = c.name  -- lookup on CityRef table based on CityName 
	Left Join dbo.DimEmployee de on se.empid=de.empid
	Where de.empid is null  -- checking if data exists for inserting 

-- Updating the Information Incrementally 

	Update de
	Set de.Name = se.Name
	, de.Salary = se.Salary 
	From Stage_Tardis.dbo.Stage_employee se 
	Inner Join dbo.DimEmployee de on se.empid = de.empid
	Where (de.Name<> se.Name) or (de.Salary <> se.Salary) 
END
GO

Truncate table DimEmployee

---Reading the data 
select * from dbo.DimEmployee

Use TARDISDW_SP
exec ETL_Load_DimEmp_Incr_Loading 
