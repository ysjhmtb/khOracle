--����� ����(���� ����)
--������� ������ ��ȣ ����, ���� �ο�
--SYSTEM --> DBA (�⺻������ ����)
--STUDENT --> ����� ����
--SCOTT, HR --> �⺻������ ����Ŭ���� �����ϴ� ����

--������ ����(DBA-SYSTEM)
--������ ���ؼ� ������ ���̽��� �����ϴ� ����
--��� ������� ��ü�� ���ؼ� ��ȸ, ����, ���� ����(��� ����)�� ���� �ִ�
--�ټ��� ����ڰ� DB�� �����Ϸ� �Ҷ� �ش� ����ڵ��� ������ 
--  �����ϴ� �����ڰ� �ʿ��ϱ� ������ ������ ������ ����Ѵ�.

--�ý����� �����ϴ� ����
--    CREATE USER - ����� ���� ����
--    DROP USER - ����� ���� ����
--    DROP ANY TABLE - ��� ������ ���̺� ���� ���� ����

--������ -> ����ڿ��� �ο��ϴ� ����
--    CREATE SESSION - ���ӱ��� (CONNECT - ROLE)
--    CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, 
--    CREATE FUNCTION, CREATE PROCEDURE, CREATE TRIGGER
--       --> (RESOURCE - ROLE)

--����� ���� ���� TESTPRIV/TESTPRIV
CREATE USER TESTPRIV IDENTIFIED BY TESTPRIV;
GRANT CREATE SESSION TO TESTPRIV;
GRANT CREATE TABLE TO TESTPRIV;

SELECT *
FROM DBA_USERS
WHERE USERNAME = 'TESTPRIV';

--TABLE SPACE(���� ����)
--���̺�, ��, �׹��� ��ü���� ������ �����ϴ� ��ũ ���� ����
--����Ŭ������ �ش� �������� ���̺� �����̽��� �Ҵ� �ȴ�.
ALTER USER TESTPRIV QUOTA 2M ON SYSTEM;

--GRANT �� ����ϴ� �ɼ�
--WITH ADMIN OPTION : �����ڿ��� �ο����� �ý��� ������ 
--                                     �ٸ� ����ڿ��� �ο��Ҷ� �����

--�����ڿ��� �ο� �޴� ���� -- CREATE TABLE;
--��ü ���� : ���̺�, ��, ������, �׿� ��ü�鿡 ���ؼ� 
--                    ����, ��ȸ, ����, ���� �� ���� ����
--ALTER - TABLE, SEQUENCE
--DELETE - TABLE, VIEW(DML �ַ� ������)
--EXECUTE - PROCEDURE
--INDEX - TABLE
--INSERT - TABLE, VIEW(DML X)
--SELECT - TABLE, SEQUENCE, VIEW
--UPDATE - TABLE, VIEW
--REFERENCES - TABLE


--ǥ����
--GRANT ��������[(�÷���)] | ALL
--ON ��ü�� | ROLL �̸� | PUBLIC
--TO ������̸�

--WITH GRANT OPTION : ���� ������ �ٸ�������� �����Ҽ� �ִ� �ɼ�
GRANT SELECT ON STUDENT.EMPLOYEE TO TESTPRIV 
WITH GRANT OPTION;

--STUDENT.DEPARTMENT ���̺��� SELECT�� INSERT ������
--SCOTT�������� �Ҵ� �ѵ� -> INSERT, SELECT
GRANT SELECT ON STUDENT.DEPARTMENT TO SCOTT;
GRANT INSERT ON STUDENT.DEPARTMENT TO SCOTT;

--�ο����� ������ ��ȸ�ϴ� ��ųʸ�
--SELECT * FROM USER_TAB_PRIVS_RECD;

--REVOKE : ���� ����(ȸ��)
REVOKE SELECT ON STUDENT.DEPARTMENT FROM SCOTT;

--TESTPRIV ������ CREATE SESSION ������ ȸ���Ͻʽÿ�.
--GRANT CREATE SESSION TO TESTPRIV;
REVOKE CREATE SESSION FROM TESTPRIV;


--��(ROLE - ����)
--����ڿ��� �������� ������ ���� �����ϰ� �ο��ϱ� ���Ͽ� �������� ������ 
--���� ���� ��ü
--  --> ���� ������ ����ڵ��� ��� �̿��Ҷ� 
--            ���� �����ϰ� ���Ѱ����� �Ҽ� ����

--�⺻������ ���� �Ǵ� ��
--CONNECT ROLE
--����ڰ� ��� ���� �����ϵ��� �ý��� ������ ����
--CREATE SESSION, ALTER SESSION, CREATE TABLE, CREATE VIEW
--CREATE SYNONYM, CREATE SEQUENCE, CREATE CLUSTER,
--CREATE DATABASE LINK

--RESOURCE ROLE
--����ڰ� DB�� ��ü�� ���� ������ �ٷ�� �ְ� ���ִ� ��
--CREATE TABLE, CREATE PROCEDURE, CREATE SEQUENCE
--CREATE CLUSTER, CREATE TRIGGER

--DBA 
--������ ���� ���� - ������ ���̽� �� ��� ��ü, 
--                          ��� �����Ϳ� ���ؼ� ����, ���� �Ҽ� �ִ� ��

SELECT *
FROM DICTIONARY
WHERE TABLE_NAME LIKE '%ROLE%';

SELECT *
FROM USER_ROLE_PRIVS;

--ROLE ���� �� �ο�
--ǥ���
--CREATE ROLE ���̸�;
--GRANT �������� TO ���̸�;
--GRANT ���̸� TO �����;

--����ڿ��� ���Ӱ��� ����, ���̺���� ����, SEQUENCE ���� ������ �ο��ϴ�
--���� �����ض�(BASIC_ROLE)
--1.�Ѱ�ü ����
CREATE ROLE BASIC_ROLE;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE
                TO BASIC_ROLE;
GRANT BASIC_ROLE TO TESTPRIV;  

--�� ȸ��(����)
REVOKE BASIC_ROLE FROM TESTPRIV;

--�� ����
DROP ROLE BASIC_ROLE;

GRANT CREATE SYNONYM TO STUDENT;








































