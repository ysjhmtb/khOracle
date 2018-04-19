--���Ǿ�(SYNONYM)
--�ٸ� ������ ���̽����� ���� ��ü�� ���� ��Ī�� �����ϴ� ��
-- --> ��ü(���̺�) ��Ī�� ���� �ϴ� ��
--���� ����ڰ� ���̺� ����, ���� �������� ���

--ǥ����
--CREATE SYNONYM ���Ǿ��(���Ӹ�, ��Ī) FOR ����ڸ�.���̺��

--DEPARTMENT ���̺��� DEPT ��� ��Ī���� ���Ǿ �����Ͻÿ�
CREATE SYNONYM DEPT FOR STUDENT.DEPARTMENT;

--(������ ����)
GRANT CREATE SYNONYM TO STUDENT;

SELECT *
FROM DEPARTMENT;
SELECT *
FROM DEPT;

SELECT *
FROM USER_SYNONYMS;

--1.����� ���Ǿ�
--��ü�� ���� ���� ������ ������ ���� �ο��鸸 ��ȸ ������ ���Ǿ�
--��ü�� OWNER�� �ַ� ���� �Ѵ�.
--2.���� ���Ǿ�
--��� ����ڰ� ���ٰ����� ���Ǿ�
--DBA ������ ���� ����ڰ� ����� --> DUAL
SELECT 1 + 5 - 2
FROM DUAL;
SELECT *
FROM ALL_SYNONYMS
WHERE SYNONYM_NAME = 'DUAL';

--(������ ���� ����)
CREATE PUBLIC SYNONYM DEPT2 FOR STUDENT.DEPARTMENT;
SELECT *
FROM DEPT2;

--���Ǿ� ����
DROP PUBLIC SYNONYM DEPT;

--(STUDENT ���� ����)
SELECT *
FROM DEPARTMENT;
SELECT * 
FROM DEPT2;

--(SCOTT ����)
SELECT * FROM DEPT2; --������ ������� -> ���� �ο� �� ��ȸ ����

--(������ ����)
--SCOTT�������� DEPARTMENT ���̺��� ��ȸ ���� �ο�
GRANT SELECT ON STUDENT.DEPARTMENT TO SCOTT;


--PL/SQL(PROCEDURAL LANGUAGE / SQL)
--����Ŭ���� �����ϴ� ������ ����. 
--> SQL ���� ���� ������ ����, ����ó��, �ݺ�ó�� -> ���� ������ ����

--���� ��(�ǽð� ����), 
--PROCEDURE
--������ ����Ǿ� �ִ�
--�������� ���� ��ȯ �����ϴ�(0���� ���� ��ȯ �ɼ��� �ִ�)
--FUNCTION
--������ ����Ǿ� �ִ�
--������ 1���� ���� ��ȯ �ȴ�.(RETURN �� ���� �Ѵ�)

--ǥ���
--DECLARE 
--    [�����]
--BEGIN
--    [�����]
--EXCEPTION
--    [���� ó����]
--END;
--/ (PL/SQL �� ���� / �ش� PL/SQL ���)

--������ PL/SQL
--'HELLO WORLD' ���
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/

--��¿� ���� ������ �ʿ��մϴ�. 
--> ���ν����� ���� ����� ȭ�鿡 ����Ҽ� �ֵ��� ����
SET SERVEROUTPUT ON;


--������ ����� �ʱ�ȭ, ������ ���
DECLARE
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(20);
BEGIN
    EMP_ID := 800;
    EMP_NAME := '�ֹ���';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/

--���۷��� ������ ����� �ʱ�ȭ, ������ ���
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

--���۷��� ������ EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE,
--SALARY ����
--EMPLOYEE ���̺��� �ش� �������� ��ȸ�Ͽ� �����鿡 ���� �����Ͽ� 
--����ϴ� PL/SQL �ۼ�
--��, �̸����� �Է� �޾� ��ġ�ϴ� ������ ������ ��� �Ѵ�.
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

--%ROWTYPE : ���̺��� ������ ��� �÷��� �ڷ����� ����
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

--���������� �˻� �Ͽ� �ش� ������ ������ ���ϴ� PL/SQL
--���� : EMPLOYEE ROW�� ���� ����, ���� ����
--���, �̸�, �޿�, ������(�Ŵ� ���ʽ� �ݾ� ����)
--���� ��� �� ����ȭ�����(��ǥ�� \)�� , �� ���� ���
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

--NVL �̿����� �ʰ�, IF ����Ͽ� ���
--IF ���ǽ� THEN ���� ��� ó���� ELSE ������ ��� ó���� END IF
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

--������ �Է¹޾�, �ش� ������ 90 �� �̻��� ��� A, 80�� �̻��� ��� B
--70�� �̻��ϰ�� C, 70�� �̸��ϰ�� D
--������ �����ϴ� ����, ������ �����ϴ� ����
--'����� ������ 93 �̰�, ������ A ���� �Դϴ�.'
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := &����;
    
    IF 90 <= SCORE THEN
        GRADE := 'A';
    ELSIF 80 <= SCORE THEN
        GRADE := 'B';
    ELSIF 70 <= SCORE THEN
        GRADE := 'C';
    ELSE
        GRADE := 'D';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('����� ������ ' || SCORE 
                        || '�� �̰�, ������ ' || GRADE || '�Դϴ�');
END;
/

--CASE ���� WHEN ���ǰ�1 THEN �����1
--                WHEN ���ǰ�2 THEN ����� 2 END
--������� ���� ������ �˻��Ͽ� �ش� ������ ���, �̸�, �μ���ȣ, �μ��� ���
--������ ���, �̸�, �μ���ȣ, �μ��� 
--JOIN�� ������� �ʰ� CASE ���� �̿��Ͽ� �ش� �μ����� ����
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    DEPT_NAME VARCHAR2(21);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE
    INTO EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_ID = '&���';
    
    DEPT_NAME := CASE DEPT_CODE 
                                WHEN 'D1' THEN '�λ������'
                                WHEN 'D2' THEN 'ȸ�������'
                                WHEN 'D3' THEN '�����ú�'
                                WHEN 'D4' THEN '����������'
                                WHEN 'D5' THEN '�ؿܿ���1��'
                            END;
    
    DBMS_OUTPUT.PUT_LINE(EMP_ID || '      ' ||
                                             EMP_NAME || '      ' ||
                                             DEPT_CODE  || '      ' ||
                                             DEPT_NAME);
END;
/

--�ݺ��� 
--FOR [�������� IN ���۰�..���ᰪ] LOOP
--        �ݺ��� ����
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
    DBMS_OUTPUT.PUT_LINE('�� �Է� �Ϸ�');
END;
/

SELECT *
FROM NUMBER_TB;

--EXIT�� �̿��Ͽ� �ݺ��� ����
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
    DBMS_OUTPUT.PUT_LINE('LOOP ����');
END;
/

--�ݺ����� �̿��Ͽ� ������ ���(¦���� �� ���)
--RESULT ����
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


--RECORDŸ�� ���� ����
--ǥ����
--TYPE ���ڵ�_Ÿ�Ը� IS RECORD(
--        ������ Ÿ��,
--        ������ Ÿ��,
--        ������ Ÿ��
--);
--������ �����ѷ��ڵ�Ÿ�Ը�;

--����� �Է��Ͽ� ���� ���� �˻� ��
--���, �̸�, �μ���, ��å - ���ڵ带 �̿��Ͽ� �ش� ���� ���
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
    WHERE E.EMP_ID = '&���';
                                                
    DBMS_OUTPUT.PUT_LINE('��� : ' || EMP_R.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || EMP_R.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�μ��� : ' || EMP_R.DEPT_NAME);
    DBMS_OUTPUT.PUT_LINE('��å�� : ' || EMP_R.JOB_NAME);
END;
/
    
--���̺� Ÿ�� ����(�迭)
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

--����ó��
UPDATE EMPLOYEE
SET EMP_ID = '201'
WHERE EMP_NAME = '�ֹ���';

BEGIN 
    UPDATE EMPLOYEE
    SET EMP_ID = '201'
    WHERE EMP_NAME = '�ֹ���';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('�̹� �����ϴ� ����Դϴ�.');
END;
/

--������ ���ǵ��� ���� ����ó���� �ʿ��Ҷ�
DECLARE
    DUP_EMPNO EXCEPTION;
    PRAGMA EXCEPTION_INIT(DUP_EMPNO, -00001);
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '201'
    WHERE EMP_NAME = '�ֹ���';
EXCEPTION
    WHEN DUP_EMPNO THEN
    DBMS_OUTPUT.PUT_LINE('�̹� ���� ��.');
END;
/

--PROCEDURE, FUNCTION, TRIGGER
--PACKAGE, CURSOR







































                                























    
    
    
    
    
    
    
    
    















