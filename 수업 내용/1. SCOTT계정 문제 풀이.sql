-- SCOTT ���� LOGON
-- DEPT ���̺�� ���� ��� �����͸� ��ȸ
SELECT *
FROM DEPT;

-- EMP ���̺�� ���� ���(EMPNO), ����̸�(ENAME)�� ��ȸ
SELECT EMPNO, ENAME
FROM EMP;

-- EMP ���̺�� ���� �����, �޿�, ���� ��ȸ
SELECT ENAME, SAL, SAL * 12
FROM EMP;

-- EMP ���̺�� ���� �����, �޿�, ����, Ŀ�̼�, ����, Ŀ�̼��� ���Ե� ���� ��ȸ
SELECT ENAME, SAL, JOB, NVL(COMM, 0), SAL * 12, (SAL + NVL(COMM,0)) * 12
FROM EMP;

-- emp ���̺� ���� �μ��ڵ� �� ��ȸ
SELECT DEPTNO
FROM EMP;

-- emp ���̺� ���� �μ��ڵ� �� ��ȸ, �� �ߺ��� ���� �Ѱ��� ��µǰ� ��.
SELECT DISTINCT DEPTNO
FROM EMP;

-- emp ���̺��� ���� ���� ��ȸ
SELECT JOB
FROM EMP;

-- emp ���̺� ���� ���� �����͸� �Ѱ����� ��ȸ
SELECT DISTINCT JOB
FROM EMP;

-- WHERE �� 
-- �޿��� 3000 �̻��� �޴� ������ ���� ��ȸ
SELECT *
FROM EMP
WHERE 3000 <= SAL;

-- �μ��ڵ尡 10�� ������ �̸�, ����, �޿� ��ȸ
SELECT ENAME, JOB, SAL
FROM EMP
WHERE DEPTNO = 10;

-- �񱳰��� ����, ���ڿ�, ��¥ �������� ���� �ݵ�� '��' �� ǥ����.
-- ������ �̸��� 'FORD'�� ������ ���� ��ȸ
SELECT *
FROM EMP
WHERE ENAME = 'FORD';

-- �Ի����� 1980�� ���Ŀ� �Ի��� �������� ���� ��ȸ
SELECT *
FROM EMP
WHERE '1980' < TO_CHAR(HIREDATE, 'YYYY');

-- �μ��ڵ尡 10�̸鼭, ������ 'MANAGER'�� ������ ���� ��ȸ
SELECT *
FROM EMP
WHERE DEPTNO = 10 AND JOB = 'MANAGER';

-- �μ��ڵ尡 10 �̰ų�, ������ 'MANAGER'�� ������ ���� ��ȸ
SELECT *
FROM EMP
WHERE DEPTNO = 10 OR JOB = 'MANAGER';

-- ������ 'MANAGER'�� �ƴ� �������� ���� ��ȸ
SELECT *
FROM EMP
WHERE JOB != 'MANAGER';

-- �޿��� 2000 �̻� 3000 ������ �޿��� �޴� ������ ��ȸ
SELECT *
FROM EMP
WHERE 2000 <= SAL AND SAL <= 3000;

SELECT *
FROM EMP
WHERE SAL BETWEEN 2000 AND 3000
ORDER BY ENAME;

--2000 �̸� 3000 �ʰ��� ������ �޿��� �޴� ���� ��ȸ
SELECT *
FROM EMP
WHERE SAL NOT BETWEEN 2000 AND 3000;

SELECT *
FROM EMP
WHERE SAL < 2000 OR 3000 < SAL;


-- Ŀ�̼��� 300 �Ǵ� 500 �Ǵ� 1400�� ���� ��ȸ
SELECT *
FROM EMP
WHERE COMM = 300 OR COMM = 500 OR COMM = 1400;

SELECT *
FROM EMP
WHERE COMM IN (300, 500, 1400);

-- �����ȣ�� 7521 �Ǵ� 7654 �Ǵ� 7844�� ������� �޿� ��ȸ
SELECT EMPNO, SAL
FROM EMP
WHERE EMPNO IN (7521, 7654, 7844);

-- ����� 7521, 7654, 7844 �� �ƴ� ���� ��ȸ
SELECT *
FROM EMP
WHERE EMPNO NOT IN (7521, 7654, 7844);

-- 1980�� 1�� 1�� ���� ���� 1980�� 12�� 31�� ���̿� �Ի��� ���� ��ȸ
SELECT *
FROM EMP
WHERE '1980' = TO_CHAR(HIREDATE, 'YYYY');

SELECT *
FROM EMP
WHERE HIREDATE LIKE '80%';

SELECT *
FROM EMP
WHERE HIREDATE BETWEEN '80/01/01' AND '80/12/31';

-- 1980�⵵�� �Ի��� ���� ��ȸ
SELECT *
FROM EMP
WHERE HIREDATE LIKE '80%';

-- 1980���� �ƴ� �ؿ� �Ի��� ���� ��ȸ
SELECT *
FROM EMP
WHERE '1980' != TO_CHAR(HIREDATE, 'YYYY');

-- ��� �̸��� 'F'�� �����ϴ� ���� ���� ��ȸ
SELECT *
FROM EMP
WHERE ENAME LIKE 'F%';

-- ��� �̸��� 'J'�� �����ϴ� ���� ���� ��ȸ
SELECT *
FROM EMP
WHERE ENAME LIKE 'J%';

-- �̸��� 'A'�� ���Ե� ���� ���� ��ȸ
--XXXA, AXXX, XXAXX
SELECT *
FROM EMP
WHERE ENAME LIKE '%A%';

-- �̸��� ������ ���ڰ� 'N'���� ������ ���� ���� ��ȸ
SELECT *
FROM EMP
WHERE ENAME LIKE '%N';

-- �̸��� �ι�° ���ڰ� 'A'�� ���� ���� ��ȸ
SELECT *
FROM EMP
WHERE ENAME LIKE '_A%';

-- �̸��� ����° ���ڰ� 'A'�� ���� ���� ��ȸ
SELECT *
FROM EMP
WHERE ENAME LIKE '__A%';

-- �̸��� 'A'�� ���� ���� ���� ��ȸ
SELECT *
FROM EMP
WHERE ENAME NOT LIKE '%A%';
