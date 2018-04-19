--동의어(SYNONYM)
--다른 데이터 베이스에서 가진 객체에 대한 별칭을 설정하는 것
-- --> 객체(테이블) 별칭을 설정 하는 것
--여러 사용자가 테이블에 접근, 공유 목적으로 사용

--표현식
--CREATE SYNONYM 동의어명(줄임말, 별칭) FOR 사용자명.테이블명

--DEPARTMENT 테이블을 DEPT 라는 별칭으로 동의어를 설정하시오
CREATE SYNONYM DEPT FOR STUDENT.DEPARTMENT;

--(관리자 계정)
GRANT CREATE SYNONYM TO STUDENT;

SELECT *
FROM DEPARTMENT;
SELECT *
FROM DEPT;

SELECT *
FROM USER_SYNONYMS;

--1.비공개 동의어
--객체에 대해 접근 가능한 권한을 받은 인원들만 조회 가능한 동의어
--객체의 OWNER가 주로 관리 한다.
--2.공개 동의어
--모든 사용자가 접근가능한 동의어
--DBA 권한을 갖은 사용자가 만든다 --> DUAL
SELECT 1 + 5 - 2
FROM DUAL;
SELECT *
FROM ALL_SYNONYMS
WHERE SYNONYM_NAME = 'DUAL';

--(관리자 계정 접속)
CREATE PUBLIC SYNONYM DEPT2 FOR STUDENT.DEPARTMENT;
SELECT *
FROM DEPT2;

--동의어 삭제
DROP PUBLIC SYNONYM DEPT;

--(STUDENT 계정 접속)
SELECT *
FROM DEPARTMENT;
SELECT * 
FROM DEPT2;

--(SCOTT 계정)
SELECT * FROM DEPT2; --권한이 불충분함 -> 권한 부여 후 조회 가능

--(관리자 계정)
--SCOTT계정에게 DEPARTMENT 테이블의 조회 권한 부여
GRANT SELECT ON STUDENT.DEPARTMENT TO SCOTT;


--PL/SQL(PROCEDURAL LANGUAGE / SQL)
--오라클에서 제공하는 절차적 언어다. 
--> SQL 문장 내에 변수를 정의, 조건처리, 반복처리 -> 로직 구현이 가능

--무명 블럭(실시간 실행), 
--PROCEDURE
--로직이 저장되어 있다
--복수개의 값이 반환 가능하다(0개의 값이 반환 될수도 있다)
--FUNCTION
--로직이 저장되어 있다
--무조건 1개의 값이 반환 된다.(RETURN 이 존재 한다)

--표기법
--DECLARE 
--    [선언부]
--BEGIN
--    [실행부]
--EXCEPTION
--    [예외 처리부]
--END;
--/ (PL/SQL 의 종료 / 해당 PL/SQL 등록)

--간단한 PL/SQL
--'HELLO WORLD' 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/

--출력에 대한 설정이 필요합니다. 
--> 프로시저의 실행 결과를 화면에 출력할수 있도록 설정
SET SERVEROUTPUT ON;


--변수의 선언과 초기화, 변수값 출력
DECLARE
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(20);
BEGIN
    EMP_ID := 800;
    EMP_NAME := '최범석';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/

--레퍼런스 변수의 선언과 초기화, 변수값 출력
DECLARE
    EMP_ID1 EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME1 EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EMP_ID1, EMP_NAME1
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID1);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME1);
END;
/

--레퍼런스 변수로 EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE,
--SALARY 선언
--EMPLOYEE 테이블에서 해당 정보들을 조회하여 변수들에 값을 저장하여 
--출력하는 PL/SQL 작성
--단, 이름으로 입력 받아 일치하는 직원의 정보를 출력 한다.
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY 
    INTO EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY 
    FROM EMPLOYEE
    WHERE EMP_NAME = '&EMP_NAME';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('JOB_CODE : ' || JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || SALARY);
END;
/

--%ROWTYPE : 테이블의 한행의 모든 컬럼과 자료형을 참조
DECLARE
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('EMP_NO : ' || EMP.EMP_NO);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || EMP.SALARY);
END;
/

--직원명으로 검색 하여 해당 직원의 연봉을 구하는 PL/SQL
--변수 : EMPLOYEE ROW를 참조 변수, 연봉 변수
--사번, 이름, 급여, 연봉액(매달 보너스 금액 포함)
--연봉 출력 시 지역화폐단위(원표시 \)와 , 를 같이 출력
DECLARE
    EMP_R EMPLOYEE%ROWTYPE;
    ANNUAL_SALARY NUMBER;
BEGIN
    SELECT *
    INTO EMP_R
    FROM EMPLOYEE
    WHERE EMP_NAME = '&EMP_NAME';
    
    ANNUAL_SALARY := (EMP_R.SALARY + 
                                EMP_R.SALARY * NVL(EMP_R.BONUS, 0)) * 12;
                                
    DBMS_OUTPUT.PUT_LINE(EMP_R.EMP_ID || '    ' || 
                                            EMP_R.EMP_NAME || '    ' || 
                                            EMP_R.SALARY  || '    ' || 
                            TO_CHAR(ANNUAL_SALARY, 'L999,999,999,999'));
END;
/

--NVL 이용하지 않고, IF 사용하여 출력
--IF 조건식 THEN 참일 경우 처리식 ELSE 거짓일 경우 처리식 END IF
DECLARE
    EMP_R EMPLOYEE%ROWTYPE;
    ANNUAL_SALARY NUMBER;
BEGIN
    SELECT *
    INTO EMP_R
    FROM EMPLOYEE
    WHERE EMP_NAME = '&EMP_NAME';
    
    IF (EMP_R.BONUS IS NULL) THEN
        ANNUAL_SALARY := EMP_R.SALARY * 12;
    ELSE
        ANNUAL_SALARY := (EMP_R.SALARY + 
                                EMP_R.SALARY * EMP_R.BONUS) * 12;
    END IF;                                
                                
    DBMS_OUTPUT.PUT_LINE(EMP_R.EMP_ID || '    ' || 
                                            EMP_R.EMP_NAME || '    ' || 
                                            EMP_R.SALARY  || '    ' || 
                            TO_CHAR(ANNUAL_SALARY, 'L999,999,999,999'));
END;
/

--점수를 입력받아, 해당 점수가 90 점 이상일 경우 A, 80점 이상일 경우 B
--70점 이상일경우 C, 70점 미만일경우 D
--점수를 저장하는 변수, 학점을 저장하는 변수
--'당신의 점수는 93 이고, 학점은 A 학점 입니다.'
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := &점수;
    
    IF 90 <= SCORE THEN
        GRADE := 'A';
    ELSIF 80 <= SCORE THEN
        GRADE := 'B';
    ELSIF 70 <= SCORE THEN
        GRADE := 'C';
    ELSE
        GRADE := 'D';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE 
                        || '점 이고, 학점은 ' || GRADE || '입니다');
END;
/

--CASE 변수 WHEN 조건값1 THEN 결과값1
--                WHEN 조건값2 THEN 결과값 2 END
--사번으로 직원 정보를 검색하여 해당 직원의 사번, 이름, 부서번호, 부서명 출력
--변수는 사번, 이름, 부서번호, 부서명 
--JOIN을 사용하지 않고 CASE 문을 이용하여 해당 부서명을 설정
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    DEPT_NAME VARCHAR2(21);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE
    INTO EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DEPT_NAME := CASE DEPT_CODE 
                                WHEN 'D1' THEN '인사관리부'
                                WHEN 'D2' THEN '회계관리부'
                                WHEN 'D3' THEN '마케팅부'
                                WHEN 'D4' THEN '국내영업부'
                                WHEN 'D5' THEN '해외영업1부'
                            END;
    
    DBMS_OUTPUT.PUT_LINE(EMP_ID || '      ' ||
                                             EMP_NAME || '      ' ||
                                             DEPT_CODE  || '      ' ||
                                             DEPT_NAME);
END;
/

--반복문 
--FOR [루프변수 IN 시작값..종료값] LOOP
--        반복문 실행
--END LOOP
CREATE TABLE NUMBER_TB(
    NUM1 NUMBER,
    NUM10 NUMBER,
    NUM100 NUMBER
);

BEGIN
    FOR IDX IN 1..10 LOOP
        INSERT INTO NUMBER_TB VALUES (IDX, IDX*10, IDX*100);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('값 입력 완료');
END;
/

SELECT *
FROM NUMBER_TB;

--EXIT을 이용하여 반복문 종료
DECLARE
    IDX NUMBER := 1;
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE(IDX);
        IDX := IDX + 1;
        IF 5 < IDX THEN
            EXIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('LOOP 종료');
END;
/

--반복문을 이용하여 구구단 출력(짝수단 만 출력)
--RESULT 변수
DECLARE 
    RNUM NUMBER;
BEGIN
    FOR DAN IN 2..9 LOOP
        IF MOD(DAN, 2) = 0 THEN
            FOR NUM IN 1..9 LOOP
                RNUM := DAN * NUM;
                DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || NUM || ' = ' || RNUM);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
        END IF;
    END LOOP;

END;
/


--RECORD타입 변수 선언
--표현식
--TYPE 레코드_타입명 IS RECORD(
--        변수명 타입,
--        변수명 타입,
--        변수명 타입
--);
--변수명 선언한레코드타입명;

--사번을 입력하여 직원 정보 검색 후
--사번, 이름, 부서명, 직책 - 레코드를 이용하여 해당 값들 출력
DECLARE
    TYPE EMP_TYPE IS RECORD(
        EMP_ID EMPLOYEE.EMP_ID%TYPE,
        EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
        DEPT_NAME DEPARTMENT.DEPT_TITLE%TYPE,
        JOB_NAME JOB.JOB_NAME%TYPE
    );
    EMP_R EMP_TYPE;
BEGIN
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME
    INTO EMP_R
    FROM EMPLOYEE E
    LEFT OUTER JOIN DEPARTMENT D 
                                                ON (E.DEPT_CODE = D.DEPT_ID) 
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
    WHERE E.EMP_ID = '&사번';
                                                
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_R.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_R.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || EMP_R.DEPT_NAME);
    DBMS_OUTPUT.PUT_LINE('직책명 : ' || EMP_R.JOB_NAME);
END;
/
    
--테이블 타입 연습(배열)
DECLARE
    TYPE EMP_ID_T IS TABLE OF EMPLOYEE.EMP_ID%TYPE
    INDEX BY BINARY_INTEGER;
    TYPE EMP_NAME_T IS TABLE OF EMPLOYEE.EMP_NAME%TYPE
    INDEX BY BINARY_INTEGER;
    
    EMP_ID_TABLE EMP_ID_T;
    EMP_NAME_TABLE EMP_NAME_T;
    
    IDX BINARY_INTEGER := 0;
BEGIN
    FOR K IN (SELECT EMP_ID, EMP_NAME
                        FROM EMPLOYEE) LOOP
        IDX := IDX + 1;
        EMP_ID_TABLE(IDX) := K.EMP_ID;
        EMP_NAME_TABLE(IDX) := K.EMP_NAME;
    END LOOP;                        
    
    FOR I IN 1..IDX LOOP
        DBMS_OUTPUT.PUT_LINE(I || '  ' ||
                                                EMP_ID_TABLE(I) || '  ' || 
                                                EMP_NAME_TABLE(I));
    END LOOP;
END;
/

--예외처리
UPDATE EMPLOYEE
SET EMP_ID = '201'
WHERE EMP_NAME = '최범석';

BEGIN 
    UPDATE EMPLOYEE
    SET EMP_ID = '201'
    WHERE EMP_NAME = '최범석';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/

--기존에 정의되지 않은 예외처리가 필요할때
DECLARE
    DUP_EMPNO EXCEPTION;
    PRAGMA EXCEPTION_INIT(DUP_EMPNO, -00001);
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '201'
    WHERE EMP_NAME = '최범석';
EXCEPTION
    WHEN DUP_EMPNO THEN
    DBMS_OUTPUT.PUT_LINE('이미 존재 함.');
END;
/

--PROCEDURE, FUNCTION, TRIGGER
--PACKAGE, CURSOR







































                                























    
    
    
    
    
    
    
    
    















