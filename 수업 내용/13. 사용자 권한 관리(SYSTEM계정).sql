--사용자 관리(권한 관리)
--사용자의 계정과 암호 설정, 권한 부여
--SYSTEM --> DBA (기본적으로 제공)
--STUDENT --> 사용자 계정
--SCOTT, HR --> 기본적으로 오라클에서 제공하는 계정

--관리자 권한(DBA-SYSTEM)
--보안을 위해서 데이터 베이스를 관리하는 권한
--모든 사용자의 객체에 대해서 조회, 수정, 삭제 권한(모든 권한)을 갖고 있다
--다수의 사용자가 DB에 접근하려 할때 해당 사용자들의 권한을 
--  관리하는 관리자가 필요하기 때문에 관리자 권한을 사용한다.

--시스템을 관리하는 권한
--    CREATE USER - 사용자 계정 생정
--    DROP USER - 사용자 계정 삭제
--    DROP ANY TABLE - 모든 계정의 테이블에 대한 삭제 권한

--관리자 -> 사용자에게 부여하는 권한
--    CREATE SESSION - 접속권한 (CONNECT - ROLE)
--    CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, 
--    CREATE FUNCTION, CREATE PROCEDURE, CREATE TRIGGER
--       --> (RESOURCE - ROLE)

--사용자 계정 생성 TESTPRIV/TESTPRIV
CREATE USER TESTPRIV IDENTIFIED BY TESTPRIV;
GRANT CREATE SESSION TO TESTPRIV;
GRANT CREATE TABLE TO TESTPRIV;

SELECT *
FROM DBA_USERS
WHERE USERNAME = 'TESTPRIV';

--TABLE SPACE(저장 공간)
--테이블, 뷰, 그밖의 객체들의 정보를 저장하는 디스크 상의 공간
--오라클에서는 해당 계정마다 테이블 스페이스가 할당 된다.
ALTER USER TESTPRIV QUOTA 2M ON SYSTEM;

--GRANT 시 사용하는 옵션
--WITH ADMIN OPTION : 관리자에게 부여받은 시스템 권한을 
--                                     다른 사용자에게 부여할때 사용함

--관리자에게 부여 받는 권한 -- CREATE TABLE;
--객체 권한 : 테이블, 뷰, 시퀀스, 그외 객체들에 대해서 
--                    생성, 조회, 수정, 삭제 에 대한 권한
--ALTER - TABLE, SEQUENCE
--DELETE - TABLE, VIEW(DML 주로 사용안함)
--EXECUTE - PROCEDURE
--INDEX - TABLE
--INSERT - TABLE, VIEW(DML X)
--SELECT - TABLE, SEQUENCE, VIEW
--UPDATE - TABLE, VIEW
--REFERENCES - TABLE


--표현법
--GRANT 권한종류[(컬럼명)] | ALL
--ON 객체명 | ROLL 이름 | PUBLIC
--TO 사용자이름

--WITH GRANT OPTION : 받은 권한을 다른사람에게 설정할수 있는 옵션
GRANT SELECT ON STUDENT.EMPLOYEE TO TESTPRIV 
WITH GRANT OPTION;

--STUDENT.DEPARTMENT 테이블의 SELECT와 INSERT 권한을
--SCOTT계정에게 할당 한뒤 -> INSERT, SELECT
GRANT SELECT ON STUDENT.DEPARTMENT TO SCOTT;
GRANT INSERT ON STUDENT.DEPARTMENT TO SCOTT;

--부여받은 권한을 조회하는 딕셔너리
--SELECT * FROM USER_TAB_PRIVS_RECD;

--REVOKE : 권한 삭제(회수)
REVOKE SELECT ON STUDENT.DEPARTMENT FROM SCOTT;

--TESTPRIV 계정에 CREATE SESSION 권한을 회수하십시오.
--GRANT CREATE SESSION TO TESTPRIV;
REVOKE CREATE SESSION FROM TESTPRIV;


--롤(ROLE - 역할)
--사용자에게 여러개의 권한을 보다 간편하게 부여하기 위하여 여러개의 권한을 
--묶어 놓는 객체
--  --> 여러 권한의 사용자들이 디비를 이용할때 
--            보다 간편하게 권한관리를 할수 있음

--기본적으로 제공 되는 롤
--CONNECT ROLE
--사용자가 디비에 접속 가능하도록 시스템 권한의 묶음
--CREATE SESSION, ALTER SESSION, CREATE TABLE, CREATE VIEW
--CREATE SYNONYM, CREATE SEQUENCE, CREATE CLUSTER,
--CREATE DATABASE LINK

--RESOURCE ROLE
--사용자가 DB내 객체에 대한 정보를 다룰수 있게 해주는 롤
--CREATE TABLE, CREATE PROCEDURE, CREATE SEQUENCE
--CREATE CLUSTER, CREATE TRIGGER

--DBA 
--관리자 권한 계정 - 데이터 베이스 내 모든 객체, 
--                          모든 데이터에 대해서 접근, 제어 할수 있는 롤

SELECT *
FROM DICTIONARY
WHERE TABLE_NAME LIKE '%ROLE%';

SELECT *
FROM USER_ROLE_PRIVS;

--ROLE 생성 후 부여
--표기법
--CREATE ROLE 롤이름;
--GRANT 권한종류 TO 롤이름;
--GRANT 롤이름 TO 사용자;

--사용자에게 접속가능 권한, 테이블생성 권한, SEQUENCE 생성 권한을 부여하는
--롤을 생성해라(BASIC_ROLE)
--1.롤객체 생성
CREATE ROLE BASIC_ROLE;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE
                TO BASIC_ROLE;
GRANT BASIC_ROLE TO TESTPRIV;  

--롤 회수(제거)
REVOKE BASIC_ROLE FROM TESTPRIV;

--롤 제거
DROP ROLE BASIC_ROLE;

GRANT CREATE SYNONYM TO STUDENT;








































