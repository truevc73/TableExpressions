use metroAlt

--1) Create a derived table that returns the position name as position
--and count of employees at that position. (I know that this can be done
--as a simple join, but do it in the format of a derived 
--table. There still will be a join in the subquery portion)
Select Position, Emps
from
(select PositionName as [Position], count(EmployeeKey) as Emps 
from Position 
inner join EmployeePosition 
on Position.PositionKey = EmployeePosition.PositionKey
group by PositionName)
as Employeesperposition

--2) Create a derived table that returns a column HireYear and the count 
--of employees who were hired that year. (Same comment as above).
Select HireYear, Emps
from
(select year(EmployeePositionDateAssigned) as [HireYear], count(EmployeeKey) as Emps
from EmployeePosition
group by year(EmployeePositionDateAssigned))
as Employeesperyear

--3) Redo problem 1 as a Common Table Expression (CTE).
go
with Employeesperposition as
(
select PositionName as [Position], count(EmployeeKey) as Emps 
from Position 
inner join EmployeePosition 
on Position.PositionKey = EmployeePosition.PositionKey
group by PositionName
)
Select Position, Emps from Employeesperposition

--4) Redo problem 2 as a CTE.
go 
with Employeesperyear as
(
select year(EmployeePositionDateAssigned) as [HireYear], count(EmployeeKey) as Emps
from EmployeePosition
group by year(EmployeePositionDateAssigned)
)
Select HireYear, Emps from Employeesperyear

--5) Create a CTE that takes a variable argument called @BusBarn and
--returns the count of busses grouped by the description 
--of that bus type at a particular Bus barn. Set @BusBarn to 3.
go 
Declare @BusBarn int
Set @BusBarn = 3; --declaring a variable, giving it a value of '3'

with bustypecount as
(
select Bustype.BusTypeKey as [Type], BusTypeDescription as [Description], count(BusKey) as [Count]
from BusType
inner join Bus
on BusType.BusTypeKey = Bus.BusTypeKey
where Bus.BusBarnKey = @BusBarn
group by Bustype.BusTypeKey, BusTypeDescription
)
select [Count], [Type], [Description] from bustypecount

--6) Create a View of Employees for Human Resources it should contain all the information
--in the Employee table plus their position and hourly pay rate
go
Create view HumanResources
AS
Select e.EmployeeKey [Key],
EmployeeLastName [Last],
EmployeeFirstName [First],
EmployeeAddress [Address],
EmployeeCity [City],
EmployeeZipCode [Zip],
EmployeePhone [Phone],
EmployeeEmail [Email],
EmployeeHireDate [Hire Date],
EmployeeHourlyPayRate [Pay Rate],
PositionName [Position]
From Employee e
inner join EmployeePosition ep
on e.EmployeeKey=ep.EmployeeKey
inner join Position p
on ep.PositionKey=p.PositionKey
go 
select [Key], [Last], [First], [Address], [City], [Zip], [Phone], [Email], [Hire Date], [Pay Rate], [Position]
from HumanResources

--7) Alter the view in 6 to bind the schema
go
Alter view [HP600\dlaschiazza].HumanResources
with schemabinding
AS
Select e.EmployeeKey [Key],
EmployeeLastName [Last],
EmployeeFirstName [First],
EmployeeAddress [Address],
EmployeeCity [City],
EmployeeZipCode [Zip],
EmployeePhone [Phone],
EmployeeEmail [Email],
EmployeeHireDate [Hire Date],
EmployeeHourlyPayRate [Pay Rate],
PositionName [Position]
From Employee e
inner join EmployeePosition ep
on e.EmployeeKey=ep.EmployeeKey
inner join Position p
on ep.PositionKey=p.PositionKey



