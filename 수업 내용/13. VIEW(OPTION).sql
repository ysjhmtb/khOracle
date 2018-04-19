--�� �ɼ�
--OR REPLACE : ������ ���� �̸��� �䰡 ���� �� ��� ���� ����.
--                          --> �̸��� �䰡 ���� ���� ���� ��� ���� ���� �Ѵ�.
--FORCE : ���������� ��� �� ���̺��� ���� ���� ������쿡�� �� ���� 
--NOFORCE : ���������� ��� �� ���̺��� ���� �� ��츸 �� ����
--WITH CHECK OPTION : �������� ����� �÷��� ���� ���� �Ϸ� �Ҷ�
--                                        ������ ���� �ɼ�(DML�� ���� �ϴ� ����)
--WITH READ ONLY : �並 ���ؼ� ��ȸ�� �����ϵ��� �ϴ� �ɼ�

--FORCE : ���������� ��� �� ���̺��� ���� ���� ������쿡�� �� ���� 
CREATE OR REPLACE FORCE VIEW TEMP_V AS
SELECT *
FROM TTT;

SELECT *
FROM USER_VIEWS;

--WITH CHECK OPTION : �������� ����� �÷��� ���� ���� �Ϸ� �Ҷ�
--                                        ������ ���� �ɼ�(DML�� ���� �ϴ� ����)
--EMPLOYEE_COPY ���̺��� 'D5'�μ� �ο��� ��ȸ�ϴ� �� ����
CREATE OR REPLACE VIEW EMP_CP_V AS
SELECT *
FROM EMPLOYEE_COPY
WHERE DEPT_CODE = 'D5'
WITH CHECK OPTION;

SELECT *
FROM EMP_CP_V;

--�並 �̿��Ͽ� �������� �޿� 3200000, �޿���� S4 ����
UPDATE EMP_CP_V
SET SALARY = 3200000, SAL_LEVEL = 'S4'
WHERE EMP_NAME = '������';
SELECT *
FROM EMP_CP_V;
--�μ� �������� ���� D5 -> D6 �̵� �Ͽ����ϴ�. 
--�並 �̿��Ͽ� ���� �����͸� ������ �ֽʽÿ�.
UPDATE EMP_CP_V
SET DEPT_CODE = 'D6'
WHERE DEPT_CODE = 'D5'; --���� �Ұ�

--WITH READ ONLY : �並 ���ؼ� ��ȸ�� �����ϵ��� �ϴ� �ɼ�
CREATE OR REPLACE /*NOFORCE*/ VIEW EMP_CP_V AS
SELECT *
FROM EMPLOYEE_COPY
WHERE DEPT_CODE = 'D5'
WITH READ ONLY;

UPDATE EMP_CP_V
SET SALARY = 3000000, SAL_LEVEL = 'S4'
WHERE EMP_NAME = '������';


--SEQUENCE
--> �ڵ� ��ȣ ������ -> ���������� ���� ���� �����ϴ� ��ü
--ǥ���� 
--CREATE SEQUENCE ������ ��
--START WITH ���۰�
--INCREMENT BY ����
--MAXVALUE �ִ밪 | NOMAXVALUE 10^27
--MINVALUE �ּҰ� | NOMINVALUE -10^26
--CYCLE | NOCYCLE
--CACHE [20]���Ƿ� �����س��� ���� | NOCACHE

--������ : USER_ID_SEQ ���۰� 1 ~ 99999
CREATE SEQUENCE USER_ID_SEQ
START WITH 1
INCREMENT BY 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

SELECT *
FROM USER_SEQUENCES;

--������ ���� ���� ��� : ��������.NEXTVAL
--������ ���� ���� ��� : ��������.CURRVAL
SELECT USER_ID_SEQ.NEXTVAL
FROM DUAL;
SELECT USER_ID_SEQ.CURRVAL
FROM DUAL;

--�л� ���̺�(STUDENT_TB)
--�й�, �̸�, �������
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
                    , '�ֹ���', '1999/01/01');
SELECT *
FROM STUDENT_TB;
INSERT INTO STUDENT_TB(SID, SNAME, BIRTH)
VALUES (TO_CHAR(SYSDATE,'YYYY')|| LPAD(STUDENT_ID_SEQ.NEXTVAL,5,'0')
                    , '������', '1991/07/28');

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
--������ ����
DROP SEQUENCE CACHE_SEQ;


--INDEX : SQL ���̾��� ó�� �ӵ��� ��� ��Ű�� ���ؼ� �÷��� �����ϴ� ��ü 
--INDEX ���� : �˻� �ӵ��� ��������. -> �ý��ۿ� ���ϰ� �پ���.
--                            -> �ý����� ��ü ������ ��� ��Ų��.
--INDEX ���� : �ε����� �����ϱ� ���� �߰����� ���� ������ �ʿ��ϴ�
--                   �ε����� �����ϴµ� �ð��� �ɸ���.
--DML�� ���� �Ͼ�� ���̺��̳� �÷��� ���ؼ� �ε����� �����Ǿ� �������
--�ð��� ���� �ɸ�(�ε��� ��迭)

--�ε����� ȿ�������� ����ϴ� ���
--�������� ���� 40000�̻��� �������� 10~20% ������ ��ȸ�Ҷ�
--�ΰ��� ���̺��� ���� �Ҷ�
--�����Ͱ� ���� ������� �ʴ� ���
--���̺� ����Ǿ� �ִ� �뷮�� ū ���

--CREATE INDEX �ε����� ON ���̺��(�÷���1,�÷���2,�÷���3~~~)

SELECT *
FROM TB_GRADE
WHERE TERM_NO = '200801'; --0��

CREATE INDEX GRADE_IDX ON TB_GRADE(TERM_NO);

SELECT *
FROM TB_GRADE
WHERE TERM_NO = '200801'; --0.32��

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

--�ε��� ����
-- 1. ���� �ε���(UNIQUE)
-- �ε����� ���� �� �÷��� �ߺ��� ���� ������� ����
CREATE UNIQUE INDEX EMP_NO_IDX ON EMPLOYEE_COPY(EMP_NO);
CREATE UNIQUE INDEX EMP_NO_IDX2 ON EMPLOYEE_COPY(DEPT_CODE);

-- 2. ����� �ε���(NONUNIQUE)
-- �ε����� ���� �� �÷��� �ߺ��� ���� ������� ����(WHERE, JOIN ���� ����ϴ� �÷��� ����)
CREATE UNIQUE INDEX EMP_NO_IDX ON EMPLOYEE_COPY(EMP_NO);

-- 3. ���� �ε���(SINGLE)
-- �ϳ��� �÷��� ������� �ε����� ����
CREATE INDEX �ε����� ON ���̺��(�÷���);

-- 4. ���� �ε���(COMPOSITE)
-- ������ �÷� ���� ������� �ε����� ����(����Ű�� ���� ����)
CREATE INDEX �ε����� ON ���̺��(�÷���1, �÷���2...);

-- 5 �Լ� ��� �ε���(FUNCTION BASED)
-- ���� ����ϴ� ������ ������� �ε����� ����
CREATE INDEX SAL_IDX ON EMPLOYEE_COPY((SALARY+SALARY*NVL(BONUS,0))*12);

SELECT *
FROM EMPLOYEE_COPY
WHERE (SALARY+SALARY*NVL(BONUS,0))*12>=30000000;


SELECT *
FROM USER_INDEXES;
















































