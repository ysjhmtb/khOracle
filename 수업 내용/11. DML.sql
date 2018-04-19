--DML(DATA MANIPULATION LANGUAGE - 데이터 조작어)
--INSERT(추가),UPDATE(수정), DELETE(삭제), SELECT(DQL)
--INSERT : 새로운 데이터를 추가하는 것 -> 행이 늘어남
--INSERT INTO 테이블명(컬럼1, 컬럼2, 컬럼3.....)
--          VALUES(컬럼1값, 컬럼2값, 컬럼3값.....);
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, 
    EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL,
    SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE,
    ENT_YN)
VALUES (900, '최범석', '990101-1234567',
    'beomsuk@NAVER.COM', '0101112222', 'D4', 'J7', 'S4',
    5000000, 0.2, NULL, SYSDATE, NULL,
    'N');
COMMIT;
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME = '최범석';
--전체 컬럼 값 추가시 (컬럼명 생략이 가능하다)
INSERT INTO EMPLOYEE
VALUES (900, '최범석', '990101-1234567',
    'beomsuk@NAVER.COM', '0101112222', 'D4', 'J7', 'S4',
    5000000, 0.2, NULL, SYSDATE, NULL,
    'N');
--몇개의 컬럼 값만 추가시 (컬럼명 생략이 불가능하다) 
--> 추가할 컬럼명을 따로 기술
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO)
    VALUES ('사번', '이름', '주민번호');
    
--서브쿼리를 이용해서 INSERT문 작성 방법
--사번, 이름, 부서명을 저장하는 테이블을 생성
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(35)
);
SELECT *
FROM EMP_01;

INSERT INTO EMP_01 (
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE
    FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
);

SELECT *
FROM EMP_01;
COMMIT;

ROLLBACK;


--INSERT ALL : 복수개의 테이블에 동시에 값을 넣을 때 사용
--단, 같은 검색 조건일 경우만 사용가능 합니다.
--(같은 서브쿼리를 이용하기 때문에)

--테이블 2개 생성 후 각각의 테이블에 'D1' 사원 정보 추가
--EMP_DEPT_01 : 사번, 이름, 부서번호, 채용일
--EMP_SAL_01 : 사번, 이름, 급여
CREATE TABLE EMP_DEPT_01 AS
(SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE 1 = 0);

CREATE TABLE EMP_SAL_01 AS
(SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE 1 = 0);

SELECT *
FROM EMP_DEPT_01;

--각각의 테이블에 서브쿼리를 이용하여 D1부서를 추가하는 쿼리 작성
INSERT INTO EMP_DEPT_01 (
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'
);

INSERT INTO EMP_SAL_01 (
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'
);
SELECT *
FROM EMP_DEPT_01;
SELECT *
FROM EMP_SAL_01;

DELETE FROM EMP_DEPT_01;
DELETE FROM EMP_SAL_01;

INSERT ALL
INTO EMP_DEPT_01 
            VALUES (EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_SAL_01
            VALUES (EMP_ID, EMP_NAME, SALARY)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

SELECT *
FROM EMP_DEPT_01;
SELECT *
FROM EMP_SAL_01;

--만약 복수의 테이블에 다른 기준으로 테이블의 데이터가 구성되어 있는 경우
--2000/01/01 이전 입사한 사람들은 EMP_OLD
--2000/01/01 이후(포함) 입사한 사람들은 EMP_NEW
--두 테이블의 컬럼은 (사번, 이름, 입사일, 급여)
CREATE TABLE EMP_OLD AS (
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1 = 0
);
CREATE TABLE EMP_NEW AS (
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1 = 0
);

INSERT ALL
    WHEN HIRE_DATE < TO_DATE('2000/01/01','YYYY/MM/DD') THEN 
    INTO EMP_OLD VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    WHEN HIRE_DATE >= TO_DATE('2000/01/01','YYYY/MM/DD') THEN
    INTO EMP_NEW VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;
    
SELECT *
FROM EMP_OLD;
SELECT *
FROM EMP_NEW;

--테이블 2개 생성 생일 80년대 이전 사람들, 이후 사람들 2개의 테이블
--EMP_SENIOR, EMP_JUNIOR 
--사번, 이름, 주민등록번호
CREATE TABLE EMP_SENIOR AS (
    SELECT EMP_ID, EMP_NAME, EMP_NO
    FROM EMPLOYEE
    WHERE 1 = 0
);
CREATE TABLE EMP_JUNIOR AS (
    SELECT EMP_ID, EMP_NAME, EMP_NO
    FROM EMPLOYEE
    WHERE 1 = 0
);
INSERT ALL
    WHEN TO_NUMBER(SUBSTR(EMP_NO, 1, 1)) < 8 THEN 
    INTO EMP_SENIOR VALUES (EMP_ID, EMP_NAME, EMP_NO)
    WHEN TO_NUMBER(SUBSTR(EMP_NO, 1, 1)) >= 8 THEN 
    INTO EMP_JUNIOR VALUES (EMP_ID, EMP_NAME, EMP_NO)
    SELECT EMP_ID, EMP_NAME, EMP_NO
    FROM EMPLOYEE;
SELECT *
FROM EMP_SENIOR;    
SELECT *
FROM EMP_JUNIOR;

--4가지 -> 주 사용은 1,2 번
--1. 컬럼명을 쓰지 않고 테이블의 모든 컬럼 값을 넣을 경우
--2. 몇개의 컬럼만 값을 넣을 경우
--3. 복수개의 테이블에 값을 넣을 경우 (검색 조건이 같을때)
--4. 복수개의 테이블에 값을 넣을 경우 (각각의 검색 조건이 다를때)


--UPDATE : 테이블에 있는 값을 수정하는 구문이다
--                테이블의 행의 갯수에 영향이 없다.(컬럼값만 변한다.)
--UPDATE 테이블명 SET 컬럼명 = 변경값 , 컬럼명2 = 변경값2 WHERE 조건식
--DEPT_COPY : 부서 테이블을 그대로 복사
CREATE TABLE DEPT_COPY AS (
SELECT *
FROM DEPARTMENT
);

SELECT *
FROM DEPT_COPY;

--D9 부서의 부서명이 '총무부' -> '전략기획팀' 변경
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';
SELECT *
FROM DEPT_COPY;

--UPDATE 문에서도 SUBQUERY 사용 가능 합니다.
--값처럼 이용하는 SCALAR SUBQUERY, 다중행, 다중열 -> SET, WHERE

--하동운의 급여를 유재식의 급여값으로 변경 하려고 합니다.
UPDATE EMPLOYEE E
SET E.SALARY = (SELECT E1.SALARY
                             FROM EMPLOYEE E1
                             WHERE E1.EMP_NAME = '유재식')
WHERE E.EMP_NAME = '하동운';

SELECT *
FROM EMPLOYEE;

--무한도전 팀 전체 인원의 급여를 유재식의 급여로 변경
--노옹철, 정중하, 전형돈, 방명수, 하동운
UPDATE EMPLOYEE E
SET E.SALARY = (SELECT E1.SALARY
                             FROM EMPLOYEE E1
                             WHERE E1.EMP_NAME = '유재식')
WHERE E.EMP_NAME IN ('노옹철', '정중하', '전형돈', '방명수', '하동운');                      
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME IN ('노옹철', '정중하', '전형돈', '방명수', '하동운');
ROLLBACK;

--조건, 대상은 위와 동일합니다.
--유재식의 급여로 변경 + 보너스 변경
UPDATE EMPLOYEE E
SET E.SALARY = (SELECT E1.SALARY
                             FROM EMPLOYEE E1
                             WHERE E1.EMP_NAME = '유재식'),
        E.BONUS = (SELECT E1.BONUS
                             FROM EMPLOYEE E1
                             WHERE E1.EMP_NAME = '유재식')
WHERE E.EMP_NAME IN ('노옹철', '정중하', '전형돈', '방명수', '하동운');
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME IN ('노옹철', '정중하', '전형돈', '방명수', '하동운');
ROLLBACK;

--복수 열을 동시에 바꾸는 방법(다중열 서브쿼리 이용)
UPDATE EMPLOYEE E
SET (E.SALARY, E.BONUS) = (SELECT E2.SALARY, E2.BONUS
                                                FROM EMPLOYEE E2
                                                WHERE E2.EMP_NAME = '유재식')
WHERE E.EMP_NAME IN ('노옹철', '정중하', '전형돈', '방명수', '하동운');                                                
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME IN ('노옹철', '정중하', '전형돈', '방명수', '하동운');
ROLLBACK;

--EMPLOYEE_COPY 테이블
--아시아 지역에서 일하는 직원들의 보너스를 0.5로 변경
UPDATE EMPLOYEE_COPY E1
SET E1.BONUS = 0.5
WHERE E1.EMP_ID IN (SELECT E.EMP_ID
                                    FROM LOCATION L
                                    JOIN DEPARTMENT D ON (L.LOCAL_CODE = D.LOCATION_ID)
                                    RIGHT JOIN EMPLOYEE_COPY E ON (D.DEPT_ID = E.DEPT_CODE)
                                    WHERE L.LOCAL_NAME LIKE 'ASIA%');
SELECT *
FROM EMPLOYEE_COPY;

--EMPLOYEE 테이블의 D6부서의 부서코드 -> 65 
--외래키 제약조건 확인
UPDATE EMPLOYEE
SET DEPT_CODE = '65'
WHERE DEPT_CODE = 'D6';

--프라이머리키 제약조건 확인
--NOT NULL
UPDATE EMPLOYEE
SET EMP_ID = NULL
WHERE EMP_NAME = '유재식';
--UNIQUE 
UPDATE EMPLOYEE
SET EMP_ID = 220
WHERE EMP_NAME = '유재식';

ROLLBACK;

--DELETE : 테이블의 행을 삭제 하는 구문 -> 행의 갯수가 줄어든다.
--DELETE FROM 테이블명 WHERE 조건절; 
--> 서브쿼리도 이용이 가능

--EMPLOYEE 테이블의 '최범석' 데이터를 삭제
DELETE FROM EMPLOYEE 
WHERE EMP_NAME = '최범석';
SELECT *
FROM EMPLOYEE;
ROLLBACK;

DELETE FROM EMPLOYEE;
SELECT *
FROM EMPLOYEE;
ROLLBACK;

--EMPLOYEE테이블의 D1부서의 인원정보를 삭제 하시오
DELETE FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

SELECT *
FROM EMPLOYEE;

ROLLBACK;

--부서 테이블에서 D1부서를 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

ROLLBACK;
--SYS_C007102
--SYS_C007116
--제약조건을 비활성화 후 삭제를 하려고 함
ALTER TABLE EMPLOYEE_COPY DISABLE CONSTRAINT SYS_C007102;
ALTER TABLE EMPLOYEE DISABLE CONSTRAINT SYS_C007116;

SELECT *
FROM USER_CONSTRAINTS
WHERE CONSTRAINT_NAME = 'SYS_C007116';

--삭제 후 제약조건을 활성화 함
ALTER TABLE EMPLOYEE_COPY ENABLE CONSTRAINT SYS_C007102;
ALTER TABLE EMPLOYEE ENABLE CONSTRAINT SYS_C007116;

--D1	인사관리부	L1
INSERT INTO DEPARTMENT
    VALUES ('D1', '인사관리부', 'L1');


--MERGE : 구조가 비슷한 두 테이블의 정보를 합친다.
--      조건식 -> 있으면, 해당 값을 업데이트
--                -> 없으면, 해당 값을 추가

--EMPLOYEE 복사 테이블 2개 생성
--EMP_02, EMP_03 -> 'J3'
CREATE TABLE EMP_02 AS(
SELECT *
FROM EMPLOYEE
);
CREATE TABLE EMP_03 AS(
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE = 'J3'
);

--EMP_03 테이블엔 본인의 정보를 추가한다.
INSERT INTO EMP_03
    VALUES (555, '최범석', '991111-1234567', 
    'beomsuk@naver.com', '01012345678','D2', 'J2', 'S4',
    4000000, 0.1, NULL, SYSDATE, NULL, 'N');
SELECT *
FROM EMP_02;
SELECT *
FROM EMP_03;

UPDATE EMP_03
SET SALARY = 0;

MERGE INTO EMP_02 E 
USING EMP_03 E1 ON (E.EMP_ID = E1.EMP_ID)
WHEN MATCHED THEN 
    UPDATE  SET E.SALARY = E1.SALARY
WHEN NOT MATCHED THEN
    INSERT VALUES (E1.EMP_ID, E1.EMP_NAME, E1.EMP_NO, E1.EMAIL, E1.PHONE, E1.DEPT_CODE, E1.JOB_CODE, E1.SAL_LEVEL, E1.SALARY, E1.BONUS, E1.MANAGER_ID, E1.HIRE_DATE, E1.ENT_DATE, E1.ENT_YN);

SELECT *
FROM EMP_02;


--트랜젝션 -> COMMIT, ROLLBACK, SAVEPOINT, ROLLBACK 이름;
--트랜젝션 -> 업무의 최소단위를 뜻한다. 
---> 같이 처리 되어야 되는 일들의 묶음
--은행ATM -> 원준씨한테 이체 50만원
--1. 은행 가야 된다.
--2. 카드를 넣는다.
--3. 비밀번호를 입력한다.
--4. 계좌번호를 입력한다.
--5. 금액을 입력한다.
--6. 이체 한다.
--  6-2 원준씨 통장에 금액 +50
--  6-1 제 통장에서 금액이 -50
--7. 송금이 완료되었습니다.

--COMMIT : 트랜젝션이 정상 종료 되었을 경우 영구히 저장, 반영
--ROLLBACK : 트랜젝션 비정상 종료 되었을 경우 원래의 상태로 되돌린다.
--SAVEPOINT : 트랜젝션을 세분화 하여 업무를 나눈다. 
--                      -> 트랜젝션 중간 저장 지점을 생성한다.
--ROLLBACK 세이브포인트명 : 해당 세이브포인트 상태로 되돌린다.

--유저정보 테이블 생성
--테이블명 : USER_TB
--컬럼 : 
--    ID VARCHAR2(20) PRIMARY KEY
--    PWD VARCHAR2(30)
--    NAME VARCHAR2(15) NOT NULL
CREATE TABLE USER_TB(
    ID VARCHAR2(20) PRIMARY KEY,
    PWD VARCHAR2(30),
    NAME VARCHAR2(15) NOT NULL
);

INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('재준', 'JJID', 'JJPWD');
INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('영곤', 'YKID', 'YKPWD');    
INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('경호', 'KHID', 'KHPWD');   
ROLLBACK;
COMMIT;

SELECT *
FROM USER_TB;

INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('윤석', 'YSID', 'YSPWD');   
SAVEPOINT ADD_ST_1;

INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('인선', 'ISID', 'ISPWD');   

SAVEPOINT ADD_ST_2;
--다른 업무
SAVEPOINT ADD_ST_3;
--다른 업무

ROLLBACK; --> 윤석, 인선씨 데이터가 전부 취소 됨
ROLLBACK TO ADD_ST_1; --> 윤석씨 데이터만 남음
SELECT *
FROM USER_TB;
COMMIT;

--TRUNCATE : 데이터 완전 삭제 -> 메모리를 아예 바꾼다.
SELECT *
FROM USER_TB;

DELETE FROM USER_TB;--> DML -> ROLLBACK 가능

TRUNCATE TABLE USER_TB;
ROLLBACK;

























































































    


