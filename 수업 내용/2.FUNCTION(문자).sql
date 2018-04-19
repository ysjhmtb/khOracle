--���� �� �Լ�
--����, ����, ����Ʈ ���� �Լ� -> ����ȯ�Լ� -> ���� ���� �Լ�
--���� ���� �Լ�
--LENGTH() - ���� ���� ��ȯ
SELECT LENGTH('�����ٶ�'), LENGTH('ABCDE')
FROM DUAL;

--LENGTHB() - ���� ũ�⸦ ��ȯ
SELECT LENGTHB('�����ٶ�'), LENGTHB('ABCDE')
FROM DUAL;

--INSTR() - ã�� ������ �ε����� ��ȯ
SELECT INSTR('AABAACABCB', 'A') "A",
INSTR('AABAACABCB', 'A', 1) "B",
INSTR('AABAACABCB', 'A', -1) "C",
INSTR('AABAACABCB', 'A', 1, 3) "D",
INSTR('AABAACABCB', 'A', -1, 2) "E"
FROM DUAL;

--���� �������� �̸��� ����, �̸����� @�� �ε����� ���
SELECT EMAIL, INSTR(EMAIL, '@')
FROM EMPLOYEE;

--LPAD() : LEFT�� ������ ���ڸ� �߰� ������ ���̸�ŭ �߰�
SELECT LPAD('AAAAA', 10, '#'),
LPAD('AAAAA', 10, ' ')
--,LPAD('������', 20, '#')
FROM DUAL;

--RPAD() : RIGHT
SELECT RPAD('AAAAA', 10, '#'),
RPAD('AAAAA', 10, ' ')
FROM DUAL;

--SUBSTR() : ���ڸ� ���ϴ� ���̸�ŭ �ڸ�
SELECT SUBSTR('ABCDEF', 2),
SUBSTR('ABCDEF', 2, 3),
SUBSTR('�����ٶ� �ٻ��', 4, 4),
SUBSTR('�����ٶ� �ٻ��', -3, 2)
FROM DUAL;

--�ֹε�� ��ȣ�� �����ʿ� ******
--������ �ֹι�ȣ, �ֹι�ȣ ���ڸ��� *ó���Ͽ� ���
--(101010-1******)
SELECT EMP_NO, 
            SUBSTR(EMP_NO, 1, 8) || '******',
            RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*'),
            RPAD(SUBSTR(EMP_NO, 1, INSTR(EMP_NO,'-') + 1), 14, '*')
FROM EMPLOYEE;

--TRIM() - �翷�� ���� �����Ͽ� ��ȯ
SELECT '   TEST TRIM   ',
TRIM('   TEST TRIM   ')
FROM DUAL;

--RTRIM() - ������ ���� �����Ͽ� ��ȯ
SELECT RTRIM('ABCCCDDEF   '),
RTRIM('ABCCCDDEF', 'FDE')
FROM DUAL;

--LTRIM() - ���� ���� �����Ͽ� ��ȯ(���ϴ� ���� �����)
SELECT LTRIM('   ABCDEFGH'),
LTRIM('ABCDEFGH', 'BC'),
LTRIM('ABCDEFGH', 'BCA')
FROM DUAL;

--LOWER() - ��� ���ڸ� �ҹ��ڷ� ����
SELECT 'HELLO WORLD',
LOWER('HELLO WORLD')
FROM DUAL;

--UPPER() - ��� ���ڸ� �빮�ڷ� ����
SELECT 'abcdefgh ijk',
UPPER('abcdefgh ijk')
FROM DUAL;

--INITCAP() - ���� ���ڸ� �빮�ڷ� ����
SELECT 'hello world',
INITCAP('hello world')
FROM DUAL;

--REPLACE() - Ư�� ���ڷ� ġȯ
SELECT REPLACE('����� ���ﵿ ���￪', '���ﵿ', '�Ｚ��')
FROM DUAL;

--CONCAT() - ���ڿ� ���ڸ� ����
SELECT CONCAT('������', '�󸶹ٻ�'),
'������' || '�󸶹ٻ�'
FROM DUAL;


--�������� ��������� ���� ��ȸ �Ͻÿ�.
--��� ��ȣ, ��� �̸�, �ֹι�ȣ, �⵵(2�ڸ�), ��(2�ڸ�), ��(2�ڸ�)
--�ֹι�ȣ ������������ �����Ͽ� ���
SELECT EMP_ID AS "��� ��ȣ", EMP_NAME AS "��� �̸�",
              EMP_NO AS "�ֹι�ȣ", 
              SUBSTR(EMP_NO, 1, 2) AS "�⵵",
              SUBSTR(EMP_NO, 3, 2) AS "��",
              SUBSTR(EMP_NO, 5, 2) AS "��"
FROM EMPLOYEE
ORDER BY EMP_NO;

--�������� �Ի����� ���� ��ȸ �Ͻÿ�
--�����ȣ, ����̸�, �Ի���, 
--�Ի�⵵(2�ڸ�), �Ի��(2�ڸ�), �Ի���(2�ڸ�) ��ȸ
--�ֱ� �Ի��� ���� ���
SELECT EMP_ID AS "��� ��ȣ", EMP_NAME AS "��� �̸�",
              HIRE_DATE "�Ի���",
              SUBSTR(HIRE_DATE, 1, 2) AS "�Ի�⵵",
              SUBSTR(HIRE_DATE, 4, 2) AS "�Ի� ��",
              SUBSTR(HIRE_DATE, 7, 2) AS "�Ի� ��"
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;










