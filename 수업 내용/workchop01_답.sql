--1. �� ������б��� �а� �̸��� �迭�� ǥ���Ͻÿ�. 
--��, ��� ����� "�а� ��", "�迭" ���� ǥ���ϵ��� ����.
SELECT DEPARTMENT_NAME AS "�а� ��",
              CATEGORY AS "�迭"
FROM TB_DEPARTMENT;

--�а��� �а� ������ ������ ���� ���·� ȭ�鿡 �������.
--������а��� ������ 20 �� �Դϴ�.
SELECT DEPARTMENT_NAME || '�� ������ ' || CAPACITY || ' �� �Դϴ�.' AS "�а��� ����" 
FROM TB_DEPARTMENT;


--3. "������а�" �� �ٴϴ� ���л� �� ���� �������� ���л��� ã�ƴ޶�� ��û��
--���Դ�. �����ΰ�? (�����а��� '�а��ڵ�'�� �а� ���̺�(TB_DEPARTMENT)�� ��ȸ�ؼ�
--ã�� ������ ����)
--�����а� - 001
SELECT *
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '������а�';
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '001' 
AND STUDENT_SSN LIKE '______-2%'
AND ABSENCE_YN = 'Y';

--4. ���������� ���� ���� ��� ��ü�� ���� ã�� �̸��� �Խ��ϰ��� ����. �� ����ڵ���
--�й��� ������ ���� �� ����ڵ��� ã�� ������ SQL ������ �ۼ��Ͻÿ�.
--A513079, A513090, A513091, A513110, A513119
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119');

--5. ���������� 20 �� �̻� 30 �� ������ �а����� �а� �̸��� �迭�� ����Ͻÿ�
SELECT DEPARTMENT_NAME AS "�а� ��",
              CATEGORY AS "�迭"
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

SELECT DEPARTMENT_NAME AS "�а� ��",
              CATEGORY AS "�迭"
FROM TB_DEPARTMENT
WHERE 20 <= CAPACITY AND CAPACITY <= 30;


--6. �� ������б��� ������ �����ϰ� ��� �������� �Ҽ� �а��� ������ �ִ�. �׷� ��
--������б� ������ �̸��� �˾Ƴ� �� �ִ� SQL ������ �ۼ��Ͻÿ�.
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

--7. Ȥ�� ������� ������ �а��� �����Ǿ� ���� ���� �л��� �ִ��� Ȯ���ϰ��� ����.
--��� SQL ������ ����ϸ� �� ������ �ۼ��Ͻÿ�.
SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

--8. ������û�� �Ϸ��� ����. �������� ���θ� Ȯ���ؾ� �ϴµ�, ���������� �����ϴ�
--������� � �������� �����ȣ�� ��ȸ�غ��ÿ�.
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;


--9. �� ���п��� � �迭(CATEGORY)���� �ִ��� ��ȸ�غ��ÿ�.
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT;

--10. 02 �й� ���� �����ڵ��� ������ ������� ����. ������ ������� ������ ��������
--�л����� �й�, �̸�, �ֹι�ȣ�� ����ϴ� ������ �ۼ��Ͻÿ�.
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ENTRANCE_DATE LIKE '02%'
AND STUDENT_ADDRESS LIKE '%����%'
AND ABSENCE_YN = 'N';



