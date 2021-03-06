CREATE TABLE NUMBER_TEST(
    NUM1 NUMBER(7, 3),
    NUM2 NUMBER(7),
    NUM3 NUMBER,
    NUM4 NUMBER(7,1),
    NUM5 NUMBER(7,-2)
);

INSERT INTO NUMBER_TEST
VALUES (1234.678,9999999,9999999,9999.999,5555555);

SELECT *
FROM NUMBER_TEST;

DROP TABLE NUMBER_TEST;


CREATE TABLE CHAR_TEST(
    CHAR1 CHAR(3),
    CHAR2 CHAR(6),
    CHAR3 CHAR(9)
);

INSERT INTO CHAR_TEST(CHAR1, CHAR2, CHAR3)
VALUES ('ABC', 'ABCABC', 'ABCABC');

SELECT CHAR1 || '/' , CHAR2 || '/', CHAR3 || '/'
FROM CHAR_TEST;

--10G 이전 버전의 경우 한글은 2BYTE
--이후 버전 부터 한글 3BYTE
INSERT INTO CHAR_TEST(CHAR1, CHAR2, CHAR3)
VALUES ('가', '가나', '가나');

CREATE TABLE VARCHAR_TEST(
    CHAR1 DATE,
    CHAR2 VARCHAR2(6),
    CHAR3 VARCHAR2(9)
);
INSERT INTO VARCHAR_TEST(CHAR1, CHAR2, CHAR3)
VALUES('가나다', '가나다', '가나다');

SELECT CHAR1 || '/' , CHAR2 || '/', CHAR3 || '/'
FROM VARCHAR_TEST;

SELECT SYSDATE, SYSDATE + 1, SYSDATE -2,
                TO_CHAR(SYSDATE + 5/24, 'YY-MM-DD HH:MI:SS')
FROM DUAL;


COMMIT;
DROP TABLE CHAR_TEST;
DROP TABLE NUMBER_TEST;
DROP TABLE VARCHAR_TEST;


--모든 직원 정보 조회
SELECT *
FROM EMPLOYEE;

SELECT EMP_ID AS "사번", EMP_NAME AS "이름",
                EMP_NO "주민번호", EMAIL "이메일"
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

SELECT EMP_NAME AS "이름", '님' AS "호칭"
FROM EMPLOYEE;

SELECT EMP_NAME || ' 님' AS "이름"
FROM EMPLOYEE;

--xxx님의 급여는 xxx원 입니다.
SELECT EMP_NAME || '님의 급여는' || SALARY || '원 입니다.' AS "결과 문구"
FROM EMPLOYEE;

SELECT SALARY AS "급여", SALARY * 12 AS "연봉",
            SALARY + 500000 "상여금"
FROM EMPLOYEE;

--기본 급여 + 보너스 금액 -> 이달의 급여
--보너스 금액 : 기본급여 * 보너스 율
SELECT SALARY + (SALARY * BONUS) AS "이달의 급여"
FROM EMPLOYEE;

--급여가 300만원 이하인 사람들만 조회 하시오
SELECT *
FROM EMPLOYEE
WHERE SALARY <= 3000000;

--급여가 300만원 이하, 직급이 J6 인 사람들만 조회 하시오
SELECT *
FROM EMPLOYEE
WHERE SALARY <= 3000000 AND JOB_CODE = 'J6';

--급여가 300만원 이하, 직급이 J6이면서, 부서가 있는 사람들만 조회 하시오
SELECT *
FROM EMPLOYEE
WHERE SALARY <= 3000000 
    AND JOB_CODE = 'J6'
    AND DEPT_CODE IS NOT NULL;


--급여가 300만원 이하, 직급이 J6이면서, 부서가 있는 사람들의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SALARY <= 3000000 
    AND JOB_CODE = 'J6'
    AND DEPT_CODE IS NOT NULL;

--급여가 200이상 300이하인 사람들의 모든 정보를 출력 하시오
SELECT *
FROM EMPLOYEE
WHERE 2000000<= SALARY 
    AND SALARY <= 3000000;

SELECT *
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 3000000;

--이씨성의 사람을 조회하십시오
--LIKE -> 와일드 카드 -> _(한글자), %(여러 글자)
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '이__';

SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '이%';

--이름 중 가운데 글자가 '은' 인 사람을 조회 하시오
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_은_';

--생일이 8월인 사람들을 조회하여 출력 하시오
SELECT *
FROM EMPLOYEE
WHERE EMP_NO NOT LIKE '__08%';

--전화번호가 널인 사람들 조회
SELECT *
FROM EMPLOYEE
WHERE PHONE IS NOT NULL;

--이메일을 조회할때 _앞글자가 3글자인 이메일만 조회하시오
SELECT * 
FROM EMPLOYEE
WHERE EMAIL NOT LIKE '___#_%' ESCAPE '#';

--직급이 J6, J7사람들의 모든 정보를 출력하시오
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE = 'J6' OR JOB_CODE = 'J7';

SELECT *
FROM EMPLOYEE
WHERE JOB_CODE NOT IN ('J6', 'J7');









