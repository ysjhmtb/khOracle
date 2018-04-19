-- SCOTT �Լ� �������� 
-- COMM �� ���� NULL�� �ƴ� ���� ��ȸ
SELECT *
FROM EMP
WHERE COMM IS NOT NULL;


-- Ŀ�̼��� ���� ���ϴ� ���� ��ȸ
SELECT *
FROM EMP
WHERE COMM IS NOT NULL 
        OR COMM != 0;

-- �����ڰ� ���� ���� ���� ��ȸ
SELECT *
FROM EMP
WHERE MGR IS NULL;

-- �޿��� ���� �޴� ���� ������ ��ȸ
SELECT *
FROM EMP
ORDER BY SAL DESC;


-- �޿��� ���� ��� Ŀ�̼��� �������� ���� ��ȸ
SELECT *
FROM EMP
ORDER BY SAL DESC, COMM DESC;

-- EMP ���̺��� �����ȣ, �����,����, �Ի��� ��ȸ
-- �� �Ի����� �������� ���� ó����.
SELECT EMPNO, ENAME, JOB, HIREDATE
FROM EMP
ORDER BY HIREDATE;

-- EMP ���̺�� ���� �����ȣ, ����� ��ȸ
-- �����ȣ ���� �������� ����
SELECT EMPNO, ENAME
FROM EMP
ORDER BY EMPNO DESC;

-- ���, �Ի���, �����, �޿� ��ȸ
-- �μ���ȣ�� ���� ������, ���� �μ���ȣ�� ���� �ֱ� �Ի��ϼ����� ó��
SELECT EMPNO, DEPTNO, HIREDATE, ENAME, SAL
FROM EMP
ORDER BY DEPTNO DESC, HIREDATE DESC;

/***** �Լ� *****/
-- �ý������� ���� ���� ��¥�� ���� ������ ����� �� ��
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24MISS')
FROM DUAL;

-- EMP ���̺�� ���� ���, �����, �޿� ��ȸ
-- ��, �޿��� 100���ڸ� ������ ��� ó����.
-- �޿� ���� �������� ������.
SELECT EMPNO, ENAME, TRUNC(SAL, -2), ROUND(SAL, -2)
FROM EMP
ORDER BY SAL DESC;

-- EMP ���̺�� ���� �����ȣ�� Ȧ���� ������� ��ȸ
SELECT *
FROM EMP
WHERE MOD(EMPNO, 2) = 1;

/* ���� ó�� �Լ�*/  
-- EMP ���̺�� ���� �����, �Ի��� ��ȸ
-- ��, �Ի����� �⵵�� ���� �и� �����ؼ� ���
SELECT ENAME, TO_CHAR(HIREDATE, 'YYYY') AS "�⵵",
              TO_CHAR(HIREDATE, 'MM') AS "��"
FROM EMP;

-- EMP ���̺�� ���� 9���� �Ի��� ������ ���� ��ȸ
SELECT *
FROM EMP
WHERE TO_CHAR(HIREDATE, 'MM') = '09';

-- EMP ���̺�� ���� '81'�⵵�� �Ի��� ���� ��ȸ
SELECT *
FROM EMP
WHERE TO_CHAR(HIREDATE, 'YY') = '81';

-- EMP ���̺�� ���� �̸��� 'E'�� ������ ���� ��ȸ
SELECT *
FROM EMP
WHERE ENAME LIKE '%E';

-- emp ���̺�� ���� �̸��� ����° ���ڰ� 'R'�� ������ ���� ��ȸ
-- LIKE �����ڸ� ���
SELECT *
FROM EMP
WHERE ENAME LIKE '__R%';

-- SUBSTR() �Լ� ���
SELECT *
FROM EMP
WHERE SUBSTR(ENAME, 3, 1) = 'R';

/************ ��¥ ó�� �Լ� **************/
-- �Ի��Ϸ� ���� 40�� �Ǵ� ��¥ ��ȸ
SELECT HIREDATE, ADD_MONTHS(HIREDATE, 480)
FROM EMP;

-- �Ի��Ϸ� ���� 33�� �̻� �ٹ��� ������ ���� ��ȸ
SELECT *
FROM EMP
WHERE ADD_MONTHS(HIREDATE,12*33) < SYSDATE;

-- ���� ��¥���� �⵵�� ����
SELECT EXTRACT (YEAR FROM SYSDATE),
             TO_CHAR(SYSDATE, 'YYYY')
FROM DUAL;





   



