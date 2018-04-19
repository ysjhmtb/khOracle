--TOP-N �м� ����
--���� ��� �߷����� ����
--�������� �̸�, �μ��ڵ�, �����ڵ�
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

--���� ������ �̸��� ������������ �����Ͽ� ������ ��ȸ �� 5������ ���
SELECT ROWNUM, EMP_NAME, DEPT_CODE, JOB_CODE
FROM( SELECT EMP_NAME, DEPT_CODE, JOB_CODE
            FROM EMPLOYEE
            ORDER BY EMP_NAME)
WHERE ROWNUM <= 5;

--RANK() OVER (���� ����)
--���� ������ ��ȸ -> �޿��� ���� �޴� ������� ���
--(�̸�, �ֹε�Ϲ�ȣ, �����ڵ�, �޿�, ����)
SELECT EMP_NAME, EMP_NO, JOB_CODE, SALARY,
              RANK() OVER (ORDER BY SALARY DESC) "����"
FROM EMPLOYEE;

--���� ������ ��ȸ -> �޿��� ���� �޴� ������� ���
--(�̸�, �ֹε�Ϲ�ȣ, �����ڵ�, �޿�, ����) -> 5��° ���� ���
SELECT *
FROM 
(SELECT EMP_NAME, EMP_NO, JOB_CODE, SALARY,
              RANK() OVER (ORDER BY SALARY DESC) "����"
FROM EMPLOYEE)
WHERE ���� <= 5;

--���� ������ ��ȸ -> �޿��� ���� �޴� ������� ���
--(�̸�, �ֹε�Ϲ�ȣ, �����ڵ�, �޿�, ����)
SELECT EMP_NAME, EMP_NO, JOB_CODE, SALARY,
              DENSE_RANK() OVER (ORDER BY SALARY DESC) "����"
FROM EMPLOYEE;

--������ ������ ������������ �����Ͽ� ������ ���(RANK())
--������, �ֹε�Ϲ�ȣ, ����, �μ���, ���޸�, �Ի�⵵(YYYY)
SELECT E.EMP_NAME, E.EMP_NO,
              EXTRACT (YEAR FROM SYSDATE) 
              - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "����",
              D.DEPT_TITLE,
              J.JOB_NAME,
              EXTRACT (YEAR FROM HIRE_DATE) "�Ի�⵵",
              RANK() OVER (ORDER BY TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')) "����"
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
     AND E.JOB_CODE = J.JOB_CODE;


--WITH - ���� ���� �� �ӽ� ���̺��� ���� ��ó�� ���̺�ó�� ��밡�� �� ��

--�������� �̸�, ����, �޿�, ���޸�, �μ����� ��ȸ
--�̸��� ������������ ���� �� ������ ����
SELECT E.EMP_NAME, 
              EXTRACT (YEAR FROM SYSDATE) 
              - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "AGE",
              E.SALARY,
              J.JOB_NAME,
              D.DEPT_TITLE,
              RANK() OVER (ORDER BY E.EMP_NAME) "INDEX"
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_CODE = J.JOB_CODE
     AND E.DEPT_CODE = D.DEPT_ID(+);
     
--���̰� 30~35 ������ �������� ������ ��ȸ
--�������� �̸�, ����, �޿�, ���޸�, �μ����� ��ȸ
SELECT *
FROM (SELECT E.EMP_NAME, 
                          EXTRACT (YEAR FROM SYSDATE) 
                          - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "AGE",
                          E.SALARY,
                          J.JOB_NAME,
                          D.DEPT_TITLE,
                          RANK() OVER (ORDER BY E.EMP_NAME) "INDEX"
            FROM EMPLOYEE E, JOB J, DEPARTMENT D
            WHERE E.JOB_CODE = J.JOB_CODE
                 AND E.DEPT_CODE = D.DEPT_ID(+))
WHERE AGE BETWEEN 30 AND 35;

WITH NAME_ORDER_INFO AS (SELECT E.EMP_NAME, 
                                                              EXTRACT (YEAR FROM SYSDATE) 
                                                              - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "AGE",
                                                              E.SALARY,
                                                              J.JOB_NAME,
                                                              D.DEPT_TITLE,
                                                              RANK() OVER (ORDER BY E.EMP_NAME) "INDEX"
                                                FROM EMPLOYEE E, JOB J, DEPARTMENT D
                                                WHERE E.JOB_CODE = J.JOB_CODE
                                                     AND E.DEPT_CODE = D.DEPT_ID(+))
SELECT *
FROM NAME_ORDER_INFO;

--������ �λ����� ����� ���� �μ��� �������� ��� ���̸� ���Ͻÿ�
--������ ������ ���� WITH�� �̿��Ͽ� �ذ�
WITH NAME_ORDER_INFO AS (SELECT E.EMP_NAME, 
                                                              EXTRACT (YEAR FROM SYSDATE) 
                                                              - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "AGE",
                                                              E.SALARY,
                                                              J.JOB_NAME,
                                                              D.DEPT_TITLE,
                                                              RANK() OVER (ORDER BY E.EMP_NAME) "INDEX"
                                                FROM EMPLOYEE E, JOB J, DEPARTMENT D
                                                WHERE E.JOB_CODE = J.JOB_CODE
                                                     AND E.DEPT_CODE = D.DEPT_ID(+))
SELECT AVG(AGE)
FROM NAME_ORDER_INFO E1
WHERE E1.DEPT_TITLE IN (SELECT E2.DEPT_TITLE
                                            FROM NAME_ORDER_INFO E2
                                            WHERE JOB_NAME = '�λ���');

--��(ȣ��)������ - �ٱ� ������ ���� ���������� ����� ������ ��ġ�� ��
--������ ����� EMPLOYEE ���̺� �����ϴ� ������ ���� ��ȸ
SELECT *
FROM EMPLOYEE E
WHERE EXISTS (SELECT *
                            FROM EMPLOYEE MANAGER
                            WHERE E.MANAGER_ID = MANAGER.EMP_ID);


--��Į�� �������� - ������� + ������ �������� -> ��ȸ ����� �Ѱ�(���, �ʵ� ��)
--�ش� ���� �������� �޿� ���(�ʸ�����) ���� ���� �޿��� �޴� ���� ���
--���� �̸�, �����ڵ�, �޿�
SELECT E1.EMP_NAME, E1.JOB_CODE, E1.SALARY
FROM EMPLOYEE E1
WHERE E1.SALARY > (SELECT AVG(SALARY)
                                         FROM EMPLOYEE E2
                                        WHERE E2.JOB_CODE = E1.JOB_CODE);

--������, �μ��ڵ�, �μ���
SELECT EMP_NAME, DEPT_CODE, (SELECT DEPT_TITLE 
                                                            FROM DEPARTMENT
                                                           WHERE DEPT_ID = DEPT_CODE) "�μ���"
FROM EMPLOYEE;


--> ��������, �������
--131. �ش� ������ ���� �μ��� ��� �޿����� ���� 
--�޿��� �޴� �������� ������ ��ȸ
--������, �μ���, ��å��, �޿�, ������, ������
--������ �������� ���� 
--(�������)
SELECT E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, E.SALARY, L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE E.SALARY > (SELECT AVG(E1.SALARY)
                                       FROM EMPLOYEE E1
                                       WHERE NVL(E.DEPT_CODE,'EMPTY') = NVL(E1.DEPT_CODE, 'EMPTY'))
ORDER BY EMP_NAME;

--92.���ʽ��� 30% �̻� �޴� ������ �μ��� ���� ���� ������ ���Ͻÿ�
--���, �̸�, ����, EMAIL, ��ȭ��ȣ
--������ �������� ����
--(�������)
SELECT E.EMP_ID, E.EMP_NAME, 
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) "����",
            E.EMAIL, PHONE
FROM EMPLOYEE E
WHERE EXISTS (SELECT *
                               FROM EMPLOYEE E2
                             WHERE NVL(E2.DEPT_CODE,'EMPTY') = NVL(E.DEPT_CODE,'EMPTY')
                                  AND E2.BONUS >= 0.3)
ORDER BY "����";

--(��������)
SELECT E1.EMP_ID, E1.EMP_NAME, 
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(E1.EMP_NO, 1, 2), 'RR')) "����",
            E1.EMAIL, E1.PHONE
FROM EMPLOYEE E1
WHERE E1.DEPT_CODE IN (SELECT E2.DEPT_CODE
                                            FROM EMPLOYEE E2
                                            WHERE E2.BONUS >= 0.3)
ORDER BY "����";


--73.�μ��� �Ի����� ���� ���� ����� 
-- ���, �̸�, �μ���(NULL�̸� '�ҼӾ���'), ���޸�, �Ի����� ��ȸ�ϰ�
-- �Ի����� ���� ������ ��ȸ�ϼ���
-- ��, ����� ������ �����ϰ� ��ȸ�ϼ���
--(�������)
SELECT E.EMP_ID, E.EMP_NAME, 
            NVL(D.DEPT_TITLE,'�μ�����') "�μ���",
            J.JOB_NAME, E.HIRE_DATE
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
     AND E.JOB_CODE = J.JOB_CODE
     AND HIRE_DATE = (SELECT MIN(E1.HIRE_DATE)
                                        FROM EMPLOYEE E1
                                        WHERE NVL(E.DEPT_CODE,'Ȯ�ΰ�') = NVL(E1.DEPT_CODE,'Ȯ�ΰ�')
                                              AND E1.ENT_YN = 'N');
--(��������)
SELECT E.EMP_ID, E.EMP_NAME, NVL(D.DEPT_TITLE,'�ҼӾ���') "�μ���",
                J.JOB_NAME, E.HIRE_DATE
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J USING (JOB_CODE)
WHERE (NVL(E.DEPT_CODE,'EMPTY'), E.HIRE_DATE) IN (SELECT NVL(DEPT_CODE,'EMPTY'), MIN(HIRE_DATE)
                                                                                            FROM EMPLOYEE
                                                                                            WHERE ENT_YN = 'N'
                                                                                            GROUP BY DEPT_CODE)
ORDER BY E.HIRE_DATE;

--74.���޺� ���̰� ���� � ������
-- ���, �̸�, ���޸�, ����, ���ʽ� ���� ������ ��ȸ�ϰ�
-- ���̼����� �������� �����ϼ���
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME,
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) "����",
            (E.SALARY + E.SALARY * NVL(E.BONUS, 0)) * 12 "����"
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
     AND TO_DATE(SUBSTR(E.EMP_NO, 1, 2),'RR') = (SELECT MAX(TO_DATE(SUBSTR(E1.EMP_NO, 1, 2),'RR'))
                                                                                    FROM EMPLOYEE E1
                                                                                    WHERE E.JOB_CODE = E1.JOB_CODE)
ORDER BY "����" DESC;
--���޺� ���̰� ���� � ������
-- ���, �̸�, ���޸�, ����, ���ʽ� ���� ������ ��ȸ�ϰ�
-- ���̼����� �������� �����ϼ���
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, 
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) "����",
            (E.SALARY + E.SALARY * NVL(E.BONUS, 0)) * 12 AS "����"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE (E.JOB_CODE, TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) IN (SELECT E1.JOB_CODE, MAX(TO_DATE(SUBSTR(E1.EMP_NO, 1, 2), 'RR'))
                                                                                                                FROM EMPLOYEE E1
                                                                                                            GROUP BY  E1.JOB_CODE)
ORDER BY "����" DESC;


--1. �ش� ������ ���� �μ��� ��� �޿�  ���� ���� 
--�޿��� �޴� �������� ������ ��ȸ
--������, �μ���, ��å��, �޿�, ������, ������
--������ �������� ���� 
SELECT E.EMP_NAME, NVL(D.DEPT_TITLE,'�ҼӾ���') AS "�μ���",
            J.JOB_NAME, E.SALARY, 
            NVL(L.LOCAL_NAME,'�ҼӾ���'), 
            NVL(N.NATIONAL_NAME,'�ҼӾ���')
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND E.JOB_CODE = J.JOB_CODE
    AND D.LOCATION_ID = L.LOCAL_CODE(+)
    AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
    AND E.SALARY > (SELECT AVG(E1.SALARY)
                                    FROM EMPLOYEE E1
                                    WHERE NVL(E1.DEPT_CODE,'EMPTY') 
                                            = NVL(E.DEPT_CODE,'EMPTY'))
ORDER BY E.EMP_NAME;

--2.���ʽ��� 30% �̻� �޴� ������ �μ�  �� ���� ���� ������ ���Ͻÿ�
--���, �̸�, ����, EMAIL, ��ȭ��ȣ
--������ �������� ����
SELECT E.EMP_ID, E.EMP_NAME,
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT ( YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "����",
            E.EMAIL, E.PHONE
FROM EMPLOYEE E
WHERE EXISTS (SELECT *
                                FROM EMPLOYEE E1
                                WHERE BONUS >= 0.3
                                    AND NVL(E1.DEPT_CODE,'EMPTY') = NVL(E.DEPT_CODE,'EMPTY'))
ORDER BY "����" ASC;

--3.�μ��� �Ի����� ���� ���� ����� 
-- ���, �̸�, �μ���(NULL�̸� '�ҼӾ���'), ���޸�, �Ի����� ��ȸ�ϰ�
-- �Ի����� ���� ������ ��ȸ�ϼ���
-- ��, ����� ������ �����ϰ� ��ȸ�ϼ���

SELECT E.EMP_ID, E.EMP_NAME, NVL(D.DEPT_TITLE,'�ҼӾ���'),
            J.JOB_NAME, E.HIRE_DATE
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND E.JOB_CODE = J.JOB_CODE
    AND (NVL(E.DEPT_CODE,'EMPTY'), E.HIRE_DATE)  
                    IN (SELECT NVL(E1.DEPT_CODE,'EMPTY'), MIN(E1.HIRE_DATE)
                            FROM EMPLOYEE E1
                           WHERE E1.ENT_YN = 'N'
                            GROUP BY E1.DEPT_CODE);
                            
                            
--4.���޺� ���̰� ���� � ������
-- ���, �̸�, ���޸�, ����, ���ʽ� ���� ������ ��ȸ�ϰ�
-- ���̼����� �������� �����ϼ���
SELECT E.EMP_ID, E.EMP_NAME, JOB_NAME,
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT ( YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "����",
            (SALARY + NVL(BONUS, 0) * SALARY) * 12 AS "����"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE TO_DATE(SUBSTR(E.EMP_NO, 1, 2),'RR') = (SELECT MAX(TO_DATE(SUBSTR(E1.EMP_NO, 1, 2),'RR'))
                                                                                    FROM EMPLOYEE E1
                                                                                WHERE E.JOB_CODE = E1.JOB_CODE)
ORDER BY "����" DESC;
















