<h1>DEV VS DBA</h1>



|           |      |
| :-------: | :--: |
| PROCEDURE | DEV  |
| FUNCTION  | DBA  |
|  TRIGGER  | DEV  |
| SEQUENCE  | DBA  |
|  SYNONYM  | DBA  |
|   VIEW    | DBA  |
|   TABLE   | DBA  |
|   USER    | DBA  |
|  PACKAGE  | DBA  |
|   ROLE    | DBA  |
|  CURSOR   | DEV  |
|   INDEX   | DBA  |

<br>

<hr>

<h2>PROCEDURE AND CURSOR</h2>

```plsql
--프로시져(PROCEDURE)
--PL/SQL문을 저장하는 객체다
--미리 저장해 놓은 PL/SQL을 필요시 호출하여 사용하는 기능
--자주 사용되는 문법, 로직들을 저장해 두면 편리하게 사용할수 있다

--표기법
CREATE OR REPLACE PROCEDURE 프로시져 명
                 (매개변수1 [IN|OUT|INOUT] 타입, 매개변수2 [MODE] 타입..) IS                    
    변수명 타입;   --지역변수 선언
BEGIN
    실행할 문장1;
    실행할 문장2;
    여러가지 로직;
END;
/

--프로시저 호출
EXECUTE 프로시져명(전달값, 전달값, 변수....);

--프로시저 삭제
DROP PROCEDURE 프로시저명;

--직원 정보 전체 삭제 하는 프로시저 생성
CREATE TABLE EMP_DUP AS
SELECT *
FROM EMPLOYEE;

SELECT *
FROM EMP_DUP;

SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE DEL_EMP_ALL IS
BEGIN
    DELETE FROM EMP_DUP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('삭제 완료');
END;
/

SELECT *
FROM USER_PROCEDURES;

EXECUTE DEL_EMP_ALL;

SELECT *
FROM EMP_DUP;


--파라미터가 있는 프로시저 생성
--해당 인원의 사번을 입력 받아, 사번에 해당하는 직원 정보만 삭제
DROP TABLE EMP_DUP;
CREATE TABLE EMP_DUP AS
SELECT *
FROM EMPLOYEE;

CREATE OR REPLACE PROCEDURE DEL_EMP_ID 
                                    (IN_EMP_ID IN EMP_DUP.EMP_ID%TYPE) IS
BEGIN
    DELETE FROM EMP_DUP
    WHERE EMP_ID = IN_EMP_ID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('아이디로 삭제 완료');
END;
/

EXEC DEL_EMP_ID('&사번');
SELECT *
FROM EMP_DUP;

--IN : 프로시져 내에서 데이터를 전달 받는 변수이기 때문에 값만 전송 해도 됨
--OUT : 데이터를 RETURN 받을때 사용해야 하기 때문에 값 전송 X
--바인드 변수 : 값을 받을때 사용하는 변수(디비에 변수를 선언한다)
--          바인드 변수 표기법 - VARIABLE 변수명 타입명;

--사번을 입력 받아서, 해당 사원 정보를 반환(직원이름, 급여, 부서코드)
CREATE OR REPLACE PROCEDURE GET_EMP_INFO(
    IN_ID IN EMPLOYEE.EMP_ID%TYPE,
    OUT_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
    OUT_SALARY OUT EMPLOYEE.SALARY%TYPE,
    OUT_DEPT OUT EMPLOYEE.DEPT_CODE%TYPE)
IS
--    지역변수
BEGIN
    SELECT EMP_NAME, SALARY, DEPT_CODE
    INTO OUT_NAME, OUT_SALARY, OUT_DEPT
    FROM EMPLOYEE
    WHERE EMP_ID = IN_ID;
END;
/

VARIABLE VAR_EMP_NAME VARCHAR2(20);
VARIABLE VAR_SALARY NUMBER;
VARIABLE VAR_DEPT_CODE CHAR(2);

EXEC GET_EMP_INFO('200', :VAR_EMP_NAME, :VAR_SALARY, :VAR_DEPT_CODE);

PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_DEPT_CODE;
--PRINT 호출 시 출력이 되지 않을 경우
--SET AUTOPRINT ON;

--함수 (FUNCTION)
--SUBSTR(컬럼명, 1, 2); -> 1~2 번째 글자
--프로시저와 호출하는 방식이 거의 동일 합니다.
--단지 RETURN 값이 존재 한다.

--표기법
--CREATE [OR REPLACE] FUNCTION 함수이름(변수명 타입, 변수명 타입...) 
--RETURN 자료형/타입 IS
--BEGIN
--  처리식
--  RETURN 데이터;
--END;
--/
--프로시저와 다른점
--매개변수의 IN/OUT을 구분하지 않아도 된다.
--RETURN문이 존재한다.

--사번을 입력 받았을때, 해당 사번의 연봉을 반환하는 함수 선언
CREATE OR REPLACE FUNCTION GET_ANNUAL_SAL
(IN_EMP_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER
IS
    R_SAL NUMBER;
BEGIN
    SELECT (SALARY + SALARY * NVL(BONUS,0)) * 12 AS "연봉"
    INTO R_SAL
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    RETURN R_SAL;   
END;
/

SELECT GET_ANNUAL_SAL('210')
FROM DUAL;

--1. 사번을 전달 받아서, 해당 사원에게 보너스를 지급하려고 합니다.
--보너스 금액은 해당 직원의 급여의 100%를 지급하려고 한다.
--해당 보너스 금액을 리턴 받는 함수 작성(GET_BONUS)
CREATE OR REPLACE FUNCTION GET_BONUS
(IN_EMP_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER IS
    R_BONUS NUMBER;
BEGIN
    SELECT SALARY
    INTO R_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;
    
    RETURN R_BONUS;
END;
/

SELECT EMP_ID, SALARY, GET_BONUS(EMP_ID)
FROM EMPLOYEE;

--2. 위의 함수를 이용하여 전체 직원의 연봉을 조회하려 한다.
--사번, 이름, 급여, 연봉
--연봉 - 급여 * 12 + 보너스금액 * 4;
SELECT EMP_ID, EMP_NAME, SALARY, 
            SALARY * 12 + GET_BONUS(EMP_ID) * 4 AS "연봉"
FROM EMPLOYEE;


--커서(CURSOR)
--SQL을 통해서 얻어진 여러 행, 여러 열로 구성된 메모리 상의 위치
--> 커서를 선언 -> OPEN -> FETCH -> CLOSE

--커서의 속성
--%NOTFOUND : 커서에 자료가 없을 경우(FETCH계속 해서 다음 인출할 데이터가 없는 경우) - TRUE
--%FOUND : 커서에 FETCH할 자료가 있을 경우 TRUE
--%ISOPEN : 해당 커서가 사용중인지를 나타내는 속성, OPEN된 상태면 - TRUE
--%ROWCOUNT : 현재 해당 커서가 인출한 ROW의 COUNT를 반환

--표기법
--CURSOR 커서명[(매개변수1 타입, 매개변수2 타입)] IS (DQL);

--OPEN 커서명[(매개변수1, 매개변수2)];

--LOOP
--  FETCH 커서명 INTO 변수명1, 변수명2.....
--  EXIT WHEN 커서명%NOTFOUND;
--END LOOP

--CLOSE 커서명;

CREATE OR REPLACE PROCEDURE PRINT_DEPT 
IS
    CURSOR DEPT_C IS SELECT * 
                                        FROM DEPARTMENT;
    DEPT_INFO DEPARTMENT%ROWTYPE;
BEGIN
    OPEN DEPT_C;
    LOOP
        FETCH DEPT_C INTO DEPT_INFO.DEPT_ID,
                                          DEPT_INFO.DEPT_TITLE,
                                          DEPT_INFO.LOCATION_ID;
        
        EXIT WHEN DEPT_C%NOTFOUND;
                
        DBMS_OUTPUT.PUT_LINE('부서코드 ' || DEPT_INFO.DEPT_ID 
                                                || ', 부서명 ' || DEPT_INFO.DEPT_TITLE
                                                || ', 위치 ID ' || DEPT_INFO.LOCATION_ID);
    END LOOP;
    CLOSE DEPT_C;
    DBMS_OUTPUT.PUT_LINE('부서 정보 출력 완료');
END;
/

EXEC PRINT_DEPT;


--자바에서 개선된 FOR문과 같다 ( FOR(한개의 항목:묶음변수){})
CREATE OR REPLACE PROCEDURE PRINT_DEPT2 
IS
    CURSOR DEPT_C IS SELECT * 
                                        FROM DEPARTMENT;
BEGIN
    FOR DEPT_INFO IN DEPT_C LOOP
        DBMS_OUTPUT.PUT_LINE('부서코드 ' || DEPT_INFO.DEPT_ID 
                                                || ', 부서명 ' || DEPT_INFO.DEPT_TITLE
                                                || ', 위치 ID ' || DEPT_INFO.LOCATION_ID);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('부서 정보 출력 완료');
END;
/

EXEC PRINT_DEPT2;


--DEPARTMENT 복사 테이블을 : DEPT_DUP(데이터O),DEPT_DEL(데이터X) 
--프로시저를 하나 만드려고 합니다.
--부서번호를 입력받아, 해당 부서 정보가 존재할 경우, 
--해당 부서정보 삭제 후 삭제 한 데이터를 DEPT_DEL 테이블에 추가하시오
CREATE TABLE DEPT_DUP AS
SELECT * 
FROM DEPARTMENT;
CREATE TABLE DEPT_DEL AS
SELECT *
FROM DEPARTMENT
WHERE 1 = 0;

CREATE OR REPLACE PROCEDURE DEPT_DEL_P(IN_DEPT_ID DEPT_DUP.DEPT_ID%TYPE)
IS
    CURSOR DEL_ROW IS (SELECT * FROM DEPT_DUP WHERE DEPT_ID = IN_DEPT_ID);
    IDX NUMBER := 0;
BEGIN
--삭제할 데이터의 존재 여부를 확인하기 위해서 IDX 변수를 사용
--해당 IDX값이 0이 아니라면 삭제 할 행 있음
    FOR K IN DEL_ROW LOOP
        IDX := IDX + 1;
    END LOOP;
    
    IF IDX != 0 THEN
        FOR DEPT IN DEL_ROW LOOP
            INSERT INTO DEPT_DEL 
            VALUES (DEPT.DEPT_ID, DEPT.DEPT_TITLE, DEPT.LOCATION_ID);
            
            DELETE FROM DEPT_DUP
            WHERE DEPT_ID = DEPT.DEPT_ID;
        END LOOP;
        COMMIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('부서번호 삭제 프로시저 완료');
END;
/

EXEC DEPT_DEL_P('D3');

SELECT *
FROM DEPT_DUP;
SELECT *
FROM DEPT_DEL;


--부서번호를 입력 받아, 해당 부서의 직원 정보를 출력하는 프로시저 생성
--PRINT_DEPT_EMP
--출력 정보 - 사번, 이름, 부서번호, 직책코드
CREATE OR REPLACE PROCEDURE PRINT_DEPT_EMP(IN_DEPT_CD IN EMPLOYEE.DEPT_CODE%TYPE) 
IS
    CURSOR EMP_C IS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
                                    FROM EMPLOYEE
                                    WHERE DEPT_CODE = IN_DEPT_CD;
BEGIN
    FOR EMP IN EMP_C LOOP
        DBMS_OUTPUT.PUT_LINE(EMP.EMP_ID || ', ' 
                                        || EMP.EMP_NAME || ', ' 
                                        || EMP.DEPT_CODE || ', ' 
                                        || EMP.JOB_CODE);
    END LOOP;
END;
/

EXEC PRINT_DEPT_EMP('D2');

--패키지(PACKAGE)
--프로시저와 함수를 관리하기 쉽게 하기 위한 묶음 객체
--표현식
--CREATE OR REPLACE PACKAGE 패키지명 
--IS
--  FUNCTION 함수명(매개변수 타입, 매개변수 타입...) RETURN 타입;
--  PROCEDURE 프로시져명[(매개변수 타입, 매개변수 타입...)];
--END;
--/

--기존에 실습한 함수와 프로시져를 패키지에 추가하는 방법
--DEL_EMP_ALL
--DEL_EMP_ID (IN_EMP_ID IN EMP_DUP.EMP_ID%TYPE)
--GET_ANNUAL_SAL (IN_EMP_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER
CREATE OR REPLACE PACKAGE KH_PACK 
IS
    PROCEDURE DEL_EMP_ALL;
    FUNCTION GET_ANNUAL_SAL(IN_EMP_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY KH_PACK
IS
    PROCEDURE DEL_EMP_ALL IS
--    지역변수
    BEGIN
        DELETE FROM EMP_DUP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('삭제 완료');
    END;
    
    FUNCTION GET_ANNUAL_SAL(IN_EMP_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER
    IS
        R_SAL NUMBER;
    BEGIN
        SELECT (SALARY + SALARY * NVL(BONUS,0)) * 12 AS "연봉"
        INTO R_SAL
        FROM EMPLOYEE
        WHERE EMP_ID = IN_EMP_ID;
    
        RETURN R_SAL;   
    END;
END;
/

EXEC KH_PACK.DEL_EMP_ALL;

--패키지 헤더, 바디(EMP_INFO_PK)
--EMP_IN_DEPT : 부서코드를 입력해서 해당 부서의 직원 정보를 출력 하는 프로시저
--                         사번, 이름, 부서코드
--DEPT_SAL_AVG : 부서코드를 입력해서 해당 부서의 급여 평균을 반환하는 함수 생성
--EMPLOYEE
CREATE OR REPLACE PACKAGE EMP_INFO_PK
IS
    PROCEDURE EMP_IN_DEPT(IN_DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE);
    FUNCTION DEPT_SAL_AVG(IN_DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE) RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY EMP_INFO_PK
IS
    
    PROCEDURE EMP_IN_DEPT(IN_DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE)
    IS
    CURSOR EMP_C IS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
                                    FROM EMPLOYEE
                                    WHERE DEPT_CODE = IN_DEPT_CODE;
    BEGIN
        FOR EMP IN EMP_C LOOP
            DBMS_OUTPUT.PUT_LINE(EMP.EMP_ID || ', ' 
                                            || EMP.EMP_NAME || ', ' 
                                            || EMP.DEPT_CODE);
        END LOOP;
    END;
    
    FUNCTION DEPT_SAL_AVG(IN_DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE) RETURN NUMBER
    IS
        R_NUM NUMBER;
    BEGIN
        SELECT TRUNC(AVG(SALARY))
        INTO R_NUM
        FROM EMPLOYEE
        WHERE DEPT_CODE = IN_DEPT_CODE;
        
        RETURN R_NUM;
    END;
END;
/
    
EXEC EMP_INFO_PK.EMP_IN_DEPT('D2'); 

SELECT EMP_INFO_PK.DEPT_SAL_AVG('D2')
FROM DUAL;

```



<br>

<hr>

<h2>TRIGGER</h2>

```plsql
--트리거(TRIGGER)
--데이터 베이스가 미리 정해놓은 조건의 동작이 수행되면 
--                                                              자동적으로 수행되는 행동을 말함
--트리거는 테이블의 데이터가 INSERT, UPDATE, DELETE 등의 DML이 수행될때를
--감지 하여 실행 됨(자바 - LISTENER)
--제품 (제품번호, 제품이름, 제품군, 제조사, 재고)
--주문 (주문번호, 제품번호, 수량)  --> 주문이 추가 될때 해당 제품의 재고를 - 시키는 TRIGGER

--트리거의 실행 시점
--해당 이벤트(DML)가 실행되기전(BEFORE), 실행 후(AFTER) 

--트리거의 이벤트 
--DML이 실행되는 순간

--트리거의 BEGIN에 작성 되는 내용
--해당 DML시 처리되어야 하는 로직(현재 테이블과는 다른 테이블, 다른 업무)

--트리거의 유형
--FOR EACH ROW(O)(행 레벨 트리거)
--      : 변경이 일어난 모든 행에 대해서 트리거를 실행함
--FOR EACH ROW(X)(문장 레벨 트리거)
--      : 변경한 시점에 한번만 트리거가 실행 된다.
--EX) 직원 테이블에서 'D5' 인원들의 급여 2000000원으로 변경하고 
--      해당 인원들의 사번과 연봉을 연봉테이블에 추가한다.

--표현식
CREATE OR REPLACE TRIGGER 트리거명 
BEFORE|AFTER   INSERT|UPDATE|DELETE ON 테이블명
[FOR EACH ROW]
BEGIN
    업무 로직
END;
/

--EX)문장 레벨 트리거 - 신입사원이 등록 될 경우 '신입사원이 입사하였습니다.' 라는 
--    메세지 출력 트리거 생성
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER ENT_EMP
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사하였습니다.');
END;
/

INSERT INTO EMPLOYEE
    VALUES ('950', '홍길동', '501111-1234555', 'KDHONG@NAVER.COM',
                    '010-123-3333', 'D3', 'J2', 'S2', 150000,
                    0.1, NULL, SYSDATE, NULL, 'N');
ROLLBACK;
DELETE FROM EMPLOYEE
WHERE EMP_ID = '950';
COMMIT;

ALTER TRIGGER ENT_EMP COMPILE;

--바인드 변수 2가지 
--FOR EACH ROW경우만 사용 가능 함
--:NEW : 새로 추가/변경 된 데이터
--:OLD : 기존 데이터

--부서명 변경시 기존이름과, 새로운이름을 출력하는 트리거를 작성하시오
--부서 복사 테이블 : DEPT_C
CREATE TABLE DEPT_C AS
SELECT *
FROM DEPARTMENT;

CREATE OR REPLACE TRIGGER DEPT_NAME_TRG
AFTER UPDATE ON DEPT_C
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(:OLD.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE(:NEW.DEPT_TITLE);
END;
/

UPDATE DEPT_C
SET DEPT_TITLE = '자바개발팀'
WHERE DEPT_ID = 'D4';
COMMIT;


--어제 실습 DEPT_DUP, DEPT_DEL
--DEPT_DUP 행 삭제 시 DEPT_DEL 테이블에 
--INSERT 시키는 트리거를 작성하여라
--트리거 작성 후 DEPT_DUP행 삭제 시 DEPT_DEL 테이블에 행 추가 됨 확인

CREATE OR REPLACE TRIGGER DEPT_DEL_TRG
AFTER DELETE ON DEPT_DUP
FOR EACH ROW
BEGIN
    INSERT INTO DEPT_DEL VALUES
               (:OLD.DEPT_ID, :OLD.DEPT_TITLE, :OLD.LOCATION_ID);
END;
/

SELECT *
FROM DEPT_DUP;

DELETE FROM DEPT_DUP
WHERE DEPT_ID = 'DA';
COMMIT;

SELECT *
FROM DEPT_DEL;


--제품이 입고 될때마다 상품재고 테이블의 수치를 일일히 바꾸기 번거롭다는 요구사항
--그래서 트리거를 사용하여, 제품 입출고 시 재고의 수량을 자동으로 변경 하려 함

--제품 정보 테이블(PRODUCT)
--PID - NUMBER PRIMARY KEY
--PNAME - VARCHAR2(100)
--BRAND - VARCHAR2(100)
--PRICE - NUMBER
--STOCK - NUMBER DEFAULT 0
CREATE TABLE PRODUCT(
    PID NUMBER PRIMARY KEY,
    PNAME VARCHAR2(100),
    BRAND VARCHAR2(100),
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 0
);

--제품 입출고 테이블(PRODUCT_INOUT)
--INOUT_ID - NUMBER PRIMARY KEY
--PID - NUMBER
--INOUT_DATE - DATE
--COUNT - NUMBER
--INOUT - VARCHAR2(6)  ('입고', '출고')
CREATE TABLE PRODUCT_INOUT(
    INOUT_ID NUMBER PRIMARY KEY,
    PID NUMBER,
    INOUT_DATE DATE,
    COUNT NUMBER,
    INOUT VARCHAR2(6)
);

--SEQUENCE 생성
--PID_SEQ : 제품번호 SEQ
CREATE SEQUENCE PID_SEQ
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

--INOUT_SEQ : 입출고 SEQ
CREATE SEQUENCE INOUT_SEQ
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

INSERT INTO PRODUCT VALUES (PID_SEQ.NEXTVAL,'아이폰8', '애플', 1000000, DEFAULT);
INSERT INTO PRODUCT VALUES (PID_SEQ.NEXTVAL,'갤럭시9', '삼성', 1200000, DEFAULT);
INSERT INTO PRODUCT VALUES (PID_SEQ.NEXTVAL,'샤오미폰', '샤오미', 700000, DEFAULT);
COMMIT;

SELECT * FROM PRODUCT;

CREATE OR REPLACE TRIGGER PRODUCT_INOUT_TRG
    AFTER INSERT ON PRODUCT_INOUT
    FOR EACH ROW
BEGIN
    IF :NEW.INOUT = '입고' THEN
        UPDATE PRODUCT
        SET STOCK = STOCK + :NEW.COUNT
        WHERE PID = :NEW.PID;
    ELSE
        UPDATE PRODUCT
        SET STOCK = STOCK - :NEW.COUNT
        WHERE PID = :NEW.PID;
    END IF;
END;
/

INSERT INTO PRODUCT_INOUT
        VALUES(INOUT_SEQ.NEXTVAL, 1, SYSDATE, 5, '입고');
INSERT INTO PRODUCT_INOUT
        VALUES(INOUT_SEQ.NEXTVAL, 1, SYSDATE, 3, '출고');

SELECT *
FROM PRODUCT;


--분석함수
--오라클 분석함수는 데이터를 분석 하는 함수
--분석함수를 사용하면, 쿼리 실행 결과(RESULT SET)을 대상으로
--전체 그룹이 아닌, 소그룹으로 다시 나눠서 각 그룹에 대한 계산을 리턴한다.

--일반 그룹함수들과 다른 점은 분석함수는 분석함수용 그룹을 별도로 지정해서 계산한다.
--이러한 분석함수용 그룹을 WINDOW  --> WINDOW 함수다

--사용형식 : 분석함수명 (전달인자1, 전달인자2, 전달인자3) OVER (쿼리의 PARTITION 절,
--                                                                                         ORDER BY 절,
--                                                                                         WINDOW 절);
--PARTITION 절 : PARTITION BY 표현식
--                         표현식에 따라서 그룹이 나뉜다.-> RESULT SET으로 구성 된다.
--ORDER BY 절 : 값을 RETURN 할때 정렬 기준 명시 하는 절 -> ORDER BY 
--WINDOW 절 : 분석함수의 대상의 그룹을 행기준으로 범위를 축소시켜서 결과를 리턴 한다.
--                      PARTITION 절에서 나뉜 그룹을 다시한번 소그룹으로 나누는 역할

--RANK : 등수를 매기는 그룹함수, 같은 등수가 존재할 경우 다음 등수를 건너 뛴다.
--최고급여가 1등 -> 내림차순
SELECT EMP_ID, EMP_NAME, SALARY, 
              RANK() OVER (ORDER BY SALARY DESC) "급여순위"
FROM EMPLOYEE;

--DENSE_RANK : 등수를 매기는 그룹함수, 같은 등수가 존재해도 다음 등수를 출력한다.
SELECT EMP_ID, EMP_NAME, SALARY, 
              DENSE_RANK() OVER (ORDER BY SALARY DESC) "RANK"
FROM EMPLOYEE;

--DENSE_RANK를 이용한 급여 순위가 16~20의 인원을 조회하여 출력하여라
--사번, 이름, 급여, 급여순위
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, SALARY, 
                          DENSE_RANK() OVER (ORDER BY SALARY DESC) "RANK"
            FROM EMPLOYEE)
WHERE RANK BETWEEN 16 AND 20;

--350만원의 RANK를 이용한 급여순위가 몇등인지를 조회하는 방법
SELECT RANK(2000000) WITHIN GROUP (ORDER BY SALARY DESC)
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY, 
              RANK() OVER (ORDER BY SALARY DESC) "급여순위"
FROM EMPLOYEE;

--CUME_DIST
--PARTITION 으로 나누어진 그룹별로 각 행을 ORDER BY 기준으로 정렬 후 
--해당 그룹의 분산을 RETURN 한다.(누적 분산)
SELECT EMP_ID, EMP_NAME, SALARY,
                CUME_DIST() OVER (ORDER BY SALARY)
FROM EMPLOYEE;

--PERCENT_RANK
--나누어진 그룹 별로 정렬 하여  해당 그룹의 백분위를 반환한다.
SELECT EMP_ID, EMP_NAME, SALARY,
            ROUND(PERCENT_RANK() OVER (ORDER BY SALARY), 2) * 100
FROM EMPLOYEE;

--NTILE
--나뉘어진 그룹을 N개의 그룹으로 다시한번 나눈다.
SELECT EMP_NAME, SALARY,
              NTILE(5) OVER (ORDER BY SALARY DESC) "급여등급"
FROM EMPLOYEE;


--ROW_NUMBER
--그룹별로 ORDER BY 된 행의 순위를 반환
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE,
         ROW_NUMBER() OVER (PARTITION BY DEPT_CODE
                                                ORDER BY HIRE_DATE ASC) "부서 내 입사순위"
FROM EMPLOYEE;



```



<br>

<hr>



