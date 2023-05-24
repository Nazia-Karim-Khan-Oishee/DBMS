CREATE TABLE TRANSACTION(
    TID INTEGER,
    ACCNO INTEGER,
    AMOUNT NUMBER,
    TRANSACTIONDATE TIMESTAMP,
    CONSTRAINT PK_TRANSACTION PRIMARY KEY (TID),
    CONSTRAINT FK_TRANSACTION FOREIGN KEY (ACCNO) REFERENCES BANK_ACCOUNTS(ACCOUNTID)
);
CREATE TABLE BALANCE(
    ACCNO INTEGER,
    PRINCIPLEAMOUNT NUMBER,
    PROFITAMOUNT NUMBER,
    CONSTRAINT PK_BALANCE PRIMARY KEY (ACCNO),
    CONSTRAINT FK_BALANCE FOREIGN KEY (ACCNO) REFERENCES BANK_ACCOUNTS (ACCOUNTID)
    );

CREATE TABLE ACCPROPERTY(
    P_ID INTEGER,
    NAME VARCHAR(255),
    PROFITRATE NUMBER,
    GRACEPERIOD INTEGER,
    CONSTRAINT PK_ACCPROPERTY PRIMARY KEY (P_ID)
);
CREATE TABLE BANK_ACCOUNTS(
    ACCOUNTID INTEGER,
    NAME VARCHAR(255),
    ACCCODE INTEGER,
    OPENINGDATE TIMESTAMP,
    LASTDATEINTEREST TIMESTAMP,
    CONSTRAINT PK_BANKACCOUNT PRIMARY KEY (ACCOUNTID),
    CONSTRAINT FK_BANKACCOUNT FOREIGN KEY (ACCCODE) REFERENCES ACCPROPERTY(P_ID)
);

insert into ACCPROPERTY (P_ID,NAME,PROFITRATE,GRACEPERIOD)VALUES(2002,'MONTHLY',2.8,1);
insert into ACCPROPERTY (P_ID,NAME,PROFITRATE,GRACEPERIOD)VALUES(3003,'quarterly',4.2,4);
insert into ACCPROPERTY (P_ID,NAME,PROFITRATE,GRACEPERIOD)VALUES(4004,'biyearly',6.8,6);
insert into ACCPROPERTY (P_ID,NAME,PROFITRATE,GRACEPERIOD)VALUES(5005,'YEARLY',8,12);


DECLARE
i INTEGER;
BEGIN
FOR i IN 1.. 5 LOOP
insert into BANK_ACCOUNTS (ACCOUNTID,NAME,ACCCODE,OPENINGDATE,LASTDATEINTEREST)VALUES(i,'AB',2002,TO_TIMESTAMP('1-10-2020','DD-MM-YYYY'),TO_TIMESTAMP('1-10-2021','DD-MM-YYYY'));
END LOOP ;
END ;
/

DECLARE
i INTEGER;
BEGIN
FOR i IN 1.. 5 LOOP
insert into TRANSACTION (TID,
    ACCNO,
    AMOUNT,TRANSACTIONDATE)VALUES(i,1,2000,TO_TIMESTAMP('1-10-2020','DD-MM-YYYY'));
END LOOP ;
END ;
/
insert into BALANCE (ACCNO,PRINCIPLEAMOUNT,PROFITAMOUNT)VALUES(1,2000,200);

1
SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE FUNCTION CURR_BALANCE(ACC_ID in BANK_ACCOUNTS.ACCOUNTID%TYPE)
RETURN INTEGER
AS
PRINCIPLE_AMOUNT INTEGER;
TOTAL_TRANSACTION INTEGER;
BEGIN
    SELECT PRINCIPLEAMOUNT INTO PRINCIPLE_AMOUNT FROM BALANCE WHERE ACCNO=ACC_ID;
    SELECT SUM(AMOUNT) INTO TOTAL_TRANSACTION FROM TRANSACTION WHERE ACCNO=ACC_ID;
    TOTAL_TRANSACTION := TOTAL_TRANSACTION+PRINCIPLE_AMOUNT;
    RETURN TOTAL_TRANSACTION;
END;
/
DECLARE
ID INTEGER;
BEGIN
ID:='&ID';
DBMS_OUTPUT.PUT_LINE(CURR_BALANCE(ID));
END;
/


2

SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE FUNCTION Calculate_Profit(ACC_ID in BANK_ACCOUNTS.ACCOUNTID%TYPE)
RETURN NUMBER
AS
Account_Code INTEGER;
TOTAL_TRANSACTION INTEGER;
period integer;
RATE number;
CURR_DATE TIMESTAMP;
LASTDATE TIMESTAMP;
MONTHS_PASSED NUMBER;
BEGIN
    SELECT ACCCODE INTO Account_Code FROM BANK_ACCOUNTS WHERE ACCOUNTID=ACC_ID;
    SELECT GRACEPERIOD INTO period FROM ACCPROPERTY WHERE P_ID=Account_Code;
    SELECT PROFITRATE INTO RATE FROM ACCPROPERTY WHERE P_ID=Account_Code;
    SELECT LASTDATEINTEREST INTO LASTDATE FROM BANK_ACCOUNTS WHERE ACCOUNTID=ACC_ID;
    SELECT SYSDATE INTO CURR_DATE FROM DUAL;

   MONTHS_PASSED := FLOOR( (CURR_DATE-LASTDATE)/30) ;
    RETURN MONTHS_PASSED;
END;
/
DECLARE
ID INTEGER;
BEGIN
ID:='&ID';
DBMS_OUTPUT.PUT_LINE(Calculate_Profit(ID));
END;
/










/////////////////


drop table Balance;
drop table Transaction;
drop table Account;
drop table AccountProperty;




create table AccountProperty(
  ID number,
  Name varchar2(50),
  ProfitRate number,
  GracePeriod number,
  constraint Pk_AccountProperty PRIMARY KEY(ID)
);

create table Account(
  ID number,
  Name varchar2(50),
  AccCode number,
  OpeningDate date,
  LastDateInterest date,
  constraint Pk_Account PRIMARY KEY(ID),
  constraint Fk_Account FOREIGN KEY(AccCode) REFERENCES AccountProperty(ID) ON DELETE CASCADE
);



create table Transaction(
  TID number,
  AccNo number,
  Amount number,
  TransactionDate date,
  constraint Pk_Transaction PRIMARY KEY(TID),
  constraint Fk_Transaction FOREIGN KEY(AccNo) REFERENCES Account(ID) ON DELETE CASCADE
);

create table Balance(
  AccNo number,
  PrincipalAmount number,
  ProfitAmount number,
  constraint Pk_Balance PRIMARY KEY(AccNo),
  constraint Fk_Balance FOREIGN KEY(AccNo) REFERENCES Account(ID) ON DELETE CASCADE
);



////////////////////////////////////////////////////////////////

 
insert into AccountProperty(ID, Name,ProfitRate,GracePeriod) values (2002, 'monthly', 2.8, 1);
insert into AccountProperty (ID, Name,ProfitRate,GracePeriod) values (3003, 'quarterly', 4.2, 4);
insert into AccountProperty (ID, Name,ProfitRate,GracePeriod) values (4004, 'biyearly', 6.8, 6);
insert into AccountProperty (ID, Name,ProfitRate,GracePeriod) values (5005, 'yearly', 8, 12);

insert into Account(ID,Name,AccCode,OpeningDate,LastDateInterest) values (1, 'A', 1, TO_DATE('10-10-2020', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));
insert into Account(ID,Name,AccCode,OpeningDate,LastDateInterest) values (2, 'B', 2, TO_DATE('10-11-2020', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));
insert into Account(ID,Name,AccCode,OpeningDate,LastDateInterest)values (3, 'C', 3, TO_DATE('11-10-2021', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));
insert into Account(ID,Name,AccCode,OpeningDate,LastDateInterest) values (4, 'D', 4, TO_DATE('10-11-2021', 'DD-MM-YYYY'), TO_DATE('11-11-2022', 'DD-MM-YYYY'));

insert into Transaction(TID,AccNo,Amount,TransactionDate) values (1, 1, 10000, TO_DATE('10-10-2020', 'DD-MM-YYYY'));
insert into Transaction(TID,AccNo,Amount,TransactionDate) values (3, 2, 120000, TO_DATE('10-10-2020', 'DD-MM-YYYY'));
insert into Transaction (TID,AccNo,Amount,TransactionDate)values (5, 3, 22000, TO_DATE('10-10-2020', 'DD-MM-YYYY'));
insert into Transaction (TID,AccNo,Amount,TransactionDate)values (7, 4, 22500, TO_DATE('10-10-2020', 'DD-MM-YYYY'));

insert into Balance(AccNo,PrincipalAmount,ProfitAmount) values (1, 2000, 500);
insert into Balance(AccNo,PrincipalAmount,ProfitAmount) values (2, 1000, 500);
insert into Balance(AccNo,PrincipalAmount,ProfitAmount) values (3, 4000, 400);
insert into Balance(AccNo,PrincipalAmount,ProfitAmount) values (4, 3000, 400);

1

SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE FUNCTION CurrentBalance(Acc_No IN number) 
RETURN number
AS
CurrentBalance number;
Principal_Amount number;
BEGIN
    SELECT PrincipalAmount INTO Principal_Amount FROM BALANCE WHERE AccNo=Acc_No;
    SELECT sum(Amount) INTO CurrentBalance FROM Transaction WHERE AccNo=Acc_No;
    CurrentBalance := CurrentBalance + Principal_Amount;
    return CurrentBalance;
END;
/

DECLARE
    AccNo Transaction.AccNo%TYPE;
BEGIN
    AccNo:='&AccountIID';
    DBMS_OUTPUT.PUT_LINE(CurrentBalance(AccNo));
END;
/


2
SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE FUNCTION Profit(Acc_NO IN Transaction.AccNo%TYPE, Profit OUT Balance.PrincipalAmount%TYPE,FinalBalance OUT Balance.PrincipalAmount%TYPE)
RETURN number
AS
PRate number;
GPeriod number;
code number;
Months number;
Principal number;
BalancebeforeProfit number;
BEGIN
  SELECT AccCode INTO code FROM Account WHERE ID=Acc_NO;
  SELECT PrincipalAmount INTO Principal FROM Balance WHERE AccNo=Acc_NO;
  SELECT ProfitRate INTO PRate FROM AccountProperty WHERE ID=code;
  SELECT GracePeriod INTO GPeriod  FROM AccountProperty WHERE ID=code;
  SELECT (SELECT SYSDATE FROM DUAL)-LastDateInterest INTO Months FROM Account WHERE ID=Acc_NO;
  Months:= (FLOOR(Months/30));
  BalancebeforeProfit:=Principal;
  Profit:=0;
  For i IN 1..Months 
  LOOP
    Profit:=(Profit+(PRate/100)*Principal);
    IF MOD(i,GPeriod)=0 THEN
      Principal:=Principal+Profit;
      Profit:=0;
    END IF;
  END LOOP;
  FinalBalance:=Principal;
  RETURN BalancebeforeProfit;
END;
/

DECLARE
    Acc_NO Transaction.AccNo%TYPE;
    Profit Balance.PrincipalAmount%TYPE;
    FinalBalance Balance.PrincipalAmount%TYPE;
BEGIN
    Acc_NO:='&AccountIID';
    DBMS_OUTPUT.PUT_LINE('Balance Before Profit: '||Profit(Acc_NO,Profit,FinalBalance)||' Profit: ' || Profit ||' Final Balance: ' || FinalBalance);
END;
/

3

CREATE OR REPLACE PROCEDURE amounts
AS
  Profit Balance.PrincipalAmount%TYPE;
  FinalBalance Balance.PrincipalAmount%TYPE;
  PreviousBalance Balance.PrincipalAmount%TYPE;
BEGIN
  FOR i IN (SELECT * FROM Account) 
  LOOP
    PreviousBalance:=Profit(i.ID,Profit,FinalBalance);
    UPDATE Balance SET PrincipalAmount=FinalBalance WHERE AccNo=i.ID;
    UPDATE Balance SET ProfitAmount=Profit WHERE AccNo=i.ID;
  END LOOP;
END;
/

BEGIN
  amounts();
END;
/