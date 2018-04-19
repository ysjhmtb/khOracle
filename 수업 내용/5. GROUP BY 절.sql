--GROUP BY ��
--�׷��� ������ �ۼ��ϴ� ��
SELECT DEPT_CODE, SALARY
FROM EMPLOYEE
ORDER BY DEPT_CODE;

SELECT DEPT_CODE, SUM(SALARY), COUNT(*), TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--EMPLOYEE ���̺��� �μ��ڵ�, ���ʽ��� ���޹޴� ��� ���� ��ȸ�ϰ� 
--�μ��ڵ� ������ �����ϼ���
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE;

--���޺� ��� �޿��� ��ȸ�Ͻÿ�
--����, �޿���, �ο���, ��ձ޿�(�Ҽ��� ���ϴ� ���� ó��)
SELECT JOB_CODE, SUM(SALARY), COUNT(*), FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY JOB_CODE;

--������ �����Ͽ� �޿���, �ο���, ��ձ޿� ��ȸ(�Ҽ��� 2°�ڸ� ���� �ݿø� ǥ��)
SELECT DECODE(SUBSTR(EMP_NO, 8, 1),1,'��',2,'��') AS "����", SUM(SALARY), COUNT(*), ROUND(AVG(SALARY),2) AS "��ձ޿�"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

--�μ���, ���޺� �޿��� �հ踦 ���Ͻÿ�
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE;

--�μ���, ���޺� �޿��� �հ谡 800���� �̻���, 
--�μ��� ����, �޿��� �հ踦 ���
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
HAVING 8000000 <= SUM(SALARY);


--������ 5���̻��� �μ��� �μ��ڵ�, �������� ����Ͻÿ�
--��, �������� ���� ������ ���
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING 5 <= COUNT(*);


--�¾ �⵵ ����(10�� ����) �׷��� ����������, 
--�⵵,�⵵ �� �ο��� �������, �ش� �⵵�� ��ձ޿��� �� ���� ���
--��ձ޿��� �Ҽ��� ���� ���� 
SELECT TO_NUMBER(SUBSTR(EMP_NO,1,1)) * 10 AS "���", COUNT(*), TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,1,1);

--SELECT         5
--FROM            1
--WHERE          2
--GROUP BY    3
--HAVING         4
--ORDER BY    6


SELECT DEPT_CODE, SUM(SALARY), GROUPING(DEPT_CODE)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE);

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY), GROUPING(DEPT_CODE), GROUPING(JOB_CODE)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE);


SELECT DEPT_CODE, SUM(SALARY), GROUPING(DEPT_CODE) "���迩��"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE)
ORDER BY "���迩��";

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY), GROUPING(DEPT_CODE)"��å������", GROUPING(JOB_CODE)"�μ�������"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY "��å������", "�μ�������";

--D5, D6, D9�� �μ���, ���޺� �޿��� ���� ���Ͽ���
--�����Լ��� ����Ͽ� ���յ� ǥ��(ROLLUP)
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE);


--D5, D6, D9�� �μ���, ���޺� �޿��� ���� ���Ͽ���
--�����Լ��� ����Ͽ� ���յ� ǥ��(CUBE)
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY), GROUPING(DEPT_CODE), GROUPING(JOB_CODE)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
GROUP BY CUBE(DEPT_CODE, JOB_CODE);






SELECT DEPT_CODE, JOB_CODE, SUM(SALARY), GROUPING(DEPT_CODE), GROUPING(JOB_CODE)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9')
GROUP BY CUBE(DEPT_CODE, JOB_CODE);








