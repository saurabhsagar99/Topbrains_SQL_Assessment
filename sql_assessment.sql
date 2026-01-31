create database Sql_Assignment;
use Sql_assignment;

create table Sales_Raw(
OrderID int,
OrderDate varchar(20),
CustomerName varchar(100),
CustomerPhone varchar(20),
CustomerCity varchar(50),
ProductNames varchar(200),
Quantities varchar(100),
UnitPrices varchar(100),
SalesPerson varchar(100)
);

insert into Sales_Raw values
(101, '2024-01-05', 'Ravi Kumar', '9876543210', 'Chennai','Laptop,Mouse', '1,2', '55000,500', 'Anitha'),
(102, '2024-01-06', 'Priya Sharma', '9123456789', 'Bangalore','Keyboard,Mouse', '1,1', '1500,500', 'Anitha'),
(103, '2024-01-10', 'Ravi Kumar', '9876543210', 'Chennai','Laptop', '1', '54000', 'Suresh'),
(104, '2024-02-01', 'John Peter', '9988776655', 'Hyderabad', 'Monitor,Mouse', '1,1', '12000,500', 'Anitha'),
(105, '2024-02-10', 'Priya Sharma', '9123456789', 'Bangalore','Laptop,Keyboard', '1,1', '56000,1500', 'Suresh');


create table Customers(
CustomerID int auto_increment primary key,
CustomerName varchar(100),
CustomerPhone varchar(20),
CustomerCity varchar(50)
);

create table SalesPersons(
SalesPersonID int auto_increment primary key,
SalesPersonName varchar(100)
);


create table Products(
ProductID int auto_increment primary key,
ProductName varchar(100)
);

create table Orders(
OrderID int primary key,
OrderDate date,
CustomerID int,
SalesPersonID int,
foreign key(CustomerID) references Customers(CustomerID),
foreign key(SalesPersonID) references SalesPersons(SalesPersonID)
);


create table OrderDetails(
OrderDetailID int auto_increment primary key,
OrderID int,
ProductID int,
Quantity int,
UnitPrice decimal(10,2),
foreign key(OrderDetailID) references Orders(OrderID),
foreign key(ProductID) references Products(ProductID)
);



/* Question 2 */

select OrderID, TotalSales from (
select OrderID,sum(q.qty * p.price) as TotalSales,dense_rank() over (order by sum(q.qty * p.price) desc) as rnk
from Sales_Raw join json_table(concat('[', Quantities, ']'),'$[*]' columns (qty int path '$')) q
join json_table(concat('[', UnitPrices, ']'),'$[*]' columns (price int path '$')) p group by OrderID) t
where rnk = 3;


/* Question 3 */ 

select SalesPerson,sum(qty * price) as TotalSales from Sales_Raw
cross join json_table(concat('[', Quantities, ']'),'$[*]' columns(qty int path '$')) q
cross join json_table(concat('[', UnitPrices, ']'),'$[*]' columns(price int path '$')) p
group by SalesPerson having sum(qty * price) > 60000;


/* Question 4 */

select customername,sum(q.qty * p.price) as totalspent from sales_raw
cross join json_table(concat('[', quantities, ']'),'$[*]' columns (qty int path '$')) q
cross join json_table(concat('[', unitprices, ']'),'$[*]' columns (price int path '$')) p group by customername
having sum(q.qty * p.price) >
(
select avg(customertotal) from (
select sum(q2.qty * p2.price) as customertotal from sales_raw
cross join json_table(concat('[', quantities, ']'),'$[*]' columns (qty int path '$')) q2
cross join json_table(concat('[', unitprices, ']'),'$[*]' columns (price int path '$')) p2 group by customername) avg_table);



/* Question 5 */

select upper(CustomerName) as CustomerName,
month(str_to_date(OrderDate, '%Y-%m-%d')) as OrderMonth from Sales_Raw where year(str_to_date(OrderDate, '%Y-%m-%d')) = 2026 and month(str_to_date(OrderDate, '%Y-%m-%d')) = 1;



