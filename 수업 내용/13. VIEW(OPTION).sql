--뷰 옵션
--OR REPLACE : 기존에 같은 이름의 뷰가 존재 할 경우 덮어 쓴다.
--                          --> 이름의 뷰가 존재 하지 않을 경우 새로 생성 한다.
--FORCE : 서브쿼리에 사용 된 테이블이 존재 하지 않을경우에도 뷰 생성 
--NOFORCE : 서브쿼리에 사용 된 테이블이 존재 할 경우만 뷰 생성
--WITH CHECK OPTION : 조건절에 사용한 컬럼의 값을 조작 하려 할때
--                                        조작을 막는 옵션(DML을 방지 하는 목적)
--WITH READ ONLY : 뷰를 통해서 조회만 가능하도록 하는 옵션

--FORCE : 서브쿼리에 사용 된 테이블이 존재 하지 않을경우에도 뷰 생성 
CREATE OR REPLACE FORCE VIEW TEMP_V AS
SELECT *
FROM TTT;

SELECT *
FROM USER_VIEWS;

--WITH CHECK OPTION : 조건절에 사용한 컬럼의 값을 조작 하려 할때
--                                        조작을 막는 옵션(DML을 방지 하는 목적)
--EMPLOYEE_COPY 테이블의 'D5'부서 인원을 조회하는 뷰 생성
CREATE OR REPLACE VIEW EMP_CP_V AS
SELECT *
FROM EMPLOYEE_COPY
WHERE DEPT_CODE = 'D5'
WITH CHECK OPTION;

SELECT *
FROM EMP_CP_V;

--뷰를 이용하여 하이유의 급여 3200000, 급여등급 S4 변경
UPDATE EMP_CP_V
SET SALARY = 3200000, SAL_LEVEL = 'S4'
WHERE EMP_NAME = '하이유';
SELECT *
FROM EMP_CP_V;
--부서 변경으로 인해 D5 -> D6 이동 하였습니다. 
--뷰를 이용하여 직원 데이터를 수정해 주십시오.
UPDATE EMP_CP_V
SET DEPT_CODE = 'D6'
WHERE DEPT_CODE = 'D5'; --변경 불가

--WITH READ ONLY : 뷰를 통해서 조회만 가능하도록 하는 옵션
CREATE OR REPLACE /*NOFORCE*/ VIEW EMP_CP_V AS
SELECT *
FROM EMPLOYEE_COPY
WHERE DEPT_CODE = 'D5'
WITH READ ONLY;

UPDATE EMP_CP_V
SET SALARY = 3000000, SAL_LEVEL = 'S4'
WHERE EMP_NAME = '하이유';


--SEQUENCE
--> 자동 번호 생성기 -> 순차적으로 정수 값을 생성하는 객체
--표현식 
--CREATE SEQUENCE 시퀀스 명
--START WITH 시작값
--INCREMENT BY 숫자
--MAXVALUE 최대값 | NOMAXVALUE 10^27
--MINVALUE 최소값 | NOMINVALUE -10^26
--CYCLE | NOCYCLE
--CACHE [20]임의로 생성해놓을 갯수 | NOCACHE

--시퀀스 : USER_ID_SEQ 시작값 1 ~ 99999
CREATE SEQUENCE USER_ID_SEQ
START WITH 1
INCREMENT BY 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

SELECT *
FROM USER_SEQUENCES;

--시퀀스 다음 값을 출력 : 시퀀스명.NEXTVAL
--시퀀스 현재 값을 출력 : 시퀀스명.CURRVAL
SELECT USER_ID_SEQ.NEXTVAL
FROM DUAL;
SELECT USER_ID_SEQ.CURRVAL
FROM DUAL;

--학생 테이블(STUDENT_TB)
--학번, 이름, 생년월일
--1103350225
--201800001 , 201800002.....201899999
CREATE TABLE STUDENT_TB(
    SID CHAR(9) PRIMARY KEY,
    SNAME VARCHAR2(30),
    BIRTH DATE
);
CREATE SEQUENCE STUDENT_ID_SEQ
START WITH 1
INCREMENT BY 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

INSERT INTO STUDENT_TB(SID, SNAME, BIRTH)
VALUES (TO_CHAR(SYSDATE,'YYYY')|| LPAD(STUDENT_ID_SEQ.NEXTVAL,5,'0')
                    , '최범석', '1999/01/01');
SELECT *
FROM STUDENT_TB;
INSERT INTO STUDENT_TB(SID, SNAME, BIRTH)
VALUES (TO_CHAR(SYSDATE,'YYYY')|| LPAD(STUDENT_ID_SEQ.NEXTVAL,5,'0')
                    , '김현수', '1991/07/28');

--CYCLE
CREATE SEQUENCE CYCLE_SEQ
START WITH 1
INCREMENT BY 1
MAXVALUE 5
CYCLE
NOCACHE;

SELECT CYCLE_SEQ.NEXTVAL
FROM DUAL;

--CACHE
CREATE SEQUENCE CACHE_SEQ
START WITH 1
INCREMENT BY 1
MAXVALUE 100000
NOCYCLE
CACHE 50;

SELECT CACHE_SEQ.NEXTVAL
FROM DUAL;

SELECT *
FROM USER_SEQUENCES;
--시퀀스 삭제
DROP SEQUENCE CACHE_SEQ;


--INDEX : SQL 질이어의 처리 속도를 향상 시키기 위해서 컬럼에 설정하는 객체 
--INDEX 장점 : 검색 속도가 빨라진다. -> 시스템에 부하가 줄어든다.
--                            -> 시스템의 전체 성능을 향상 시킨다.
--INDEX 단점 : 인덱스를 저장하기 위한 추가적인 저장 공간이 필요하다
--                   인덱스를 생성하는데 시간이 걸린다.
--DML이 자주 일어나는 테이블이나 컬럼에 대해서 인덱스가 설정되어 있을경우
--시간이 오래 걸림(인덱스 재배열)

--인덱스를 효율적으로 사용하는 방법
--데이터의 수가 40000이상의 데이터의 10~20% 정도를 조회할때
--두개의 테이블을 조인 할때
--데이터가 자주 변경되지 않는 경우
--테이블에 저장되어 있는 용량이 큰 경우

--CREATE INDEX 인덱스명 ON 테이블명(컬럼명1,컬럼명2,컬럼명3~~~)

SELECT *
FROM TB_GRADE
WHERE TERM_NO = '200801'; --0초

CREATE INDEX GRADE_IDX ON TB_GRADE(TERM_NO);

SELECT *
FROM TB_GRADE
WHERE TERM_NO = '200801'; --0.32초

DROP INDEX GRADE_IDX;

--STUDENT JOIN

SELECT *
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N USING (NATIONAL_CODE)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE); --0.016

-- EMPLOYEE DEPT_CODE INDEX
CREATE INDEX EMP_DEPT_IDX ON EMPLOYEE(DEPT_CODE);
CREATE INDEX DEPT_LOC_IDX ON DEPARTMENT(LOCATION_ID);
CREATE INDEX LOC_NCCODE_IDX ON LOCATION(NATIONAL_CODE);
CREATE INDEX EMP_JOB_IDX ON EMPLOYEE(JOB_CODE);

SELECT *
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N USING (NATIONAL_CODE)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE); --0.016

SELECT *
FROM EMPLOYEE;

--인덱스 종류
-- 1. 고유 인덱스(UNIQUE)
-- 인덱스가 설정 된 컬럼에 중복된 값이 없을경우 설정
CREATE UNIQUE INDEX EMP_NO_IDX ON EMPLOYEE_COPY(EMP_NO);
CREATE UNIQUE INDEX EMP_NO_IDX2 ON EMPLOYEE_COPY(DEPT_CODE);

-- 2. 비고유 인덱스(NONUNIQUE)
-- 인덱스가 설정 된 컬럼에 중복된 값이 있을경우 설정(WHERE, JOIN 절에 사용하는 컬럼에 설정)
CREATE UNIQUE INDEX EMP_NO_IDX ON EMPLOYEE_COPY(EMP_NO);

-- 3. 단일 인덱스(SINGLE)
-- 하나의 컬럼을 기반으로 인덱스를 생성
CREATE INDEX 인덱스명 ON 테이블명(컬럼명);

-- 4. 복합 인덱스(COMPOSITE)
-- 복수의 컬럼 값을 기반으로 인덱스를 생성(복합키와 같은 개념)
CREATE INDEX 인덱스명 ON 테이블명(컬럼명1, 컬럼명2...);

-- 5 함수 기반 인덱스(FUNCTION BASED)
-- 자주 사용하는 수식을 기반으로 인덱스를 생성
CREATE INDEX SAL_IDX ON EMPLOYEE_COPY((SALARY+SALARY*NVL(BONUS,0))*12);

SELECT *
FROM EMPLOYEE_COPY
WHERE (SALARY+SALARY*NVL(BONUS,0))*12>=30000000;


SELECT *
FROM USER_INDEXES;
















































