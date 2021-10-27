*---=-=-=-=-=-= Dish--------------------*/



create Table DISH
(
	DishID int identity(4000,1),  /* Dish iD starts from 4000 */
	Dish_Name varChar(30), 
	Dish_Price int,

	Constraint DishID_pk Primary key (DishID),
	Constraint DishID_chk Check(Dish_Price >0)
)







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