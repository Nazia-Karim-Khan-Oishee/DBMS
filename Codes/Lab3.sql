1
CREATE OR REPLACE
PROCEDURE Show_time( name IN MOVIE.MOV_TITLE%TYPE )
AS
duration number;
div integer;
time number;
BEGIN
SELECT MOV_TIME INTO duration
FROM MOVIE
WHERE  MOV_TITLE=name ;
div := MOD(duration,70);
IF (div>30) THEN
time:=duration+ Floor((duration/70))*15;
ELSE
time:=duration+ (Floor((duration/70))-1)*15;
END IF; 
DBMS_OUTPUT.PUT_LINE (Floor(time/60) || ' hour ' || MOD(time,60)||' minutes');
END ;
/
-- Call it from an anonymous block
SET SERVEROUTPUT ON SIZE 1000000
SET VERIFY OFF
DECLARE
Movie_Name MOVIE.MOV_TITLE%TYPE;
BEGIN
Movie_Name := '&moviename';
Show_time(Movie_Name);
END ;
/

2
CREATE OR REPLACE
PROCEDURE Show_Top_N_Movies( N IN NUMBER )
AS
REVIEW RATING.REV_STARS%TYPE;
TITLE  MOVIE.MOV_TITLE%TYPE;
mov_num number;
BEGIN
SELECT COUNT(MOV_ID) into mov_num FROM MOVIE;
IF(mov_num<N) THEN
DBMS_OUTPUT.PUT_LINE('ERROR');
RETURN;
END IF; 
FOR i IN (SELECT TITLE FROM (SELECT avg(REV_STARS) AS REVIEW,MOV_TITLE AS TITLE FROM RATING natural join MOVIE GROUP BY MOV_TITLE ORDER BY REVIEW DESC) WHERE ROWNUM<=N)  LOOP
DBMS_OUTPUT.PUT_LINE(i.TITLE);
 END LOOP;
END ;
/
-- Call it from an anonymous block
SET SERVEROUTPUT ON SIZE 1000000
SET VERIFY OFF
DECLARE
N NUMBER;
BEGIN
N:='&N';
Show_Top_N_Movies(N);
END ;
/

3

SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE FUNCTION GET_YEARLY_INCOME(movie_title IN MOVIE.MOV_TITLE%TYPE)
RETURN NUMBER
AS
Yearly_Income NUMBER;
Release_Year NUMBER;
Rev_Count NUMBER;
Years_Passed NUMBER;
Current_Year NUMBER;
BEGIN
  SELECT EXTRACT(YEAR FROM (MOV_RELEASEDATE)) INTO Release_Year FROM MOVIE WHERE MOV_TITLE=movie_title;
  SELECT COUNT(*) INTO Rev_Count FROM MOVIE natural join RATING WHERE RATING.REV_STARS>6;
  SELECT EXTRACT(Year FROM SYSDATE) INTO Current_Year FROM Dual;
  Years_Passed:=Current_Year-Release_Year;
  RETURN TRUNC((Rev_Count*10)/Years_Passed,4);
END;
/

DECLARE
    movie_title movie.mov_title%TYPE;
BEGIN
    movie_title:='&movie_title';
    DBMS_OUTPUT.PUT_LINE('Yearly Income ' || GET_YEARLY_INCOME(movie_title));
END;
/

4
SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE FUNCTION GENRE_INFO(id IN mtype.gen_id%TYPE)
RETURN varchar2
AS
  avg_rev_count number;
  avg_rating number;
  gen_count number;
  rev_count number;
  curr_rating number;
BEGIN
  select avg(rev_stars) into avg_rating from mtype,rating where mtype.mov_id=rating.mov_id;
  select count(rev_id) into avg_rev_count from mtype,rating where mtype.mov_id=rating.mov_id;
  select count(distinct gen_id) into gen_count from mtype;
  avg_rev_count:=avg_rev_count/gen_count;
  select avg(rev_stars) into curr_rating from mtype,rating where mtype.mov_id=rating.mov_id AND mtype.gen_id=id;
  select count(rev_id) into rev_count from mtype,rating where mtype.mov_id=rating.mov_id AND mtype.gen_id=id;
  IF(curr_rating<avg_rating AND rev_count>avg_rev_count) THEN
    return 'Widely Watched, Review Count: '||rev_count||', Average Rating: '||TRUNC(curr_rating,2);
  ELSIF (curr_rating>avg_rating AND rev_count<avg_rev_count) THEN
    return 'High Rated, Review Count: '||rev_count||', Average Rating: '||TRUNC(curr_rating,2);
  ELSIF (curr_rating>avg_rating AND rev_count>avg_rev_count) THEN
    return 'Peoples favorite, Review Count: '||rev_count||', Average Rating: '||TRUNC(curr_rating,2);
  ELSE
    return 'So so, Review Count: '||rev_count||', Average Rating: '||TRUNC(curr_rating,2);
  END IF;
    
END;
/

DECLARE
    gen_id mtype.gen_id%TYPE;
BEGIN
    gen_id:='&something';
    DBMS_OUTPUT.PUT_LINE(GENRE_INFO(gen_id));
END;
/
5
SET SERVEROUTPUT ON SIZE 1000000
CREATE OR REPLACE FUNCTION MOST_POPULAR_GENRE(START_DATE IN MOVIE.MOV_RELEASEDATE%TYPE , END_DATE IN MOVIE.MOV_RELEASEDATE%TYPE)
RETURN varchar2
AS
  count_mov number;
  genre GENRES.GEN_TITLE%TYPE;
  genre_id GENRES.GEN_ID%TYPE;
BEGIN
    SELECT id INTO genre_id FROM (SELECT MTYPE.gen_id AS id,count(MOVIES_IN_GivenInterval.MOV_ID) AS movie_count FROM (
    SELECT * FROM MOVIE WHERE MOVIE.MOV_RELEASEDATE BETWEEN START_DATE AND END_DATE)MOVIES_IN_GivenInterval,MTYPE 
    WHERE MOVIES_IN_GivenInterval.MOV_ID=MTYPE.MOV_ID 
    GROUP BY MTYPE.gen_id
    ORDER BY movie_count DESC)
    WHERE ROWNUM<=1;

    SELECT GEN_TITLE INTO genre FROM GENRES WHERE GEN_ID=genre_id;
    SELECT count(MOVIE.MOV_ID) INTO count_mov FROM MOVIE,MTYPE WHERE MOVIE.MOV_ID=MTYPE.MOV_ID AND MTYPE.gen_id=genre_id AND MOVIE.MOV_RELEASEDATE BETWEEN START_DATE AND END_DATE;  
  RETURN genre||', count of movies released: '||count_mov;  
END;
/

DECLARE
    start_date MOVIE.MOV_RELEASEDATE%TYPE;
    end_date MOVIE.MOV_RELEASEDATE%TYPE;
BEGIN
    start_date:='&start_date';
    end_date:='&end_date';
    DBMS_OUTPUT.PUT_LINE(Most_POPULAR_GENRE(TO_DATE(start_date),TO_DATE(end_date)));
END;
/