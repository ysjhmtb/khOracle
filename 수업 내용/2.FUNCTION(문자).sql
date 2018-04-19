--단일 행 함수
--문자, 숫자, 데이트 관련 함수 -> 형변환함수 -> 조건 관련 함수
--문자 관련 함수
--LENGTH() - 글자 갯수 반환
SELECT LENGTH('가나다라마'), LENGTH('ABCDE')
FROM DUAL;

--LENGTHB() - 글자 크기를 반환
SELECT LENGTHB('가나다라마'), LENGTHB('ABCDE')
FROM DUAL;

--INSTR() - 찾을 문자의 인덱스를 반환
SELECT INSTR('AABAACABCB', 'A') "A",
INSTR('AABAACABCB', 'A', 1) "B",
INSTR('AABAACABCB', 'A', -1) "C",
INSTR('AABAACABCB', 'A', 1, 3) "D",
INSTR('AABAACABCB', 'A', -1, 2) "E"
FROM DUAL;

--문제 직원들의 이메일 정보, 이메일의 @의 인덱스를 출력
SELECT EMAIL, INSTR(EMAIL, '@')
FROM EMPLOYEE;

--LPAD() : LEFT에 정해진 문자를 추가 정해진 길이만큼 추가
SELECT LPAD('AAAAA', 10, '#'),
LPAD('AAAAA', 10, ' ')
--,LPAD('가나다', 20, '#')
FROM DUAL;

--RPAD() : RIGHT
SELECT RPAD('AAAAA', 10, '#'),
RPAD('AAAAA', 10, ' ')
FROM DUAL;

--SUBSTR() : 글자를 원하는 길이만큼 자름
SELECT SUBSTR('ABCDEF', 2),
SUBSTR('ABCDEF', 2, 3),
SUBSTR('가나다라마 바사아', 4, 4),
SUBSTR('가나다라마 바사아', -3, 2)
FROM DUAL;

--주민등록 번호에 오른쪽에 ******
--직원의 주민번호, 주민번호 뒷자리를 *처리하여 출력
--(101010-1******)
SELECT EMP_NO, 
            SUBSTR(EMP_NO, 1, 8) || '******',
            RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*'),
            RPAD(SUBSTR(EMP_NO, 1, INSTR(EMP_NO,'-') + 1), 14, '*')
FROM EMPLOYEE;

--TRIM() - 양옆의 값을 제거하여 반환
SELECT '   TEST TRIM   ',
TRIM('   TEST TRIM   ')
FROM DUAL;

--RTRIM() - 오른쪽 공백 제거하여 반환
SELECT RTRIM('ABCCCDDEF   '),
RTRIM('ABCCCDDEF', 'FDE')
FROM DUAL;

--LTRIM() - 왼쪽 공백 제거하여 반환(원하는 문자 지우기)
SELECT LTRIM('   ABCDEFGH'),
LTRIM('ABCDEFGH', 'BC'),
LTRIM('ABCDEFGH', 'BCA')
FROM DUAL;

--LOWER() - 모든 문자를 소문자로 변경
SELECT 'HELLO WORLD',
LOWER('HELLO WORLD')
FROM DUAL;

--UPPER() - 모든 문자를 대문자로 변경
SELECT 'abcdefgh ijk',
UPPER('abcdefgh ijk')
FROM DUAL;

--INITCAP() - 시작 문자를 대문자로 변경
SELECT 'hello world',
INITCAP('hello world')
FROM DUAL;

--REPLACE() - 특정 문자로 치환
SELECT REPLACE('서울시 역삼동 역삼역', '역삼동', '삼성동')
FROM DUAL;

--CONCAT() - 문자와 문자를 연결
SELECT CONCAT('가나다', '라마바사'),
'가나다' || '라마바사'
FROM DUAL;


--직원들의 생년월일을 각각 조회 하시오.
--사원 번호, 사원 이름, 주민번호, 년도(2자리), 월(2자리), 일(2자리)
--주민번호 오름차순으로 정렬하여 출력
SELECT EMP_ID AS "사원 번호", EMP_NAME AS "사원 이름",
              EMP_NO AS "주민번호", 
              SUBSTR(EMP_NO, 1, 2) AS "년도",
              SUBSTR(EMP_NO, 3, 2) AS "월",
              SUBSTR(EMP_NO, 5, 2) AS "일"
FROM EMPLOYEE
ORDER BY EMP_NO;

--직원들의 입사일을 각각 조회 하시오
--사원번호, 사원이름, 입사일, 
--입사년도(2자리), 입사월(2자리), 입사일(2자리) 조회
--최근 입사자 부터 출력
SELECT EMP_ID AS "사원 번호", EMP_NAME AS "사원 이름",
              HIRE_DATE "입사일",
              SUBSTR(HIRE_DATE, 1, 2) AS "입사년도",
              SUBSTR(HIRE_DATE, 4, 2) AS "입사 월",
              SUBSTR(HIRE_DATE, 7, 2) AS "입사 일"
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;










