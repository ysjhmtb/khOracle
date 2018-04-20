--Ʈ����(TRIGGER)
--������ ���̽��� �̸� ���س��� ������ ������ ����Ǹ� 
--                                                              �ڵ������� ����Ǵ� �ൿ�� ����
--Ʈ���Ŵ� ���̺��� �����Ͱ� INSERT, UPDATE, DELETE ���� DML�� ����ɶ���
--���� �Ͽ� ���� ��(�ڹ� - LISTENER)
--��ǰ (��ǰ��ȣ, ��ǰ�̸�, ��ǰ��, ������, ���)
--�ֹ� (�ֹ���ȣ, ��ǰ��ȣ, ����)  --> �ֹ��� �߰� �ɶ� �ش� ��ǰ�� ��� - ��Ű�� TRIGGER

--Ʈ������ ���� ����
--�ش� �̺�Ʈ(DML)�� ����Ǳ���(BEFORE), ���� ��(AFTER) 

--Ʈ������ �̺�Ʈ 
--DML�� ����Ǵ� ����

--Ʈ������ BEGIN�� �ۼ� �Ǵ� ����
--�ش� DML�� ó���Ǿ�� �ϴ� ����(���� ���̺���� �ٸ� ���̺�, �ٸ� ����)

--Ʈ������ ����
--FOR EACH ROW(O)(�� ���� Ʈ����)
--      : ������ �Ͼ ��� �࿡ ���ؼ� Ʈ���Ÿ� ������
--FOR EACH ROW(X)(���� ���� Ʈ����)
--      : ������ ������ �ѹ��� Ʈ���Ű� ���� �ȴ�.
--EX) ���� ���̺��� 'D5' �ο����� �޿� 2000000������ �����ϰ� 
--      �ش� �ο����� ����� ������ �������̺� �߰��Ѵ�.

--ǥ����
CREATE OR REPLACE TRIGGER Ʈ���Ÿ� 
BEFORE|AFTER   INSERT|UPDATE|DELETE ON ���̺��
[FOR EACH ROW]
BEGIN
    ���� ����
END;
/

--EX)���� ���� Ʈ���� - ���Ի���� ��� �� ��� '���Ի���� �Ի��Ͽ����ϴ�.' ��� 
--    �޼��� ��� Ʈ���� ����
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER ENT_EMP
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('���Ի���� �Ի��Ͽ����ϴ�.');
END;
/

INSERT INTO EMPLOYEE
    VALUES ('950', 'ȫ�浿', '501111-1234555', 'KDHONG@NAVER.COM',
                    '010-123-3333', 'D3', 'J2', 'S2', 150000,
                    0.1, NULL, SYSDATE, NULL, 'N');
ROLLBACK;
DELETE FROM EMPLOYEE
WHERE EMP_ID = '950';
COMMIT;

ALTER TRIGGER ENT_EMP COMPILE;

--���ε� ���� 2���� 
--FOR EACH ROW��츸 ��� ���� ��
--:NEW : ���� �߰�/���� �� ������
--:OLD : ���� ������

--�μ��� ����� �����̸���, ���ο��̸��� ����ϴ� Ʈ���Ÿ� �ۼ��Ͻÿ�
--�μ� ���� ���̺� : DEPT_C
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
SET DEPT_TITLE = '�ڹٰ�����'
WHERE DEPT_ID = 'D4';
COMMIT;


--���� �ǽ� DEPT_DUP, DEPT_DEL
--DEPT_DUP �� ���� �� DEPT_DEL ���̺� 
--INSERT ��Ű�� Ʈ���Ÿ� �ۼ��Ͽ���
--Ʈ���� �ۼ� �� DEPT_DUP�� ���� �� DEPT_DEL ���̺� �� �߰� �� Ȯ��

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


--��ǰ�� �԰� �ɶ����� ��ǰ��� ���̺��� ��ġ�� ������ �ٲٱ� ���ŷӴٴ� �䱸����
--�׷��� Ʈ���Ÿ� ����Ͽ�, ��ǰ ����� �� ����� ������ �ڵ����� ���� �Ϸ� ��

--��ǰ ���� ���̺�(PRODUCT)
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

--��ǰ ����� ���̺�(PRODUCT_INOUT)
--INOUT_ID - NUMBER PRIMARY KEY
--PID - NUMBER
--INOUT_DATE - DATE
--COUNT - NUMBER
--INOUT - VARCHAR2(6)  ('�԰�', '���')
CREATE TABLE PRODUCT_INOUT(
    INOUT_ID NUMBER PRIMARY KEY,
    PID NUMBER,
    INOUT_DATE DATE,
    COUNT NUMBER,
    INOUT VARCHAR2(6)
);

--SEQUENCE ����
--PID_SEQ : ��ǰ��ȣ SEQ
CREATE SEQUENCE PID_SEQ
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

--INOUT_SEQ : ����� SEQ
CREATE SEQUENCE INOUT_SEQ
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

INSERT INTO PRODUCT VALUES (PID_SEQ.NEXTVAL,'������8', '����', 1000000, DEFAULT);
INSERT INTO PRODUCT VALUES (PID_SEQ.NEXTVAL,'������9', '�Ｚ', 1200000, DEFAULT);
INSERT INTO PRODUCT VALUES (PID_SEQ.NEXTVAL,'��������', '������', 700000, DEFAULT);
COMMIT;

SELECT * FROM PRODUCT;

CREATE OR REPLACE TRIGGER PRODUCT_INOUT_TRG
    AFTER INSERT ON PRODUCT_INOUT
    FOR EACH ROW
BEGIN
    IF :NEW.INOUT = '�԰�' THEN
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
        VALUES(INOUT_SEQ.NEXTVAL, 1, SYSDATE, 5, '�԰�');
INSERT INTO PRODUCT_INOUT
        VALUES(INOUT_SEQ.NEXTVAL, 1, SYSDATE, 3, '���');

SELECT *
FROM PRODUCT;


--�м��Լ�
--����Ŭ �м��Լ��� �����͸� �м� �ϴ� �Լ�
--�м��Լ��� ����ϸ�, ���� ���� ���(RESULT SET)�� �������
--��ü �׷��� �ƴ�, �ұ׷����� �ٽ� ������ �� �׷쿡 ���� ����� �����Ѵ�.

--�Ϲ� �׷��Լ���� �ٸ� ���� �м��Լ��� �м��Լ��� �׷��� ������ �����ؼ� ����Ѵ�.
--�̷��� �м��Լ��� �׷��� WINDOW  --> WINDOW �Լ���

--������� : �м��Լ��� (��������1, ��������2, ��������3) OVER (������ PARTITION ��,
--                                                                                         ORDER BY ��,
--                                                                                         WINDOW ��);
--PARTITION �� : PARTITION BY ǥ����
--                         ǥ���Ŀ� ���� �׷��� ������.-> RESULT SET���� ���� �ȴ�.
--ORDER BY �� : ���� RETURN �Ҷ� ���� ���� ��� �ϴ� �� -> ORDER BY 
--WINDOW �� : �м��Լ��� ����� �׷��� ��������� ������ ��ҽ��Ѽ� ����� ���� �Ѵ�.
--                      PARTITION ������ ���� �׷��� �ٽ��ѹ� �ұ׷����� ������ ����

--RANK : ����� �ű�� �׷��Լ�, ���� ����� ������ ��� ���� ����� �ǳ� �ڴ�.
--�ְ�޿��� 1�� -> ��������
SELECT EMP_ID, EMP_NAME, SALARY, 
              RANK() OVER (ORDER BY SALARY DESC) "�޿�����"
FROM EMPLOYEE;

--DENSE_RANK : ����� �ű�� �׷��Լ�, ���� ����� �����ص� ���� ����� ����Ѵ�.
SELECT EMP_ID, EMP_NAME, SALARY, 
              DENSE_RANK() OVER (ORDER BY SALARY DESC) "RANK"
FROM EMPLOYEE;

--DENSE_RANK�� �̿��� �޿� ������ 16~20�� �ο��� ��ȸ�Ͽ� ����Ͽ���
--���, �̸�, �޿�, �޿�����
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, SALARY, 
                          DENSE_RANK() OVER (ORDER BY SALARY DESC) "RANK"
            FROM EMPLOYEE)
WHERE RANK BETWEEN 16 AND 20;

--350������ RANK�� �̿��� �޿������� ��������� ��ȸ�ϴ� ���
SELECT RANK(2000000) WITHIN GROUP (ORDER BY SALARY DESC)
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY, 
              RANK() OVER (ORDER BY SALARY DESC) "�޿�����"
FROM EMPLOYEE;

--CUME_DIST
--PARTITION ���� �������� �׷캰�� �� ���� ORDER BY �������� ���� �� 
--�ش� �׷��� �л��� RETURN �Ѵ�.(���� �л�)
SELECT EMP_ID, EMP_NAME, SALARY,
                CUME_DIST() OVER (ORDER BY SALARY)
FROM EMPLOYEE;

--PERCENT_RANK
--�������� �׷� ���� ���� �Ͽ�  �ش� �׷��� ������� ��ȯ�Ѵ�.
SELECT EMP_ID, EMP_NAME, SALARY,
            ROUND(PERCENT_RANK() OVER (ORDER BY SALARY), 2) * 100
FROM EMPLOYEE;

--NTILE
--�������� �׷��� N���� �׷����� �ٽ��ѹ� ������.
SELECT EMP_NAME, SALARY,
              NTILE(5) OVER (ORDER BY SALARY DESC) "�޿����"
FROM EMPLOYEE;


--ROW_NUMBER
--�׷캰�� ORDER BY �� ���� ������ ��ȯ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE,
         ROW_NUMBER() OVER (PARTITION BY DEPT_CODE
                                                ORDER BY HIRE_DATE ASC) "�μ� �� �Ի����"
FROM EMPLOYEE;













