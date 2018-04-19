--ABS() : ������ ���ϴ� �Լ�
SELECT -10, ABS(-10), ABS(12345), ABS(-12345)
FROM DUAL;

--MOD() : �������� ���ϴ� �Լ�
SELECT 5/2, MOD(5,2), MOD(7, 5)
FROM DUAL;

--ROUND() : �ݿø� ���� ����ϴ� �Լ�
SELECT 
    ROUND(1.123),
    ROUND(555.555),
    ROUND(555.555, 2),
    ROUND(555.555, -2),
    ROUND(555.555, 0)
FROM DUAL;

--FLOOR() : ������ ���� ����ϴ� �Լ�
SELECT FLOOR(555.555), FLOOR(12345.678)
FROM DUAL;

--TRUNC() : Ư�� �ڸ����� �����ϴ� �Լ�
SELECT 
    TRUNC(555.555),
    TRUNC(555.555, 0),
    TRUNC(555.555, 2),
    TRUNC(555.555, -2)
FROM DUAL;

--CEIL() : �Ҽ��� ���� �ڸ��� �ø� ó���Ͽ� ���� ��ȯ�ϴ� �Լ�
SELECT
    CEIL(12.3456),
    CEIL(12345)
FROM DUAL;

SELECT 
    CEIL(1234.56),
    ROUND(1234.56),
    FLOOR(1234.56),
    TRUNC(1234.56)
FROM DUAL;



--��¥ ó�� �Լ� ����
--SYSDATE : �ý��� �ð��� �����ϴ� ����
SELECT SYSDATE
FROM DUAL;

--MONTHS_BETWEEN : �ΰ��� ��¥ �� ����� ���̳������� ��ȯ
SELECT HIRE_DATE, SYSDATE,
              CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12)
FROM EMPLOYEE;

--ADD_MONTHS() : ���� ��¥�� �Է��� ���� ���� ��¥�� ��ȯ
SELECT SYSDATE, 
              ADD_MONTHS(SYSDATE, 5),
              ADD_MONTHS(SYSDATE, -1)
FROM DUAL;

--���� ����, ���� ����
SELECT SYSDATE, SYSDATE + 1, SYSDATE + 10, SYSDATE -5
FROM DUAL;

--���� ���� 1���, 1�� ���� �� ��¥�� ����Ͻÿ�
--����, �ĳ�, ����
SELECT 
    SYSDATE,
    ADD_MONTHS(SYSDATE, 12),
    ADD_MONTHS(SYSDATE, -12)
FROM DUAL;

--NEXT_DAY : ��¥�� �������� ������ ���� ������ ��ȯ
--������ 1 : �Ͽ��� ~ 7 : �����
SELECT NEXT_DAY(SYSDATE, '�����'),
NEXT_DAY(SYSDATE, '��'),
NEXT_DAY(SYSDATE, 7)
FROM DUAL;

SELECT NEXT_DAY(SYSDATE, 'MONDAY')
FROM DUAL;

SELECT *
FROM NLS_SESSION_PARAMETERS;
ALTER SESSION SET NLS_LANGUAGE = 'KOREAN';

--LAST_DAY : �ش� ���� ������ ��¥�� ��ȯ
SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM DUAL;

--4���޿��� ���ϵ��� �ٹ��� �ؾ� �ұ��? (�ָ� ��, �� ����)
SELECT LAST_DAY(SYSDATE) - SYSDATE
FROM DUAL;

--���� ��������, �������� �ٹ� �Ⱓ�� ���Ͻÿ�.
--������, ���ó�¥, ��볯¥, ����, ���, ���(���� �Ⱓ)
--��, �⵵ ���� ��� �Ҽ��� ������ ��� ���� �Ͻÿ�
SELECT EMP_NAME, SYSDATE, HIRE_DATE,
    TRUNC(SYSDATE - HIRE_DATE) AS "��",
    TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS "��",
    TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) AS "��"
FROM EMPLOYEE;


--EXTRACT : ��, ��, �� ������ �����ϴ� �Լ�
SELECT 
    EXTRACT(YEAR FROM SYSDATE),
    EXTRACT(MONTH FROM SYSDATE),
    EXTRACT(DAY FROM SYSDATE)
FROM DUAL;

--���� �������� �������� �Ի� �⵵, �Ի��, �Ի����� ����Ͻÿ�
--�̸�, ��, ��, ��, �Ի�����(�⺻��) 
--��, �̸��� ������������ �����Ͽ� ���
SELECT EMP_NAME AS "�̸�", 
    EXTRACT(YEAR FROM HIRE_DATE) AS "��",
    EXTRACT(MONTH FROM HIRE_DATE) AS "��",
    EXTRACT(DAY FROM HIRE_DATE) AS "��",
    HIRE_DATE AS "�Ի�����"
FROM EMPLOYEE
ORDER BY EMP_NAME DESC;


--===================================
--����ȯ �Լ�
--TO_CHAR : ���� -> ����, ����Ʈ -> ����
--���� -> ���ڷ� ����Ǵ� ���
--ȭ�� ��ų�, �ݾ� ������ ','
SELECT TO_CHAR(12345), 12345 "TESTTESTTEST" 
FROM DUAL;
SELECT 
    TO_CHAR(2000000, 'L9999999999'),
    TO_CHAR(2000000, 'L0000000000'),
    TO_CHAR(2000000, 'L9,999,999,999'),
    TO_CHAR(2000000, '$9,999,999,999')
FROM DUAL;

SELECT *
FROM NLS_SESSION_PARAMETERS;
ALTER SESSION SET NLS_LANGUAGE = 'KOREAN';

--�������� ���ʽ��� ���Ե� �޿��� ����Ͻÿ�
--���� ��, �޿�(��2,000,000)
--���ʽ��� ���� ������ �޿��� ��� �Ͻÿ�(NVL)
SELECT 
    EMP_NAME,
    TO_CHAR(SALARY + SALARY * NVL(BONUS, 0), 'L999,999,999,999') "�޿�"
FROM EMPLOYEE;

--�������� ���ʽ��� ���Ե� �޿��� ����Ͻÿ�
--���� ��, �޿�(��2,000,000)
--���ʽ��� �ִ� ������ ��� �Ͻÿ�
SELECT 
    EMP_NAME,
    TO_CHAR(SALARY + SALARY * BONUS, 'L999,999,999,999') AS �޿�
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;


--��¥ -> ����
SELECT SYSDATE,
    TO_CHAR(SYSDATE, 'YYYYMMDD HHMISS') AS "�ð�1",
    TO_CHAR(SYSDATE, 'YYYY') AS "�⵵",
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS "�ð�2",
    TO_CHAR(SYSDATE, 'YYYY-MM-DD Q"�б�"') AS "�ð�3"
FROM DUAL;

--TO_DATE : ����Ÿ���� �����͸� ����Ʈ Ÿ������ ��ȯ
SELECT 
    TO_DATE('02/01/01', 'YY/MM/DD') "Ÿ��1",
    TO_CHAR(TO_DATE('02/01/01', 'YY/MM/DD'),'YYYY MM DD') "Ÿ��2",
    TO_DATE('020303','YYMMDD') "Ÿ��3",
    TO_DATE('180403 0750', 'YYMMDD HHMI') "Ÿ��4",
    TO_CHAR(TO_DATE('180403 0750', 'YYMMDD HHMI'), 'HH24:MI') "�ð�"
FROM DUAL;

--YY - ���� ���⸦ �������� �⵵�� ����
--RR - ���簡 50�⵵ ���� -> 50���� ū �⵵�� �Է� �ɰ�� �����⸦ �������� ����
--                                        50���� ���� ��쿣 ���� ���⸦ �������� ����
SELECT 
    TO_CHAR(TO_DATE('980303','YYMMDD'),'YYYY'),
    TO_CHAR(TO_DATE('980303','RRMMDD'),'YYYY'),
    TO_CHAR(TO_DATE('100303','YYMMDD'),'YYYY'),
    TO_CHAR(TO_DATE('100303','RRMMDD'),'YYYY')
FROM DUAL;

--TO_NUMBER : ����->����
SELECT TO_NUMBER('5555') + 5
FROM DUAL;

--NVL : ���� üũ�Ͽ� ���� ��� ������ ������ ��ȯ
SELECT BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;

--�����Լ� -> ���ǹ�
--DECODE, CASE
--J5	����
--J6	�븮
--J7	���
--����� ������ ���
--�̸�, ��å�ڵ�, ��å (J7 - ���, J6 - �븮, J5 - ����, �׿� ����)
--SWITCH - DECODE(Ȯ�ΰ�, "��1", "ó����1", "��2", "ó����2", "��3", "ó����3","�׿��� ��� ó����")
SELECT 
    EMP_NAME,JOB_CODE,
    DECODE(JOB_CODE, 'J7', '���', 'J6', '�븮', 'J5', '����', '�׿� ����') "��å"
FROM EMPLOYEE;

--����� ������ ���
--�̸�, ��å�ڵ�, ��å(J7 - '���', '����� �ƴմϴ�')
SELECT 
    EMP_NAME, JOB_CODE,
    DECODE(JOB_CODE, 'J7','���','����� �ƴմϴ�') "��å"
FROM EMPLOYEE;


--CASE -> IF�� ���
--CASE WHEN ���ǽ� THEN ó����, ��°�
--          WHEN ���ǽ�2 THEN ó����, ��°�2
--                                ...........
--          [ELSE �׿� ������ ��� ó����, ��°�]
--          END

--�޿��� 200���� ������ ���  - ���� �޿�
--�޿��� 200 ~ 400 �� ��� - ��� �޿�
--�޿��� 400���� �̻� �ϰ�� - ���� �޿�
--�޿�, �޿�����
SELECT SALARY,
    CASE WHEN SALARY <= 2000000 THEN '���� �޿�'
              WHEN 2000000 < SALARY AND SALARY < 4000000 THEN '��� �޿�'
              WHEN 4000000 <= SALARY THEN '�����޿�' END "�޿�����"
FROM EMPLOYEE;

--���ʽ��� �����Ϸ� �մϴ�.
--�޿��� 200���� ������ ������� �޿��� 100%
--�׿� �������� 50% �� ���ʽ��� �����Ϸ� �մϴ�.
--�����̸�, �޿�, ���ʽ� �ݾ�
--���ʽ� �ݾ��� ������������ �����Ͽ� ���
SELECT EMP_NAME, SALARY,
    CASE WHEN SALARY <= 2000000 THEN SALARY
              ELSE SALARY * 0.5 END "���ʽ�"
FROM EMPLOYEE
ORDER BY "���ʽ�" DESC;


--�̸����� �������� ���� �� �̸��� ���� ��� ������ ������������ �����Ͻÿ�
--ORDER BY NAME DESC, AGE ASC;























SELECT *
FROM NLS_SESSION_PARAMETERS;






























