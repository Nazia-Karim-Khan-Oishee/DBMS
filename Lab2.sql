1
CREATE TABLESPACE tbs1
DATAFILE 'tbs1_data.dbf' SIZE 1m,
          'tbs2_data.dbf' SIZE 1m;
CREATE TABLESPACE tbs2
DATAFILE 'tbs3_data.dbf' SIZE 1m,
          'tbs4_data.dbf' SIZE 1m;

2
CREATE USER iutlearner
IDENTIFIED BY test123
DEFAULT TABLESPACE tbs1;
ALTER USER iutlearner QUOTA 10M ON tbs2;


3
CREATE TABLE depT(
id INT ,
name VARCHAR2 (32),
constraint pk_dept PRIMARY KEY (name)
) TABLESPACE tbs1;

CREATE TABLE studT(
id INT ,
name VARCHAR2 (32),
dept VARCHAR2(32),constraint pk_student PRIMARY KEY (id),
constraint fk_student  FOREIGN KEY(dept) references depT(name)
) TABLESPACE tbs1 ;

4
CREATE TABLE courses(
code INT ,credit number ,offer_by VARCHAR2 (32),
name VARCHAR2 (32),
constraint pk_course PRIMARY KEY (code),
constraint fk_course  FOREIGN KEY(offer_by) references depT(name)
) TABLESPACE tbs2;

5
insert into depT values(1,'CSE');

DECLARE
i NUMBER (2);
BEGIN
FOR i IN 10 .. 20 LOOP
insert into studT(id,name,dept) values (i,'Nazia','CSE');
END LOOP ;
END ;
/


DECLARE
i NUMBER (2);
BEGIN
FOR i IN 10 .. 20 LOOP
insert into courses (code,credit,offer_by,name)VALUES(i,2,'CSE','DBMS2');
END LOOP ;
END ;
/


-- insert into depT values(1,'CSE');
-- insert into studT(id,name,dept) values (1,'Nazia','CSE');
-- insert into studT(id,name,dept) values (2,'Nazia','CSE');
-- insert into studT(id,name,dept) values (3,'Nazia','CSE');
-- insert into studT(id,name,dept) values (4,'Nazia','CSE');
-- insert into studT(id,name,dept) values (5,'Nazia','CSE');

-- insert into courses (code,credit,offer_by,name)VALUES(4409,2,'CSE','DBMS2');
-- insert into courses (code,credit,offer_by,name)VALUES(4410,1.5,'CSE','DBMS2Lab');

6
SELECT tablespace_name,file_id,bytes /1024/1024 MB
FROM dba_free_space
WHERE tablespace_name ='TBS1';
SELECT tablespace_name , file_id,bytes /1024/1024 MB
FROM dba_free_space
WHERE tablespace_name ='TBS2';

7
ALTER TABLESPACE tbs1
ADD DATAFILE 'tbs3_data . dbf' SIZE 1m;

8
ALTER DATABASE
DATAFILE 'tbs3_data.dbf' RESIZE 15m;
9
SELECT tablespace_name , bytes /1024/1024 MB
FROM dba_data_files
WHERE tablespace_name ='TBS1';
SELECT tablespace_name , bytes /1024/1024 MB
FROM dba_data_files
WHERE tablespace_name ='TBS2';

10
DROP TABLESPACE tbs1
INCLUDING CONTENTS AND DATAFILES
CASCADE CONSTRAINTS;

11
DROP TABLESPACE tbs2
INCLUDING CONTENTS KEEP DATAFILES
CASCADE CONSTRAINTS;


CREATE TABLESPACE tbs3
DATAFILE 'tbs5_data.dbf' SIZE 1m,
          'tbs6_data.dbf' SIZE 1m;
         ALTER USER iutlearner QUOTA 10M ON tbs3;

CREATE TABLE dt(
id INT ,
name VARCHAR2 (32),
constraint pk_dept PRIMARY KEY (name)
) TABLESPACE tbs3;
insert into dt values(1,'CSE');

select tablespace_name, owner
from all_tables where table_name='DT';

select table_name, owner
from all_tables where tablespace_name='TBS3';

