--�Լ� ��������
--
--1. ������� �ֹι�ȣ�� ��ȸ��
--  ��, �ֹι�ȣ 9��° �ڸ����� �������� '*'���ڷ� ä��
--  �� : ȫ�浿 771120-1******
SELECT EMP_NAME, 
            RPAD(SUBSTR(EMP_NO, 1, 8), LENGTH(EMP_NO), '*')
FROM EMPLOYEE;

--2. ������, �����ڵ�, ����(��) ��ȸ
--  ��, ������ ��57,000,000 ���� ǥ�õǰ� ��
--     ������ ���ʽ�����Ʈ�� ����� 1��ġ �޿���
SELECT EMP_NAME, JOB_CODE, 
            TO_CHAR((SALARY + SALARY * NVL(BONUS,0)) * 12, 'L999,999,999,999') AS "����"
FROM EMPLOYEE;

--3. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� ������ 
--   �� ��ȸ��.
--   ��� ����� �μ��ڵ� �Ի���
SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9')
     AND TO_CHAR(HIRE_DATE,'YYYY') = '2004';

--4. ������, �Ի���, �Ի��� ���� �ٹ��ϼ� ��ȸ
--   ��, �ָ��� ������
SELECT EMP_NAME, HIRE_DATE, 
              LAST_DAY(HIRE_DATE) - HIRE_DATE + 1
FROM EMPLOYEE;

--5. ������, �μ��ڵ�, �������, ����(��) ��ȸ
--   ��, ��������� �ֹι�ȣ���� �����ؼ�, 
--   ������ ������ �����Ϸ� ��µǰ� ��.
--   ���̴� �ֹι�ȣ���� �����ؼ� ��¥�����ͷ� ��ȯ�� ����, �����
--   ��, ��¥�� �̻��ϰ� �Էµ� 200, 201, 214 �ο��� ���� �� ��ȸ
SELECT EMP_NAME, DEPT_CODE, 
            SUBSTR(EMP_NO, 1, 2) || '��' 
            || SUBSTR(EMP_NO, 3, 2) || '��' 
            || SUBSTR(EMP_NO, 5, 2) || '��' AS "�������",
            EXTRACT (YEAR FROM SYSDATE) - 
            EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD')) AS "�� ����"
FROM EMPLOYEE
WHERE EMP_ID NOT IN ('200', '201', '214');


--6. �������� �Ի��Ϸ� ���� �⵵�� ������, �� �⵵�� �Ի��ο����� ���Ͻÿ�.
--  �Ʒ��� �⵵�� �Ի��� �ο����� ��ȸ�Ͻÿ�.
--  => to_char, decode, sum ���
--
--	-------------------------------------------------------------
--	��ü������   2001��   2002��   2003��   2004��
--	-------------------------------------------------------------
SELECT COUNT(*) AS "��ü �ο���",
              SUM(DECODE(TO_CHAR(HIRE_DATE, 'MM'),'09',1,0)) AS "2001��",
              SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2002',1,0)) AS "2002��",
              SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2003',1,0)) AS "2003��",
              SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2004',1,0)) AS "2004��"
FROM EMPLOYEE;

SELECT COUNT(*) AS "��ü �ο���",
              COUNT(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2001',1)) AS "2001��",
              COUNT(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2002',1)) AS "2002��",
              COUNT(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2003',1)) AS "2003��",
              COUNT(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'),'2004',1)) AS "2004��"
FROM EMPLOYEE;


--��ü �ο��� �μ��� ���� ��� �Ͻÿ�
--��ü ī��Ʈ, ���� �ƴ� ī��Ʈ, �ߺ� ���� �� ī��Ʈ
SELECT COUNT(*), COUNT(DEPT_CODE), COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

--7.  �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ��
--  => case ���
--   �μ��ڵ� ���� �������� ������.
SELECT 
    DEPT_CODE,
    CASE WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
                        WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
                        WHEN DEPT_CODE = 'D9' THEN '������' END AS "�μ���"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY DEPT_CODE;














