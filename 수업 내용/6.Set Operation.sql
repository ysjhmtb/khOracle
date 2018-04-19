--set opertion : union, union all, minus, intersect
--union : ������ ���� ����� �ϳ��� ��ģ��. �ߺ��� ���� �����Ѵ�.
--�μ� ��ȣ�� D5�� ������ ��ȸ
--6
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--�޿��� 300���� �̻��� �������� ��ȸ
--8
SELECT *
FROM EMPLOYEE
WHERE 3000000 <= SALARY;

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE 3000000 <= SALARY;


--UNION ALL : ������ ���� ����� ��ĥ��, �ߺ��� ���� ����Ѵ�.
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE 3000000 <= SALARY;

--1. ��ȭ��ȣ�� NULL�� �������� �̸�, ��ȭ��ȣ, �μ���ȣ, �޿�
--2. �μ���ȣ�� D8�� �������� ����(�̸�, ��ȭ��ȣ, �μ���ȣ, �޿�)
--3. �޿��� 500���� ������ �������� ����(�̸�, ��ȭ��ȣ, �μ���ȣ, �޿�)
--UNION
SELECT EMP_NAME, PHONE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE PHONE IS NULL
UNION
SELECT EMP_NAME, PHONE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D8'
UNION
SELECT EMP_NAME, PHONE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY <= 5000000;


--UNION ALL
SELECT EMP_NAME, PHONE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE PHONE IS NULL
UNION ALL
SELECT EMP_NAME, PHONE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D8'
UNION ALL
SELECT EMP_NAME, PHONE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY <= 5000000;

--INTERSECT : ���տ����� ������,
--                     �������� SELECT���� �������� ROW���� ���
--���� �ִ� SELECT�� �Ʒ� �ִ� SELECT���� ��� �� ��ġ�� �׸���� ���
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE 3000000 <= SALARY;

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE 3000000 <= SALARY
INTERSECT
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE EMP_NAME = '���ȥ';

--MINUS : ���տ����� �����հ� ���� �����̴�
--              ó���� ��ȸ�� �׸��� �������� �Ʒ��� ��ȸ�� �׸�� ��ġ�� �κ��� ���� �� �� ���
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE 3000000 <= SALARY;



SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE 3000000 <= SALARY
MINUS
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';


--�����ϴ� �Ŵ����� �ִ� ������ �߿� ������ J7�� �ƴ� ������� ��ȸ�Ͻÿ�
--WHERE
SELECT *
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL 
    AND JOB_CODE != 'J7';


--SET OPERATION(MINUS)
SELECT *
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL
MINUS
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE = 'J7';


--GROUPING SET : ���� �׷��� �˻� ����� ���ļ� ���
--19
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID;
--15
SELECT DEPT_CODE, '���ڵ� ����',  MANAGER_ID, TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE, MANAGER_ID;
--19
SELECT '�μ��ڵ� ����', JOB_CODE, MANAGER_ID, TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY JOB_CODE, MANAGER_ID;


SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY GROUPING SETS((DEPT_CODE, JOB_CODE, MANAGER_ID),
                                                 (DEPT_CODE, MANAGER_ID),
                                                 (JOB_CODE, MANAGER_ID));


--JOIN : �ٸ� ���̺��� ������ ���� RESULT SET�� ����Ҷ�(�ѹ��� ����ϰ��� �Ҷ�)
--           ����Ѵ�. (���̺��� ��ģ��)

SELECT *
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;


--����Ŭ ����(����Ŭ������ ��밡���ϴ�)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

--ANSIǥ�� ������ �̿��� JOIN
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);


--��� ������ ����Ѵ�.
--���, �̸�, ��å��, �Ի���
--����Ŭ ���� ����
SELECT EMPLOYEE.EMP_ID, EMPLOYEE.EMP_NAME, JOB.JOB_NAME, EMPLOYEE.HIRE_DATE
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;


--�Ƚ�ǥ��
--ON �̿��� JOIN
SELECT EMP.EMP_ID, EMP.EMP_NAME, J.JOB_NAME, EMP.HIRE_DATE, JOB_CODE
FROM EMPLOYEE EMP 
JOIN JOB J ON (EMP.JOB_CODE = J.JOB_CODE);

--USING �̿��� JOIN
SELECT EMP.EMP_ID, EMP.EMP_NAME, J.JOB_NAME, EMP.HIRE_DATE, JOB_CODE
FROM EMPLOYEE EMP 
JOIN JOB J USING (JOB_CODE);


--'L4'�� ���� ������ ����Ϸ��� �մϴ�.
--�ش� ������ ���� ��, �����ڵ�, ������ 
--�Ƚ�ǥ��
SELECT LOCAL_NAME, NATIONAL_CODE, NATIONAL_NAME
FROM LOCATION
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE LOCAL_CODE = 'L4';

--����Ŭ
--�ش� ������ ���� ��, �����ڵ�, ������ 
SELECT L.LOCAL_NAME, L.NATIONAL_CODE, N.NATIONAL_NAME 
FROM LOCATION L, NATIONAL N
WHERE L.NATIONAL_CODE = N.NATIONAL_CODE
    AND L.LOCAL_CODE = 'L4';
    

--INNER JOIN - ���� ������ ���� ���� ��츸 ��ȸ ��
--OUTER JOIN - ���������� �����Ͱ� �Ϻθ� ���� �Ұ��, 
--                      ���� ���̺��� ������ �׻� �����Ͽ� ��ȸ �Ҷ� ���

--��� ������ ������ ����Ϸ��� �Ѵ�. 
--������, �̸���, ��ȭ��ȣ, �μ���
--����Ŭ OUTER JOIN
SELECT E.EMP_NAME, E.EMAIL, E.PHONE, D.DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+);


--�Ƚ�ǥ�� �ƿ��� ����
SELECT * 
FROM DEPARTMENT D
RIGHT JOIN EMPLOYEE E ON (E.DEPT_CODE = D.DEPT_ID);

SELECT * 
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);


--ũ�ν� ���� : (ī���̼� �� AXB) 
--                  �� ���̺��� ��ĥ�� ���ü� �ִ� ��� ��� �׸��� ���
SELECT *
FROM LOCATION, NATIONAL;


SELECT *
FROM LOCATION
CROSS JOIN NATIONAL;

--NON-EQUI-JOIN : ���� ���ν��� �����ϴ� ���̾ƴ�, 
--                                ���ǽ��� �̿��Ͽ� JOIN ������ ����
--������ �޿���޿� �´� �޿��� �ް��ִ� ������ ������ ����Ͻÿ�
--������, �޿����, ����޿�, �ش�޿������ �����޿�/�ְ�޿�
--ANSI
SELECT E.EMP_NAME, E.SAL_LEVEL, E.SALARY, S.MIN_SAL || '/'|| S.MAX_SAL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON (
E.SAL_LEVEL = S.SAL_LEVEL AND
E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

--ORACLE
SELECT E.EMP_NAME, E.SAL_LEVEL, S.SAL_LEVEL, E.SALARY, S.MIN_SAL || '/'|| S.MAX_SAL
FROM EMPLOYEE E, SAL_GRADE S
WHERE E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

--SELF JOIN : ���� ���̺��� ������ �Ͽ� ����� ��ȸ ��
--���� ������ ����ϰ� ��
--���� �̸�, �Ŵ��� �̸�
--ORACLE
SELECT E1.EMP_NAME AS "���� �̸�", E2.EMP_NAME AS "�Ŵ��� �̸�"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID;

--ANSI
SELECT E1.EMP_NAME AS "���� �̸�", E2.EMP_NAME AS "�Ŵ��� �̸�"
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);

--��� ���� ���� ��ȸ
--������, �Ŵ��� ��
--ANSI 
SELECT E1.EMP_NAME AS "���� �̸�", E2.EMP_NAME AS "�Ŵ��� �̸�"
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);




































































