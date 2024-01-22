CREATE TABLE TRANSACTION(
    TID number,
  AccNo number,
  Amount number,
  TransactionDate date,
  constraint Pk_Transaction PRIMARY KEY(TID),
  constraint Fk_Transaction FOREIGN KEY(AccNo) REFERENCES BANK_ACCOUNTS(ID) ON DELETE CASCADE
);
CREATE TABLE BALANCE(
     AccNo number,
  PrincipalAmount number,
  ProfitAmount number,
  constraint Pk_OF_Balance PRIMARY KEY(AccNo),
  constraint Fk_OF_Balance FOREIGN KEY(AccNo) REFERENCES BANK_ACCOUNTS(ID) ON DELETE CASCADE
);
CREATE TABLE ACCOUNTPROPERTY(
   ID number,
  Name varchar2(50),
  ProfitRate number,
  GracePeriod number,
  constraint Pk_AccountProperty PRIMARY KEY(ID)
);
CREATE TABLE BANK_ACCOUNTS(
    ID number,
  Name varchar2(50),
  AccCode number,
  OpeningDate date,
  LastDateInterest date,
  constraint Pk_OF_BANKACCOUNTS PRIMARY KEY(ID),
  constraint Fk_OF_Account FOREIGN KEY(AccCode) REFERENCES AccountProperty(ID) ON DELETE CASCADE
);

insert into ACCOUNTPROPERTY(ID, Name,ProfitRate,GracePeriod) values (2002, 'monthly', 2.8, 1);
insert into ACCOUNTPROPERTY (ID, Name,ProfitRate,GracePeriod) values (3003, 'quarterly', 4.2, 4);
insert into ACCOUNTPROPERTY (ID, Name,ProfitRate,GracePeriod) values (4004, 'biyearly', 6.8, 6);
insert into ACCOUNTPROPERTY (ID, Name,ProfitRate,GracePeriod) values (5005, 'yearly', 8, 12);

insert into BANK_ACCOUNTS(ID,Name,AccCode,OpeningDate,LastDateInterest) values (1, 'A', 2002, TO_DATE('10-10-2020', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));
insert into BANK_ACCOUNTS(ID,Name,AccCode,OpeningDate,LastDateInterest) values (2, 'B', 3003, TO_DATE('10-11-2020', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));
insert into BANK_ACCOUNTS(ID,Name,AccCode,OpeningDate,LastDateInterest)values (3, 'C', 4004, TO_DATE('11-10-2021', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));
insert into BANK_ACCOUNTS(ID,Name,AccCode,OpeningDate,LastDateInterest) values (4, 'D', 5005, TO_DATE('10-11-2021', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));
insert into BANK_ACCOUNTS(ID,Name,AccCode,OpeningDate,LastDateInterest) values (9, 'E', 2002, TO_DATE('10-10-2020', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));

insert into TRANSACTION(TID,AccNo,Amount,TransactionDate) values (1, 1, 10000, TO_DATE('10-10-2020', 'DD-MM-YYYY'));
insert into TRANSACTION(TID,AccNo,Amount,TransactionDate) values (3, 2, 120000, TO_DATE('10-10-2020', 'DD-MM-YYYY'));
insert into TRANSACTION (TID,AccNo,Amount,TransactionDate)values (5, 3, 22000, TO_DATE('10-10-2020', 'DD-MM-YYYY'));
insert into TRANSACTION (TID,AccNo,Amount,TransactionDate)values (7, 4, 22500, TO_DATE('10-10-2020', 'DD-MM-YYYY'));

insert into BALANCE(AccNo,PrincipalAmount,ProfitAmount) values (1, 2000, 500);
insert into BALANCE(AccNo,PrincipalAmount,ProfitAmount) values (2, 1000, 500);
insert into BALANCE(AccNo,PrincipalAmount,ProfitAmount) values (3, 4000, 400);
insert into BALANCE(AccNo,PrincipalAmount,ProfitAmount) values (4, 3000, 400);

1
CREATE SEQUENCE SERIAL_NO
MINVALUE 100
MAXVALUE 9999
START WITH 100
INCREMENT BY 1
CACHE 20;

SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE FUNCTION CreateID(User_Name IN BANK_ACCOUNTS.Name%TYPE, AccCode IN BANK_ACCOUNTS.AccCode%TYPE, OpenningDate BANK_ACCOUNTS.OpeningDate%TYPE)
RETURN varchar2
AS
ACCOOUNTID VARCHAR2(255);
TTTT  BANK_ACCOUNTS.Name%TYPE;
YMD BANK_ACCOUNTS.OpeningDate%TYPE;
NNN VARCHAR2(50);
XXX NUMBER;
BEGIN
SELECT SERIAL_NO.NEXTVAL INTO XXX
FROM DUAL ;
YMD:= OpenningDate;
TTTT:=AccCode;
NNN:= SUBSTR(User_Name,1,3);
ACCOOUNTID:= CONCAT(TTTT,TO_CHAR(YMD,'YYYYMMDD'));
ACCOOUNTID:= CONCAT(ACCOOUNTID,'.');
ACCOOUNTID:= CONCAT(ACCOOUNTID,NNN);
ACCOOUNTID:= CONCAT(ACCOOUNTID,'.');
ACCOOUNTID:= CONCAT(ACCOOUNTID,XXX);

RETURN ACCOOUNTID;
END;
/
SET VERIFY OFF
DECLARE
User_Name BANK_ACCOUNTS.Name%TYPE;
AccCode BANK_ACCOUNTS.AccCode%TYPE;
OpeningDate VARCHAR2(255);
BEGIN
    User_Name:='&UserName';
    AccCode:='&AccountCode';
    OpeningDate:='&Date';
    DBMS_OUTPUT.PUT_LINE(CreateID(User_Name,AccCode,TO_DATE(OpeningDate,'DD-MM-YYYY')));
END;
/

2
ALTER TABLE BALANCE DROP CONSTRAINT Fk_OF_Balance;
ALTER TABLE TRANSACTION DROP CONSTRAINT Fk_Transaction;
ALTER TABLE BANK_ACCOUNTS DROP CONSTRAINT Pk_OF_BANKACCOUNTS;
ALTER TABLE BANK_ACCOUNTS
DROP COLUMN ACCOUNT_ID;
ALTER TABLE BANK_ACCOUNTS
DROP COLUMN ID;
ALTER TABLE BANK_ACCOUNTS
ADD ACCOUNT_ID VARCHAR2(255) NOT NULL;
DELETE FROM BANK_ACCOUNTS;
DELETE FROM BALANCE;
DELETE FROM TRANSACTION;
ALTER TABLE BANK_ACCOUNTS ADD CONSTRAINT Pk_OF_BANKACCOUNTS PRIMARY KEY (ACCOUNT_ID);
ALTER TABLE BALANCE
DROP COLUMN AccNo;
ALTER TABLE TRANSACTION
DROP COLUMN AccNo;
ALTER TABLE BALANCE
ADD AccNo VARCHAR2(255) NOT NULL;
ALTER TABLE TRANSACTION
ADD AccNo VARCHAR2(255) NOT NULL;
ALTER TABLE BALANCE ADD CONSTRAINT Fk_OF_Balance FOREIGN KEY (AccNo) REFERENCES BANK_ACCOUNTS (ACCOUNT_ID)  on delete cascade;
ALTER TABLE TRANSACTION ADD CONSTRAINT  Fk_Transaction FOREIGN KEY (AccNo) REFERENCES BANK_ACCOUNTS (ACCOUNT_ID)  on delete cascade;


3
CREATE OR REPLACE
TRIGGER ACCOUNT_ID_GENERATOR
BEFORE INSERT ON BANK_ACCOUNTS
FOR EACH ROW
DECLARE
    NEW_ID varchar2(255) ;
BEGIN
NEW_ID:= CreateID(:NEW.Name, :NEW.AccCode, :NEW.OpeningDate);
:NEW.ACCOUNT_ID := NEW_ID ;
END ;
/


4
CREATE OR REPLACE
TRIGGER update_balance
after INSERT ON BANK_ACCOUNTS
FOR EACH ROW
DECLARE
    NEW_ID varchar2(255) ;
BEGIN
insert into BALANCE(AccNo,PrincipalAmount,ProfitAmount) values (:NEW.ACCOUNT_ID, 5000, 0);

END ;
/

5
CREATE OR REPLACE
TRIGGER BALANCE_AFTERTRANSACTION
after INSERT ON TRANSACTION
FOR EACH ROW
BEGIN
update balance SET PrincipalAmount=PrincipalAmount+:NEW.Amount WHERE AccNo = :NEW.AccNo;
END ;
/


insert into BANK_ACCOUNTS(Name,AccCode,OpeningDate,LastDateInterest) values ('B', 2002, TO_DATE('10-10-2020', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));

SELECT * FROM BANK_ACCOUNTS;
SELECT * FROM BALANCE;

insert into TRANSACTION(TID,AccNo,Amount,TransactionDate) values (2, '200220201010.B.122', 10000, TO_DATE('10-10-2020', 'DD-MM-YYYY'));
SELECT * FROM BALANCE;
