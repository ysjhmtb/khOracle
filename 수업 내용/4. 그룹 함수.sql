--그룹 함수
--SUM : 해당 값들의 합계를 반환
--전 직원의 급여 총액을 구하여라
SELECT SUM(SALARY) AS "급여총액"
FROM EMPLOYEE;

--직급이 'J6'인 사람들의 급여의 합계를 구하시오.
SELECT SUM(SALARY) AS "급여합계"
FROM EMPLOYEE
WHERE JOB_CODE = 'J6';

--AVG : 해당 조건들의 평균값을 반환
--모든 직원들의 급여 평균을 구하시오.
--(단, 소숫점 둘째자리에서 반올림 하시오)
SELECT ROUND(AVG(SALARY), 1)
FROM EMPLOYEE;

--COUNT : 해당 조건(그룹)의 값의 갯수를 반환
--80년대에 태어난 인원은 몇명입니까?
SELECT COUNT (*)
FROM EMPLOYEE
WHERE EMP_NO LIKE '8%';

--MIN : 해당 그룹의 가장 작은값
--MAX : 해당 그룹의 가장 큰값
SELECT MIN(EMP_ID), MAX(EMP_ID),
MIN (EMP_NAME), MAX(EMP_NAME),
MIN (HIRE_DATE), MAX(HIRE_DATE)
FROM EMPLOYEE;


--1. 직원명과 주민번호를 조회함
  --단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채움
  --예 : 홍길동 771120-1******

SELECT EMP_NAME, (SUBSTR(EMP_NO, 1, 8), LEGHTH(EMP_NO), '*')
FROM EMPLOYEE;


--2. 직원명, 직급코드, 연봉(원) 조회
  --단, 연봉은 ￦57,000,000 으로 표시되게 함
   --  연봉은 보너스포인트가 적용된 1년치 급여임
SELECT EMP_NAME, JOB_CODE,
TO_CHAR(basicpay,'L999,999,999') 
from EMPLOYEE;

--3. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의 
  -- 수 조회함.
   --사번 사원명 부서코드 입사일

SELECT COUNT(*)
ENAME, TO_CHAR(HIREDATE, '2004') "년도",
FROM EMP
WHERE JOB_CODE 'D5', 'D9'
AND TO_CHAR(HIRE_DATE,'YYYY') = '2004';


--4. 직원명, 입사일, 입사한 달의 근무일수 조회
  -- 단, 주말도 포함함
   
SELECT ENAME, 
TO_CHAR(HIREDATE, 'YYYY') "년도",
TO_CHAR(HIREDATE, 'MM') AS "월"
TO_CHAR(HIREDATE, 'DD') AS "일"
FROM EMPLOYEE;



--5. 직원명, 부서코드, 생년월일, 나이(만) 조회
  -- 단, 생년월일은 주민번호에서 추출해서, 
   --ㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
   --나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
   ---단, 날짜가 이상하게 입력된 200, 201, 214 인원은 제외 후 조회

SELECT EMP_NAME, DEPT_CODE,
SUBSTR(EMP_NO, 1, 2) || '년'
|| SUBSTR(EMP_NO, 3, 2) || '월'
   SUBSTR(EMP_NO, 5, 2) || '일'
EXTRACT (YEAR FROM SYSDATE) - 
EXTRACT (YEAR FROM TO DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD'))
FROM EMPLOYEE
WHERE EMP_ID NOT IN ('200', '201', '214');



--6. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
  --아래의 년도에 입사한 인원수를 조회하시오.
  --=> to_char, decode, sum 사용

	-------------------------------------------------------------
--	전체직원수   2001년   2002년   2003년   2004년
	-------------------------------------------------------------
SELECT COUNT(*) AS "전체 인원수",  
SUM(DECODE(TO_CHAR(HIREDATE,'YYYY'),'2001',1, 0)) S2001 ,
SUM(DECODE(TO_CHAR(HIREDATE,'YYYY'),'2002',1, 0)) S2002 ,
SUM(DECODE(TO_CHAR(HIREDATE,'YYYY'),'2003',1, 0)) S2003 ,
SUM(DECODE(TO_CHAR(HIREDATE,'YYYY'),'2004',1, 0)) S2004 
FROM EMPLOYEE ;

--전체 인원의 부서의 수를 출력 하시오
--전체 카운트, 널이 아닌 카운트, 중복 제거 한 카운트
SELECT COUNT(*), COUNT(DEPT_CODE), COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE ;



--7.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.
  -- 단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회함
  --=> case 사용
   --부서코드 기준 오름차순 정렬함.
SELECT DEPT_CODE, 
CASE WHEN DEPT_CODE = 'D5' THEN '총무부'
            WHEN DEPT_CODE = 'D6' THEN '기획부'
            WHEN DEPT_CODE = 'D9' THEN '영업부' END AS "부서명"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY DEPT_CODE;

--1. 직원의 주민번호를 암호화 시키려고 합니다.
--주민번호 각 자리를 숫자로 받아 각 숫자를 +5하여 출력하시오. 
--(10이 넘어갈경우 10을 뺀 값이 나와야 합니다.)
SELECT NUM,
SUBSTR(EMP_NO), LEGHTH(EMP_NO), '*'
FROM EMPLOYEE;

--2.연봉협상결과 

--보너스가 없는 직원들은 인센티브로 이번해에 자기 월급에 50%를 더주고 보너스가 있는
 
--직원들은 보너스에 50%인상시켜 주기로하였다

--그중 가장 낮은 연봉은 받는 직원은 사장님의 배려로 인상된 금액에 30% 더 준다고 하였다

--가장 낮은 연봉자의 인센이 다포함된 연봉은 얼마일까요 (5,240,230 이면 524만원이라고 출력 천의 자리 버림)
--가장 높은 연봉자의 연봉 출력 
--평균 연봉 출력
--2500만원이 넘는 직원 카운트 출력

--실습용 계정에 EMPLOYEE 테이블을 이용하세요   

--3.직원의 2번쨰 이름만 * 처리한다음 직업코드가 'J5'인 사람은 Q반 'J6'인 사람은 B반으로 처리하고,
--나머지는 제외
--단, 직원명, 직업코드, 연봉에 보너스포인트가 적용, 연봉의 3번쨰 글자부터는 *처리함
--연봉을 낮은순으로 정렬, 이름순으로 정렬
  
SELECT EMP_NAME, JOB_CODE, 
TO_CHAR(BONUS,'L999,999,999')
FROM EMPLOYEE
WHERE JOB_CODE 'J5', 'J6'
ORDER BY DESC;

--4. EMPLOYEE 테이블 중 사원명 + 연봉 + 나이(한국 기준) + 입사년도 + 입사월 + 입사일 + 이메일
--			+ 이메일 _ 앞 알파벳 개수 + 폰 번호 + 폰 번호 분류 컬럼 검색
--	1. 성씨 자음이 'ㅅ' 자이면서 40대인 사람만 검색
--	2. 주민번호가 비정상적(월, 일 초과)인 사원 및 폰 번호 미소유자는 검색 대상에서 제외
--		-> IN()이나 ~ = ~ OR, ~ = ~ AND로 특정 데이터 거르는 편법 금지
--	3. 이메일 _ 앞의 알파벳 개수는 앞의 개수가 2, 3, 4개인 경우 두자리, 세자리, 네자리 이렇게 출력
--	4. 폰 번호 분류는 앞이 011이거나 10자리면 옛 폰번호, 아니면 새 폰번호 이렇게 출력
--	5. 연봉은 보너스(NULL이면 0 처리)만큼 더한 월급 * 12

SELECT EMP_NAME, SAL, HIREDATE, ADD_MONTHS
FROM EMPLOYEE;

--5. 생일이 2, 3, 9, 10월인 직원의 이름, 주민등록번호, 핸드폰 번호 출력.
--단, 핸드폰 번호의 뒷 번호(4자리)는 *로 처리.
--0101234**** 또는 0101234****
--직원명으로 내림차순 정렬

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





6. 이름, 연봉, 부서코드,이메일을 출력하시오.
   이메일 _ 와 @ 사이의 문자는 '&'로 바꾸시오
   이름을 기준으로 오름차순으로 정렬하시오.

7. 사원이름, 월급, 입사한 달에 받을 월급
   (일급은 현재 월급으로 계산,주말까지 포함)

8. 사원번호, 사원명, 주민번호, 나이대를 조회. 모든 직원들의 나이대를 40대, 50대, 60대인지 구분한뒤 표시하고 나머지 연령대는 기타로 표시하시오

9. 모든사원이 20살부터 취업준비를 하였다고 할때, 취업에 성공한 날까지 걸린 일수를 구하세요. 
   이름, 성공한 날 까지 걸린 일수

10. 직원들의 입사일로부터 월만 가지고, 각 분기별 입사인원수를 구하시오.
    1분기: 1~3 2분기: 4~6 3분기: 7~9 4분기: 10~12

    전체직원수  1분기   2분기   3분기   4분기

DECLARE @Temp TABLE 
( SaleDate DATETIME --판매일 
,SaleAmout DECIMAL --판매금 ); 

/* 1월 ~ 3월 : 1분기 
4월 ~ 6월 : 2분기 
7월 ~ 9월 : 3분기 
10월 ~ 12월 : 4분기 */ 
--데이터 입력 
INSERT INTO @Temp VALUES('2013-01-04', 2000000); --1분기 
INSERT INTO @Temp VALUES('2013-04-08', 1200000); --2분기 
INSERT INTO @Temp VALUES('2013-06-17', 400000); --2분기 
INSERT INTO @Temp VALUES('2013-07-08', 3000000); --3분기 
INSERT INTO @Temp VALUES('2013-07-27', 1000000); --3분기 
INSERT INTO @Temp VALUES('2013-08-02', 450000); --3분기 
INSERT INTO @Temp VALUES('2013-08-20', 550000); --3분기 
INSERT INTO @Temp VALUES('2013-09-09', 600000); --3분기 
INSERT INTO @Temp VALUES('2013-09-16', 500000); --3분기 
INSERT INTO @Temp VALUES('2013-10-07', 240000); --4분기 
INSERT INTO @Temp VALUES('2013-11-08', 500000); --4분기 
INSERT INTO @Temp VALUES('2013-12-11', 100000); --4분기 

--데이터 잘 조회 되는지 확인 한번 하고~ 
SELECT * FROM @Temp; 

--분기별로 판매금액 합계 구하기 
SELECT 
--날짜형식을 년도로 변환해줌, 이건 그냥 SUBSTRING 처리 해도 된다. 
DATEPART(YEAR, SaleDate) AS SaleDateYYYY 
--날짜형식을 분기별 형식으로 변환해줌. 
,DATEPART(QUARTER, SaleDate) AS SaleDateQuarter 
--년도와 분기별 판매금액 합계를 구한다. 
,SUM(SaleAmout) AS SaleAmout 
FROM 
@Temp 
GROUP BY 
--년도와 
DATEPART(YEAR, SaleDate) 
--분기별로 합계를 구하기 위해서 그룹 지어준다. 
,DATEPART(QUARTER, SaleDate)








11. 직원들의 전화번호를 출력하시오
    직원 이름, 원본 전화번호, 포멧 적용한 전화번호
    (010-123-1234 OR 010-1234-5678)





