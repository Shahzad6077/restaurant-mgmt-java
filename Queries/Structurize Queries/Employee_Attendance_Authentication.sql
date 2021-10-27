
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

