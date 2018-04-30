/*Person Table */

CREATE TABLE person(PersonId int Primary key not null,
					firstName varchar(45),
                    lastName varchar(45));
                    
alter table person add emailid varchar(45);                    
alter table person add phonenumber varchar(15);

select * from person;

Update person
set emailid = 'chitra.paryani@gmail.com' 
where personid = 1;

Update person
set phonenumber = '1234567890'
where personid = 1;

Update person
set emailid = 'omegatraders@gmail.com' 
where personid = 111;

Update person
set phonenumber = '7894561230'
where personid = 111;
                    
Insert into person values(1,'chitra','paryani');                    
Insert into person values(2,'priya','paryani','priya.paryani@gmail.com','123456789');                    
Insert into person values (111, 'omega traders','terry turner');
Insert into person values (222, 'chappels','roasters','chappels.roaster@gmail.com','785632156');
select * from person;
                    
/*Address Table */
CREATE TABLE Address(AddressId int primary key not null,
					 Street1 varchar(45),
                     Street2 varchar(45),
                     country varchar(45),
                     city varchar(45),
                     zipcode varchar(45),
                     personId int,
                     foreign key (personId) references person(personId));

alter table address add state varchar(45);

Insert into address values(1,'65-2','St germain street','USA','Boston','02115',1,'MA');
Insert into address values(2,'55-2','park street','USA','Boston','02116',1,'MA');
Insert into address values(111,'45-2','Symphony street','USA','Boston','02115',1,'MA');
Insert into address values(222,'45-2','mass avenue','USA','Boston','02115',1,'MA');
Select * from address;



/* Query to get address details, person details of a person */
Select * from person
inner join address
on person.personid = address.personid;



                     
/*Customer Table */
CREATE TABLE customer( CustomerId int primary key not null,
						creditlimit int,
                        lastrevised date,
                        foreign key (customerid) references person(personId));

Insert into customer values(1, 100000, '2017-12-13');
Insert into customer values(2, 500000, '2017-12-14');

/* Query to get customer name, address and credit limit */
SELECT * from customer 
INNER JOIN person 
INNER JOIN address
on person.personid = customer.customerid and
person.personid = address.personid;

                        
/*Vendor Table */
CREATE TABLE vendor(VendorId int primary key not null,
					foreign key (vendorId) references person(personId));

Insert into vendor values(111);                    
Insert into vendor values(222);                    
/* Query to get vendor details */
select * from vendor 
INNER JOIN person
on vendor.vendorId = person.personId;
                    
/* Customer order Table */
CREATE TABLE Customer_Order(orderid int primary key not null,
							orderdate date,
                            customerid int,
                            foreign key(customerid) references customer(customerid)
                            ON DELETE NO ACTION
                            ON UPDATE NO ACTION);

Alter table customer_order add requesteddate date;

update customer_order
set requesteddate = '2017-12-15'
where orderid = 1;

update customer_order
set requesteddate = '2017-12-15'
where orderid = 2;

INSERT INTO customer_order values(1, '2017-12-13',1);
INSERT INTO customer_order values(2, '2017-12-14',2);

select * from customer_order;
select * from customer;
select * from address;
/* Query to get customer order data */
SELECT * from customer_order 
INNER JOIN customer
INNER JOIN Person
INNER JOIN Address
on customer_order.customerid = customer.customerid and
customer.customerid = person.personid and
person.personid = address.personid;

						
/* Product Table */
CREATE TABLE product(ProductId int primary key not null,
					  Name varchar(45) Not NUll,
                      Description varchar(45) Null);

Alter table product add price int;                      
Alter table product add currency varchar(10);

INSERT INTO product values(1,'HP Notebook','LCD Touchscreen, AMD A8-7410 APU',111,457, 'dollar');
INSERT INTO product values(2,'HP ENVY','16GB RAM, AMD A8-7410 APU',111,1000, 'dollar');
INSERT INTO product values(3,'DELL','8GB RAM, AMD A8-7410 APU',222,800, 'dollar');

Select * from product;

/*Query to get vendor details*/
SELECT * from product 
Inner join vendor
Inner Join person
on vendor.vendorId = product.vendorId and
vendor.vendorId = person.personId;

select * from product;
delete from product where productId = 1;

Alter table product add vendorid int;
Alter table product add constraint fk_product foreign key (vendorid) references vendor(vendorid);

drop table product;
                        
/*OrderItem Table*/
CREATE TABLE OrderItem(ID int primary key not null,
						orderid int not null,
                        productid int not null,
                        quantity int not null,                        
                        foreign key (orderId) references customer_order(orderId)
                        ON DELETE NO ACTION
                        ON UPDATE NO ACTION,
                        foreign key (productId) references product(productId)
                        ON DELETE NO ACTION
                        ON UPDATE NO ACTION);
                        
Insert into orderItem values(1,1,1,1);
Insert into orderItem values(2,2,2,1);
Select * from orderItem;

/*Query to get product and order details */

Select * from product 
Inner Join orderItem
on orderitem.productId = product.productId;

drop table orderitem;                        
                        
/* CREATE INDEX */
CREATE INDEX OrderIdIndex on customer_order(orderid);                        

CREATE INDEX OrderItemIndex on OrderItem(orderId);
CREATE INDEX productItemIndex on OrderItem(productId);

desc orderitem;        
                
/* CREATE TABLE PICK */
CREATE TABLE PICK(PickId int not null primary key,
				   pickdate date,
                   pickedby varchar(45),
                   orderid int,
                   foreign key (orderid) references customer_order(orderid));
                   
INSERT INTO PICK values(1,'2017-12-13','Suresh',1);                   
INSERT INTO PICK values(2,'2017-12-14','Ramesh',2);                   

/* SQL query to get order pick details */
SELECT * FROM customer 
INNER JOIN person
INNER JOIN address 
INNER JOIN customer_order
INNER JOIN product
INNER JOIN orderitem
INNER JOIN pick
on customer.customerId = person.personId and
person.personId = address.personId and
customer.customerId = customer_order.customerId and
customer_order.orderId = orderitem.orderId and
orderitem.productId = product.productId and
orderitem.orderid = pick.orderid;

                   
/*Create Table Stock Pick */
CREATE TABLE STOCKPICK(id int not null primary key,
					   pickId int,
                       productId int,
                       quantity int not null,
                       foreign key (pickId) references pick(pickId) 
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION,
                       foreign key (productId) references product(productId)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION);

INSERT INTO stockpick values(1,1,1,1);                       
INSERT INTO stockpick values(2,2,2,1);                       

/*Create Table ScheduleDelivery */
CREATE TABLE ScheduleDelivery(DeliveryId int primary key not null,
							   Deliverydate date,
                               shippedby varchar(45),
                               pickId int,
                               customerid int,
                               invoiceid int,
                               foreign key (pickId) references pick(pickId),
                               foreign key (customerId) references customer(customerid)
                               );

show create table scheduledelivery;

Alter table scheduledelivery drop foreign key scheduledelivery_ibfk_3;

alter table scheduledelivery drop invoiceid;

select * from scheduledelivery;

desc scheduledelivery;

Insert into scheduledelivery values(1,'2017-12-15','Best Buy',1,1);
Insert into scheduledelivery values(2,'2017-12-16','Amazon',2,2);                               
/*Create Invoice Table */
CREATE TABLE invoice(invoiceId int primary key not null,
					 invoicedate date,
                     deliveryid int,
                     invoicetotal int,
                     customerid int,
                     foreign key (customerid) references customer(customerid));

Insert into invoice values(1, '2017-12-15',1,30000,1);
Insert into invoice values(2, '2017-12-16',2,50000,2);

/*Create Delivery Invoice Table */
CREATE TABLE DeliveryInvoice(Id int primary key not null,
							 deliveryid int,
                             invoiceid int,
                             invoicedate date,
                             foreign key (deliveryid) references scheduledelivery(deliveryid)
                             ON DELETE NO ACTION
                             ON UPDATE NO ACTION,
                             foreign key (invoiceId) references invoice(invoiceId)
                             ON DELETE NO ACTION
                             ON UPDATE NO ACTION);

INSERT INTO DeliveryInvoice values(1, 1, 1, '2017-12-15');
INSERT INTO DeliveryInvoice values(2, 2, 2, '2017-12-16');

/*Top Customer*/
SELECT person.firstName, person.lastName, product.name AS productName, DeliveryInvoice.invoicedate , 
product.price,product.currency,ScheduleDelivery.shippedby from customer
INNER JOIN scheduledelivery
INNER JOIN stockpick
INNER JOIN product
INNER JOIN person
INNER JOIN DeliveryInvoice
on customer.customerid = scheduledelivery.customerid and
customer.customerid = person.personid and
scheduledelivery.pickid = stockpick.pickid and
stockpick.productid = product.productid and 
deliveryinvoice.deliveryId = scheduledelivery.deliveryId
ORDER BY product.price DESC
LIMIT 1; 

/*Delayed Delivery */
SELECT customer.customerid, person.firstName, person.lastName, 
ScheduleDelivery.deliverydate FROM customer_order
INNER JOIN ScheduleDelivery
INNER JOIN customer 
INNER JOIN person
on customer.customerid = customer_order.customerid and
person.personid = customer.customerid and
customer_order.customerid = ScheduleDelivery.customerid
where requesteddate < deliverydate;



alter table invoice add constraint fk_delivery foreign key (deliveryid) references ScheduleDelivery(deliveryid);                    

drop table invoice;

show create table invoice;

Alter table invoice drop foreign key fk_delivery;
Alter table invoice drop foreign key customerid;

/* Stored procedure to maintain history data for analysis purpose */

Create table history(firstName varchar(45), lastName varchar(45));

desc person;

desc address;

desc customer;

desc customer_order;

desc orderItem;

desc product;

desc vendor;

desc stockpick;

desc pick;

desc scheduledelivery;

desc deliveryinvoice;

desc invoice;

desc productcategory;

desc v_rating;

desc c_rating;
/* Created temp inventory table to show stock available in warehouse*/
Create table inventory(id int not null primary key,warehouse varchar(45), 
productid int, stockAvailable int,
foreign key (productId) references product(productId));

alter table inventory add Asofdate date;
Update inventory
set Asofdate = '2017-12-13';

Insert into inventory values (1, 'M1',1,100);
Insert into inventory values (2, 'M1',2,100);
Insert into inventory values (3, 'M1',3,100);

select * from inventory;

/*Created View to view total stock available including ordered and available */
CREATE View TotalAvailProduct
AS
SELECT orderid, quantity from orderitem
UNION ALL
select productid, stockavailable from inventory;

CREATE view stock
AS 
SELECT orderid, sum(quantity) from totalavailproduct group by orderid;

select * from stock;		

/* Trigger to change order status flow */

Alter table customer_order add column order_status_flow varchar(45);

select * from customer_order;

Delimiter //
CREATE TRIGGER changeStatusOrder
BEFORE INSERT on customer_order
FOR EACH ROW
BEGIN
SET new.order_status_flow = 'Entered';
END //
Delimiter ;

UPDATE customer_order
SET order_status_flow = 'Entered';

select * from customer_order;

Insert into customer_order (orderid,orderdate,customerid,requesteddate)
values (3,'2017-12-14',1,'2017-12-20');

select * from orderItem;

UPDATE orderitem
SET item_status_flow = 'Ordered';

alter table orderitem add item_status_flow varchar(45);

Delimiter //
CREATE TRIGGER changeStatusItem
BEFORE INSERT on orderitem
FOR EACH ROW
BEGIN
SET new.item_status_flow = 'Ordered';
END //
Delimiter ;

Insert into orderitem (Id, orderid, productid, quantity) values
(3,3,1,1);


select * from orderitem;


/*Trigger for pick */
select * from pick;

alter table pick add pick_status_flow varchar(45);
alter table pick drop pick_status_flow;
update pick
set pick_status_flow = 'Picked';

Delimiter //
CREATE TRIGGER changeStatusPick
BEFORE INSERT on pick
FOR EACH ROW
BEGIN
SET new.pick_status_flow = 'Picked';
END //
Delimiter ;

Insert into pick (pickid, pickdate, pickedby, orderid) values 
(3,'2017-12-14','Mahesh',3);

select * from pick;

/* Trigger for Delivery of Items */
select * from scheduledelivery;

alter table scheduledelivery add delivery_status_flow varchar(45);

update scheduledelivery
SET delivery_status_flow = 'Delivered';

Delimiter //
CREATE TRIGGER changeStatusDelivery
BEFORE INSERT on scheduledelivery
FOR EACH ROW
BEGIN
SET new.delivery_status_flow = 'Delivered';
END //
Delimiter ;

Insert into scheduledelivery 
(deliveryid, deliverydate, shippedby, pickid, customerid) values
(3,'2017-12-20','Best Buy',3,1);

delete from scheduledelivery where DeliveryId = 3;

select * from scheduledelivery;




/* User Access */

/* Service Clerk */
CREATE USER ServiceClerk  IDENTIFIED BY 'password';

-- Revoke all privileges for the user
REVOKE ALL privileges, grant option from ServiceClerk;

-- Grant needed privileges
GRANT SELECT ON customer to ServiceClerk;

GRANT UPDATE (firstName, lastName, EmailId, PhoneNumber) 
ON customer TO ServiceClerk;

GRANT SELECT, DELETE ON customer_order to ServiceClerk;

GRANT INSERT, SELECT, DELETE on orderItem to ServiceClerk;

GRANT SELECT on inventory to ServiceClerk;

/* Entry Clerk */
CREATE USER EntryClerk  IDENTIFIED BY 'password';

-- Revoke all privileges for the user
REVOKE ALL privileges, grant option from ServiceClerk;

-- Grant needed privileges
GRANT INSERT, SELECT on customer TO EntryClerk;

GRANT UPDATE (firstName, lastName, EmailId, PhoneNumber) 
ON customer TO EntryClerk;

GRANT SELECT, DELETE ON customer_order to EntryClerk;

GRANT INSERT, SELECT, DELETE on orderItem to EntryClerk;

GRANT SELECT on inventory to EntryClerk;

/* Table product category */
desc filmclub.filmcategory;
Select * from product;

Alter table product add categoryid int;
Alter table product add constraint fk_cat foreign key (categoryId) references ProductCategory(categoryId);
Alter table product drop category;

CREATE TABLE ProductCategory(CategoryId int, Category varchar(45));

Insert into ProductCategory values (1, 'Laptop');
Insert into ProductCategory values (2, 'Desktop');

UPDATE product
SET category = 'Laptop';
select * from product;
Update product
SET categoryid = 1;
select * from productcategory;
select * from productcategory;
/* Procedure to get product Category */
Delimiter //
Create procedure product_cat_view(IN categoryvar int)
BEGIN
Select productcategory.Category, product.Name from product, productcategory 
where product.categoryid = productcategory.Categoryid and
productcategory.CategoryId = categoryvar;
END //
Delimiter ;





/*count of products based on category */
Delimiter //
Create procedure product_cat_count(IN categoryvar int, OUT total int)
BEGIN
Select productcategory.Category, count(product.Name) from product, productcategory 
where product.categoryid = productcategory.Categoryid and
productcategory.CategoryId = categoryvar;
END //
Delimiter ;



/* Create Vendor rating table */
create table v_rating(vendorid int, rating int,
foreign key (vendorid) references vendor(vendorid));

select * from vendor;

insert into v_rating values(111,5);
insert into v_rating values(222,4);

/* Create Customer rating */
Create table c_rating(customerid int, rating int,
foreign key (customerid) references customer(customerid));

select * from customer;
select * from c_rating;
Insert into c_rating values(1, 5);
Insert into c_rating values(2, 8);

/*created function to find vendor rating */
Delimiter %%
create function fn_vendorRating(vendorID int)
returns varchar(200)
begin
    DECLARE result varchar(200);
    SET result:=
   (select concat(vendorid, ' | ',repeat('*',rating))
   as rating
   from vendor v,v_rating vr
   where v.vendorid = vr.vendorid and vr.vendorid = vendorId);
   RETURN result;
end %%
DELIMITER ;



/* Create function to find customer rating */
Delimiter %%
create function fn_custRating(customerID int)
returns varchar(200)
begin
    DECLARE result varchar(200);
    SET result:=
   (select concat(customerid, ' | ',repeat('*',rating))
   as rating
   from customer v,c_rating vr
   where v.customerid = vr.customerid and vr.customerid = customerID);
   RETURN result;
end %%
DELIMITER ;


