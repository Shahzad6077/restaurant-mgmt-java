--create database RestaurantSystem



Create TABLE EMPLOYEE
(
	EmpID varchar(50) Default 'Employee Left.',
	EmpName varchar(50) Not Null,
	PhoneNo varChar(20) Null,
	ShiftPeriod varChar(20) DEFAULT NULL,
	Address varchar(50) Default Null,
	PasswordE varBinary(1000) Not Null,
	Status varChar(20) default 'Active',
	Constraint EMPLOYEE_pk PRIMARY KEY (EmpID)
	)

insert INTO EMPLOYEE (EmpID,EmpName,PasswordE)
VALUES ('1148','Shahzad',CONVERT(varbinary,'379Shahzad')),
		('1149','Sharjeel',CONVERT(varbinary,'pop')),
		('1151','Zahid',CONVERT(varbinary,'asd')),
		('1150','Usman',CONVERT(varbinary,'qwe') ),
		('1152','Mubashir',CONVERT(varbinary,'234')),
		('1153','Sheriyar',CONVERT(varbinary,'cvb')),
		('1124','Ali',CONVERT(varbinary,'hgf')),
		('1160','Shahzad',CONVERT(varbinary,'bnm')),
		('1144','Racstar',CONVERT(varbinary,'778')),
		('1122','Talha',CONVERT(varbinary,'676') );

insert INTO EMPLOYEE (EmpID,EmpName,PasswordE)
VALUES ('4854','Khalil',CONVERT(varbinary,'123123')),
		('1953','Jameel',CONVERT(varbinary,'123123'))

Delete From EMPLOYEE


CREATE TABLE ROLLE
(
	RoleName varchar(50) Default 'Desired Role is End.',
	Pay Float default 0.0,
	Constraint ROLLE_pk Primary Key (RoleName)
	)

Insert INTO ROLLE (RoleName,Pay)
values ('Admin',50000),
		('Cashier',21000),
		('Cheif',22000),
		('Waiter',15000),
		('Security Guards',16000),
		('Dilvery Boy',18000);


		SELECT *
		FROM ROLLE


CREATE TABLE EMPLOYEE_ROLES
(
	EmpID varchar(50) Default 'Employee Left.',
	RoleName varchar(50) Default 'Desired Role is End.',
	Constraint Emp_roles_pk Primary key (EmpID,RoleName),
	Constraint Emp_roles_fk1 Foreign Key (EmpID) references EMPLOYEE(EmpID) ON Update Cascade on delete set default,
	Constraint Emp_roles_fk2 Foreign KEY (RoleName) references ROLLE(RoleName) ON Update Cascade on delete Cascade
	)
	 
Insert Into EMPLOYEE_ROLES (EmpID,RoleName)
Values ('1148','Cashier'),
		('1149','Admin'),
		('1151','Admin'),
		('1150','Admin'),
		('1152','Admin'),
		('1153','Admin'),
		('1124','Admin'),
		('1160','Cashier'),
		('1144','Admin'),
		('1122','Cashier');

Select *
From EMPLOYEE_ROLES

Create view EMPLOYEE_View AS
Select E.EmpID, E.EmpName , E.PhoneNo, E.ShiftPeriod , E.Address, ER.RoleName, E.Status
from EMPLOYEE E Inner JOIN EMPLOYEE_ROLES ER On (E.EmpID = ER.EmpID)


Select *
from EMPLOYEE_View
where EmpID='1124'

Create view Security_athuntication
AS select E.EmpID , EmpName, ER.RoleName, E.PasswordE
FROM EMPLOYEE E Inner JOIN EMPLOYEE_ROLES ER On (E.EmpID = ER.EmpID)
where E.Status = 'Active'; --status 1 means employee active


Select *
From Security_athuntication
where RoleName= 'Cashier'

--for data entering procedure.

create procedure newEmpRecord @empID varChar(50) ,@name  varChar(50), @Pw  varChar(50), @phone varchar(20) , @address  varChar(50), @role  varChar(50), @shift  varChar(20)
AS
insert into EMPLOYEE (EmpID,EmpName,PhoneNo,ShiftPeriod,Address,PasswordE,Status)
values (@empID,@name,@phone,@shift,@address,CONVERT(varbinary,@Pw),default) 
insert into EMPLOYEE_ROLES (EmpID, RoleName)
values (@empID,@role)


Exec newEmpRecord '1003','Mesum Ali','asd123','09123','p123 LHR','Admin','Day' 


create procedure newEmpRole @empID varChar(50) ,@role  varChar(50)
AS
Insert Into EMPLOYEE_ROLES (EmpID,RoleName)
Values (@empID,@role)

exec newEmpRole '1004','Waiter'

/*-----------------------------*/




-- Attendance Table
create Table ATTENDANCE
(
	ADate_ID Date default CONVERT(date, getdate()),
	EmpID varchar(50) Default 'Employee Left.' Not null,
	A_Status varChar(20),
	A_Time time  default convert(time, getDate()),
	Month varChar(20) default dateName(month, getDate()), --add  check of months
	Reason varchar(30),

	Constraint attendance_pk primary key (ADate_ID,EmpID) ,
	Constraint attendance_fk foreign key (EmpID) references EMPLOYEE(EmpID) on update cascade on delete cascade,
	Constraint attendance_chkStatus Check (A_Status IN ('Present','Absent')) 
)

--Demy Data enter
select *
from ATTENDANCE

insert into ATTENDANCE (ADate_ID,EmpID,A_Status)
values ('2018-12-12','1003','Absent'),
		(default,'1002','Present'),
		(default,'1003','Absent'),
		(default,'1005','Present');



create view Attendance_View AS
Select E.EmpID, E.EmpName , A.ADate_ID ,A.A_Status , A_Time , Month, Reason
from ATTENDANCE A Inner Join EMPLOYEE E on 
	 (A.EmpID = E.EmpID)

Select *
from Attendance_View
where Month = 'February' dateName(month, getDate())


/*-------------------------------------------------*/

/*------------------- Stock_Item Table -------------------*/


create table STOCK_ITEM
(
	StockID int identity(9000,1),
	SIName varchar(30) ,
	SIQuantity float ,
	SIUnit varchar(10) ,
	Price_Per_Unit int ,
	Constraint STOCK_ITEM_Org_pk Primary key (StockID) ,
	Constraint STOCK_ITEM_Org_ChkQ Check(SIQuantity >0),
	Constraint STOCK_ITEM_Org_ChkPrice Check(Price_Per_Unit > 0)
)

	

create table STOCK_ITEM_Backup
(
	BTime time default convert(time, getDate()),
	BDate date default convert(date, getDate()),
	StockID INT ,
	SIName varchar(30) ,
	SIQuantity float ,
	SIUnit varchar(10) ,
	Price_Per_Unit int ,
	Constraint STOCK_ITEM_pk Primary key (BTime,BDate,StockID) ,
	Constraint STOCK_ITEM_ChkQ Check(SIQuantity >0),
	Constraint STOCK_ITEM_ChkPrice Check(Price_Per_Unit > 0)
)





-- for insertion code
--this is for when record is not found in orignakl table 
create procedure stockInputMethod @name varChar(30) ,@qty float , @unit varchar(10), @price int 
as
insert into STOCK_ITEM (SIName,SIQuantity,SIUnit,Price_Per_Unit)
values (@name,@qty,@unit,@price)
declare @idOrig int;
select @idOrig= StockID from STOCK_ITEM where SIName=@name;
insert into STOCK_ITEM_Backup (StockID,SIName,SIQuantity,SIUnit,Price_Per_Unit)
values (@idOrig,@name,@qty,@unit,@price)


exec stockInputMethod 'Dahi',10,'KG',90


create procedure stockUpdateMethod @id int, @name varChar(30) ,@qty float , @unit varchar(10), @price int 
as
update STOCK_ITEM
set SIQuantity= SIQuantity+@qty,Price_Per_Unit=@price
where StockID= @id
insert into STOCK_ITEM_Backup (StockID,SIName,SIQuantity,SIUnit,Price_Per_Unit)
values (@id,@name,@qty,@unit,@price)


exec stockUpdateMethod 9002,'chiken',4,'KG',10



SELECT * from STOCK_ITEM

Select * from STOCK_ITEM_Backup

/*---------------------------practise chk*/
create table A
(
	id int primary key,
	name varchar(10),
	quatntity int 
)

insert into A
values (32,'tr'),
	(123,'qw'),
	(5,'asd')

create table B
(
	Bdate time default convert(time, getDate()),
 	id int default 98 ,
	name varchar(10),
	qty int ,
	constraint asd primary key(Bdate,id)
)

create procedure backupT @Id int , @n varchar(10), @qty int
as 
insert into A 
values(@ID,@n,@qty)
insert into B
values(default, @ID,@n,@qty)


create procedure backupTUpdate @Id int , @n varchar(10), @qty int
as 
update A
set  quatntity=@qty
where id=@Id 
insert into B
values(default, @ID,@n,@qty)

exec backupTUpdate 90, 'rice',20

select * from A
select * from B
----------------




/*---=-=-=-=-=-= Dish--------------------*/



create Table DISH
(
	DishID int identity(4000,1),  /* Dish iD starts from 4000 */
	Dish_Name varChar(30), 
	Dish_Price float(53),

	Constraint DishID_pk Primary key (DishID),
	Constraint DishID_chk Check(Dish_Price >0)
)


/*
--- modify constrain (snippet) ---
ALTER TABLE DISH DROP CONSTRAINT DishID_chk;

*/

/*
--- modify coloum datatype (snippet) ---
ALTER TABLE DISH
ALTER COLUMN Dish_Price float(53);
*/



create table DISH_ITEM_LINE
(
	DishID int,
	StockID int	,
	Item_Qty int,
	
	Constraint DISH_ITEM_LINE_pk Primary key (DishID,StockID),
	Constraint DISH_ITEM_LINE_fk1 Foreign key (DishID) references DISH(DishID),
	Constraint DISH_ITEM_LINE_fk2 Foreign key (StockID) references STOCK_ITEM(StockID)
)


insert into DISH 
values ( 'Karahi Ghost', 900)

Select * from DISH

Select * from DISH_ITEM_LINE

update DISH_ITEM_LINE
set Item_Qty = 70
where DishID = 4000 AND StockID = 9003

select DishID, SI.SIName, SI.SIQuantity, Item_Qty
from DISH_ITEM_LINE DIL inner join STOCK_ITEM SI on(DIL.StockID = SI.StockID )


--------------------------------------
/*

-- this query is for showing all those dishes that is not based on any stock item like Roti Raita etc.-----
Create View Dishes_that_has_Not_Stock AS
SELECT di.DishID, COUNT(*) as total
from DISH di left join DISH_ITEM_LINE dil 
on (di.DishID = dil.DishID)
where dil.DishID is NULL
group by di.DishID


--------------------------------------------------------------------------
Create View Dishes_that_has_Stock as
select table1.DishID
from 
(
	select DishID, COUNT(*) as total
	from DISH_ITEM_LINE DIL inner join STOCK_ITEM SI on(DIL.StockID = SI.StockID )
	group by DishID
) 
AS table1 INNER JOIN 
(
	select D.DishID, COUNT(*) as total
	from DISH_ITEM_LINE D inner join STOCK_ITEM SI on(D.StockID = SI.StockID )
	where  D.Item_Qty <=SI.SIQuantity 
	group by D.DishID
 ) AS resultTable ON (table1.DishID = resultTable.DishID)

where table1.total = resultTable.total
-------------------------------------------------------------------------



-- query for showing both that has stock (and has stock qty ) or not 

SELECT DNS.DishID 
FROM Dishes_that_has_Not_Stock DNS
UNION
SELECT DS.DishID 
FROM Dishes_that_has_Stock DS




---------------------------------------final query for SHowing dishes in Order Page---------------------------------------

CREATE VIEW Dish_table_for_Order AS
select *
from DISH
where DishID in (
					SELECT DNS.DishID 
					FROM Dishes_that_has_Not_Stock DNS
					UNION
					SELECT DS.DishID 
					FROM Dishes_that_has_Stock DS
				);

*/

----------------------------- Hold Table -------------------------

create table TABLE_O
(
	tableID varchar(30) primary key
)
insert into TABLE_O
values ('t1'),
		('t2'),
		('t3'),
		('t4'),
		('t5')

create table HOLD_TABLE
(
	holdId int identity (1,1),
	tableId varchar(30) ,
	dishId int ,
	dishName varchar(30) ,
	qty int ,
	price float(53),
	currentTime varchar(30) default CONVERT(varchar(15),  CAST(GETDATE() AS TIME), 100),
	currentDate date default convert(date, getDate()),
	status varchar(30) default 'unchecked',


	Constraint hold_pk primary key (holdId),
	CONSTRAINT hold_fk1 foreign key (tableId) references TABLE_O(tableId) on update cascade on delete set null,
	CONSTRAINT hold_fk2 foreign key (dishId) references DISH(dishID) on update cascade on delete set null,

)
----------------------
/*
--- modify coloum datatype (snippet) ---
ALTER TABLE HOLD_TABLE
add  price float(53);
*/


select * 
from HOLD_TABLE

select *
from DISH

-- inserting values.

insert into HOLD_TABLE (tableId,dishId,dishName,qty)
values ('t3',4000,'Karahi Ghost',1)

insert into HOLD_TABLE (tableId,dishId,dishName,qty,currentDate)
values ('t2',4009,'Suzee fried Chicken',6,CONVERT(date,'2019-05-17'))



SELECT CONVERT(VARCHAR(5),getdate(),108)



SELECT CONVERT(varchar(15),  CAST(GETDATE() AS TIME), 100) as AmPmTime



create procedure testHold @q int , @tId varchar(30), @dId int
as 
update HOLD_TABLE
set  qty=@q
where	tableId=@tId 
AND		dishId =@dId



exec testHold 2,'t3',4000

------------------------ views

create view holdTableToday
as
select tableId, dishId,dishName,qty,currentTime 
from HOLD_TABLE
where currentDate = CONVERT(varchar,GETDATE())
AND status = 'unchecked'


--------------------- procedures 
create procedure holdTableTodayView
as
select *
from holdTableToday
----------- finial statement-------------
exec holdTableTodayView
---------------
create procedure insertingHoldTable @tID varchar(30),@dID int , @dName varchar(30),@quantity int
as
insert into HOLD_TABLE (tableId,dishId,dishName,qty)
values (@tID,@dID,@dName,@quantity)



create procedure exisitingQuantityUpdate  @tID varchar(30),@dID int ,@quantity int
as
update HOLD_TABLE
set  qty=qty+@quantity
where	tableId=@tID 
AND		dishId =@dID

-----

--- query for redirecting specific table for checked.

create procedure checkedHoldTable @tID varchar(30)
as

select *

















































