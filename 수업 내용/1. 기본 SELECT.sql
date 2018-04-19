CREATE TABLE NUMBER_TEST(
    NUM1 NUMBER(7, 3),
    NUM2 NUMBER(7),
    NUM3 NUMBER,
    NUM4 NUMBER(7,1),
    NUM5 NUMBER(7,-2)
);

INSERT INTO NUMBER_TEST
VALUES (1234.678,9999999,9999999,9999.999,5555555);

SELECT *
FROM NUMBER_TEST;

DROP TABLE NUMBER_TEST;


CREATE TABLE CHAR_TEST(
    CHAR1 CHAR(3),
    CHAR2 CHAR(6),
    CHAR3 CHAR(9)
);

INSERT INTO CHAR_TEST(CHAR1, CHAR2, CHAR3)
VALUES ('ABC', 'ABCABC', 'ABCABC');

SELECT CHAR1 || '/' , CHAR2 || '/', CHAR3 || '/'
FROM CHAR_TEST;

--10G ���� ������ ��� �ѱ��� 2BYTE
--���� ���� ���� �ѱ� 3BYTE
INSERT INTO CHAR_TEST(CHAR1, CHAR2, CHAR3)
VALUES ('��', '����', '����');

CREATE TABLE VARCHAR_TEST(
    CHAR1 DATE,
    CHAR2 VARCHAR2(6),
    CHAR3 VARCHAR2(9)
);
INSERT INTO VARCHAR_TEST(CHAR1, CHAR2, CHAR3)
VALUES('������', '������', '������');

SELECT CHAR1 || '/' , CHAR2 || '/', CHAR3 || '/'
FROM VARCHAR_TEST;

SELECT SYSDATE, SYSDATE + 1, SYSDATE -2,
                TO_CHAR(SYSDATE + 5/24, 'YY-MM-DD HH:MI:SS')
FROM DUAL;


COMMIT;
DROP TABLE CHAR_TEST;
DROP TABLE NUMBER_TEST;
DROP TABLE VARCHAR_TEST;


--��� ���� ���� ��ȸ
SELECT *
FROM EMPLOYEE;

SELECT EMP_ID AS "���", EMP_NAME AS "�̸�",
                EMP_NO "�ֹι�ȣ", EMAIL "�̸���"
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

SELECT EMP_NAME AS "�̸�", '��' AS "ȣĪ"
FROM EMPLOYEE;

SELECT EMP_NAME || ' ��' AS "�̸�"
FROM EMPLOYEE;

--xxx���� �޿��� xxx�� �Դϴ�.
SELECT EMP_NAME || '���� �޿���' || SALARY || '�� �Դϴ�.' AS "��� ����"
FROM EMPLOYEE;

SELECT SALARY AS "�޿�", SALARY * 12 AS "����",
            SALARY + 500000 "�󿩱�"
FROM EMPLOYEE;

--�⺻ �޿� + ���ʽ� �ݾ� -> �̴��� �޿�
--���ʽ� �ݾ� : �⺻�޿� * ���ʽ� ��
SELECT SALARY + (SALARY * BONUS) AS "�̴��� �޿�"
FROM EMPLOYEE;

--�޿��� 300���� ������ ����鸸 ��ȸ �Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE SALARY <= 3000000;

--�޿��� 300���� ����, ������ J6 �� ����鸸 ��ȸ �Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE SALARY <= 3000000 AND JOB_CODE = 'J6';

--�޿��� 300���� ����, ������ J6�̸鼭, �μ��� �ִ� ����鸸 ��ȸ �Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE SALARY <= 3000000 
    AND JOB_CODE = 'J6'
    AND DEPT_CODE IS NOT NULL;


--�޿��� 300���� ����, ������ J6�̸鼭, �μ��� �ִ� ������� �̸� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SALARY <= 3000000 
    AND JOB_CODE = 'J6'
    AND DEPT_CODE IS NOT NULL;

--�޿��� 200�̻� 300������ ������� ��� ������ ��� �Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE 2000000<= SALARY 
    AND SALARY <= 3000000;

SELECT *
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 3000000;

--�̾����� ����� ��ȸ�Ͻʽÿ�
--LIKE -> ���ϵ� ī�� -> _(�ѱ���), %(���� ����)
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '��__';

SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '��%';

--�̸� �� ��� ���ڰ� '��' �� ����� ��ȸ �Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_��_';

--������ 8���� ������� ��ȸ�Ͽ� ��� �Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE EMP_NO NOT LIKE '__08%';

--��ȭ��ȣ�� ���� ����� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE PHONE IS NOT NULL;

--�̸����� ��ȸ�Ҷ� _�ձ��ڰ� 3������ �̸��ϸ� ��ȸ�Ͻÿ�
SELECT * 
FROM EMPLOYEE
WHERE EMAIL NOT LIKE '___#_%' ESCAPE '#';

--������ J6, J7������� ��� ������ ����Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE = 'J6' OR JOB_CODE = 'J7';

SELECT *
FROM EMPLOYEE
WHERE JOB_CODE NOT IN ('J6', 'J7');









