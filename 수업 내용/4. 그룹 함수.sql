--�׷� �Լ�
--SUM : �ش� ������ �հ踦 ��ȯ
--�� ������ �޿� �Ѿ��� ���Ͽ���
SELECT SUM(SALARY) AS "�޿��Ѿ�"
FROM EMPLOYEE;

--������ 'J6'�� ������� �޿��� �հ踦 ���Ͻÿ�.
SELECT SUM(SALARY) AS "�޿��հ�"
FROM EMPLOYEE
WHERE JOB_CODE = 'J6';

--AVG : �ش� ���ǵ��� ��հ��� ��ȯ
--��� �������� �޿� ����� ���Ͻÿ�.
--(��, �Ҽ��� ��°�ڸ����� �ݿø� �Ͻÿ�)
SELECT ROUND(AVG(SALARY), 1)
FROM EMPLOYEE;

--COUNT : �ش� ����(�׷�)�� ���� ������ ��ȯ
--80��뿡 �¾ �ο��� ����Դϱ�?
SELECT COUNT (*)
FROM EMPLOYEE
WHERE EMP_NO LIKE '8%';

--MIN : �ش� �׷��� ���� ������
--MAX : �ش� �׷��� ���� ū��
SELECT MIN(EMP_ID), MAX(EMP_ID),
MIN (EMP_NAME), MAX(EMP_NAME),
MIN (HIRE_DATE), MAX(HIRE_DATE)
FROM EMPLOYEE;


--1. ������� �ֹι�ȣ�� ��ȸ��
  --��, �ֹι�ȣ 9��° �ڸ����� �������� '*'���ڷ� ä��
  --�� : ȫ�浿 771120-1******

SELECT EMP_NAME, (SUBSTR(EMP_NO, 1, 8), LEGHTH(EMP_NO), '*')
FROM EMPLOYEE;


--2. ������, �����ڵ�, ����(��) ��ȸ
  --��, ������ ��57,000,000 ���� ǥ�õǰ� ��
   --  ������ ���ʽ�����Ʈ�� ����� 1��ġ �޿���
SELECT EMP_NAME, JOB_CODE,
TO_CHAR(basicpay,'L999,999,999') 
from EMPLOYEE;

--3. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� ������ 
  -- �� ��ȸ��.
   --��� ����� �μ��ڵ� �Ի���

SELECT COUNT(*)
ENAME, TO_CHAR(HIREDATE, '2004') "�⵵",
FROM EMP
WHERE JOB_CODE 'D5', 'D9'
AND TO_CHAR(HIRE_DATE,'YYYY') = '2004';


--4. ������, �Ի���, �Ի��� ���� �ٹ��ϼ� ��ȸ
  -- ��, �ָ��� ������
   
SELECT ENAME, 
TO_CHAR(HIREDATE, 'YYYY') "�⵵",
TO_CHAR(HIREDATE, 'MM') AS "��"
TO_CHAR(HIREDATE, 'DD') AS "��"
FROM EMPLOYEE;



--5. ������, �μ��ڵ�, �������, ����(��) ��ȸ
  -- ��, ��������� �ֹι�ȣ���� �����ؼ�, 
   --������ ������ �����Ϸ� ��µǰ� ��.
   --���̴� �ֹι�ȣ���� �����ؼ� ��¥�����ͷ� ��ȯ�� ����, �����
   ---��, ��¥�� �̻��ϰ� �Էµ� 200, 201, 214 �ο��� ���� �� ��ȸ

SELECT EMP_NAME, DEPT_CODE,
SUBSTR(EMP_NO, 1, 2) || '��'
|| SUBSTR(EMP_NO, 3, 2) || '��'
   SUBSTR(EMP_NO, 5, 2) || '��'
EXTRACT (YEAR FROM SYSDATE) - 
EXTRACT (YEAR FROM TO DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD'))
FROM EMPLOYEE
WHERE EMP_ID NOT IN ('200', '201', '214');



--6. �������� �Ի��Ϸ� ���� �⵵�� ������, �� �⵵�� �Ի��ο����� ���Ͻÿ�.
  --�Ʒ��� �⵵�� �Ի��� �ο����� ��ȸ�Ͻÿ�.
  --=> to_char, decode, sum ���

	-------------------------------------------------------------
--	��ü������   2001��   2002��   2003��   2004��
	-------------------------------------------------------------
SELECT COUNT(*) AS "��ü �ο���",  
SUM(DECODE(TO_CHAR(HIREDATE,'YYYY'),'2001',1, 0)) S2001 ,
SUM(DECODE(TO_CHAR(HIREDATE,'YYYY'),'2002',1, 0)) S2002 ,
SUM(DECODE(TO_CHAR(HIREDATE,'YYYY'),'2003',1, 0)) S2003 ,
SUM(DECODE(TO_CHAR(HIREDATE,'YYYY'),'2004',1, 0)) S2004 
FROM EMPLOYEE ;

--��ü �ο��� �μ��� ���� ��� �Ͻÿ�
--��ü ī��Ʈ, ���� �ƴ� ī��Ʈ, �ߺ� ���� �� ī��Ʈ
SELECT COUNT(*), COUNT(DEPT_CODE), COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE ;



--7.  �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.
  -- ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ��
  --=> case ���
   --�μ��ڵ� ���� �������� ������.
SELECT DEPT_CODE, 
CASE WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
            WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
            WHEN DEPT_CODE = 'D9' THEN '������' END AS "�μ���"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY DEPT_CODE;

--1. ������ �ֹι�ȣ�� ��ȣȭ ��Ű���� �մϴ�.
--�ֹι�ȣ �� �ڸ��� ���ڷ� �޾� �� ���ڸ� +5�Ͽ� ����Ͻÿ�. 
--(10�� �Ѿ��� 10�� �� ���� ���;� �մϴ�.)
SELECT NUM,
SUBSTR(EMP_NO), LEGHTH(EMP_NO), '*'
FROM EMPLOYEE;

--2.���������� 

--���ʽ��� ���� �������� �μ�Ƽ��� �̹��ؿ� �ڱ� ���޿� 50%�� ���ְ� ���ʽ��� �ִ�
 
--�������� ���ʽ��� 50%�λ���� �ֱ���Ͽ���

--���� ���� ���� ������ �޴� ������ ������� ����� �λ�� �ݾ׿� 30% �� �شٰ� �Ͽ���

--���� ���� �������� �μ��� �����Ե� ������ ���ϱ�� (5,240,230 �̸� 524�����̶�� ��� õ�� �ڸ� ����)
--���� ���� �������� ���� ��� 
--��� ���� ���
--2500������ �Ѵ� ���� ī��Ʈ ���

--�ǽ��� ������ EMPLOYEE ���̺��� �̿��ϼ���   

--3.������ 2���� �̸��� * ó���Ѵ��� �����ڵ尡 'J5'�� ����� Q�� 'J6'�� ����� B������ ó���ϰ�,
--�������� ����
--��, ������, �����ڵ�, ������ ���ʽ�����Ʈ�� ����, ������ 3���� ���ں��ʹ� *ó����
--������ ���������� ����, �̸������� ����
  
SELECT EMP_NAME, JOB_CODE, 
TO_CHAR(BONUS,'L999,999,999')
FROM EMPLOYEE
WHERE JOB_CODE 'J5', 'J6'
ORDER BY DESC;

--4. EMPLOYEE ���̺� �� ����� + ���� + ����(�ѱ� ����) + �Ի�⵵ + �Ի�� + �Ի��� + �̸���
--			+ �̸��� _ �� ���ĺ� ���� + �� ��ȣ + �� ��ȣ �з� �÷� �˻�
--	1. ���� ������ '��' ���̸鼭 40���� ����� �˻�
--	2. �ֹι�ȣ�� ��������(��, �� �ʰ�)�� ��� �� �� ��ȣ �̼����ڴ� �˻� ��󿡼� ����
--		-> IN()�̳� ~ = ~ OR, ~ = ~ AND�� Ư�� ������ �Ÿ��� ��� ����
--	3. �̸��� _ ���� ���ĺ� ������ ���� ������ 2, 3, 4���� ��� ���ڸ�, ���ڸ�, ���ڸ� �̷��� ���
--	4. �� ��ȣ �з��� ���� 011�̰ų� 10�ڸ��� �� ����ȣ, �ƴϸ� �� ����ȣ �̷��� ���
--	5. ������ ���ʽ�(NULL�̸� 0 ó��)��ŭ ���� ���� * 12

SELECT EMP_NAME, SAL, HIREDATE, ADD_MONTHS
FROM EMPLOYEE;

--5. ������ 2, 3, 9, 10���� ������ �̸�, �ֹε�Ϲ�ȣ, �ڵ��� ��ȣ ���.
--��, �ڵ��� ��ȣ�� �� ��ȣ(4�ڸ�)�� *�� ó��.
--0101234**** �Ǵ� 0101234****
--���������� �������� ����

SELECT ENAME,EMPNO,  from emp_tb_eob_employeepersonal 
 cross join dbo.GetDays(Getdate(),Getdate()+7) as dates where weekofmonthnumber>0
 and month(dates.date)=month(DOB) and day(dates.date)=day(DOB)



GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT [dbo].[GetDays] ('02/01/2011','02/28/2011')

ALTER FUNCTION [dbo].[GetDays](@startDate datetime, @endDate datetime)
RETURNS @retValue TABLE
(Days int ,Date datetime, WeekOfMonthNumber int, WeekOfMonthDescription varchar(10), DayName varchar(10))
AS
BEGIN
    DECLARE @nextDay int
    DECLARE @nextDate datetime 
    DECLARE @WeekOfMonthNum int 
    DECLARE @WeekOfMonthDes varchar(10) 
    DECLARE @DayName varchar(10) 
    SELECT @nextDate = @startDate, @WeekOfMonthNum = DATEDIFF(week, DATEADD(MONTH, DATEDIFF(MONTH,0,@startDate),0),@startDate) + 1, 
    @WeekOfMonthDes = CASE @WeekOfMonthNum 
        WHEN '1' THEN 'First' 
        WHEN '2' THEN 'Second' 
        WHEN '3' THEN 'Third' 
        WHEN '4' THEN 'Fourth' 
        WHEN '5' THEN 'Fifth' 
        WHEN '6' THEN 'Sixth' 
        END, 
    @DayName 
    = DATENAME(weekday, @startDate)
SET @nextDay=1
WHILE @nextDate <= @endDate 
BEGIN 
    INSERT INTO @retValue values (@nextDay,@nextDate, @WeekOfMonthNum, @WeekOfMonthDes, @DayName) 
    SELECT @nextDay=@nextDay + 1 
SELECT @nextDate = DATEADD(day,1,@nextDate), 
    @WeekOfMonthNum 
    = DATEDIFF(week, DATEADD(MONTH, DATEDIFF(MONTH,0, @nextDate),0), @nextDate) + 1, 
    @WeekOfMonthDes 
    = CASE @WeekOfMonthNum 
    WHEN '1' THEN 'First' 
    WHEN '2' THEN 'Second' 
    WHEN '3' THEN 'Third' 
    WHEN '4' THEN 'Fourth' 
    WHEN '5' THEN 'Fifth' 
    WHEN '6' THEN 'Sixth' 
    END, 
    @DayName 
    = DATENAME(weekday, @nextDate) 
    CONTINUE 
END 

WHILE(@nextDay <=31)
BEGIN


    INSERT INTO @retValue values (@nextDay,@nextDate, 0, '', '') 
    SELECT @nextDay=@nextDay + 1

END

    RETURN
END





6. �̸�, ����, �μ��ڵ�,�̸����� ����Ͻÿ�.
   �̸��� _ �� @ ������ ���ڴ� '&'�� �ٲٽÿ�
   �̸��� �������� ������������ �����Ͻÿ�.

7. ����̸�, ����, �Ի��� �޿� ���� ����
   (�ϱ��� ���� �������� ���,�ָ����� ����)

8. �����ȣ, �����, �ֹι�ȣ, ���̴븦 ��ȸ. ��� �������� ���̴븦 40��, 50��, 60������ �����ѵ� ǥ���ϰ� ������ ���ɴ�� ��Ÿ�� ǥ���Ͻÿ�

9. ������� 20����� ����غ� �Ͽ��ٰ� �Ҷ�, ����� ������ ������ �ɸ� �ϼ��� ���ϼ���. 
   �̸�, ������ �� ���� �ɸ� �ϼ�

10. �������� �Ի��Ϸκ��� ���� ������, �� �б⺰ �Ի��ο����� ���Ͻÿ�.
    1�б�: 1~3 2�б�: 4~6 3�б�: 7~9 4�б�: 10~12

    ��ü������  1�б�   2�б�   3�б�   4�б�

DECLARE @Temp TABLE 
( SaleDate DATETIME --�Ǹ��� 
,SaleAmout DECIMAL --�Ǹű� ); 

/* 1�� ~ 3�� : 1�б� 
4�� ~ 6�� : 2�б� 
7�� ~ 9�� : 3�б� 
10�� ~ 12�� : 4�б� */ 
--������ �Է� 
INSERT INTO @Temp VALUES('2013-01-04', 2000000); --1�б� 
INSERT INTO @Temp VALUES('2013-04-08', 1200000); --2�б� 
INSERT INTO @Temp VALUES('2013-06-17', 400000); --2�б� 
INSERT INTO @Temp VALUES('2013-07-08', 3000000); --3�б� 
INSERT INTO @Temp VALUES('2013-07-27', 1000000); --3�б� 
INSERT INTO @Temp VALUES('2013-08-02', 450000); --3�б� 
INSERT INTO @Temp VALUES('2013-08-20', 550000); --3�б� 
INSERT INTO @Temp VALUES('2013-09-09', 600000); --3�б� 
INSERT INTO @Temp VALUES('2013-09-16', 500000); --3�б� 
INSERT INTO @Temp VALUES('2013-10-07', 240000); --4�б� 
INSERT INTO @Temp VALUES('2013-11-08', 500000); --4�б� 
INSERT INTO @Temp VALUES('2013-12-11', 100000); --4�б� 

--������ �� ��ȸ �Ǵ��� Ȯ�� �ѹ� �ϰ�~ 
SELECT * FROM @Temp; 

--�б⺰�� �Ǹűݾ� �հ� ���ϱ� 
SELECT 
--��¥������ �⵵�� ��ȯ����, �̰� �׳� SUBSTRING ó�� �ص� �ȴ�. 
DATEPART(YEAR, SaleDate) AS SaleDateYYYY 
--��¥������ �б⺰ �������� ��ȯ����. 
,DATEPART(QUARTER, SaleDate) AS SaleDateQuarter 
--�⵵�� �б⺰ �Ǹűݾ� �հ踦 ���Ѵ�. 
,SUM(SaleAmout) AS SaleAmout 
FROM 
@Temp 
GROUP BY 
--�⵵�� 
DATEPART(YEAR, SaleDate) 
--�б⺰�� �հ踦 ���ϱ� ���ؼ� �׷� �����ش�. 
,DATEPART(QUARTER, SaleDate)








11. �������� ��ȭ��ȣ�� ����Ͻÿ�
    ���� �̸�, ���� ��ȭ��ȣ, ���� ������ ��ȭ��ȣ
    (010-123-1234 OR 010-1234-5678)





