--DEFAULT : 컬럼의 기본 값 설정
--컬럼에 DEFAULT 설정
--NOT NULL과 마찬가지로 MODIFY
CREATE TABLE DEFAULT_TB(
    SALARY NUMBER DEFAULT 20,
    TEST_CHAR VARCHAR2(20) DEFAULT 'TEST'
);

SELECT *
FROM DEFAULT_TB;
INSERT INTO DEFAULT_TB(SALARY, TEST_CHAR)
                    VALUES (50, 'INPUT TEXT');
INSERT INTO DEFAULT_TB(SALARY, TEST_CHAR)
                    VALUES (DEFAULT, 'INPUT TEXT2');
INSERT INTO DEFAULT_TB(SALARY, TEST_CHAR)
                    VALUES (100, DEFAULT);
SELECT *
FROM DEFAULT_TB;

INSERT INTO DEFAULT_TB(SALARY)
                                         VALUES (200);


--DDL (CREATE, DROP, ALTER)
--ALTER : DB사용하는 객체 정보를 변경
--테이블 객체 수정 : 
--ALTER TABLE 테이블명 수정할내용
--컬럼 추가/삭제, 제약조건 추가/삭제
--컬럼 자료형 변경, DEFAULT/NOT NULL
--테이블명 변경, 컬럼명, 제약조건 이름 변경

--컬럼 추가
SELECT *
FROM DEPT_COPY;

--층(1층, 2층, 3층, 별관 2층)에 관련된 컬럼 추가
--코멘트 - '구역정보'
ALTER TABLE DEPT_COPY 
    ADD (LOCATION_NAME VARCHAR2(20));
SELECT *
FROM DEPT_COPY;
COMMENT ON COLUMN DEPT_COPY.LOCATION_NAME 
                                                                            IS '구역정보';

--컬럼 삭제
ALTER TABLE DEPT_COPY 
DROP COLUMN LOCATION_NAME;

SELECT *
FROM DEPT_COPY;

ALTER TABLE DEPT_COPY 
ADD (DEPT_ID VARCHAR2(20) DEFAULT '대한민국');

--DEPARTMENT 테이블의 복사 테이블을 생성(DEPT_COPY_CONS)
--층(FLOOR VARCHAR2(10))에 대한 컬럼 추가(기본값 1층)
--DEPT_ID - PRIMARY KEY 제약조건
--LOCATION_ID - FORIGN KEY 제약조건
CREATE TABLE DEPT_COPY_CONS AS
SELECT *
FROM DEPARTMENT;

ALTER TABLE DEPT_COPY_CONS 
ADD (FLOOR VARCHAR2(10) DEFAULT '1');
ALTER TABLE DEPT_COPY_CONS
ADD CONSTRAINT DCOPY_ID_PK PRIMARY KEY (DEPT_ID);
ALTER TABLE DEPT_COPY_CONS
ADD CONSTRAINT DCOPY_LID_FK FOREIGN KEY (LOCATION_ID)
REFERENCES LOCATION(LOCAL_CODE);

SELECT *
FROM DEPT_COPY_CONS;

--컬럼 길이(사이즈) 수정
--늘릴때 -> 특이사항 없음(제약조건이 없다)
--줄일때 -> 기존 값들 보다 큰 값으로만 변경이 가능하다
--EX)VARCHAR2(15) '여기', '위치1', '여긴어디지' -> VARCHAR2(9) '???'
CREATE TABLE DEPT_COPY2 AS
SELECT *
FROM DEPARTMENT;
--DEPT_ID	CHAR(2 BYTE)
--DEPT_TITLE	VARCHAR2(35 BYTE)
--LOCATION_ID	CHAR(2 BYTE)
ALTER TABLE DEPT_COPY2 
MODIFY DEPT_ID CHAR(3)
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_ID CHAR(3);

DESC DEPT_COPY2;

--기존 값보다 작은 사이즈로 줄어들경우
ALTER TABLE DEPT_COPY2
MODIFY DEPT_TITLE VARCHAR2(10);

--DEPT_COPY2 - LNAME (CHAR30) 컬럼 추가
--기본값 - '한국'
ALTER TABLE DEPT_COPY2 
ADD (LNAME CHAR(30) DEFAULT '한국');
SELECT *
FROM DEPT_COPY2;

INSERT INTO DEPT_COPY2 
VALUES('DA', '웹개발 부서', 'L3', DEFAULT);

--컬럼에 설정된 DEFAULT 값 변경
--DEPT_COPY2 - LNAME   '한국' -> '미국'
ALTER TABLE DEPT_COPY2
MODIFY LNAME VARCHAR2(30) DEFAULT '미국';
--CHAR -> VARCHAR2 변경 가능 함(변경 시 컬럼내 값 길이 조심)
INSERT INTO DEPT_COPY2(DEPT_ID, DEPT_TITLE, LOCATION_ID)
VALUES('DC', '해외개발 부서', 'L1');
SELECT *
FROM DEPT_COPY2;

--컬럼 삭제
ALTER TABLE DEPT_COPY2
DROP COLUMN LNAME;

SELECT *
FROM DEPT_COPY2;

--테이블의 컬럼 삭제 시 삭제 후 최소 1개 이상의 컬럼이 남아있어야 함
--(테이블내 모든 컬럼을 삭제 -> 테이블 DROP)
ALTER TABLE DEPT_COPY2
DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_ID; --에러 발생


--참조 하고있는 컬럼이 존재 할 경우(다른 테이블에서 부모키로 사용하고 있다)
--컬럼 삭제가 되지 않음
ALTER TABLE DEPARTMENT
DROP COLUMN DEPT_ID;
--DML -> 트랜젝션 처리가 가능합니다.(COMMIT, ROLLBACK 
--                                                                -> 복구, 되돌리기)
--DDL -> 트랜젝션 처리 불가(AUTO COMMIT)

--인스타 정보를 저장하는 TABLE 생성
--게시글 정보 테이블
--PICTURE_BOARD
--컬럼
--BOARD_ID - NUMBER
--WRITER - VARCHAR2(3)
--CONTENT - VARCHAR2(1500)
--WRITE_TIME - DATE (기본값 현재시간)
--F_COUNT - NUMBER
--IMAGE_PATH - VARCHAR(1000)
--REPLY - VARCHAR2(600)
--제약조건
--BOARD_ID -> PRIMARY KEY - BOARD_ID_PK
--WRITER -> EMPLOYEE(EMP_ID) 컬럼 참조 - BOARD_WRITER_FK
--F_COUNT -> CHECK 0 이상 - BOARD_COUNT_CK
--IMAGE_PATH -> NOT NULL

CREATE TABLE PICTURE_BOARD(
    BOARD_ID NUMBER,
    WRITER VARCHAR2(3),
    CONTENT VARCHAR2(1500),
    WRITE_TIME DATE DEFAULT SYSDATE,
    F_COUNT NUMBER,
    IMAGE_PATH VARCHAR(1000) NOT NULL,
    REPLY VARCHAR2(600),
    CONSTRAINT BOARD_ID_PK PRIMARY KEY (BOARD_ID),
    CONSTRAINT BOARD_WRITER_FK FOREIGN KEY (WRITER)
                                                    REFERENCES EMPLOYEE(EMP_ID),
    CONSTRAINT BOARD_COUNT_CK CHECK (F_COUNT >= 0)                                                
);

SELECT *
FROM USER_CONSTRAINTS
JOIN USER_CONS_COLUMNS USING (CONSTRAINT_NAME)
WHERE USER_CONSTRAINTS.TABLE_NAME = 'PICTURE_BOARD';

--제약조건 삭제
ALTER TABLE PICTURE_BOARD
DROP CONSTRAINT SYS_C007162;

--복수개의 제약조건 삭제
ALTER TABLE PICTURE_BOARD
DROP CONSTRAINT BOARD_COUNT_CK
DROP CONSTRAINT BOARD_ID_PK
DROP CONSTRAINT BOARD_WRITER_FK;

SELECT *
FROM USER_CONSTRAINTS
JOIN USER_CONS_COLUMNS USING (CONSTRAINT_NAME)
WHERE USER_CONSTRAINTS.TABLE_NAME = 'PICTURE_BOARD';


--데이터 딕셔너리(데이터 사전, 메타 데이터)
--데이터를 위한 데이터
--제약조건에 관련된 딕셔너리 - ALL_CONSTRAINTS
--제약조건을 컬럼별로 관리하는 딕셔너리 - USER_CONS_COLUMNS
--테이블 정보를 조회하는 딕셔너리 - USER_TABLES
--딕셔너리 종류
--USER_XXXX - 해당 접속 정보, 유저에 관련된 정보
--ALL_XXXX - 해당 유저가 가지고 있는, 접근 가능한 모든 정보에 관하여 출력
--DBA_XXXX - DB설정에 관한 모든 데이터를 접근 가능(DBA - SYSTEM계정)
--딕셔너리 정보 수정, 변경은 DDL 문을 실행 할때 해당 정보에 맞는 데이터가
--딕셔너리에 저장되는 형식
SELECT *
FROM USER_CONSTRAINTS;
SELECT *
FROM ALL_CONSTRAINTS;
SELECT *
FROM DBA_CONSTRAINTS;


--VIEW(뷰)
--SELECT 대한 결과를 저장하는 객체이다.(임시 테이블, 가상 테이블)
--실질적으로 데이터는 저장하지 않는다. 
            --> 원본 테이블의 데이터의 변경시 뷰의 데이터도 같이 변경
--기존의 테이블 사용과 동일
--CREATE OR REPLACE VIEW 뷰이름 AS 서브쿼리

--뷰 생성
--사원정보를 조회하는 뷰(EMP_V)
--사번, 이름, 주민번호, 부서코드, 부서명, 직급코드, 직급명, 급여
CREATE OR REPLACE VIEW EMP_V AS
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE
            ,E.JOB_CODE, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
--CONNECT, RESOURCE(CREATE VIEW 이미 포함되어 있음)
--GRANT CREATE VIEW TO STUDENT;

--전지연의 사원 정보를 뷰를 이용하여 조회
SELECT *
FROM EMP_V
WHERE EMP_NAME = '전지연';

SELECT *
FROM EMP_V
WHERE DEPT_TITLE = '인사관리부';

SELECT *
FROM USER_VIEWS;

--뷰를 사용하는 이유
--데이터 보안, 권한을 관리하기 위해서(한정된 정보를 제공)
--편리성 - 다른 테이블들을 JOIN해서 조회해야 되는 결과를 편리하게 제공
--상대적으로 조회 속도가 빠르다.

--EMPLOYEE_COPY테이블 복사
CREATE OR REPLACE VIEW EMP_COPY_V AS
SELECT *
FROM EMPLOYEE_COPY;

SELECT *
FROM EMP_COPY_V;

--EMP_COPY_V를 통해서 사번 220번 직원의 급여를 2000000으로 변경
UPDATE EMP_COPY_V
SET SALARY = 2000000
WHERE EMP_ID = '220';

INSERT INTO EMP_COPY_V
    VALUES ('800', '최범석', '990101-1000001', 'beomsuk@naver.com', 
                    '0101111111','D2', 'J5', 'S4', 2000000,
                    0.1, NULL, SYSDATE, NULL, 'N');
    
SELECT *
FROM EMPLOYEE_COPY;


UPDATE EMP_V
SET SALARY = 2000000;

SELECT *
FROM EMP_V;
--뷰에 조회되지 않는 컬럼 중 NOT NULL 혹은 PRIMARY KEY와 같은 제약조건에
--위배될 경우는 값을 추가할수 없다.
INSERT INTO EMP_V
VALUES ('800', '최범석', 'D1','인사관리부', 'J7', '사원', 2000000);

--뷰를 통해서 DML이 불가능 한경우
--1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
--2. 뷰 정의에 포함되지 않은 컬럼의 제약조건에 위배될 경우
--        (PRIMARY KEY, NOT NULL)
--3. 산술 표현식으로 컬럼이 정의 된 경우(연봉 (SALARY + SALARY * BONUS) * 12))
--4. JOIN을 이용해서 여러 테이블이 연결된 경우 -> 2번
--5. DISTINCT, GROUP BY를 통해서 연산 된 값

--1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW JOB_V AS
SELECT JOB_CODE
FROM JOB;

--J8 인턴
INSERT INTO JOB_V(JOB_CODE, JOB_NAME) VALUES ('J8', '인턴');

SELECT *
FROM JOB_V;

UPDATE JOB_V
SET JOB_NAME = '인턴';

--2. 뷰 정의에 포함되지 않은 컬럼의 제약조건에 위배될 경우
--        (PRIMARY KEY, NOT NULL)
CREATE OR REPLACE VIEW JOB_V AS
SELECT JOB_NAME
FROM JOB;
INSERT INTO JOB_V(JOB_NAME) VALUES ('인턴');

--3. 산술 표현식으로 컬럼이 정의 된 경우(연봉 (SALARY + SALARY * BONUS) * 12))
--사번, 사원명, 연봉 뷰를 제공하려 한다.
CREATE OR REPLACE VIEW EMP_SALARY_V AS
SELECT EMP_ID, EMP_NAME,
(SALARY + SALARY * NVL(BONUS, 0)) * 12 AS ANUUAL_SALARY
FROM EMPLOYEE;

SELECT *
FROM EMP_SALARY_V;

UPDATE EMP_SALARY_V
SET ANUUAL_SALARY = '40000000'
WHERE EMP_NAME = '노옹철';

--4. JOIN을 이용해서 여러 테이블이 연결된 경우 -> 2번
CREATE OR REPLACE VIEW EMP_V AS
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE
            ,E.JOB_CODE, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

UPDATE EMP_V
SET JOB_CODE = 'J9';
ROLLBACK;

--5. DISTINCT, GROUP BY를 통해서 연산 된 값
CREATE OR REPLACE VIEW EMP2_V AS
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

SELECT *
FROM EMP2_V;

UPDATE EMP2_V
SET DEPT_CODE = 'D1';

SELECT *
FROM USER_VIEWS;
--뷰 삭제
DROP VIEW EMP_SALARY_V;