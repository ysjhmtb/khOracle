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

























