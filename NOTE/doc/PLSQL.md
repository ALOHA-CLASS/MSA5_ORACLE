# PL/SQL
: SQL 을 절차적 프로그래밍이 가능하도록 확장한 언어


## PL/SQL 기본 구조

▶ 블록
: PL/SQL 프로그램의 기본 단위

* 형태
DECLARE
    필요한 요소를 선언;      -- 선언부
BEGIN
    실행 명령어;             -- 실행부
EXCEPTION
    예외 처리하는 부분       -- 예외 처리부
END;
/ 

▶ 익명 블록
: 이름이 없은 블록
- 컴파일이 완료가 되면, 실행까지 동시에 완료된다.


▶ PL/SQL 출력

SET SERVEROUTPUT ON;            -- 실행결과를 출력하도록 설정
BEGIN
    DBMS_OUTPUT.PUT_LINE('출력 메시지');
END;
/


▶ 기본 문법사항
- 블록의 부분은 지정하는 명령에서는 ;(세미콜론)을 사용하지 않는다
  (DECLARE, BEGIN, EXCEPTION)
- 블록의 각 부분에서 실행하는 문장에는 ;(세미콜론)을 사용한다
- 한 줄 주석(--), 여러 줄 주석 (/*  */)
- PL/SQL 작성 후 실행 시, 마지막에 / 를 사용


▶ PL/SQL 구성요소
- 변수
- 상수
- 연산자
- 주석
- DML문

▶ 변수 선언

    변수명 데이터타입 := 값;

▶ 상수 선언

    상수명 CONSTANT 데이터타입 := 값;

▶ 변수의 기본값 지정

    변수명 데이터타입 DEFAULT 값;

▶ 변수의 NOT NULL 지정

    변수명 데이터타입 NOT NULL 값;


▶ 데이터타입
- 스칼라형      : NUMBER, CHAR, VARCHAR2, DATE, BOOLEAN

- 참조형        : 이미 테이블의 정의된 컬럼의 타입을 참조
                * 변수명 테이블명.컬럼%TYPE := 값;



▶ 연산자
    (우선순위 높음)
    **              제곱 연산자
    +, -            부호 연산자   (+10, -10)
    *, /            곱셈, 나눗셈
    +, -, ||        덧셈, 뺄셈, 문자열 연결 연산자   (1+2)
    비교 연산자
    NOT
    AND
    OR
    (우선순위 낮음)

▶ 주석
- 한줄 주석     : --
- 여러 줄 주석  : /*  */


▶ DML 문
- SELECT, INSERT, UPDATE, DELETE.
- PL/SQL 상에서 DDL 은 직접 쓸 수 없다.
- PL/SQL 에서는 주로 DML 을 사용한다.

* 주로 데이터를 조회한 결과값을 변수에 대입하는 SELECT 문을 많이 사용한다.

* INTO 절을 이용해서, 조회결과를 변수에 대입한다.
ex)  SELECT e.emp_name, d.dept_title
       INTO vs_emp_name, vs_dept_name       -- 조회결과를 변수에 대입
      ...



▶ 제어문
- 조건문, 반복문


▶ 조건문
- IF, CASE

 ● IF
    * IF ~ THEN
    * IF ~ THEN ~ ELSE
    * IF ~ THEN ~ ELSIF

    * 기본 형식
    #--------------------------------
    IF 조건식 THEN 실행할 명령어;
    END IF;

    #--------------------------------
    IF 조건식 
    THEN 
        실행할 명령어;
    ELSE
        실행할 명령어;
    END IF;

    #--------------------------------
    IF 조건식 
        THEN 실행할 명령어;
    ELSEIF 조건식
        THEN 실행할 명령어;
    ELSEIF 조건식
        THEN 실행할 명령어;
    ELSE
        실행할 명령어;
    END IF;

  ● CASE

    CASE 비교 기준
        WHEN 값1 THEN 
                실행할 명령어;
        WHEN 값2 THEN 
                실행할 명령어;
        ...
        ELSE
                실행할 명령어;
    END CASE;                
            

▶ 반복문

 ● LOOP

    LOOP 
        반복 실행할 명령어;
        (EXIT WHEN 종료조건);    
    END LOOP;


 ● WHILE LOOP

    WHILE 조건식 LOOP
        반복 실행할 명령어;
    END LOOP;


 ● FOR  LOOP

    FOR i IN 시작값..종료값 LOOP
        반복 실행할 명령어;
    END FOR;

    FOR i N REVERSE 시작값..종료값 LOOP
        반복 실행할 명령어;
    END LOOP;


 ● EXIT, CONTINUE
    
    - EXIT                  : 반복문 종료
    - EXIT WHEN 조건        : 조건식 만족하면, 반복 종료
    - CONTINUE              : 현재 반복주기를 넘어간다
    - CONTINUE WHEN 조건    : 조건식 만족하면, 현재 반복주기를 넘어간다



▶ 함수
    * 분류 : 내장 함수, 사용자 정의 함수


    * 함수 생성

    CREATE OR REPLACE FUNCTION 함수명
    (
        파라미터1 [IN] 데이터타입,
        파라미터2 [IN] 데이터타입,
        ...
    )
    RETURN 반환타입
    IS | AS
        선언부;
    BEGIN
        실행부;
        RETURN (반환 값);
    EXCEPTION
        예외 처리부;
    END [함수명];


    * 함수 실행
    - 블록 안에서 실행
    DECLARE
        변수명 데이터타입;
    BEGIN
        변수명 := 함수명(인자1, 인자2, ...);
    END;
    /

    - SELECT 에서 실행
    SELECT 함수명(인자1, 인자2, ... ) 
    FROM 테이블명;

    * 함수 삭제
    DROP FUNCTION 함수명;



▶ 프로시저 (PROCEDURE)
: 특정 업무를 처리하는 일련의 작업을 프로그램으로 저장하여 사용하는 객체

 * 프로시저 생성 (파라미터 없는 프로시저)

    CREATE OR REPLACE PROCEDURE 프로시저명
    IS | AS
        선언부
    BEGIN
        실행부
    EXCEPTION
        예외 처리부
    END [프로시저명];


 * 프로시저 생성 (파라미터 있는 프로시저)

    CREATE OR REPLACE PROCEDURE 프로시저명
    (
        파라미터1 [IN / OUT / IN OUT] 데이터타입 [ := 값 | DEFAULT 기본값 ],
        파라미터2 [IN / OUT / IN OUT] 데이터타입 [ := 값 | DEFAULT 기본값 ],
        ...
    )
    IS | AS
        선언부
    BEGIN
        실행부
    EXCEPTION
        예외 처리부
    END [프로시저명];

 * 프로시저 실행
    
    SET SERVEROUTPUT ON;

    EXCUTE 프로시저명;

    EXCUTE 프로시저명(인자1, 인자2, ...);

    EXCUTE 프로시저명(파라미터1 => 인자1, 파라미터2 => 인자2, ...);


 * 프로시저 삭제

    DROP PROCEDURE 프로시저명;



