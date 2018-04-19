--�������� : ���� �ӿ� ������ ����.
--                    --> ������ �ȿ� ������, from��, select, group by �� ���� ���� 
--                                ������ ������ �̿�Ǵ� ����

--������� ���ö �� ����� �μ� ��ȸ
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '���ö';

--'D9' �μ��� ��� ������ ���
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--���ö�� ���� �μ��� ���� ������ ����Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                     WHERE EMP_NAME = '���ö');

--������ ���� ����� �����̳� ��¿� �̿��ϴ� ��

--��ü ������ ��� �޿� // ���� �� ���� �޿��� �޴� ������ ������ ���
SELECT AVG(SALARY)
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                                FROM EMPLOYEE);

--������� �μ�//�� ���� �ִ� ���� ���� ��ȸ
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                        WHERE ENT_YN = 'Y');

--������� �μ��� ���� �ִ� ���� ���� ��ȸ
--(����ڴ� ��¿��� ����, �������� �ο��� ��ȸ)
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                        WHERE ENT_YN = 'Y')
    AND ENT_YN = 'N';
    
--���������� ����
--������ �������� : ���������� ��� ���� 1���� ������ �̷���� ������
--������ �������� : ���������� ��� ���� 1�� �̻��� ������ �̷���� ������
--���߿� �������� : ���������� ��� ���� 1�� �̻��� �÷����� �̷���� ������
--������ ���߿� �������� : ���������� ��� ���� ������, ������ �϶�
    --> �� ������ ������ ���� �տ� �ü� �ִ� �����ڰ� ���� ��
    
--������ ��������
--���߿� ��������
SELECT *
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

--������ ��������
--��Į�� ��������
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

--������ ��������
SELECT TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--������, ���߿� ��������
SELECT DEPT_CODE, TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--������ �������� : ���������� ��� ���� 1���� ��(�Ѱ��� ��)
--���ö ������ �޿�//���� ���� �޿��� �޴� ���� ��ȸ
--���, �̸�, �޿� 
--���� �޿����� ��ȸ �Ͻʽÿ�.
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME = '���ö';

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                                    FROM EMPLOYEE
                                WHERE EMP_NAME = '���ö')
ORDER BY SALARY DESC;


--���� ���� �޿�//�� �޴� ������ ������ ��� �Ͻÿ�
--���, �̸�, �μ�, ����, �޿�
SELECT MIN(SALARY)
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                                  FROM EMPLOYEE);
                                  
--�μ��� �޿��� ���� ���� ����// �μ��ڵ�, �޿��� �հ踦 ��� �Ͻÿ�
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                                                FROM EMPLOYEE
                                        GROUP BY DEPT_CODE);
                                        
                                        
--������ ��������
--�Ϲ� �� ������ <, >, <=, >= 
--ANY : ���� ���� �߿� �ϳ��� ��ġ�ϸ�
--ALL : ���� ����(���δ�) ������ �����ϸ�
--EXIST : �ش� ���ǿ� �����ϴ� ���� �ִٸ�

--�μ��� �ְ�޿�//�� �޴� ������ �̸�, ����, �޿��� ��ȸ�Ͻÿ�
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                                    FROM EMPLOYEE
                            GROUP BY DEPT_CODE);

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY = ANY(SELECT MAX(SALARY)
                                        FROM EMPLOYEE
                                GROUP BY DEPT_CODE);
                                
--�븮 ������ ������ �߿��� ���������� �ּ� �޿����� ���� �޴� ����
--���, �̸�, ����, �޿� ��ȸ
--(ANY)
SELECT SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '����';

SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '�븮'
     AND E.SALARY > ANY(SELECT SALARY
                                            FROM EMPLOYEE E
                                            JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
                                            WHERE J.JOB_NAME = '����');

--(SUBQUERY)
SELECT MIN(SALARY)
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '����';

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '�븮'
    AND E.SALARY > (SELECT MIN(SALARY)
                                    FROM EMPLOYEE E
                                      JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
                                  WHERE J.JOB_NAME = '����');
                                  
--���� ������ ������ �߿��� �븮 ������ �޿��� ���� ���� �޴� ����
--���, �̸�, ����, �޿� ��ȸ                         
--ALL
SELECT SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '�븮';

SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
     AND J.JOB_NAME = '����'
     AND E.SALARY > ALL (SELECT SALARY
                                            FROM EMPLOYEE E
                                            JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
                                            WHERE J.JOB_NAME = '�븮');


--������, ���߷� ��������
--�ڱ� ������ �޿� ��� �ݾ�//�� �޴� �������� ���� ��ȸ
SELECT JOB_CODE, TRUNC(AVG(SALARY),-5)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY),-5) 
                                                        FROM EMPLOYEE
                                                        GROUP BY JOB_CODE);

-- ����� �������� ���� �μ�, ���� ����//�� �ش��ϴ�
-- ����� �̸�, ����, �μ�, �Ի����� ��ȸ�ϼ���
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
     AND SUBSTR(EMP_NO, 8,1) = '2';
     
SELECT JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
     AND SUBSTR(EMP_NO, 8,1) = '2';     
     
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                        WHERE ENT_YN = 'Y'
                                             AND SUBSTR(EMP_NO, 8,1) = '2')
   AND JOB_CODE IN (SELECT JOB_CODE
                                        FROM EMPLOYEE
                                        WHERE ENT_YN = 'Y'
                                             AND SUBSTR(EMP_NO, 8,1) = '2');
                                             
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
                                                                FROM EMPLOYEE
                                                                WHERE ENT_YN = 'Y'
                                                                     AND SUBSTR(EMP_NO, 8,1) = '2');

-- ���� �������� ���� �� ����� �������� ���� �μ�, ���� ���޿� �ش��ϴ�
-- ����� �̸�, ����, �μ�, �Ի����� ��ȸ�ϼ���.
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
                                                                FROM EMPLOYEE
                                                                WHERE ENT_YN = 'Y'
                                                                     AND SUBSTR(EMP_NO, 8,1) = '2')
     AND ENT_YN = 'N';
     

--�������� ��ȸ
--���, �μ��ڵ�, �μ���, �޿�
--(JOIN)
SELECT E.EMP_ID, E.DEPT_CODE, D.DEPT_TITLE, E.SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID;

--(SUBQUERY - JOIN (X))
SELECT EMP_ID, DEPT_CODE, (SELECT DEPT_TITLE 
                                                    FROM DEPARTMENT
                                                    WHERE DEPT_CODE = DEPT_ID),SALARY
FROM EMPLOYEE;

--���������� ������ ��� ���� ����Ҽ� �ִ�
--SELECT, FROM, WHERE, GROUP BY(X), HAVING, ORDER BY(X)
--DML - INSERT, DELETE
--DDL - ���̺��� ���鶧, ����

--FROM ������ ���� SUBQUERY - INLINE VIEW
--�������� �̸�, ����, �μ��ڵ�, �μ���, �޿� ��ȸ
--(SUBQUERY)
SELECT EMP_NAME, 
                EXTRACT(YEAR FROM SYSDATE) - 
                EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2),'RR')) AS "AGE",
                DEPT_CODE,
                (SELECT DEPT_TITLE
                    FROM DEPARTMENT
                    WHERE DEPT_CODE = DEPT_ID) AS "DEPT_NAME",
                SALARY
FROM EMPLOYEE;

SELECT EMP_NAME, AGE, DEPT_CODE, DEPT_NAME, SALARY
FROM (SELECT EMP_NAME, 
                EXTRACT(YEAR FROM SYSDATE) - 
                EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2),'RR')) AS "AGE",
                DEPT_CODE,
                (SELECT DEPT_TITLE
                    FROM DEPARTMENT
                    WHERE DEPT_CODE = DEPT_ID) AS "DEPT_NAME",
                SALARY
            FROM EMPLOYEE) INFO;
            
--���� ������ INLINEVIEW�� �̿��Ͽ� 40���� ���� ������ ���Ͻÿ�
SELECT EMP_NAME, AGE, DEPT_CODE, DEPT_NAME, SALARY
FROM (SELECT EMP_NAME, 
                EXTRACT(YEAR FROM SYSDATE) - 
                EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2),'RR')) AS "AGE",
                DEPT_CODE,
                (SELECT DEPT_TITLE
                    FROM DEPARTMENT
                    WHERE DEPT_CODE = DEPT_ID) AS "DEPT_NAME",
                SALARY
            FROM EMPLOYEE)
WHERE AGE BETWEEN 40 AND 49;

--TOP-N �м� : ���� N ���� �׸� ��ȸ

--��� ���� ��ȸ
--���, �̸�, EMAIL, �μ��ڵ�, ��å�ڵ�, �Ի���
--ROWNUM : ����Ŭ ���ο��� �ش� ROW�� �Ҵ��ϴ� ��ȣ
SELECT ROWNUM, EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE ROWNUM <= 3;

--��� ���� ��ȸ
--���, �̸�, EMAIL, �μ��ڵ�, ��å�ڵ�, �Ի���
--�̸� �������� ����
SELECT  EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
ORDER BY EMP_NAME;

--��� ���� ��ȸ
--���, �̸�, EMAIL, �μ��ڵ�, ��å�ڵ�, �Ի���
--�̸� �������� ���� �� ���� 3���� �׸� ��ȸ
SELECT *
FROM (SELECT  EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, JOB_CODE, HIRE_DATE
                FROM EMPLOYEE
                ORDER BY EMP_NAME)
WHERE ROWNUM <= 3;


--�μ��� �޿� �հ踦 ���� �� ���� 3�� �μ��� �μ��ڵ�, �μ���, �޿��� ���
SELECT DEPT_CODE, (SELECT DEPT_TITLE 
                                        FROM DEPARTMENT
                                        WHERE DEPT_ID = DEPT_CODE) "DEPT_NAME", SALARY_SUM 
FROM (SELECT DEPT_CODE, SUM(SALARY) "SALARY_SUM"
            FROM EMPLOYEE
            GROUP BY DEPT_CODE
            ORDER BY "SALARY_SUM" DESC)            
WHERE ROWNUM <= 3;

--�޿��� ���� ������� 10���� ��� �޿��� ���Ͽ���
SELECT AVG(SALARY)
FROM (
    SELECT SALARY
    FROM EMPLOYEE
    ORDER BY SALARY)
WHERE ROWNUM <= 10;


            
            

























     
















                            


























