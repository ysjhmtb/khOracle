--���ν���(PROCEDURE)
--PL/SQL���� �����ϴ� ��ü��
--�̸� ������ ���� PL/SQL�� �ʿ�� ȣ���Ͽ� ����ϴ� ���
--���� ���Ǵ� ����, �������� ������ �θ� ���ϰ� ����Ҽ� �ִ�

--ǥ���
CREATE OR REPLACE PROCEDURE ���ν��� ��
                 (�Ű�����1 [IN|OUT|INOUT] Ÿ��, �Ű�����2 [MODE] Ÿ��..) IS                    
    ������ Ÿ��;   --�������� ����
BEGIN
    ������ ����1;
    ������ ����2;
    �������� ����;
END;
/

--���ν��� ȣ��
EXECUTE ���ν�����(���ް�, ���ް�, ����....);

--���ν��� ����
DROP PROCEDURE ���ν�����;

--���� ���� ��ü ���� �ϴ� ���ν��� ����
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
    DBMS_OUTPUT.PUT_LINE('���� �Ϸ�');
END;
/

SELECT *
FROM USER_PROCEDURES;

EXECUTE DEL_EMP_ALL;

SELECT *
FROM EMP_DUP;


--�Ķ���Ͱ� �ִ� ���ν��� ����
--�ش� �ο��� ����� �Է� �޾�, ����� �ش��ϴ� ���� ������ ����
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
    DBMS_OUTPUT.PUT_LINE('���̵�� ���� �Ϸ�');
END;
/

EXEC DEL_EMP_ID('&���');
SELECT *
FROM EMP_DUP;

--IN : ���ν��� ������ �����͸� ���� �޴� �����̱� ������ ���� ���� �ص� ��
--OUT : �����͸� RETURN ������ ����ؾ� �ϱ� ������ �� ���� X
--���ε� ���� : ���� ������ ����ϴ� ����(��� ������ �����Ѵ�)
--          ���ε� ���� ǥ��� - VARIABLE ������ Ÿ�Ը�;

--����� �Է� �޾Ƽ�, �ش� ��� ������ ��ȯ(�����̸�, �޿�, �μ��ڵ�)
CREATE OR REPLACE PROCEDURE GET_EMP_INFO(
    IN_ID IN EMPLOYEE.EMP_ID%TYPE,
    OUT_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
    OUT_SALARY OUT EMPLOYEE.SALARY%TYPE,
    OUT_DEPT OUT EMPLOYEE.DEPT_CODE%TYPE)
IS
--    ��������
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
--PRINT ȣ�� �� ����� ���� ���� ���
--SET AUTOPRINT ON;

--�Լ� (FUNCTION)
--SUBSTR(�÷���, 1, 2); -> 1~2 ��° ����
--���ν����� ȣ���ϴ� ����� ���� ���� �մϴ�.
--���� RETURN ���� ���� �Ѵ�.

--ǥ���
--CREATE [OR REPLACE] FUNCTION �Լ��̸�(������ Ÿ��, ������ Ÿ��...) 
--RETURN �ڷ���/Ÿ�� IS
--BEGIN
--  ó����
--  RETURN ������;
--END;
--/
--���ν����� �ٸ���
--�Ű������� IN/OUT�� �������� �ʾƵ� �ȴ�.
--RETURN���� �����Ѵ�.

--����� �Է� �޾�����, �ش� ����� ������ ��ȯ�ϴ� �Լ� ����
CREATE OR REPLACE FUNCTION GET_ANNUAL_SAL
(IN_EMP_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER
IS
    R_SAL NUMBER;
BEGIN
    SELECT (SALARY + SALARY * NVL(BONUS,0)) * 12 AS "����"
    INTO R_SAL
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    RETURN R_SAL;   
END;
/

SELECT GET_ANNUAL_SAL('210')
FROM DUAL;

--1. ����� ���� �޾Ƽ�, �ش� ������� ���ʽ��� �����Ϸ��� �մϴ�.
--���ʽ� �ݾ��� �ش� ������ �޿��� 100%�� �����Ϸ��� �Ѵ�.
--�ش� ���ʽ� �ݾ��� ���� �޴� �Լ� �ۼ�(GET_BONUS)
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

--2. ���� �Լ��� �̿��Ͽ� ��ü ������ ������ ��ȸ�Ϸ� �Ѵ�.
--���, �̸�, �޿�, ����
--���� - �޿� * 12 + ���ʽ��ݾ� * 4;
SELECT EMP_ID, EMP_NAME, SALARY, 
            SALARY * 12 + GET_BONUS(EMP_ID) * 4 AS "����"
FROM EMPLOYEE;


--Ŀ��(CURSOR)
--SQL�� ���ؼ� ����� ���� ��, ���� ���� ������ �޸� ���� ��ġ
--> Ŀ���� ���� -> OPEN -> FETCH -> CLOSE

--Ŀ���� �Ӽ�
--%NOTFOUND : Ŀ���� �ڷᰡ ���� ���(FETCH��� �ؼ� ���� ������ �����Ͱ� ���� ���) - TRUE
--%FOUND : Ŀ���� FETCH�� �ڷᰡ ���� ��� TRUE
--%ISOPEN : �ش� Ŀ���� ����������� ��Ÿ���� �Ӽ�, OPEN�� ���¸� - TRUE
--%ROWCOUNT : ���� �ش� Ŀ���� ������ ROW�� COUNT�� ��ȯ

--ǥ���
--CURSOR Ŀ����[(�Ű�����1 Ÿ��, �Ű�����2 Ÿ��)] IS (DQL);

--OPEN Ŀ����[(�Ű�����1, �Ű�����2)];

--LOOP
--  FETCH Ŀ���� INTO ������1, ������2.....
--  EXIT WHEN Ŀ����%NOTFOUND;
--END LOOP

--CLOSE Ŀ����;

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
                
        DBMS_OUTPUT.PUT_LINE('�μ��ڵ� ' || DEPT_INFO.DEPT_ID 
                                                || ', �μ��� ' || DEPT_INFO.DEPT_TITLE
                                                || ', ��ġ ID ' || DEPT_INFO.LOCATION_ID);
    END LOOP;
    CLOSE DEPT_C;
    DBMS_OUTPUT.PUT_LINE('�μ� ���� ��� �Ϸ�');
END;
/

EXEC PRINT_DEPT;


--�ڹٿ��� ������ FOR���� ���� ( FOR(�Ѱ��� �׸�:��������){})
CREATE OR REPLACE PROCEDURE PRINT_DEPT2 
IS
    CURSOR DEPT_C IS SELECT * 
                                        FROM DEPARTMENT;
BEGIN
    FOR DEPT_INFO IN DEPT_C LOOP
        DBMS_OUTPUT.PUT_LINE('�μ��ڵ� ' || DEPT_INFO.DEPT_ID 
                                                || ', �μ��� ' || DEPT_INFO.DEPT_TITLE
                                                || ', ��ġ ID ' || DEPT_INFO.LOCATION_ID);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('�μ� ���� ��� �Ϸ�');
END;
/

EXEC PRINT_DEPT2;


--DEPARTMENT ���� ���̺��� : DEPT_DUP(������O),DEPT_DEL(������X) 
--���ν����� �ϳ� ������� �մϴ�.
--�μ���ȣ�� �Է¹޾�, �ش� �μ� ������ ������ ���, 
--�ش� �μ����� ���� �� ���� �� �����͸� DEPT_DEL ���̺� �߰��Ͻÿ�
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
--������ �������� ���� ���θ� Ȯ���ϱ� ���ؼ� IDX ������ ���
--�ش� IDX���� 0�� �ƴ϶�� ���� �� �� ����
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
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ ���� ���ν��� �Ϸ�');
END;
/

EXEC DEPT_DEL_P('D3');

SELECT *
FROM DEPT_DUP;
SELECT *
FROM DEPT_DEL;


--�μ���ȣ�� �Է� �޾�, �ش� �μ��� ���� ������ ����ϴ� ���ν��� ����
--PRINT_DEPT_EMP
--��� ���� - ���, �̸�, �μ���ȣ, ��å�ڵ�
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

--��Ű��(PACKAGE)
--���ν����� �Լ��� �����ϱ� ���� �ϱ� ���� ���� ��ü
--ǥ����
--CREATE OR REPLACE PACKAGE ��Ű���� 
--IS
--  FUNCTION �Լ���(�Ű����� Ÿ��, �Ű����� Ÿ��...) RETURN Ÿ��;
--  PROCEDURE ���ν�����[(�Ű����� Ÿ��, �Ű����� Ÿ��...)];
--END;
--/

--������ �ǽ��� �Լ��� ���ν����� ��Ű���� �߰��ϴ� ���
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
--    ��������
    BEGIN
        DELETE FROM EMP_DUP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('���� �Ϸ�');
    END;
    
    FUNCTION GET_ANNUAL_SAL(IN_EMP_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER
    IS
        R_SAL NUMBER;
    BEGIN
        SELECT (SALARY + SALARY * NVL(BONUS,0)) * 12 AS "����"
        INTO R_SAL
        FROM EMPLOYEE
        WHERE EMP_ID = IN_EMP_ID;
    
        RETURN R_SAL;   
    END;
END;
/

EXEC KH_PACK.DEL_EMP_ALL;

--��Ű�� ���, �ٵ�(EMP_INFO_PK)
--EMP_IN_DEPT : �μ��ڵ带 �Է��ؼ� �ش� �μ��� ���� ������ ��� �ϴ� ���ν���
--                         ���, �̸�, �μ��ڵ�
--DEPT_SAL_AVG : �μ��ڵ带 �Է��ؼ� �ش� �μ��� �޿� ����� ��ȯ�ϴ� �Լ� ����
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

























