create table Franchise(
Franchise_Name varchar(255),
CONSTRAINT PK_Franchise PRIMARY KEY(Franchise_Name)
);
create table Customer(
    Customer_ID number,
    Phone_Number number,
    Customer_Name varchar(255),
    CONSTRAINT PK_Customer PRIMARY KEY(Customer_ID)
);
create table Branch (
    Branch_ID number ,
    Franchise_Name varchar(255),
    Branch_Address varchar(255),
    Location varchar(255),
    CONSTRAINT PK_Branch PRIMARY KEY(Branch_ID),
    CONSTRAINT FK_Branch Foreign KEY(Franchise_Name) references Franchise(Franchise_Name)
);
create table Preferences (
    Branch_ID number ,
    Customer_ID number,
CONSTRAINT PK_Preferences1 PRIMARY KEY(Branch_ID,Customer_ID),
    CONSTRAINT FK_Preferences1 Foreign KEY(Branch_ID) references Branch(Branch_ID),
    CONSTRAINT FK_Preferences2 Foreign KEY(Customer_ID) references Customer(Customer_ID)
);
create table Chef(
Chef_ID integer,
Chef_Name varchar(255),
Branch_ID integer,
Franchise_Name varchar(255),
Cuisine varchar(255),
CONSTRAINT PK_Chef PRIMARY KEY(Chef_ID),
CONSTRAINT FK_Chef1 Foreign KEY(Franchise_Name) references Franchise(Franchise_Name),
CONSTRAINT FK_Chef2 Foreign KEY(Branch_ID) references Branch(Branch_ID)
);
create table Menu(
    Menu_Name VARCHAR(255),
    Main_Ingredient VARCHAR(255),
    Cuisine varchar(255),
    price varchar(255), 
    calorie_count integer,
    CONSTRAINT PK_Menu PRIMARY KEY (Menu_Name)
);
create table ordertable(
    order_id number,
        Customer_ID number,   
     Menu_Name VARCHAR(255),
     Franchise_Name varchar(200),
     CONSTRAINT PK_order1 PRIMARY KEY (order_id),
        CONSTRAINT FK_order1 Foreign KEY(Menu_Name) references Menu(Menu_Name),
     CONSTRAINT FK_order2 Foreign KEY(Franchise_Name) references Franchise(Franchise_Name),
        CONSTRAINT FK_order3 Foreign KEY(Customer_ID) references Customer(Customer_ID)
);
create table Menu_PreparedBy(
        Menu_Name VARCHAR(255),
        Chef_ID integer,
        Franchise_Name varchar(255),
        CONSTRAINT PK_Menu_PreparedBy1 PRIMARY KEY(Chef_ID,Menu_Name),
        CONSTRAINT FK_Menu_PreparedBy1 Foreign KEY(Chef_ID) references Chef(Chef_ID),
        CONSTRAINT FK_Menu_PreparedBy2 Foreign KEY(Menu_Name) references Menu(Menu_Name),
        CONSTRAINT FK_Menu_PreparedBy3 Foreign KEY(Franchise_Name) references Franchise(Franchise_Name)
);
create table Rating(
        Menu_Name VARCHAR(255),
        Franchise_Name varchar(255),
       Customer_ID number,
       Rating number,
     CONSTRAINT PK_Rating PRIMARY KEY (Customer_ID),
    CONSTRAINT FK_Rating1 Foreign KEY(Menu_Name) references Menu(Menu_Name),
    CONSTRAINT FK_Rating2 Foreign KEY(Franchise_Name) references Francise(Franchise_Name)
);
create table Menu_OfferedBy(
        Menu_Name VARCHAR(255),
        Franchise_Name varchar(255),
     CONSTRAINT PK_MenuOfferedBy PRIMARY KEY (Menu_Name,Franchise_Name),
CONSTRAINT FK_Menu_OfferedBy1 Foreign KEY(Menu_Name) references Menu(Menu_Name),
    CONSTRAINT FK_Menu_OfferedBy2 Foreign KEY(Franchise_Name) references Franchise_Name(Franchise_Name)
);
/////////2

a.
Select count(*) 
from Preferences natural join Branch 
group by Franchise_Name;

b.
Select avg(Rating),Menu_Name
from Rating
group by Menu_Name;

c.
Select * from
Menu 
where Menu_Name IN (
Select Menu_Name from(
Select count(*) as order_count,Menu_Name,Franchise_Name
from ordertable
group by (Menu_Name,Franchise_Name)
order by order_count desc)
where ROWNUM <=5);

d.
select customer_name
from customer
where customer_id IN(
select customer_id 
from(
Select count(*) as count_menu,customer_id
from Menu_OfferedBy natural join ordertable USING (Franchise_Name)
group by (customer_id,Franchise_Name)
having count(*)>=2));

e.
Select customer_name
from customer
where customer_id NOT IN(
select customer_id 
from ordertable
);

