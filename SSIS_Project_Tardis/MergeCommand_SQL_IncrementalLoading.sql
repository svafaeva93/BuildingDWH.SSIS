-- Incremental loading using Merge Command 
---Structure of Merge Command 
Use TARDISDW_Merge
GO


--Merge into Destination as Destination 
--using Source as Source 
--on Source.Id = Destination.Id 

--when matched and some condition 
--then 
--update 
--set 


--when not matched by target
--then 
--insert into destination (columns) values (source columns or reference table columns); 

select  * from Stage_Tardis.dbo.Stage_employee
select * from DimEmployee 

--Real Query 
MERGE INTO DimEmployee AS D
USING (
    SELECT S.empid, S.Name, S.Salary, S.Tax, CR.ID AS CityID
    FROM Stage_Tardis.dbo.Stage_employee AS S
    JOIN CityRef AS CR ON S.city = CR.name
) AS S
ON D.empid = S.empid
WHEN NOT MATCHED BY TARGET THEN
    INSERT (empid, Name, Salary, Tax, City)
    VALUES (S.empid, S.Name, S.Salary, S.Tax, CAST(S.CityID AS VARCHAR(15)))
WHEN MATCHED AND (S.Name <> D.Name OR S.Salary <> D.Salary OR S.Tax <> D.Tax) THEN
    UPDATE SET
        D.Name = S.Name,
        D.Salary = S.Salary,
        D.Tax = S.Tax;


select * from DimEmployee order by empid

Select * from TARDISDW_SP.dbo.CityRef

Update Stage_Tardis.DBO.Stage_employee
set name = 'Carlson'
where empid = 5 

SELECT * FROM Stage_Tardis.DBO.Stage_employee
insert into Stage_Tardis.dbo.Stage_employee values (6, 'Anna', 2800, 18, 'NYC', 'F') 
insert into Stage_Tardis.dbo.Stage_employee values (7,'Zarina', 2000, 22, 'Vancouver', 'F')

Update Stage_Tardis.DBO.Stage_employee
Set City = 'NYC'
Where empid = 6 

Select * from CityRef
Insert into CityRef values (40,'Vancouver')