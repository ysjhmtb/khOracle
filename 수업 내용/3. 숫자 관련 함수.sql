--ABS() : 절댓값을 구하는 함수
SELECT -10, ABS(-10), ABS(12345), ABS(-12345)
FROM DUAL;

--MOD() : 나머지를 구하는 함수
SELECT 5/2, MOD(5,2), MOD(7, 5)
FROM DUAL;

--ROUND() : 반올림 값을 출력하는 함수
SELECT 
    ROUND(1.123),
    ROUND(555.555),
    ROUND(555.555, 2),
    ROUND(555.555, -2),
    ROUND(555.555, 0)
FROM DUAL;

--FLOOR() : 내림한 값을 출력하는 함수
SELECT FLOOR(555.555), FLOOR(12345.678)
FROM DUAL;

--TRUNC() : 특정 자릿수를 절삭하는 함수
SELECT 
    TRUNC(555.555),
    TRUNC(555.555, 0),
    TRUNC(555.555, 2),
    TRUNC(555.555, -2)
FROM DUAL;

--CEIL() : 소숫점 이하 자리를 올림 처리하여 정수 반환하는 함수
SELECT
    CEIL(12.3456),
    CEIL(12345)
FROM DUAL;

SELECT 
    CEIL(1234.56),
    ROUND(1234.56),
    FLOOR(1234.56),
    TRUNC(1234.56)
FROM DUAL;



--날짜 처리 함수 시작
--SYSDATE : 시스템 시간을 저장하는 변수
SELECT SYSDATE
FROM DUAL;

--MONTHS_BETWEEN : 두개의 날짜 간 몇개월이 차이나는지를 반환
SELECT HIRE_DATE, SYSDATE,
              CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12)
FROM EMPLOYEE;

--ADD_MONTHS() : 기준 날짜에 입력한 개월 이후 날짜를 반환
SELECT SYSDATE, 
              ADD_MONTHS(SYSDATE, 5),
              ADD_MONTHS(SYSDATE, -1)
FROM DUAL;

--몇일 이후, 몇일 이전
SELECT SYSDATE, SYSDATE + 1, SYSDATE + 10, SYSDATE -5
FROM DUAL;

--금일 기준 1년뒤, 1년 이전 의 날짜를 출력하시오
--금일, 후년, 전년
SELECT 
    SYSDATE,
    ADD_MONTHS(SYSDATE, 12),
    ADD_MONTHS(SYSDATE, -12)
FROM DUAL;

--NEXT_DAY : 날짜를 기준으로 다음에 오는 요일을 반환
--요일은 1 : 일요일 ~ 7 : 토요일
SELECT NEXT_DAY(SYSDATE, '목요일'),
NEXT_DAY(SYSDATE, '일'),
NEXT_DAY(SYSDATE, 7)
FROM DUAL;

SELECT NEXT_DAY(SYSDATE, 'MONDAY')
FROM DUAL;

SELECT *
FROM NLS_SESSION_PARAMETERS;
ALTER SESSION SET NLS_LANGUAGE = 'KOREAN';

--LAST_DAY : 해당 월의 마지막 날짜를 반환
SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM DUAL;

--4월달에는 몇일동안 근무를 해야 할까요? (주말 토, 일 포함)
SELECT LAST_DAY(SYSDATE) - SYSDATE
FROM DUAL;

--오늘 기준으로, 직원들의 근무 기간을 구하시오.
--직원명, 오늘날짜, 고용날짜, 몇일, 몇달, 몇년(일한 기간)
--달, 년도 같은 경우 소숫점 이하의 경우 버림 하시오
SELECT EMP_NAME, SYSDATE, HIRE_DATE,
    TRUNC(SYSDATE - HIRE_DATE) AS "일",
    TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS "달",
    TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) AS "년"
FROM EMPLOYEE;


--EXTRACT : 년, 월, 일 정보를 추출하는 함수
SELECT 
    EXTRACT(YEAR FROM SYSDATE),
    EXTRACT(MONTH FROM SYSDATE),
    EXTRACT(DAY FROM SYSDATE)
FROM DUAL;

--직원 정보에서 직원들의 입사 년도, 입사월, 입사일을 출력하시오
--이름, 년, 월, 일, 입사년월일(기본값) 
--단, 이름의 내림차순으로 정렬하여 출력
SELECT EMP_NAME AS "이름", 
    EXTRACT(YEAR FROM HIRE_DATE) AS "년",
    EXTRACT(MONTH FROM HIRE_DATE) AS "월",
    EXTRACT(DAY FROM HIRE_DATE) AS "일",
    HIRE_DATE AS "입사년월일"
FROM EMPLOYEE
ORDER BY EMP_NAME DESC;


--===================================
--형변환 함수
--TO_CHAR : 숫자 -> 문자, 데이트 -> 문자
--숫자 -> 문자로 변경되는 경우
--화폐를 찍거나, 금액 구분자 ','
SELECT TO_CHAR(12345), 12345 "TESTTESTTEST" 
FROM DUAL;
SELECT 
    TO_CHAR(2000000, 'L9999999999'),
    TO_CHAR(2000000, 'L0000000000'),
    TO_CHAR(2000000, 'L9,999,999,999'),
    TO_CHAR(2000000, '$9,999,999,999')
FROM DUAL;

SELECT *
FROM NLS_SESSION_PARAMETERS;
ALTER SESSION SET NLS_LANGUAGE = 'KOREAN';

--직원들의 보너스가 포함된 급여를 출력하시오
--직원 명, 급여(￦2,000,000)
--보너스가 없는 직원은 급여만 출력 하시오(NVL)
SELECT 
    EMP_NAME,
    TO_CHAR(SALARY + SALARY * NVL(BONUS, 0), 'L999,999,999,999') "급여"
FROM EMPLOYEE;

--직원들의 보너스가 포함된 급여를 출력하시오
--직원 명, 급여(￦2,000,000)
--보너스가 있는 직원만 출력 하시오
SELECT 
    EMP_NAME,
    TO_CHAR(SALARY + SALARY * BONUS, 'L999,999,999,999') AS 급여
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;


--날짜 -> 문자
SELECT SYSDATE,
    TO_CHAR(SYSDATE, 'YYYYMMDD HHMISS') AS "시간1",
    TO_CHAR(SYSDATE, 'YYYY') AS "년도",
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS "시간2",
    TO_CHAR(SYSDATE, 'YYYY-MM-DD Q"분기"') AS "시간3"
FROM DUAL;

--TO_DATE : 문자타입의 데이터를 데이트 타입으로 반환
SELECT 
    TO_DATE('02/01/01', 'YY/MM/DD') "타입1",
    TO_CHAR(TO_DATE('02/01/01', 'YY/MM/DD'),'YYYY MM DD') "타입2",
    TO_DATE('020303','YYMMDD') "타입3",
    TO_DATE('180403 0750', 'YYMMDD HHMI') "타입4",
    TO_CHAR(TO_DATE('180403 0750', 'YYMMDD HHMI'), 'HH24:MI') "시간"
FROM DUAL;

--YY - 현재 세기를 기준으로 년도를 설정
--RR - 현재가 50년도 이전 -> 50보다 큰 년도가 입력 될경우 전세기를 기준으로 변경
--                                        50보다 작을 경우엔 현재 세기를 기준으로 변경
SELECT 
    TO_CHAR(TO_DATE('980303','YYMMDD'),'YYYY'),
    TO_CHAR(TO_DATE('980303','RRMMDD'),'YYYY'),
    TO_CHAR(TO_DATE('100303','YYMMDD'),'YYYY'),
    TO_CHAR(TO_DATE('100303','RRMMDD'),'YYYY')
FROM DUAL;

--TO_NUMBER : 문자->숫자
SELECT TO_NUMBER('5555') + 5
FROM DUAL;

--NVL : 널을 체크하여 널일 경우 지정된 값으로 반환
SELECT BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;

--선택함수 -> 조건문
--DECODE, CASE
--J5	과장
--J6	대리
--J7	사원
--사원의 정보를 출력
--이름, 직책코드, 직책 (J7 - 사원, J6 - 대리, J5 - 과장, 그외 간부)
--SWITCH - DECODE(확인값, "값1", "처리값1", "값2", "처리값2", "값3", "처리값3","그외의 경우 처리값")
SELECT 
    EMP_NAME,JOB_CODE,
    DECODE(JOB_CODE, 'J7', '사원', 'J6', '대리', 'J5', '과장', '그외 간부') "직책"
FROM EMPLOYEE;

--사원의 정보를 출력
--이름, 직책코드, 직책(J7 - '사원', '사원이 아닙니다')
SELECT 
    EMP_NAME, JOB_CODE,
    DECODE(JOB_CODE, 'J7','사원','사원이 아닙니다') "직책"
FROM EMPLOYEE;


--CASE -> IF와 비슷
--CASE WHEN 조건식 THEN 처리값, 출력값
--          WHEN 조건식2 THEN 처리값, 출력값2
--                                ...........
--          [ELSE 그외 나머지 경우 처리값, 출력값]
--          END

--급여가 200만원 이하일 경우  - 적은 급여
--급여가 200 ~ 400 일 경우 - 평균 급여
--급여가 400만원 이상 일경우 - 높은 급여
--급여, 급여수준
SELECT SALARY,
    CASE WHEN SALARY <= 2000000 THEN '적은 급여'
              WHEN 2000000 < SALARY AND SALARY < 4000000 THEN '평균 급여'
              WHEN 4000000 <= SALARY THEN '높은급여' END "급여수준"
FROM EMPLOYEE;

--보너스를 지급하려 합니다.
--급여가 200만원 이하인 사람들은 급여의 100%
--그외 나머지는 50% 만 보너스를 지급하려 합니다.
--직원이름, 급여, 보너스 금액
--보너스 금액의 내림차순으로 정렬하여 출력
SELECT EMP_NAME, SALARY,
    CASE WHEN SALARY <= 2000000 THEN SALARY
              ELSE SALARY * 0.5 END "보너스"
FROM EMPLOYEE
ORDER BY "보너스" DESC;


--이름으로 내림차순 정렬 후 이름이 같을 경우 나이의 오름차순으로 정렬하시오
--ORDER BY NAME DESC, AGE ASC;























SELECT *
FROM NLS_SESSION_PARAMETERS;






























