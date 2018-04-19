--DEFAULT : �÷��� �⺻ �� ����
--�÷��� DEFAULT ����
--NOT NULL�� ���������� MODIFY
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
--ALTER : DB����ϴ� ��ü ������ ����
--���̺� ��ü ���� : 
--ALTER TABLE ���̺�� �����ҳ���
--�÷� �߰�/����, �������� �߰�/����
--�÷� �ڷ��� ����, DEFAULT/NOT NULL
--���̺�� ����, �÷���, �������� �̸� ����

--�÷� �߰�
SELECT *
FROM DEPT_COPY;

--��(1��, 2��, 3��, ���� 2��)�� ���õ� �÷� �߰�
--�ڸ�Ʈ - '��������'
ALTER TABLE DEPT_COPY 
    ADD (LOCATION_NAME VARCHAR2(20));
SELECT *
FROM DEPT_COPY;
COMMENT ON COLUMN DEPT_COPY.LOCATION_NAME 
                                                                            IS '��������';

--�÷� ����
ALTER TABLE DEPT_COPY 
DROP COLUMN LOCATION_NAME;

SELECT *
FROM DEPT_COPY;

ALTER TABLE DEPT_COPY 
ADD (DEPT_ID VARCHAR2(20) DEFAULT '���ѹα�');

--DEPARTMENT ���̺��� ���� ���̺��� ����(DEPT_COPY_CONS)
--��(FLOOR VARCHAR2(10))�� ���� �÷� �߰�(�⺻�� 1��)
--DEPT_ID - PRIMARY KEY ��������
--LOCATION_ID - FORIGN KEY ��������
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

--�÷� ����(������) ����
--�ø��� -> Ư�̻��� ����(���������� ����)
--���϶� -> ���� ���� ���� ū �����θ� ������ �����ϴ�
--EX)VARCHAR2(15) '����', '��ġ1', '��������' -> VARCHAR2(9) '???'
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

--���� ������ ���� ������� �پ����
ALTER TABLE DEPT_COPY2
MODIFY DEPT_TITLE VARCHAR2(10);

--DEPT_COPY2 - LNAME (CHAR30) �÷� �߰�
--�⺻�� - '�ѱ�'
ALTER TABLE DEPT_COPY2 
ADD (LNAME CHAR(30) DEFAULT '�ѱ�');
SELECT *
FROM DEPT_COPY2;

INSERT INTO DEPT_COPY2 
VALUES('DA', '������ �μ�', 'L3', DEFAULT);

--�÷��� ������ DEFAULT �� ����
--DEPT_COPY2 - LNAME   '�ѱ�' -> '�̱�'
ALTER TABLE DEPT_COPY2
MODIFY LNAME VARCHAR2(30) DEFAULT '�̱�';
--CHAR -> VARCHAR2 ���� ���� ��(���� �� �÷��� �� ���� ����)
INSERT INTO DEPT_COPY2(DEPT_ID, DEPT_TITLE, LOCATION_ID)
VALUES('DC', '�ؿܰ��� �μ�', 'L1');
SELECT *
FROM DEPT_COPY2;

--�÷� ����
ALTER TABLE DEPT_COPY2
DROP COLUMN LNAME;

SELECT *
FROM DEPT_COPY2;

--���̺��� �÷� ���� �� ���� �� �ּ� 1�� �̻��� �÷��� �����־�� ��
--(���̺� ��� �÷��� ���� -> ���̺� DROP)
ALTER TABLE DEPT_COPY2
DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_ID; --���� �߻�


--���� �ϰ��ִ� �÷��� ���� �� ���(�ٸ� ���̺��� �θ�Ű�� ����ϰ� �ִ�)
--�÷� ������ ���� ����
ALTER TABLE DEPARTMENT
DROP COLUMN DEPT_ID;
--DML -> Ʈ������ ó���� �����մϴ�.(COMMIT, ROLLBACK 
--                                                                -> ����, �ǵ�����)
--DDL -> Ʈ������ ó�� �Ұ�(AUTO COMMIT)

--�ν�Ÿ ������ �����ϴ� TABLE ����
--�Խñ� ���� ���̺�
--PICTURE_BOARD
--�÷�
--BOARD_ID - NUMBER
--WRITER - VARCHAR2(3)
--CONTENT - VARCHAR2(1500)
--WRITE_TIME - DATE (�⺻�� ����ð�)
--F_COUNT - NUMBER
--IMAGE_PATH - VARCHAR(1000)
--REPLY - VARCHAR2(600)
--��������
--BOARD_ID -> PRIMARY KEY - BOARD_ID_PK
--WRITER -> EMPLOYEE(EMP_ID) �÷� ���� - BOARD_WRITER_FK
--F_COUNT -> CHECK 0 �̻� - BOARD_COUNT_CK
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

--�������� ����
ALTER TABLE PICTURE_BOARD
DROP CONSTRAINT SYS_C007162;

--�������� �������� ����
ALTER TABLE PICTURE_BOARD
DROP CONSTRAINT BOARD_COUNT_CK
DROP CONSTRAINT BOARD_ID_PK
DROP CONSTRAINT BOARD_WRITER_FK;

SELECT *
FROM USER_CONSTRAINTS
JOIN USER_CONS_COLUMNS USING (CONSTRAINT_NAME)
WHERE USER_CONSTRAINTS.TABLE_NAME = 'PICTURE_BOARD';


--������ ��ųʸ�(������ ����, ��Ÿ ������)
--�����͸� ���� ������
--�������ǿ� ���õ� ��ųʸ� - ALL_CONSTRAINTS
--���������� �÷����� �����ϴ� ��ųʸ� - USER_CONS_COLUMNS
--���̺� ������ ��ȸ�ϴ� ��ųʸ� - USER_TABLES
--��ųʸ� ����
--USER_XXXX - �ش� ���� ����, ������ ���õ� ����
--ALL_XXXX - �ش� ������ ������ �ִ�, ���� ������ ��� ������ ���Ͽ� ���
--DBA_XXXX - DB������ ���� ��� �����͸� ���� ����(DBA - SYSTEM����)
--��ųʸ� ���� ����, ������ DDL ���� ���� �Ҷ� �ش� ������ �´� �����Ͱ�
--��ųʸ��� ����Ǵ� ����
SELECT *
FROM USER_CONSTRAINTS;
SELECT *
FROM ALL_CONSTRAINTS;
SELECT *
FROM DBA_CONSTRAINTS;


--VIEW(��)
--SELECT ���� ����� �����ϴ� ��ü�̴�.(�ӽ� ���̺�, ���� ���̺�)
--���������� �����ʹ� �������� �ʴ´�. 
            --> ���� ���̺��� �������� ����� ���� �����͵� ���� ����
--������ ���̺� ���� ����
--CREATE OR REPLACE VIEW ���̸� AS ��������

--�� ����
--��������� ��ȸ�ϴ� ��(EMP_V)
--���, �̸�, �ֹι�ȣ, �μ��ڵ�, �μ���, �����ڵ�, ���޸�, �޿�
CREATE OR REPLACE VIEW EMP_V AS
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE
            ,E.JOB_CODE, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
--CONNECT, RESOURCE(CREATE VIEW �̹� ���ԵǾ� ����)
--GRANT CREATE VIEW TO STUDENT;

--�������� ��� ������ �並 �̿��Ͽ� ��ȸ
SELECT *
FROM EMP_V
WHERE EMP_NAME = '������';

SELECT *
FROM EMP_V
WHERE DEPT_TITLE = '�λ������';

SELECT *
FROM USER_VIEWS;

--�並 ����ϴ� ����
--������ ����, ������ �����ϱ� ���ؼ�(������ ������ ����)
--���� - �ٸ� ���̺���� JOIN�ؼ� ��ȸ�ؾ� �Ǵ� ����� ���ϰ� ����
--��������� ��ȸ �ӵ��� ������.

--EMPLOYEE_COPY���̺� ����
CREATE OR REPLACE VIEW EMP_COPY_V AS
SELECT *
FROM EMPLOYEE_COPY;

SELECT *
FROM EMP_COPY_V;

--EMP_COPY_V�� ���ؼ� ��� 220�� ������ �޿��� 2000000���� ����
UPDATE EMP_COPY_V
SET SALARY = 2000000
WHERE EMP_ID = '220';

INSERT INTO EMP_COPY_V
    VALUES ('800', '�ֹ���', '990101-1000001', 'beomsuk@naver.com', 
                    '0101111111','D2', 'J5', 'S4', 2000000,
                    0.1, NULL, SYSDATE, NULL, 'N');
    
SELECT *
FROM EMPLOYEE_COPY;


UPDATE EMP_V
SET SALARY = 2000000;

SELECT *
FROM EMP_V;
--�信 ��ȸ���� �ʴ� �÷� �� NOT NULL Ȥ�� PRIMARY KEY�� ���� �������ǿ�
--����� ���� ���� �߰��Ҽ� ����.
INSERT INTO EMP_V
VALUES ('800', '�ֹ���', 'D1','�λ������', 'J7', '���', 2000000);

--�並 ���ؼ� DML�� �Ұ��� �Ѱ��
--1. �� ���ǿ� ���Ե��� ���� �÷��� �����ϴ� ���
--2. �� ���ǿ� ���Ե��� ���� �÷��� �������ǿ� ����� ���
--        (PRIMARY KEY, NOT NULL)
--3. ��� ǥ�������� �÷��� ���� �� ���(���� (SALARY + SALARY * BONUS) * 12))
--4. JOIN�� �̿��ؼ� ���� ���̺��� ����� ��� -> 2��
--5. DISTINCT, GROUP BY�� ���ؼ� ���� �� ��

--1. �� ���ǿ� ���Ե��� ���� �÷��� �����ϴ� ���
CREATE OR REPLACE VIEW JOB_V AS
SELECT JOB_CODE
FROM JOB;

--J8 ����
INSERT INTO JOB_V(JOB_CODE, JOB_NAME) VALUES ('J8', '����');

SELECT *
FROM JOB_V;

UPDATE JOB_V
SET JOB_NAME = '����';

--2. �� ���ǿ� ���Ե��� ���� �÷��� �������ǿ� ����� ���
--        (PRIMARY KEY, NOT NULL)
CREATE OR REPLACE VIEW JOB_V AS
SELECT JOB_NAME
FROM JOB;
INSERT INTO JOB_V(JOB_NAME) VALUES ('����');

--3. ��� ǥ�������� �÷��� ���� �� ���(���� (SALARY + SALARY * BONUS) * 12))
--���, �����, ���� �並 �����Ϸ� �Ѵ�.
CREATE OR REPLACE VIEW EMP_SALARY_V AS
SELECT EMP_ID, EMP_NAME,
(SALARY + SALARY * NVL(BONUS, 0)) * 12 AS ANUUAL_SALARY
FROM EMPLOYEE;

SELECT *
FROM EMP_SALARY_V;

UPDATE EMP_SALARY_V
SET ANUUAL_SALARY = '40000000'
WHERE EMP_NAME = '���ö';

--4. JOIN�� �̿��ؼ� ���� ���̺��� ����� ��� -> 2��
CREATE OR REPLACE VIEW EMP_V AS
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE
            ,E.JOB_CODE, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

UPDATE EMP_V
SET JOB_CODE = 'J9';
ROLLBACK;

--5. DISTINCT, GROUP BY�� ���ؼ� ���� �� ��
CREATE OR REPLACE VIEW EMP2_V AS
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

SELECT *
FROM EMP2_V;

UPDATE EMP2_V
SET DEPT_CODE = 'D1';

SELECT *
FROM USER_VIEWS;
--�� ����
DROP VIEW EMP_SALARY_V;