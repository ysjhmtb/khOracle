--TOP-N 분석 쿼리
--상위 몇개를 추려내는 쿼리
--직원들의 이름, 부서코드, 직급코드
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

--직원 정보를 이름의 오름차순으로 정렬하여 순번을 조회 후 5번까지 출력
SELECT ROWNUM, EMP_NAME, DEPT_CODE, JOB_CODE
FROM( SELECT EMP_NAME, DEPT_CODE, JOB_CODE
            FROM EMPLOYEE
            ORDER BY EMP_NAME)
WHERE ROWNUM <= 5;

--RANK() OVER (정렬 기준)
--직원 정보를 조회 -> 급여를 많이 받는 사람부터 출력
--(이름, 주민등록번호, 직급코드, 급여, 순번)
SELECT EMP_NAME, EMP_NO, JOB_CODE, SALARY,
              RANK() OVER (ORDER BY SALARY DESC) "순번"
FROM EMPLOYEE;

--직원 정보를 조회 -> 급여를 많이 받는 사람부터 출력
--(이름, 주민등록번호, 직급코드, 급여, 순번) -> 5번째 까지 출력
SELECT *
FROM 
(SELECT EMP_NAME, EMP_NO, JOB_CODE, SALARY,
              RANK() OVER (ORDER BY SALARY DESC) "순번"
FROM EMPLOYEE)
WHERE 순번 <= 5;

--직원 정보를 조회 -> 급여를 많이 받는 사람부터 출력
--(이름, 주민등록번호, 직급코드, 급여, 순번)
SELECT EMP_NAME, EMP_NO, JOB_CODE, SALARY,
              DENSE_RANK() OVER (ORDER BY SALARY DESC) "순번"
FROM EMPLOYEE;

--직원의 나이의 오름차순으로 정렬하여 순번을 출력(RANK())
--직원명, 주민등록번호, 나이, 부서명, 직급명, 입사년도(YYYY)
SELECT E.EMP_NAME, E.EMP_NO,
              EXTRACT (YEAR FROM SYSDATE) 
              - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "나이",
              D.DEPT_TITLE,
              J.JOB_NAME,
              EXTRACT (YEAR FROM HIRE_DATE) "입사년도",
              RANK() OVER (ORDER BY TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')) "순번"
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
     AND E.JOB_CODE = J.JOB_CODE;


--WITH - 쿼리 실행 시 임시 테이블을 만들어서 뷰처럼 테이블처럼 사용가능 한 절

--직원들의 이름, 나이, 급여, 직급명, 부서명을 조회
--이름의 오름차순으로 정렬 후 순번을 적용
SELECT E.EMP_NAME, 
              EXTRACT (YEAR FROM SYSDATE) 
              - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "AGE",
              E.SALARY,
              J.JOB_NAME,
              D.DEPT_TITLE,
              RANK() OVER (ORDER BY E.EMP_NAME) "INDEX"
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_CODE = J.JOB_CODE
     AND E.DEPT_CODE = D.DEPT_ID(+);
     
--나이가 30~35 사이인 직원들의 정보를 조회
--직원들의 이름, 나이, 급여, 직급명, 부서명을 조회
SELECT *
FROM (SELECT E.EMP_NAME, 
                          EXTRACT (YEAR FROM SYSDATE) 
                          - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "AGE",
                          E.SALARY,
                          J.JOB_NAME,
                          D.DEPT_TITLE,
                          RANK() OVER (ORDER BY E.EMP_NAME) "INDEX"
            FROM EMPLOYEE E, JOB J, DEPARTMENT D
            WHERE E.JOB_CODE = J.JOB_CODE
                 AND E.DEPT_CODE = D.DEPT_ID(+))
WHERE AGE BETWEEN 30 AND 35;

WITH NAME_ORDER_INFO AS (SELECT E.EMP_NAME, 
                                                              EXTRACT (YEAR FROM SYSDATE) 
                                                              - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "AGE",
                                                              E.SALARY,
                                                              J.JOB_NAME,
                                                              D.DEPT_TITLE,
                                                              RANK() OVER (ORDER BY E.EMP_NAME) "INDEX"
                                                FROM EMPLOYEE E, JOB J, DEPARTMENT D
                                                WHERE E.JOB_CODE = J.JOB_CODE
                                                     AND E.DEPT_CODE = D.DEPT_ID(+))
SELECT *
FROM NAME_ORDER_INFO;

--직급이 부사장인 사람이 속한 부서의 직원들의 평균 나이를 구하시오
--위에서 선언해 놓은 WITH를 이용하여 해결
WITH NAME_ORDER_INFO AS (SELECT E.EMP_NAME, 
                                                              EXTRACT (YEAR FROM SYSDATE) 
                                                              - EXTRACT (YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "AGE",
                                                              E.SALARY,
                                                              J.JOB_NAME,
                                                              D.DEPT_TITLE,
                                                              RANK() OVER (ORDER BY E.EMP_NAME) "INDEX"
                                                FROM EMPLOYEE E, JOB J, DEPARTMENT D
                                                WHERE E.JOB_CODE = J.JOB_CODE
                                                     AND E.DEPT_CODE = D.DEPT_ID(+))
SELECT AVG(AGE)
FROM NAME_ORDER_INFO E1
WHERE E1.DEPT_TITLE IN (SELECT E2.DEPT_TITLE
                                            FROM NAME_ORDER_INFO E2
                                            WHERE JOB_NAME = '부사장');

--상(호연)관쿼리 - 바깥 쿼리의 값이 서브쿼리의 결과에 영향을 미치는 것
--관리자 사번이 EMPLOYEE 테이블에 존재하는 직원에 대한 조회
SELECT *
FROM EMPLOYEE E
WHERE EXISTS (SELECT *
                            FROM EMPLOYEE MANAGER
                            WHERE E.MANAGER_ID = MANAGER.EMP_ID);


--스칼라 서브쿼리 - 상관쿼리 + 단일행 서브쿼리 -> 조회 결과가 한개(상수, 필드 값)
--해당 직급 직원들의 급여 평균(십만단위) 보다 많은 급여를 받는 직원 목록
--직원 이름, 직급코드, 급여
SELECT E1.EMP_NAME, E1.JOB_CODE, E1.SALARY
FROM EMPLOYEE E1
WHERE E1.SALARY > (SELECT AVG(SALARY)
                                         FROM EMPLOYEE E2
                                        WHERE E2.JOB_CODE = E1.JOB_CODE);

--직원명, 부서코드, 부서명
SELECT EMP_NAME, DEPT_CODE, (SELECT DEPT_TITLE 
                                                            FROM DEPARTMENT
                                                           WHERE DEPT_ID = DEPT_CODE) "부서명"
FROM EMPLOYEE;


--> 서브쿼리, 상관쿼리
--131. 해당 직원이 속한 부서의 평균 급여보다 많은 
--급여를 받는 직원들의 정보만 조회
--직원명, 부서명, 직책명, 급여, 지역명, 국가명
--직원명 오름차순 정렬 
--(상관쿼리)
SELECT E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, E.SALARY, L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE E.SALARY > (SELECT AVG(E1.SALARY)
                                       FROM EMPLOYEE E1
                                       WHERE NVL(E.DEPT_CODE,'EMPTY') = NVL(E1.DEPT_CODE, 'EMPTY'))
ORDER BY EMP_NAME;

--92.보너스를 30% 이상 받는 직원의 부서에 속한 직원 정보를 구하시오
--사번, 이름, 나이, EMAIL, 전화번호
--나이의 오름차순 정렬
--(상관쿼리)
SELECT E.EMP_ID, E.EMP_NAME, 
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) "나이",
            E.EMAIL, PHONE
FROM EMPLOYEE E
WHERE EXISTS (SELECT *
                               FROM EMPLOYEE E2
                             WHERE NVL(E2.DEPT_CODE,'EMPTY') = NVL(E.DEPT_CODE,'EMPTY')
                                  AND E2.BONUS >= 0.3)
ORDER BY "나이";

--(서브쿼리)
SELECT E1.EMP_ID, E1.EMP_NAME, 
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(E1.EMP_NO, 1, 2), 'RR')) "나이",
            E1.EMAIL, E1.PHONE
FROM EMPLOYEE E1
WHERE E1.DEPT_CODE IN (SELECT E2.DEPT_CODE
                                            FROM EMPLOYEE E2
                                            WHERE E2.BONUS >= 0.3)
ORDER BY "나이";


--73.부서별 입사일이 가장 빠른 사원의 
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하세요
-- 단, 퇴사한 직원은 제외하고 조회하세요
--(상관쿼리)
SELECT E.EMP_ID, E.EMP_NAME, 
            NVL(D.DEPT_TITLE,'부서없음') "부서명",
            J.JOB_NAME, E.HIRE_DATE
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
     AND E.JOB_CODE = J.JOB_CODE
     AND HIRE_DATE = (SELECT MIN(E1.HIRE_DATE)
                                        FROM EMPLOYEE E1
                                        WHERE NVL(E.DEPT_CODE,'확인값') = NVL(E1.DEPT_CODE,'확인값')
                                              AND E1.ENT_YN = 'N');
--(서브쿼리)
SELECT E.EMP_ID, E.EMP_NAME, NVL(D.DEPT_TITLE,'소속없음') "부서명",
                J.JOB_NAME, E.HIRE_DATE
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J USING (JOB_CODE)
WHERE (NVL(E.DEPT_CODE,'EMPTY'), E.HIRE_DATE) IN (SELECT NVL(DEPT_CODE,'EMPTY'), MIN(HIRE_DATE)
                                                                                            FROM EMPLOYEE
                                                                                            WHERE ENT_YN = 'N'
                                                                                            GROUP BY DEPT_CODE)
ORDER BY E.HIRE_DATE;

--74.직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME,
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) "나이",
            (E.SALARY + E.SALARY * NVL(E.BONUS, 0)) * 12 "연봉"
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
     AND TO_DATE(SUBSTR(E.EMP_NO, 1, 2),'RR') = (SELECT MAX(TO_DATE(SUBSTR(E1.EMP_NO, 1, 2),'RR'))
                                                                                    FROM EMPLOYEE E1
                                                                                    WHERE E.JOB_CODE = E1.JOB_CODE)
ORDER BY "나이" DESC;
--직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, 
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) "나이",
            (E.SALARY + E.SALARY * NVL(E.BONUS, 0)) * 12 AS "연봉"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE (E.JOB_CODE, TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) IN (SELECT E1.JOB_CODE, MAX(TO_DATE(SUBSTR(E1.EMP_NO, 1, 2), 'RR'))
                                                                                                                FROM EMPLOYEE E1
                                                                                                            GROUP BY  E1.JOB_CODE)
ORDER BY "나이" DESC;


--1. 해당 직원이 속한 부서의 평균 급여  보다 많은 
--급여를 받는 직원들의 정보만 조회
--직원명, 부서명, 직책명, 급여, 지역명, 국가명
--직원명 오름차순 정렬 
SELECT E.EMP_NAME, NVL(D.DEPT_TITLE,'소속없음') AS "부서명",
            J.JOB_NAME, E.SALARY, 
            NVL(L.LOCAL_NAME,'소속없음'), 
            NVL(N.NATIONAL_NAME,'소속없음')
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND E.JOB_CODE = J.JOB_CODE
    AND D.LOCATION_ID = L.LOCAL_CODE(+)
    AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
    AND E.SALARY > (SELECT AVG(E1.SALARY)
                                    FROM EMPLOYEE E1
                                    WHERE NVL(E1.DEPT_CODE,'EMPTY') 
                                            = NVL(E.DEPT_CODE,'EMPTY'))
ORDER BY E.EMP_NAME;

--2.보너스를 30% 이상 받는 직원의 부서  에 속한 직원 정보를 구하시오
--사번, 이름, 나이, EMAIL, 전화번호
--나이의 오름차순 정렬
SELECT E.EMP_ID, E.EMP_NAME,
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT ( YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "나이",
            E.EMAIL, E.PHONE
FROM EMPLOYEE E
WHERE EXISTS (SELECT *
                                FROM EMPLOYEE E1
                                WHERE BONUS >= 0.3
                                    AND NVL(E1.DEPT_CODE,'EMPTY') = NVL(E.DEPT_CODE,'EMPTY'))
ORDER BY "나이" ASC;

--3.부서별 입사일이 가장 빠른 사원의 
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하세요
-- 단, 퇴사한 직원은 제외하고 조회하세요

SELECT E.EMP_ID, E.EMP_NAME, NVL(D.DEPT_TITLE,'소속없음'),
            J.JOB_NAME, E.HIRE_DATE
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND E.JOB_CODE = J.JOB_CODE
    AND (NVL(E.DEPT_CODE,'EMPTY'), E.HIRE_DATE)  
                    IN (SELECT NVL(E1.DEPT_CODE,'EMPTY'), MIN(E1.HIRE_DATE)
                            FROM EMPLOYEE E1
                           WHERE E1.ENT_YN = 'N'
                            GROUP BY E1.DEPT_CODE);
                            
                            
--4.직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
SELECT E.EMP_ID, E.EMP_NAME, JOB_NAME,
            EXTRACT (YEAR FROM SYSDATE) - EXTRACT ( YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR')) AS "나이",
            (SALARY + NVL(BONUS, 0) * SALARY) * 12 AS "연봉"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE TO_DATE(SUBSTR(E.EMP_NO, 1, 2),'RR') = (SELECT MAX(TO_DATE(SUBSTR(E1.EMP_NO, 1, 2),'RR'))
                                                                                    FROM EMPLOYEE E1
                                                                                WHERE E.JOB_CODE = E1.JOB_CODE)
ORDER BY "나이" DESC;
















