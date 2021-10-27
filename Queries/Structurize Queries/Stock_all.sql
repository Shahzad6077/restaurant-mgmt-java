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
