--1. ������ ���, �̸�, �����̸���, �����̸��� ���
--�̸��� ���� �� _**@kh.or.kr �������� ���� ���
--(sun_di@kh.or.kr -> sun_**/////////@kh.or.kr);
SELECT EMP_ID, EMP_NAME, EMAIL,
RPAD(SUBSTR(EMAIL, 1, INSTR(EMAIL, '_')), INSTR(EMAIL,'@')-1,'*') ||
SUBSTR(EMAIL,INSTR(EMAIL,'@')) AS "���� �̸���"
FROM EMPLOYEE;

--�̸��� ������ ���� ���, XXXX@********* �� ������ ���
--RPAD
SELECT EMAIL, RPAD(SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')),
                                            LENGTH(EMAIL), '*') "�̸��� * ó��"
FROM EMPLOYEE;


SELECT EMP_ID, EMP_NAME, EMAIL,
RPAD(SUBSTR(EMAIL, 1, INSTR(EMAIL, '_')), INSTR(EMAIL, '@')-1, '*') ||
SUBSTR(EMAIL, INSTR(EMAIL, '@'))"TEST",
SUBSTR(EMAIL, 1, INSTR(EMAIL, '_')) || '**' ||
SUBSTR(EMAIL, INSTR(EMAIL, '@'))"TEST2"
FROM EMPLOYEE;


--2. ���� ������ ������ ���(��� ����)
SELECT *
FROM EMPLOYEE
WHERE EMP_NO LIKE '______-1%';

--3. �������� �ټӳ���� ���Ͻÿ�.
SELECT 
TO_CHAR(SYSDATE, 'YYYY'),
TO_CHAR(HIRE_DATE, 'YYYY'),
TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(HIRE_DATE, 'YYYY')
FROM EMPLOYEE;


--4. �λ������ �������� �޿� ���� ��ȸ(���� �̸�, �޿�)
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';


--5. �̸��� ������ ���ڰ� '��' �λ���� �¾ �⵵�� ���Ͻÿ�
SELECT SUBSTR(EMP_NO, 1,2) || '��'
FROM EMPLOYEE
WHERE EMP_NAME LIKE '__��';


--6. ��ȭ ��ȣ�� ����� �ڸ��� 3�ڸ��� ����� ������ ���
SELECT *
FROM EMPLOYEE
WHERE LENGTH(PHONE) = 10;


--�Ի���� 9���� ������ ��� ���� ���
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE LIKE '___09%';
SELECT *
FROM EMPLOYEE
WHERE SUBSTR(HIRE_DATE, 4, 2) = '09';






