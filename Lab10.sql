1
SET SERVEROUTPUT ON SIZE 1000000
DECLARE
TOTAL_ROWS NUMBER (2);
BEGIN
UPDATE INSTRUCTOR
SET SALARY = SALARY + SALARY*(0.1)
WHERE SALARY < 75000 ;

IF SQL% NOTFOUND THEN
DBMS_OUTPUT . PUT_LINE ( 'No instructor satisfied the condition ');
ELSIF SQL% FOUND THEN
TOTAL_ROWS := SQL% ROWCOUNT ;
DBMS_OUTPUT . PUT_LINE ( TOTAL_ROWS || ' instructors updated ');
END IF;
END ;
/

2
SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE
PROCEDURE TIME_SLOT
AS
BEGIN
    
    FOR ROW IN (SELECT INSTRUCTOR.ID AS ID,INSTRUCTOR.NAME AS NAME,TIME_SLOT.TIME_SLOT_ID AS TIME_SLOT_ID, TIME_SLOT.DAY AS DAY, TIME_SLOT.start_time AS start, TIME_SLOT.end_time AS end, T
     FROM INSTRUCTOR, TEACHES, SECTION ,TIME_SLOT  WHERE INSTRUCTOR.ID = TEACHES.ID AND   
                    TEACHES.COURSE_ID = SECTION.COURSE_ID AND TEACHES.SEC_ID = SECTION.SEC_ID AND TEACHES.SEMESTER = SECTION.SEMESTER AND TEACHES.YEAR = SECTION.YEAR AND
                    SECTION.TIME_SLOT_ID = TIME_SLOT.TIME_SLOT_ID) LOOP
        dbms_output.put_line(ROW.ID || ' '||ROW.NAME || ' '||ROW.TIME_SLOT_ID || ' ' || ROW.DAY || ' ' || ROW.start||' ' ||ROW.end);
    END LOOP;

END;
/

    BEGIN 
        TIME_SLOT;
    END;
    /

3
SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE
PROCEDURE AdvisorWithHighestStudent(N IN NUMBER)
AS
    MAX_ROW NUMBER;
BEGIN
    SELECT count(*) INTO MAX_ROW FROM (SELECT * FROM (SELECT i_id,count(*)studentCount FROM advisor group by i_id order by studentCount desc)StudentTable JOIN instructor on countTable.i_id=instructor.ID);
    IF N>=MAX_ROW THEN
        DBMS_OUTPUT.put_line('N exceeds maximum number of records');
        RETURN;
    END IF;
    FOR ROW IN (SELECT * FROM (SELECT * FROM (SELECT i_id,count(*)studentCount FROM advisor group by i_id order by studentCount desc)StudentTable JOIN instructor on countTable.i_id=instructor.ID) WHERE ROWNUM<=N) LOOP
        DBMS_OUTPUT.PUT_LINE(ROW.ID || ' ' || ROW.name || ' ' || ROW.dept_name || ' ' || ROW.salary || ' ' || ROW.studentCount);
    END LOOP;
END;
/

DECLARE
    N NUMBER;
BEGIN
    N:='&number';
    AdvisorWithHighestStudent(N);
END;
/


4.
CREATE SEQUENCE STUDENT_SEQ
MINVALUE 1
MAXVALUE 9999
START WITH 1
INCREMENT BY 1
CACHE 20;
CREATE OR REPLACE
TRIGGER STUDENT_ID_GENERATOR
BEFORE INSERT ON STUDENT
FOR EACH ROW
DECLARE
    NEW_ID STUDENT.ID% TYPE ;
BEGIN
SELECT STUDENT_SEQ . NEXTVAL INTO NEW_ID
FROM DUAL ;
:NEW.ID := NEW_ID ;
END ;
/
insert into student (name,dept_name,tot_cred)values ('nazia', 'Comp. Sci.', 100);
insert into student (name,dept_name,tot_cred)values ('oishee', 'Comp. Sci.', 100);
select * from student where name ='nazia';
select * from student where name ='oishee';

5
CREATE OR REPLACE
TRIGGER AssignAdvisor
AFTER INSERT ON student
FOR EACH ROW
DECLARE
Instructor_ID instructor.ID% TYPE ;
BEGIN
SELECT MAX(ID) INTO Instructor_ID FROM (SELECT ID FROM instructor WHERE :NEW.dept_name=instructor.dept_name) WHERE ROWNUM=1;
INSERT INTO advisor VALUES (:NEW.ID,Instructor_ID);
END;
/