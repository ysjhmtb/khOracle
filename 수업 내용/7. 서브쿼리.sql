--서브쿼리 : 쿼리 속에 쿼리가 들어간다.
--                    --> 쿼리문 안에 조건절, from절, select, group by 와 같은 절에 
--                                쿼리가 값으로 이용되는 쿼리

--사원명이 노옹철 인 사람의 부서 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

--'D9' 부서의 사원 정보를 출력
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--노옹철이 속한 부서의 직원 정보를 출력하시오
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                     WHERE EMP_NAME = '노옹철');

--쿼리에 대한 결과를 조건이나 출력에 이용하는 것

--전체 직원의 평균 급여 // 보다 더 많은 급여를 받는 직원의 정보를 출력
SELECT AVG(SALARY)
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                                FROM EMPLOYEE);

--퇴사자의 부서//에 속해 있는 직원 정보 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                        WHERE ENT_YN = 'Y');

--퇴사자의 부서에 속해 있는 직원 정보 조회
--(퇴사자는 출력에서 제외, 재직중인 인원만 조회)
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                        WHERE ENT_YN = 'Y')
    AND ENT_YN = 'N';
    
--서브쿼리의 종류
--단일행 서브쿼리 : 서브쿼리의 결과 값이 1개의 행으로 이루어져 있을때
--다중행 서브쿼리 : 서브쿼리의 결과 값이 1개 이상의 행으로 이루어져 있을때
--다중열 서브쿼리 : 서브쿼리의 결과 값이 1개 이상의 컬럼으로 이루어져 있을때
--다중행 다중열 서브쿼리 : 서브쿼리의 결과 값이 여러행, 여러열 일때
    --> 각 쿼리별 유형에 따라 앞에 올수 있는 연산자가 구분 됨
    
--단일행 서브쿼리
--다중열 서브쿼리
SELECT *
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

--단일행 서브쿼리
--스칼라 서브쿼리
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

--다중행 서브쿼리
SELECT TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--다중행, 다중열 서브쿼리
SELECT DEPT_CODE, TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--단일행 서브쿼리 : 서브쿼리의 결과 값이 1개의 행(한개의 값)
--노옹철 직원의 급여//보다 많은 급여를 받는 직원 조회
--사번, 이름, 급여 
--높은 급여부터 조회 하십시오.
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                                    FROM EMPLOYEE
                                WHERE EMP_NAME = '노옹철')
ORDER BY SALARY DESC;


--가장 적은 급여//를 받는 직원의 정보를 출력 하시오
--사번, 이름, 부서, 직급, 급여
SELECT MIN(SALARY)
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                                  FROM EMPLOYEE);
                                  
--부서별 급여의 합이 가장 높은// 부서코드, 급여의 합계를 출력 하시오
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                                                FROM EMPLOYEE
                                        GROUP BY DEPT_CODE);
                                        
                                        
--다중행 서브쿼리
--일반 비교 연산자 <, >, <=, >= 
--ANY : 여러 값들 중에 하나라도 일치하면
--ALL : 여러 값들(전부다) 조건을 만족하면
--EXIST : 해당 조건에 만족하는 값이 있다면

--부서별 최고급여//를 받는 직원의 이름, 직급, 급여를 조회하시오
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                                    FROM EMPLOYEE
                            GROUP BY DEPT_CODE);

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY = ANY(SELECT MAX(SALARY)
                                        FROM EMPLOYEE
                                GROUP BY DEPT_CODE);
                                
--대리 직급의 직원들 중에서 과장직급의 최소 급여보다 많이 받는 직원
--사번, 이름, 직급, 급여 조회
--(ANY)
SELECT SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '과장';

SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리'
     AND E.SALARY > ANY(SELECT SALARY
                                            FROM EMPLOYEE E
                                            JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
                                            WHERE J.JOB_NAME = '과장');

--(SUBQUERY)
SELECT MIN(SALARY)
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '과장';

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리'
    AND E.SALARY > (SELECT MIN(SALARY)
                                    FROM EMPLOYEE E
                                      JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
                                  WHERE J.JOB_NAME = '과장');
                                  
--과장 직급의 직원들 중에서 대리 직급의 급여들 보다 많이 받는 직원
--사번, 이름, 직급, 급여 조회                         
--ALL
SELECT SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리';

SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
     AND J.JOB_NAME = '과장'
     AND E.SALARY > ALL (SELECT SALARY
                                            FROM EMPLOYEE E
                                            JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
                                            WHERE J.JOB_NAME = '대리');


--다중행, 다중렬 서브쿼리
--자기 직급의 급여 평균 금액//을 받는 직원들의 정보 조회
SELECT JOB_CODE, TRUNC(AVG(SALARY),-5)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY),-5) 
                                                        FROM EMPLOYEE
                                                        GROUP BY JOB_CODE);

-- 퇴사한 여직원과 같은 부서, 같은 직급//에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회하세요
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
     AND SUBSTR(EMP_NO, 8,1) = '2';
     
SELECT JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
     AND SUBSTR(EMP_NO, 8,1) = '2';     
     
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE
                                        FROM EMPLOYEE
                                        WHERE ENT_YN = 'Y'
                                             AND SUBSTR(EMP_NO, 8,1) = '2')
   AND JOB_CODE IN (SELECT JOB_CODE
                                        FROM EMPLOYEE
                                        WHERE ENT_YN = 'Y'
                                             AND SUBSTR(EMP_NO, 8,1) = '2');
                                             
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
                                                                FROM EMPLOYEE
                                                                WHERE ENT_YN = 'Y'
                                                                     AND SUBSTR(EMP_NO, 8,1) = '2');

-- 현재 재직중인 직원 중 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회하세요.
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
                                                                FROM EMPLOYEE
                                                                WHERE ENT_YN = 'Y'
                                                                     AND SUBSTR(EMP_NO, 8,1) = '2')
     AND ENT_YN = 'N';
     

--직원정보 조회
--사번, 부서코드, 부서명, 급여
--(JOIN)
SELECT E.EMP_ID, E.DEPT_CODE, D.DEPT_TITLE, E.SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID;

--(SUBQUERY - JOIN (X))
SELECT EMP_ID, DEPT_CODE, (SELECT DEPT_TITLE 
                                                    FROM DEPARTMENT
                                                    WHERE DEPT_CODE = DEPT_ID),SALARY
FROM EMPLOYEE;

--서브쿼리는 쿼리의 모든 곳에 사용할수 있다
--SELECT, FROM, WHERE, GROUP BY(X), HAVING, ORDER BY(X)
--DML - INSERT, DELETE
--DDL - 테이블을 만들때, 변경

--FROM 절에서 쓰는 SUBQUERY - INLINE VIEW
--직원들의 이름, 나이, 부서코드, 부서명, 급여 조회
--(SUBQUERY)
SELECT EMP_NAME, 
                EXTRACT(YEAR FROM SYSDATE) - 
                EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2),'RR')) AS "AGE",
                DEPT_CODE,
                (SELECT DEPT_TITLE
                    FROM DEPARTMENT
                    WHERE DEPT_CODE = DEPT_ID) AS "DEPT_NAME",
                SALARY
FROM EMPLOYEE;

SELECT EMP_NAME, AGE, DEPT_CODE, DEPT_NAME, SALARY
FROM (SELECT EMP_NAME, 
                EXTRACT(YEAR FROM SYSDATE) - 
                EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2),'RR')) AS "AGE",
                DEPT_CODE,
                (SELECT DEPT_TITLE
                    FROM DEPARTMENT
                    WHERE DEPT_CODE = DEPT_ID) AS "DEPT_NAME",
                SALARY
            FROM EMPLOYEE) INFO;
            
--지금 구성한 INLINEVIEW를 이용하여 40대인 직원 정보를 구하시오
SELECT EMP_NAME, AGE, DEPT_CODE, DEPT_NAME, SALARY
FROM (SELECT EMP_NAME, 
                EXTRACT(YEAR FROM SYSDATE) - 
                EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2),'RR')) AS "AGE",
                DEPT_CODE,
                (SELECT DEPT_TITLE
                    FROM DEPARTMENT
                    WHERE DEPT_CODE = DEPT_ID) AS "DEPT_NAME",
                SALARY
            FROM EMPLOYEE)
WHERE AGE BETWEEN 40 AND 49;

--TOP-N 분석 : 상위 N 개의 항목 조회

--사원 정보 조회
--사번, 이름, EMAIL, 부서코드, 직책코드, 입사일
--ROWNUM : 오라클 내부에서 해당 ROW에 할당하는 번호
SELECT ROWNUM, EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE ROWNUM <= 3;

--사원 정보 조회
--사번, 이름, EMAIL, 부서코드, 직책코드, 입사일
--이름 오름차순 정렬
SELECT  EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
ORDER BY EMP_NAME;

--사원 정보 조회
--사번, 이름, EMAIL, 부서코드, 직책코드, 입사일
--이름 오름차순 정렬 후 상위 3개의 항목 조회
SELECT *
FROM (SELECT  EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, JOB_CODE, HIRE_DATE
                FROM EMPLOYEE
                ORDER BY EMP_NAME)
WHERE ROWNUM <= 3;


--부서별 급여 합계를 구한 후 상위 3개 부서의 부서코드, 부서명, 급여합 출력
SELECT DEPT_CODE, (SELECT DEPT_TITLE 
                                        FROM DEPARTMENT
                                        WHERE DEPT_ID = DEPT_CODE) "DEPT_NAME", SALARY_SUM 
FROM (SELECT DEPT_CODE, SUM(SALARY) "SALARY_SUM"
            FROM EMPLOYEE
            GROUP BY DEPT_CODE
            ORDER BY "SALARY_SUM" DESC)            
WHERE ROWNUM <= 3;

--급여가 낮은 사람부터 10명의 평균 급여를 구하여라
SELECT AVG(SALARY)
FROM (
    SELECT SALARY
    FROM EMPLOYEE
    ORDER BY SALARY)
WHERE ROWNUM <= 10;


            
            

























     
















                            


























