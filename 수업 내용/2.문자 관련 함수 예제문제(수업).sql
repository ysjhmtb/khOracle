--1. 직원의 사번, 이름, 원본이메일, 변경이메일 출력
--이메일 정보 만 _**@kh.or.kr 형식으로 값을 출력
--(sun_di@kh.or.kr -> sun_**/////////@kh.or.kr);
SELECT EMP_ID, EMP_NAME, EMAIL,
RPAD(SUBSTR(EMAIL, 1, INSTR(EMAIL, '_')), INSTR(EMAIL,'@')-1,'*') ||
SUBSTR(EMAIL,INSTR(EMAIL,'@')) AS "변경 이메일"
FROM EMPLOYEE;

--이메일 정보가 있을 경우, XXXX@********* 로 나오게 출력
--RPAD
SELECT EMAIL, RPAD(SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')),
                                            LENGTH(EMAIL), '*') "이메일 * 처리"
FROM EMPLOYEE;


SELECT EMP_ID, EMP_NAME, EMAIL,
RPAD(SUBSTR(EMAIL, 1, INSTR(EMAIL, '_')), INSTR(EMAIL, '@')-1, '*') ||
SUBSTR(EMAIL, INSTR(EMAIL, '@'))"TEST",
SUBSTR(EMAIL, 1, INSTR(EMAIL, '_')) || '**' ||
SUBSTR(EMAIL, INSTR(EMAIL, '@'))"TEST2"
FROM EMPLOYEE;


--2. 남자 직원의 정보를 출력(모든 정보)
SELECT *
FROM EMPLOYEE
WHERE EMP_NO LIKE '______-1%';

--3. 직원들의 근속년수를 구하시오.
SELECT 
TO_CHAR(SYSDATE, 'YYYY'),
TO_CHAR(HIRE_DATE, 'YYYY'),
TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(HIRE_DATE, 'YYYY')
FROM EMPLOYEE;


--4. 인사관리부 직원들의 급여 정보 조회(직원 이름, 급여)
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';


--5. 이름의 마지막 글자가 '연' 인사람이 태어난 년도를 구하시오
SELECT SUBSTR(EMP_NO, 1,2) || '년'
FROM EMPLOYEE
WHERE EMP_NAME LIKE '__연';


--6. 전화 번호의 가운댓 자리가 3자리인 사람의 정보를 출력
SELECT *
FROM EMPLOYEE
WHERE LENGTH(PHONE) = 10;


--입사월이 9월인 직원의 모든 정보 출력
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE LIKE '___09%';
SELECT *
FROM EMPLOYEE
WHERE SUBSTR(HIRE_DATE, 4, 2) = '09';






