-- Active: 1709601465263@@127.0.0.1@1521@orcl@JOEUN

# PL/SQL
-- PL/SQL 기본 구조

-- 블록
DECLARE
    필요한 요소를 선언;  -- 선언부
BEGIN
    실행문;             -- 실행부
EXCEPTION
    예외 처리 부분      -- 예외 처리
END;
/




-- 변수 선언과 출력
SET SERVEROUTPUT ON;     -- 실행결과 출력하도록 설정
DECLARE
    -- 변수명 데이터타입 [DEFAULT 기본값] [NOT NULL, NULL];
    -- 상수명 CONSTANT 데이터타입 [DEFAULT 기본값] [NOT NULL, NULL];
    VI_NUM  NUMBER;     -- 선언부
    CO_NUM  CONSTANT NUMBER := 200;  -- 상수 선언
BEGIN
    VI_NUM := 100;      -- 실행부
    VI_NUM := 1000;
    -- CO_NUM := 2000;    -- 상수는 값릉 최초에 한 번만 초기화하고 바꿀 수 없다.
    DBMS_OUTPUT.PUT_LINE('변수 : ' || VI_NUM);
    DBMS_OUTPUT.PUT_LINE('상수 : ' || CO_NUM);
    -- DBMS_OUTPUT.PUT_LINE(VI_NUM);
    /*
        여러 줄 주석
        여러 줄 주석
    */
END;
/



-- 

DECLARE
    -- 변수 선언
    -- VS_EMP_NAME VARCHAR(100);       -- 사원명
    -- VS_DEPT_NAME VARCHAR(100);      -- 부서명
    -- 데이터타입 참조형 : 테이블명.컬럼명%TYPE
    VS_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;     
    VS_DEPT_NAME DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT E.EMP_NAME, D.DEPT_TITLE
      INTO VS_EMP_NAME, VS_DEPT_NAME        -- 조회결과를 변수에 대입(INTO)
    FROM EMPLOYEE E
        ,DEPARTMENT D
    WHERE E.DEPT_CODE = D.DEPT_ID
      AND E.EMP_ID = 200;
    
    -- 이어지는 실행문에서, VS_EMP_NAME, VS_DEPT_NAME  활용하기 위함
    DBMS_OUTPUT.PUT_LINE(VS_EMP_NAME || ' : ' || VS_DEPT_NAME);
END;
/























-- 제어문
/*
    조건문
    - IF
    - CASE
    반복문

    기타제어문
*/

-- IF
DECLARE
    VN_NUM1 NUMBER := 10;
    VN_NUM2 NUMBER := 20;
BEGIN
    IF VN_NUM1 > VN_NUM2 THEN
        DBMS_OUTPUT.PUT_LINE(VN_NUM1 || '이 더 큽니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(VN_NUM2 || '이 더 큽니다.');
    END IF;
END;
/

-- IF ~ ELSEIF
-- 사원들 중 부서가 'D1'에서 급여가 가장 많은 사원의 급여를
-- 조회하여 1,000,000 원 이상 2,000,000 이하 이면 1 출력
--         2,000,001 원 이상 3,000,000 이하 이면 2 출력
--         그렇지 않으면 3을 출력해보세요.
DECLARE
    -- 지정된 부서 D1
    VN_DEPT_CODE DEPARTMENT.DEPT_ID%TYPE := 'D1';
    -- D1 부서의 최대급여를 담을 변수 선언    
    MAX_SALARY NUMBER := 0;
BEGIN
    -- 조회
    SELECT MAX(SALARY)
      INTO MAX_SALARY
    FROM EMPLOYEE
    WHERE DEPT_CODE = VN_DEPT_CODE;

    DBMS_OUTPUT.PUT_LINE('D1 부서 최대급여 : ' || MAX_SALARY);
    -- 조건문
    -- 출력
    IF MAX_SALARY BETWEEN 1000000 AND 2000000 THEN
        DBMS_OUTPUT.PUT_LINE('1');
    ELSIF MAX_SALARY BETWEEN 2000001 AND 3000000 THEN
        DBMS_OUTPUT.PUT_LINE('2');
    ELSE
        DBMS_OUTPUT.PUT_LINE('3');
    END IF;
END;
/


-- CASE
DECLARE
    VN_DEPT_CODE DEPARTMENT.DEPT_ID%TYPE := 'D1';
    MAX_SALARY NUMBER := 0;
BEGIN
    SELECT MAX(SALARY)
      INTO MAX_SALARY
    FROM EMPLOYEE
    WHERE DEPT_CODE = VN_DEPT_CODE;

    DBMS_OUTPUT.PUT_LINE('D1 부서 최대급여 : ' || MAX_SALARY);

    CASE 
        WHEN MAX_SALARY BETWEEN 1000000 AND 2000000 THEN 
            DBMS_OUTPUT.PUT_LINE('1');
        WHEN MAX_SALARY BETWEEN 2000001 AND 3000000 THEN
            DBMS_OUTPUT.PUT_LINE('2');
        ELSE
            DBMS_OUTPUT.PUT_LINE('3');
    END CASE;
END;
/

-- 반복문

-- LOOP
DECLARE
    VN_BASE_NUM NUMBER := 3;
    VN_CNT NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || VN_CNT || '=' ||
                             VN_BASE_NUM * VN_CNT);
        VN_CNT := VN_CNT + 1;
        EXIT WHEN VN_CNT > 9;           -- 종료조건
     END LOOP;
END;
/




-- WHILE LOOP

DECLARE
    VN_BASE_NUM NUMBER := 3;
    VN_CNT NUMBER := 1;
BEGIN
    WHILE VN_CNT <= 9 LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || VN_CNT || '=' ||
                             VN_BASE_NUM * VN_CNT);
        VN_CNT := VN_CNT + 1;
    END LOOP;
END;
/


-- FOR LOOP
DECLARE
    VN_BASE_NUM NUMBER := 3;
BEGIN
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || i || '=' ||
                             VN_BASE_NUM * i);
    END LOOP;
END;
/





-- FOR LOOP (REVERSE)
DECLARE
    VN_BASE_NUM NUMBER := 3;
BEGIN
    FOR i IN REVERSE 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || i || '=' ||
                             VN_BASE_NUM * i);
    END LOOP;
END;
/



-- CONTINUE

DECLARE
    VN_NUM NUMBER := 1;
BEGIN
    FOR i IN 1..20
    LOOP
        CONTINUE WHEN MOD(i, 2) = 0;        -- 짝수일 때, 건너뜀
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/


-- 함수
-- 부서번호로, 부서명을 구하는 함수 생성
CREATE OR REPLACE FUNCTION get_dept_title ( p_dept_id NUMBER )
RETURN VARCHAR2
IS
    OUT_DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT DEPT_TITLE
      INTO OUT_DEPT_TITLE
    FROM DEPARTMENT
    WHERE DEPT_ID = p_dept_id;

    RETURN OUT_DEPT_TITLE;
END;
/

-- SELECT 문에서 함수 실행
SELECT get_dept_title(200)
FROM dual;


-- 블록에서 함수 실행
DECLARE
    RESULT DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    RESULT := GET_DEPT_TITLE( 'D1' )
    DBMS_OUTPUT.PUT_LINE( RESULT );
END;
/








-- 114.
-- 사원번호로 부서명을 구하는 함수를 정의하시오.

CREATE OR REPLACE FUNCTION dept_title( p_emp_id VARCHAR2 ) 
RETURN VARCHAR2
IS
    OUT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT DEPT_TITLE
      INTO OUT_TITLE
    FROM EMPLOYEE E
        ,DEPARTMENT D
    WHERE E.DEPT_CODE = D.DEPT_ID
      AND E.EMP_ID = p_emp_id;
    RETURN OUT_TITLE;
END;
/

-- SELECT 문으로 함수 실행
SELECT dept_title( emp_id )
FROM employee;


-- 블록에서 함수 실행
DECLARE
    RESULT DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    RESULT := DEPT_TITLE( '200' )
    DBMS_OUTPUT.PUT_LINE( RESULT );
END;
/



-- 함수 생성
-- emp_id 를 인자로 넘겨주면,
-- 사원 구분을 '매니저', '사원' 으로 반환하는 함수를 정의해보세요.
-- 함수명: emp_type( )

SELECT EMP_ID
      ,EMP_NAME
      ,DEPT_TITLE( EMP_ID ) 부서명
      ,EMP_TYPE( EMP_ID ) 구분
FROM EMPLOYEE;


-- 
CREATE OR REPLACE FUNCTION EMP_TYPE( P_EMP_ID VARCHAR2 ) 
RETURN VARCHAR2
IS
    RESULT VARCHAR2(10);
BEGIN
    -- 직원 타입 조회
    SELECT
        CASE
            WHEN EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = p_emp_id )
            THEN '매니저'
            ELSE '사원'
        END
        INTO RESULT
    FROM dual;
    RETURN RESULT;
END;
/








-- 프로시저 생성
CREATE OR REPLACE PROCEDURE PRO_PRINT
IS
    V_A NUMBER := 10;
    V_B NUMBER := 20;
    V_C NUMBER;
BEGIN
    V_C := V_A + V_B;
    DBMS_OUTPUT.PUT_LINE('V_C : ' || V_C);
END;
/


-- 프로시저 실행
SET SERVEROUTPUT ON;
EXECUTE PRO_PRINT();








-- 파라미터 있는 프로시저 생성
CREATE OR REPLACE PROCEDURE PRO_EMP_WRITER
(
    IN_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
    IN_TITLE IN VARCHAR2 DEFAULT '제목없음',
    IN_CONTENT IN VARCHAR2 DEFAULT '내용없음'
)
IS
    V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;

BEGIN
    SELECT EMP_NAME INTO V_EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    INSERT INTO BOARD( BOARD_NO, TITLE, WRITER, CONTENT )
    VALUES ( SEQ_BOARD.NEXTVAL, IN_TITLE, V_EMP_NAME, IN_CONTENT );
END;
/

-- SEQ_BOARD 시퀀스 생성
CREATE SEQUENCE SEQ_BOARD
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 10000;

SELECT * FROM BOARD;

-- 프로시저 실행
EXECUTE PRO_EMP_WRITER( '200', '글 제목', '글 내용' );

EXECUTE PRO_EMP_WRITER( '200', '글 제목' );

EXECUTE PRO_EMP_WRITER( '200' );


-- 인사 정보
SELECT * FROM EMPLOYEES;
-- 부서 정보
SELECT * FROM DEPARTMENTS;
-- 직무 이력
SELECT * FROM JOB_HISTORY;




-- 직무 변경에 따른 직무 이력 갱신하기
CREATE OR REPLACE PROCEDURE PRO_APP_EMP (
    -- 파라미터
    IN_EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE,     -- 사원번호
    IN_JOB_ID IN JOBS.JOB_ID%TYPE,               -- 직무ID
    IN_STD_DATE IN DATE,                         -- 직무 시작일
    IN_END_DATE IN DATE                          -- 직무 종료일
)
IS
    -- 선언부
    V_DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE;     -- 부서번호
    V_CNT NUMBER := 0;                          -- 직무이력 개수
BEGIN
    -- 실행부
    -- 1. 사원 테이블에서 부서번호 조회
    SELECT DEPARTMENT_ID INTO V_DEPT_ID
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = IN_EMP_ID;

    -- 2. 사원 테이블의 JOB_ID 수정
    -- AC_MGR   -->     IT_PROG
    UPDATE EMPLOYEES
       SET JOB_ID = IN_JOB_ID
    WHERE EMPLOYEE_ID = IN_EMP_ID;

    -- 3. 직무이력 테이블에 업무이력 생신
    -- * 현재 날짜에 포함된 직무이력 여부 확인
    SELECT COUNT(*) INTO V_CNT      -- 직무이력 개수
    FROM JOB_HISTORY
    WHERE EMPLOYEE_ID = IN_EMP_ID
      AND sysdate BETWEEN START_DATE AND END_DATE;

    -- 해당 기간에 직무 이력이 없으면 --> 새로 추가
    IF V_CNT = 0 THEN
        INSERT INTO JOB_HISTORY( EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID )
        VALUES ( IN_EMP_ID, IN_STD_DATE, IN_END_DATE, IN_JOB_ID, V_DEPT_ID );
    -- 해당 기간에 직무 이력이 있으면 --> 직무ID, 시작일, 종료일 변경 
    ELSE
        UPDATE JOB_HISTORY
           SET JOB_ID = IN_JOB_ID
              ,START_DATE = IN_STD_DATE
              ,END_DATE = IN_END_DATE
        WHERE EMPLOYEE_ID = IN_EMP_ID 
          AND sysdate BETWEEN START_DATE AND END_DATE;
          
    END IF;
END;
/

-- 
EXECUTE PRO_APP_EMP( '200', 'IT_PROG', '2025/01/01', '2026/01/01' );


SELECT * FROM JOB_HISTORY
ORDER BY EMPLOYEE_ID;
 









-- OUT 파라미터를 사용한 프로시저
-- '200/김조은/3,000,000'
CREATE OR REPLACE PROCEDURE PRO_OUT_EMP (
    IN_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,  -- 사원번호
    OUT_RESULT_STR OUT CLOB
)
IS
    V_EMP EMPLOYEE%ROWTYPE;
    -- %ROWTYPE
    -- : 해당 테이블 또는 뷰의 컬럼들을 참조타입으로 선언
BEGIN
    SELECT * INTO V_EMP
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    OUT_RESULT_STR := V_EMP.EMP_ID
                      || '/' || V_EMP.EMP_NAME
                      || '/' || V_EMP.SALARY;
END;
/

-- OUT 파라미터 프로시저 실행(블록으로 실행)
DECLARE
    -- 프로시저 OUT 결과를 받아올 변수
    OUT_RESULT_STR CLOB;
BEGIN
    -- 프로시저 실행
    PRO_OUT_EMP( '200', OUT_RESULT_STR );
    DBMS_OUTPUT.PUT_LINE( OUT_RESULT_STR );
END;
/





-- 프로시저로 OUT 파라미터 2개 이상 사용하기
CREATE OR REPLACE PROCEDURE PRO_OUT_MUL (
    IN_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
    OUT_DEPT_CODE OUT EMPLOYEE.DEPT_CODE%TYPE,
    OUT_JOB_CODE OUT EMPLOYEE.JOB_CODE%TYPE
)
IS
    V_EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * INTO V_EMP
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    OUT_DEPT_CODE := V_EMP.DEPT_CODE;
    OUT_JOB_CODE := V_EMP.JOB_CODE;
END;
/






-- 프로시저 호출
-- 1) 매개변수 없거나, IN 매개변수만 : EXECUTE 프로시저명( 인자1, 인자2 );
-- 2) OUT 매개변수                  : PL/SQL 블록 안에서 호출

-- EXECUTE PRO_OUT_MUL( 1, 2, 3 ) -- OUT 파라미터가 있어서, 블록 안에서 호출해야함

DECLARE
    OUT_DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    OUT_JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
BEGIN
    -- 호출
    PRO_OUT_MUL( '200', OUT_DEPT_CODE, OUT_JOB_CODE );
    DBMS_OUTPUT.PUT_LINE('부서코드 : ' || OUT_DEPT_CODE );
    DBMS_OUTPUT.PUT_LINE('직급코드 : ' || OUT_JOB_CODE );
END;
/




-- 프로시저에서 예외처리
CREATE OR REPLACE PROCEDURE PRO_PRINT_EMP(
    IN_EMP_ID IN EMPLOYEE.EMP_ID%TYPE    
)
IS
    STR_EMP_INFO CLOB;
    V_EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * INTO V_EMP
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    STR_EMP_INFO := '사원정보' || CHR(10) ||
                    '사원명 : ' || V_EMP.EMP_NAME || CHR(10) ||
                    '이메일 : ' || V_EMP.EMAIL || CHR(10) ||
                    '전화번호 : ' || V_EMP.PHONE;

    DBMS_OUTPUT.PUT_LINE( STR_EMP_INFO );

    -- 예외처리부
    EXCEPTION
        -- NO_DATA_FOUND : SELECT INTO 변수 를 사용할 때, 조회 결과가 하나도 없는 경우 예외 발생
        WHEN NO_DATA_FOUND THEN
            STR_EMP_INFO := '존재하지 않는 사원ID 입니다.';
            DBMS_OUTPUT.PUT_LINE( STR_EMP_INFO );
END;
/

-- 존재하는 사원 번호
EXECUTE PRO_PRINT_EMP('200')


-- 존재하는 않는 사원 번호 (예외 발생)
EXECUTE PRO_PRINT_EMP('300')






-- 115.
/* 
    사원 번호를 입력하면, 해당 사원을 아래 <조건>에 따라 승진시키는 프로시저를 완성하시오.
    <조건>
    프로시저명 : PROMOTE_EMPLOYEE( 사원번호 );  
    아래는 각 직급별 근속연수이다. 아래 조건에 맞추어 사원을 승진시키시오.
    부사장 16~20년   
    부장 14~15년
    차장 11~13년
    과장 7~10년
    대리 4~6년
    사원 1~3년
*/

CREATE OR REPLACE PROCEDURE PROMOTE_EMPLOYEE( 
    P_EMP_ID IN NUMBER
)
AS
    -- 근속연수
    V_YEAR_OF_WORK NUMBER;
    -- 직급번호
    V_JOB_CODE VARCHAR2(2);
BEGIN
    -- 근속 연수 조회
    SELECT TRUNC( MONTHS_BETWEEN( SYSDATE, HIRE_DATE ) / 12 )
      INTO V_YEAR_OF_WORK
    FROM EMPLOYEE
    WHERE EMP_ID = p_emp_id;

    -- 근속 연수에 따라 직급 코드 결정
    IF V_YEAR_OF_WORK > 15 THEN V_JOB_CODE := 'J2';
    ELSIF V_YEAR_OF_WORK > 13 THEN V_JOB_CODE := 'J3';
    ELSIF V_YEAR_OF_WORK > 10 THEN V_JOB_CODE := 'J4';
    ELSIF V_YEAR_OF_WORK > 6 THEN V_JOB_CODE := 'J5';
    ELSIF V_YEAR_OF_WORK > 3 THEN V_JOB_CODE := 'J6';
    ELSE
        DBMS_OUTPUT.PUT_LINE('승진 대상 사원이 아닙니다.');
        RETURN;
    END IF;
    -- 직급 수정 (승진)
    UPDATE EMPLOYEE
    SET JOB_CODE = V_JOB_CODE
    WHERE EMP_ID = P_EMP_ID;

    -- 결과 메시지 출력
    DBMS_OUTPUT.PUT_LINE(P_EMP_ID || ' 사원을 ' 
                                  || V_JOB_CODE
                                  || ' 직급으로 승진시켰습니다.'
                        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('존재하지 않는 사원번호입니다.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('예외 발생 : ' || SQLERRM);
        -- SQLERRM : 에러 메시지를 반환
END;
/

-- 실행
BEGIN
    PROMOTE_EMPLOYEE( 215 );
END;
/
SELECT * FROM EMPLOYEE;














