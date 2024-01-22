drop table depositor cascade constraints;
drop table borrower cascade constraints;
drop table account cascade constraints;
drop table loan cascade constraints;
drop table customer cascade constraints;
drop table branch cascade constraints;

create table branch
(branch_name varchar(15) not null,
branch_city varchar(15) not null,
assets number not null,
primary key(branch_name));

create table customer
(customer_name varchar(15) not null,
customer_street varchar(12) not null,
customer_city varchar(15) not null,
primary key(customer_name));

create table account
(account_number varchar(15) not null,
branch_name varchar(15) not null,
balance number not null,
primary key(account_number),
foreign key(branch_name) references branch(branch_name));


create table loan
(loan_number varchar(15) not null,
branch_name varchar(15) not null,
amount number not null,
primary key(loan_number),
foreign key(branch_name) references branch(branch_name));

create table depositor
(customer_name varchar(15) not null,
account_number varchar(15) not null,
primary key(customer_name, account_number),
foreign key(account_number) references account(account_number),
foreign key(customer_name) references customer(customer_name));

create table borrower
(customer_name varchar(15) not null,
loan_number varchar(15)	not null,
primary key(customer_name, loan_number),
foreign key(customer_name) references customer(customer_name),
foreign key(loan_number) references loan(loan_number));

/* populate relations */

insert into customer values ('Jones','Main','Harrison');
insert into customer values ('Smith', 'Main', 'Rye');
insert into customer values ('Hayes','Main','Harrison');
insert into customer values ('Curry','North', 'Rye');
insert into customer values ('Lindsay','Park','Pittsfield');
insert into customer values ('Turner','Putnam','Stamford');
insert into customer values ('Williams',	'Nassau','Princeton');
insert into customer values ('Adams','Spring','Pittsfield');
insert into customer values ('Johnson','Alma','Palo Alto');
insert into customer values ('Glenn','Sand Hill','Woodside');
insert into customer values ('Brooks','Senator',	'Brooklyn');
insert into customer values ('Green','Walnut','Stamford');
insert into customer values ('Jackson','University','Salt Lake');
insert into customer values ('Majeris','First','Rye');
insert into customer values ('McBride','Safety','Rye');

insert into branch values ('Downtown','Brooklyn',900000);
insert into branch values ('Redwood','Palo Alto',2100000);
insert into branch values ('Perryridge','Horseneck',1700000);
insert into branch values ('Mianus','Horseneck',400200);
insert into branch values ('Round Hill','Horseneck',8000000);
insert into branch values ('Pownal','Bennington',400000);
insert into branch values ('North Town','Rye',	3700000);
insert into branch values ('Brighton','Brooklyn',7000000);
insert into branch values ('Central','Rye', 400280);

insert into account	values ('A-101','Downtown',500);
insert into account	values ('A-215','Mianus',700);
insert into account	values ('A-102','Perryridge',400);
insert into account	values ('A-305','Round Hill',350);
insert into account	values ('A-201','Perryridge',900);
insert into account	values ('A-222','Redwood',700);
insert into account	values ('A-217','Brighton',750);
insert into account	values ('A-333','Central',850);
insert into account	values ('A-444','North Town',625);

insert into depositor values ('Johnson','A-101');
insert into depositor values ('Smith',	'A-215');
insert into depositor values ('Hayes',	'A-102');
insert into depositor values ('Hayes',	'A-101');
insert into depositor values ('Turner',	'A-305');
insert into depositor values ('Johnson','A-201');
insert into depositor values ('Jones',	'A-217');
insert into depositor values ('Lindsay','A-222');
insert into depositor values ('Majeris','A-333');
insert into depositor values ('Smith',	'A-444');

insert into loan values ('L-17','Downtown',1000);
insert into loan values ('L-23','Redwood',2000);
insert into loan values ('L-15','Perryridge',1500);
insert into loan values ('L-14','Downtown',1500);
insert into loan values ('L-93','Mianus',500);
insert into loan values ('L-11','Round Hill',900);
insert into loan values ('L-16','Perryridge',1300);
insert into loan values ('L-20','North Town',7500);
insert into loan values ('L-21','Central',570);

insert into borrower values ('Jones','L-17');
insert into borrower values ('Smith','L-23');
insert into borrower values ('Hayes','L-15');
insert into borrower values ('Jackson','L-14');
insert into borrower values ('Curry','L-93');
insert into borrower values ('Smith','L-11');
insert into borrower values ('Williams','L-17');
insert into borrower values ('Adams','L-16');
insert into borrower values ('McBride','L-20');
insert into borrower values ('Smith','L-21');

-- commit;
Warm-up:
a.
SET SERVEROUTPUT ON SIZE 1000000
BEGIN
DBMS_OUTPUT . PUT_LINE ( '200042137');
END ;
/
b. 
SET VERIFY OFF
DECLARE
USERNAME VARCHAR2 (10);
BEGIN
USERNAME := '& username ';
DBMS_OUTPUT . PUT_LINE ( ' Length of username:' || LENGTH(USERNAME));
END ;
/
C. 
SET VERIFY OFF
DECLARE
NUMBER1 NUMBER;
NUMBER2 NUMBER;
BEGIN
NUMBER1 := '& NUMBER1 ';
NUMBER2 := '& NUMBER2 ';
DBMS_OUTPUT . PUT_LINE ( 'SUM:' || (NUMBER1+NUMBER2));
END ;
/
D.
SET SERVEROUTPUT ON SIZE 1000000
DECLARE
D DATE := SYSDATE ;
BEGIN
DBMS_OUTPUT . PUT_LINE ( TO_CHAR (D ,'HH24 :MI :SS') );
END ;
/
E. 
SET SERVEROUTPUT ON SIZE 1000000
SET VERIFY OFF
DECLARE
NUMBER1 NUMBER;
BEGIN
NUMBER1 := '& NUMBER1 ';
IF MOD(NUMBER1,2)=0 THEN
DBMS_OUTPUT.PUT_LINE ( NUMBER1 || ' IS EVEN');
ELSE
DBMS_OUTPUT. PUT_LINE ( NUMBER1 || ' IS ODD');
END IF;
END ;
/
SET SERVEROUTPUT ON SIZE 1000000
SET VERIFY OFF
DECLARE
NUMBER1 NUMBER;
REM NUMBER;
BEGIN
NUMBER1 := '& NUMBER1 ';
REM := MOD(NUMBER1,2);
CASE REM
WHEN 0 THEN
DBMS_OUTPUT . PUT_LINE (NUMBER1 || ' IS EVEN');
ELSE
DBMS_OUTPUT . PUT_LINE ( NUMBER1 || ' IS ODD');
END CASE ;
END ;
/
F.
CREATE OR REPLACE
PROCEDURE PRIME(NUM IN number)
AS
    FOUND NUMBER :=0;
BEGIN
    FOR i IN 2..(NUM-1) LOOP
        IF(MOD(NUM,i)=0) THEN
            DBMS_OUTPUT . PUT_LINE('NOT PRIME');
            FOUND:=1;
            EXIT;
        END IF;
    END LOOP;
    IF(FOUND=0) THEN
        DBMS_OUTPUT. PUT_LINE('PRIME');
    END IF;

END;
DECLARE
N NUMBER;
BEGIN
N := '& N';
PRIME(N);
END ;
/
2.a
CREATE OR REPLACE
PROCEDURE INFO_OF_N_RichestBranches(NUM IN NUMBER)
AS
    NUMBEROFROWS NUMBER;
BEGIN
    SELECT max(ROWNUM) INTO NUMBEROFROWS FROM (SELECT * FROM branch ORDER BY assets DESC);
    IF(NUM>NUMBEROFROWS) THEN
        DBMS_OUTPUT.PUT_LINE('N Exceeds the number of records');
        RETURN;
    END IF;
    FOR i IN (SELECT * FROM (SELECT * FROM branch ORDER BY assets DESC) WHERE ROWNUM<=NUM) LOOP
        DBMS_OUTPUT.PUT_LINE(i.branch_name || ' ' || i.branch_city || ' ' || i.assets);
    END LOOP;

END;
/
DECLARE
    NUM NUMBER;
BEGIN
    NUM:='&NUM';
    INFO_OF_N_RichestBranches(NUM);
END;
/

2.B
CREATE OR REPLACE
PROCEDURE CustomerStatus(CustomerName IN customer.customer_name%TYPE)
AS
    NET_BALANCE number;
    NET_LOAN number;
BEGIN
    SELECT sum(account.balance) INTO NET_BALANCE FROM account,depositor WHERE depositor.customer_name=CustomerName and depositor.account_number=account.account_number;
    SELECT sum(loan.amount) INTO NET_LOAN FROM borrower,loan WHERE borrower.customer_name=CustomerName and borrower.loan_number=loan.loan_number;
    IF((NET_BALANCE)<=(NET_LOAN)) THEN
        DBMS_OUTPUT.PUT_LINE('Green Zone');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Red Zone');
    END IF;
END;
/

BEGIN
    CustomerStatus('Hayes');
END;
/
2.c
CREATE OR REPLACE
FUNCTION TaxAmount(CustomerName customer.customer_name%TYPE)
RETURN NUMBER
AS
    NET_BALANCE number;
    TAX number;
BEGIN
    SELECT sum(account.balance) INTO NET_BALANCE FROM account,depositor WHERE depositor.customer_name=CustomerName and depositor.account_number=account.account_number;
    IF((NET_BALANCE)>=750) THEN
        TAX:=0.08*NET_BALANCE;
    ELSE
        Tax:=0;
    END IF;
    RETURN Tax;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(TaxAmount('Johnson'));
END;
/

2.D 
CREATE OR REPLACE
FUNCTION CATEGORY(CUSTOMER_NAME customer.customer_name%TYPE)
RETURN VARCHAR2
AS
    NET_BALANCE number;
    NET_LOAN number;
    CATEGORY VARCHAR2(20);
BEGIN
    SELECT sum(account.balance) INTO NET_BALANCE FROM account,depositor WHERE depositor.customer_name=CustomerName AND depositor.account_number=account.account_number;
    SELECT sum(loan.amount) INTO NET_LOAN FROM borrower,loan WHERE borrower.customer_name=CustomerName AND borrower.loan_number=loan.loan_number;
    IF((NET_BALANCE)>1000 AND (NET_LOAN)<1000) THEN
        Category:='C-A1';
    ELSIF((NET_BALANCE)<500 AND (NET_LOAN)>2000) THEN
        Category:='C-C3';
    ELSE
        Category:='C-B1';
    END IF;
    RETURN Category;
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(CATEGORY('Johnson'));
END;
/
