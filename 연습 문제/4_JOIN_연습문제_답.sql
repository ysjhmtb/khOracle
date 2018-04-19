--JOIN ��������
--1. 2020�� 12�� 25���� ���� �������� ��ȸ�Ͻÿ�.
SELECT TO_CHAR(TO_DATE('20201225','YYYYMMDD'), 'DY, DAY') "����"
FROM DUAL;

--2. �ֹι�ȣ�� 70��� ���̸鼭 ������ �����̰�, ���� ������ �������� 
--�����, �ֹι�ȣ, �μ���, ���޸��� ��ȸ�Ͻÿ�.
SELECT E.EMP_NAME, E.EMP_NO, D.DEPT_TITLE, J.JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE SUBSTR(E.EMP_NO, 1, 1) = '7' 
  AND SUBSTR(E.EMP_NO, 8, 1) = '2'
  AND E.EMP_NAME LIKE '��%';

--3. ���� ���̰� ���� ������ ���, �����, ����, �μ���, ���޸��� ��ȸ�Ͻÿ�.
SELECT EMP_ID, EMP_NAME,
       TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'))/12)"����",
       DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE EMP_NO = (SELECT MAX(EMP_NO)
                FROM EMPLOYEE);

--3. �� �μ��� 60~90 ��� �� �ο��� ���� �� ��� ���� ���Ͽ���
--�μ�, ����, �ο��� ��� �� �μ��ڵ��� �������� ���� �� ���� ���� ���� �Ͻÿ�
SELECT DEPT_CODE AS "�μ�", TO_NUMBER(SUBSTR(EMP_NO, 1, 1)) * 10 || '���' AS "����", COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, SUBSTR(EMP_NO, 1, 1)
ORDER BY "�μ�", "����";


--4. �̸��� '��'�ڰ� ���� �������� ���, �����, �μ����� ��ȸ�Ͻÿ�.
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE EMP_NAME LIKE '%��%';


--5. �ؿܿ������� �ٹ��ϴ� �����, ���޸�, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�.
SELECT E.EMP_NAME, J.JOB_NAME, D.DEPT_ID, D.DEPT_TITLE 
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE D.DEPT_TITLE LIKE '�ؿܿ���%';

--6. ���ʽ�����Ʈ�� �޴� �������� �����, ���ʽ�����Ʈ, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
SELECT E.EMP_NAME, E.BONUS, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE BONUS != 0 AND BONUS IS NOT NULL;


--7. �μ��ڵ尡 D2�� �������� �����, ���޸�, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
SELECT E.EMP_NAME, J.JOB_NAME, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE E.DEPT_CODE = 'D2';

--8. ������ �ּұ޿�(MIN_SAL)���� ���� �޴� ��������
--�����, ���޸�, �޿�, ������ ��ȸ�Ͻÿ�.
--������ ���ʽ�����Ʈ�� �����Ͻÿ�.
SELECT E.EMP_NAME, J.JOB_NAME, SALARY, SALARY + (SALARY * NVL(BONUS, 0)) * 12 AS "����"
FROM EMPLOYEE E
JOIN SAL_GRADE S ON (E.SAL_LEVEL = S.SAL_LEVEL AND S.MIN_SAL < E.SALARY)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

--9. �ѱ�(KO)�� �Ϻ�(JP)�� �ٹ��ϴ� �������� 
--�����, �μ���, ������, �������� ��ȸ�Ͻÿ�.
SELECT E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME ,N.NATIONAL_NAME
FROM EMPLOYEE E 
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (L.LOCAL_CODE = D.LOCATION_ID)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE L.NATIONAL_CODE IN ('KO', 'JP');

--10. ���� �μ��� �ٹ��ϴ� �������� �����, �μ��ڵ�, �����̸��� ��ȸ�Ͻÿ�.
--self join ���
SELECT E1.EMP_NAME, E1.DEPT_CODE, E2.EMP_NAME
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON (E1.DEPT_CODE = E2.DEPT_CODE);

--11. ���ʽ�����Ʈ�� ���� ������ �߿��� �����ڵ尡 J4�� J7�� �������� �����, ���޸�, �޿��� ��ȸ�Ͻÿ�.
--��, join�� IN ����� ��
SELECT E.EMP_NAME, J.JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.BONUS IS NOT NULL
  AND E.JOB_CODE IN ('J4', 'J7');

--12. �������� ������ ����� ������ ���� ��ȸ�Ͻÿ�.
SELECT DECODE(ENT_YN,'Y','���','����') AS "����", COUNT(*)
FROM EMPLOYEE
GROUP BY ENT_YN;
