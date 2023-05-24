create user s<200042137> identified by cse4308;
grant dba to s<200042137>;

create table STUDENT(
ID varchar(20) primary key,
NAME varchar2(20),
DEPT_NAME varchar2(20),
TOT_CRED int
);
insert into STUDENT values('00128', 'Zhang' , 'Comp.Sci.' ,'102');
insert into STUDENT values('12345', 'Shankar' , 'Comp.Sci.' ,'32');
insert into STUDENT values('19991', 'Brandt' , 'History' ,'80');
insert into STUDENT values('23121', 'Chavez' , 'Finance' ,'110');
insert into STUDENT values('44553', 'Peltier' , 'Physics' ,'56');
insert into STUDENT values('45678', 'Levy' , 'Physics' ,'46');
insert into STUDENT values('54321', 'Williams' , 'Comp.Sci.' ,'5');
insert into STUDENT values('55739', 'Sanchez' , 'Music' ,'38');
insert into STUDENT values('70557', 'Snow' , 'Physics' ,'0');
insert into STUDENT values('76543', 'Brown' , 'Comp.Sci.' ,'58');
insert into STUDENT values('76653', 'Aoi' , 'Elec.Eng.' ,'60');
insert into STUDENT values('98765', 'Bourikas' , 'Elec.Eng.' ,'9');
insert into STUDENT values('98988', 'Tanaka' , 'Biology' ,'120');

SELECT * FROM STUDENT ;
SELECT ID,NAME FROM STUDENT ;
SELECT NAME,DEPT_NAME FROM STUDENT WHERE TOT_CRED > 100;
SELECT NAME,DEPT_NAME FROM STUDENT WHERE TOT_CRED>=80 AND TOT_CRED<=120;

SELECT ID,NAME FROM STUDENT WHERE DEPT_NAME = 'Comp.Sci.';
SELECT NAME,TOT_CRED FROM STUDENT WHERE DEPT_NAME = 'Physics';
select ID,NAME FROM STUDENT WHERE DEPT_NAME = 'Comp.Sci.' OR TOT_CRED <10;
select  distinct DEPT_NAME FROM STUDENT ;

