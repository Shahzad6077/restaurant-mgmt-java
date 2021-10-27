create table  Customer 
(
	C_ID int identity(1,1),
	C_Name varChar(50) default 'Unknown',
	C_PhoneNo varChar(20) default 'Unknown',

	Constraint customer_pk primary key (C_ID)
)



create procedure createCustomerID
as 
insert into Customer (C_Name,C_PhoneNo)
values (default,default)
--select IDENT_CURRENT( 'customer' ) as recentID;


exec createCustomerID

-- getting recent id of customer--
create procedure getRecentCustomerID 
as
select IDENT_CURRENT( 'customer' ) 

--------------------------------------------------
create Table Order_T
(
	OrderID int identity (8000,1),
	cust_ID int default null,
	OrderDate date default convert(date, getDate()),
	orderTime varchar(30) default CONVERT(varchar(15),  CAST(GETDATE() AS TIME), 100),
	OrderType varChar(20) default 'Take Away',
	Bill Float ,
	Constraint Order_pk primary key (OrderID) ,
	Constraint Order_fk foreign key  (cust_ID) references Customer(C_ID) on update cascade on delete set default 
)

create procedure InsretOrder @orderType varchar(max), @totalB float
as
declare @id int;
exec createCustomerID
select @id = IDENT_CURRENT( 'customer' ) 
insert into Order_T (cust_ID,OrderDate,OrderType,Bill)
values (@id, default,@orderType, @totalB);
select IDENT_CURRENT( 'order_T' ) as genID

---------------

exec InsretOrder 'TakeWay',610

select * from order_T



Create Table OrderDish_Line
(
	OrderID int ,
	DishID int ,
	Qty int,
	Constraint OrderDish_Line_pk primary key  (OrderID,DishID),
	
	Constraint OrderDish_Line_fk1 Foreign key (DishID) references DISH(DishID),
	Constraint OrderDish_Line_fk2 Foreign key (OrderID) references Order_T(OrderID)
)

--CREATE PROCEDURE AddOrderLineItems

insert into OrderDish_Line
values (8000,4001,2),
		(8000,4003,4);
------------------------------------------------
select convert(date, '2019/3/5')

-- show order by date

create proc viewOrderByDate @date date
as
select D.DishID, D.Dish_Name, D.Dish_Price ,OItem.Qty, OT.OrderID, OT.cust_ID, OT.OrderDate ,OT.orderTime , OT.Bill 
from DISH D INNER JOIN OrderDish_Line OItem on (D.DishID = OItem.DishID)
 Inner join Order_T OT on (OT.OrderID = OItem.OrderID)
 where OT.OrderDate = convert(date, @date)

 exec viewOrderByDate '2019/7/17'

-- show Ordewr by Id

create proc viewOrderById @id int
as
select D.DishID as dId, D.Dish_Name dName, D.Dish_Price dPrice,OItem.Qty dQty, OT.OrderID oId, OT.cust_ID cId, OT.OrderDate oDate,OT.orderTime oTime, OT.Bill oBill 
from DISH D INNER JOIN OrderDish_Line OItem on (D.DishID = OItem.DishID)
 Inner join Order_T OT on (OT.OrderID = OItem.OrderID)
 where OT.OrderID = @id

 exec viewOrderById 8016

---------------------------------------------------
 create proc viewOrderAudit
 as
 select D.DishID as dID, D.Dish_Name as dName, D.Dish_Price dPrice, OT.OrderID as oID , OItem.Qty , OT.orderDate,OT.orderTime,Bill 
 from DISH D INNER JOIN OrderDish_Line OItem on (D.DishID = OItem.DishID)
 Inner join Order_T OT on (OT.OrderID = OItem.OrderID)

 where OT.OrderID = (
						select IDENT_CURRENT( 'order_T' )
						)

exec viewOrderAudit						



-----------------------------------------------------------
create table setting 
(
	id int ,
	Tax varChar(30),
	Mode varChar(30),
	LoginSys varChar(30),
	gst float,
	serviceChrg float,
	discount float,
	session int default 0
)





insert into setting
values (379,'20','Admin','Session',0.7,0.3,0,default)








