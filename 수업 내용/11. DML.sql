--DML(DATA MANIPULATION LANGUAGE - ������ ���۾�)
--INSERT(�߰�),UPDATE(����), DELETE(����), SELECT(DQL)
--INSERT : ���ο� �����͸� �߰��ϴ� �� -> ���� �þ
--INSERT INTO ���̺��(�÷�1, �÷�2, �÷�3.....)
--          VALUES(�÷�1��, �÷�2��, �÷�3��.....);
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, 
    EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL,
    SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE,
    ENT_YN)
VALUES (900, '�ֹ���', '990101-1234567',
    'beomsuk@NAVER.COM', '0101112222', 'D4', 'J7', 'S4',
    5000000, 0.2, NULL, SYSDATE, NULL,
    'N');
COMMIT;
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME = '�ֹ���';
--��ü �÷� �� �߰��� (�÷��� ������ �����ϴ�)
INSERT INTO EMPLOYEE
VALUES (900, '�ֹ���', '990101-1234567',
    'beomsuk@NAVER.COM', '0101112222', 'D4', 'J7', 'S4',
    5000000, 0.2, NULL, SYSDATE, NULL,
    'N');
--��� �÷� ���� �߰��� (�÷��� ������ �Ұ����ϴ�) 
--> �߰��� �÷����� ���� ���
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO)
    VALUES ('���', '�̸�', '�ֹι�ȣ');
    
--���������� �̿��ؼ� INSERT�� �ۼ� ���
--���, �̸�, �μ����� �����ϴ� ���̺��� ����
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


--INSERT ALL : �������� ���̺� ���ÿ� ���� ���� �� ���
--��, ���� �˻� ������ ��츸 ��밡�� �մϴ�.
--(���� ���������� �̿��ϱ� ������)

--���̺� 2�� ���� �� ������ ���̺� 'D1' ��� ���� �߰�
--EMP_DEPT_01 : ���, �̸�, �μ���ȣ, ä����
--EMP_SAL_01 : ���, �̸�, �޿�
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

--������ ���̺� ���������� �̿��Ͽ� D1�μ��� �߰��ϴ� ���� �ۼ�
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

--���� ������ ���̺� �ٸ� �������� ���̺��� �����Ͱ� �����Ǿ� �ִ� ���
--2000/01/01 ���� �Ի��� ������� EMP_OLD
--2000/01/01 ����(����) �Ի��� ������� EMP_NEW
--�� ���̺��� �÷��� (���, �̸�, �Ի���, �޿�)
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

--���̺� 2�� ���� ���� 80��� ���� �����, ���� ����� 2���� ���̺�
--EMP_SENIOR, EMP_JUNIOR 
--���, �̸�, �ֹε�Ϲ�ȣ
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

--4���� -> �� ����� 1,2 ��
--1. �÷����� ���� �ʰ� ���̺��� ��� �÷� ���� ���� ���
--2. ��� �÷��� ���� ���� ���
--3. �������� ���̺� ���� ���� ��� (�˻� ������ ������)
--4. �������� ���̺� ���� ���� ��� (������ �˻� ������ �ٸ���)


--UPDATE : ���̺� �ִ� ���� �����ϴ� �����̴�
--                ���̺��� ���� ������ ������ ����.(�÷����� ���Ѵ�.)
--UPDATE ���̺�� SET �÷��� = ���氪 , �÷���2 = ���氪2 WHERE ���ǽ�
--DEPT_COPY : �μ� ���̺��� �״�� ����
CREATE TABLE DEPT_COPY AS (
SELECT *
FROM DEPARTMENT
);

SELECT *
FROM DEPT_COPY;

--D9 �μ��� �μ����� '�ѹ���' -> '������ȹ��' ����
UPDATE DEPT_COPY
SET DEPT_TITLE = '������ȹ��'
WHERE DEPT_ID = 'D9';
SELECT *
FROM DEPT_COPY;

--UPDATE �������� SUBQUERY ��� ���� �մϴ�.
--��ó�� �̿��ϴ� SCALAR SUBQUERY, ������, ���߿� -> SET, WHERE

--�ϵ����� �޿��� ������� �޿������� ���� �Ϸ��� �մϴ�.
UPDATE EMPLOYEE E
SET E.SALARY = (SELECT E1.SALARY
                             FROM EMPLOYEE E1
                             WHERE E1.EMP_NAME = '�����')
WHERE E.EMP_NAME = '�ϵ���';

SELECT *
FROM EMPLOYEE;

--���ѵ��� �� ��ü �ο��� �޿��� ������� �޿��� ����
--���ö, ������, ������, ����, �ϵ���
UPDATE EMPLOYEE E
SET E.SALARY = (SELECT E1.SALARY
                             FROM EMPLOYEE E1
                             WHERE E1.EMP_NAME = '�����')
WHERE E.EMP_NAME IN ('���ö', '������', '������', '����', '�ϵ���');                      
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME IN ('���ö', '������', '������', '����', '�ϵ���');
ROLLBACK;

--����, ����� ���� �����մϴ�.
--������� �޿��� ���� + ���ʽ� ����
UPDATE EMPLOYEE E
SET E.SALARY = (SELECT E1.SALARY
                             FROM EMPLOYEE E1
                             WHERE E1.EMP_NAME = '�����'),
        E.BONUS = (SELECT E1.BONUS
                             FROM EMPLOYEE E1
                             WHERE E1.EMP_NAME = '�����')
WHERE E.EMP_NAME IN ('���ö', '������', '������', '����', '�ϵ���');
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME IN ('���ö', '������', '������', '����', '�ϵ���');
ROLLBACK;

--���� ���� ���ÿ� �ٲٴ� ���(���߿� �������� �̿�)
UPDATE EMPLOYEE E
SET (E.SALARY, E.BONUS) = (SELECT E2.SALARY, E2.BONUS
                                                FROM EMPLOYEE E2
                                                WHERE E2.EMP_NAME = '�����')
WHERE E.EMP_NAME IN ('���ö', '������', '������', '����', '�ϵ���');                                                
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME IN ('���ö', '������', '������', '����', '�ϵ���');
ROLLBACK;

--EMPLOYEE_COPY ���̺�
--�ƽþ� �������� ���ϴ� �������� ���ʽ��� 0.5�� ����
UPDATE EMPLOYEE_COPY E1
SET E1.BONUS = 0.5
WHERE E1.EMP_ID IN (SELECT E.EMP_ID
                                    FROM LOCATION L
                                    JOIN DEPARTMENT D ON (L.LOCAL_CODE = D.LOCATION_ID)
                                    RIGHT JOIN EMPLOYEE_COPY E ON (D.DEPT_ID = E.DEPT_CODE)
                                    WHERE L.LOCAL_NAME LIKE 'ASIA%');
SELECT *
FROM EMPLOYEE_COPY;

--EMPLOYEE ���̺��� D6�μ��� �μ��ڵ� -> 65 
--�ܷ�Ű �������� Ȯ��
UPDATE EMPLOYEE
SET DEPT_CODE = '65'
WHERE DEPT_CODE = 'D6';

--�����̸Ӹ�Ű �������� Ȯ��
--NOT NULL
UPDATE EMPLOYEE
SET EMP_ID = NULL
WHERE EMP_NAME = '�����';
--UNIQUE 
UPDATE EMPLOYEE
SET EMP_ID = 220
WHERE EMP_NAME = '�����';

ROLLBACK;

--DELETE : ���̺��� ���� ���� �ϴ� ���� -> ���� ������ �پ���.
--DELETE FROM ���̺�� WHERE ������; 
--> ���������� �̿��� ����

--EMPLOYEE ���̺��� '�ֹ���' �����͸� ����
DELETE FROM EMPLOYEE 
WHERE EMP_NAME = '�ֹ���';
SELECT *
FROM EMPLOYEE;
ROLLBACK;

DELETE FROM EMPLOYEE;
SELECT *
FROM EMPLOYEE;
ROLLBACK;

--EMPLOYEE���̺��� D1�μ��� �ο������� ���� �Ͻÿ�
DELETE FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

SELECT *
FROM EMPLOYEE;

ROLLBACK;

--�μ� ���̺��� D1�μ��� ����
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

ROLLBACK;
--SYS_C007102
--SYS_C007116
--���������� ��Ȱ��ȭ �� ������ �Ϸ��� ��
ALTER TABLE EMPLOYEE_COPY DISABLE CONSTRAINT SYS_C007102;
ALTER TABLE EMPLOYEE DISABLE CONSTRAINT SYS_C007116;

SELECT *
FROM USER_CONSTRAINTS
WHERE CONSTRAINT_NAME = 'SYS_C007116';

--���� �� ���������� Ȱ��ȭ ��
ALTER TABLE EMPLOYEE_COPY ENABLE CONSTRAINT SYS_C007102;
ALTER TABLE EMPLOYEE ENABLE CONSTRAINT SYS_C007116;

--D1	�λ������	L1
INSERT INTO DEPARTMENT
    VALUES ('D1', '�λ������', 'L1');


--MERGE : ������ ����� �� ���̺��� ������ ��ģ��.
--      ���ǽ� -> ������, �ش� ���� ������Ʈ
--                -> ������, �ش� ���� �߰�

--EMPLOYEE ���� ���̺� 2�� ����
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

--EMP_03 ���̺� ������ ������ �߰��Ѵ�.
INSERT INTO EMP_03
    VALUES (555, '�ֹ���', '991111-1234567', 
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


--Ʈ������ -> COMMIT, ROLLBACK, SAVEPOINT, ROLLBACK �̸�;
--Ʈ������ -> ������ �ּҴ����� ���Ѵ�. 
---> ���� ó�� �Ǿ�� �Ǵ� �ϵ��� ����
--����ATM -> ���ؾ����� ��ü 50����
--1. ���� ���� �ȴ�.
--2. ī�带 �ִ´�.
--3. ��й�ȣ�� �Է��Ѵ�.
--4. ���¹�ȣ�� �Է��Ѵ�.
--5. �ݾ��� �Է��Ѵ�.
--6. ��ü �Ѵ�.
--  6-2 ���ؾ� ���忡 �ݾ� +50
--  6-1 �� ���忡�� �ݾ��� -50
--7. �۱��� �Ϸ�Ǿ����ϴ�.

--COMMIT : Ʈ�������� ���� ���� �Ǿ��� ��� ������ ����, �ݿ�
--ROLLBACK : Ʈ������ ������ ���� �Ǿ��� ��� ������ ���·� �ǵ�����.
--SAVEPOINT : Ʈ�������� ����ȭ �Ͽ� ������ ������. 
--                      -> Ʈ������ �߰� ���� ������ �����Ѵ�.
--ROLLBACK ���̺�����Ʈ�� : �ش� ���̺�����Ʈ ���·� �ǵ�����.

--�������� ���̺� ����
--���̺�� : USER_TB
--�÷� : 
--    ID VARCHAR2(20) PRIMARY KEY
--    PWD VARCHAR2(30)
--    NAME VARCHAR2(15) NOT NULL
CREATE TABLE USER_TB(
    ID VARCHAR2(20) PRIMARY KEY,
    PWD VARCHAR2(30),
    NAME VARCHAR2(15) NOT NULL
);

INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('����', 'JJID', 'JJPWD');
INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('����', 'YKID', 'YKPWD');    
INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('��ȣ', 'KHID', 'KHPWD');   
ROLLBACK;
COMMIT;

SELECT *
FROM USER_TB;

INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('����', 'YSID', 'YSPWD');   
SAVEPOINT ADD_ST_1;

INSERT INTO USER_TB(NAME, ID, PWD)
                            VALUES ('�μ�', 'ISID', 'ISPWD');   

SAVEPOINT ADD_ST_2;
--�ٸ� ����
SAVEPOINT ADD_ST_3;
--�ٸ� ����

ROLLBACK; --> ����, �μ��� �����Ͱ� ���� ��� ��
ROLLBACK TO ADD_ST_1; --> ������ �����͸� ����
SELECT *
FROM USER_TB;
COMMIT;

--TRUNCATE : ������ ���� ���� -> �޸𸮸� �ƿ� �ٲ۴�.
SELECT *
FROM USER_TB;

DELETE FROM USER_TB;--> DML -> ROLLBACK ����

TRUNCATE TABLE USER_TB;
ROLLBACK;

























































































    


