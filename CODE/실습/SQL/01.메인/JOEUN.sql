-- Active: 1709601465263@@127.0.0.1@1521@orcl@JOEUN
-- 72.
-- MS_BOARD 의 WRITER 속성을 NUMBER 타입으로 변경하고
-- MS_USER 의 USER_NO 를 참조하는 외래키로 지정하시오.

-- 1)
-- 데이터 타입 변경
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입;
ALTER TABLE MS_BOARD MODIFY WRITER NUMBER;

-- 외래키 지정
-- ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명
-- FOREIGN KEY (외래키컬럼) REFERENCES 참조테이블(기본키);
ALTER TABLE MS_BOARD ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY (WRITER) REFERENCES MS_USER(USER_NO);


-- 2) 외래키 : MS_FILE (BOARD_NO)  ---->  MS_BOARD (BOARD_NO)
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);


-- 3) 외래키 : MS_REPLY (BOARD_NO)  ---->  MS_BOARD (BOARD_NO)
ALTER TABLE MS_REPLY ADD CONSTRAINT MS_REPLY_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);

-- 제약조건 삭제
-- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;



-- 73.
-- MS_USER 테이블에 속성을 추가하시오.
ALTER TABLE MS_USER ADD CTZ_NO CHAR(14) NOT NULL UNIQUE;
ALTER TABLE MS_USER ADD GENDER CHAR(6) NOT NULL;

COMMENT ON COLUMN MS_USER.CTZ_NO IS '주민번호';
COMMENT ON COLUMN MS_USER.GENDER IS '성별';



-- 74.
-- MS_USER 의 GENDER 속성이 ('여', '남', '기타') 값만 갖도록
-- 제약조건을 추가하시오.
-- CHECK 제약조건 추가

ALTER TABLE MS_USER 
ADD CONSTRAINT MS_USER_GENDER_CHECK
CHECK ( gender IN ('여', '남', '기타') );




-- 75.
-- MS_FILE 테이블에 확장자(EXT) 속성을 추가하시오.

ALTER TABLE MS_FILE ADD EXT VARCHAR2(10) NULL;
COMMENT ON COLUMN MS_FILE.EXT IS '확장자';


-- 76.
-- 테이블 MS_FILE 의 FILE_NAME 속성에서 확장자를 추출하여 
-- EXT 속성에 UPDATE 하는 SQL 문을 작성하시오. 

MERGE INTO MS_FILE T      -- 대상 테이블 지정
-- 사용할 데이터 자원을 지정
USING ( SELECT FILE_NO, FILE_NAME FROM MS_FILE ) F 
-- ON (UPDATE 조건)
ON (T.FILE_NO = F.FILE_NO)
-- 매치조건
WHEN MATCHED THEN
    -- 이미지 파일 확장자를 추출하여 수정
    UPDATE SET T.EXT = SUBSTR( F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) + 1 )
    -- 이미지 확장자(jpeg, jpg, gif, png, webp)가 아니면 삭제
    DELETE WHERE LOWER( SUBSTR( F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) + 1 ) )
                 NOT IN ('jpeg', 'jpg', 'gif', 'png', 'webp')

-- 매치가 안됐을 때 조건
-- WHEN NOT MATCHED THEN
;

SELECT * FROM MS_FILE;





-- 파일 추가
INSERT INTO MS_FILE ( 
            FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT
            )
VALUES (1, 1, '강아지.png', '123', sysdate, sysdate, 'jpg' );


INSERT INTO MS_FILE ( 
            FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT
            )
VALUES (2, 1, 'main.html', '123', sysdate, sysdate, 'jpg' );



-- 게시글 추가
INSERT INTO MS_BOARD (
                BOARD_NO, TITLE, CONTENT, WRITER, HIT, LIKE_CNT,
                DEL_YN, DEL_DATE, REG_DATE, UPD_DATE
                )
VALUES (
        1, '제목', '내용', 1, 0, 0, 'N', NULL, sysdate, sysdate
        );


-- 유저 추가
INSERT INTO MS_USER(
                USER_NO, USER_ID, USER_PW, USER_NAME, BIRTH,
                TEL, ADDRESS, REG_DATE, UPD_DATE,
                CTZ_NO, GENDER
                )
VALUES ( 1, 'ALOHA', '123456', '김조은', TO_DATE('2003/01/01', 'YYYY/MM/DD'),
         '010-1234-1234', '부평', sysdate, sysdate,
         '030101-3334444', '기타');





-- 77.
-- 테이블 MS_FILE 의 EXT 속성이
-- ('jpg', 'jpeg', 'gif', 'png', 'webp') 값을 갖도록 하는 제약조건을 추가하시오.

ALTER TABLE MS_FILE
ADD CONSTRAINT MS_FILE_EXT_CHECK
CHECK (EXT IN ('jpg', 'jpeg', 'gif', 'png', 'webp'));

ALTER TABLE MS_FILE
DROP CONSTRAINT MS_FILE_EXT_CHECK;



-- 78.
-- MS_USER, MS_BOARD, MS_FILE, MS_REPLY 테이블의
-- 모든 데이터를 삭제하는 명령어를 작성하시오.
-- DDL - TRUNCATE
TRUNCATE TABLE MS_USER;
TRUNCATE TABLE MS_BOARD;
TRUNCATE TABLE MS_FILE;
TRUNCATE TABLE MS_REPLY;
-- DML - DELETE
DELETE FROM MS_USER;
DELETE FROM MS_BOARD;
DELETE FROM MS_FILE;
DELETE FROM MS_REPLY;

-- SELECT
SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;
SELECT * FROM MS_REPLY;



-- DELETE vs TRUNCATE
-- * DELETE - 데이터 조작어(DML)
--   - 한 행 단위로 데이터를 삭제한다.
--   - WHERE 조건절을 기준으로 일부만 삭제도 가능하다.
--   - COMMIT, ROLLBACK 를 이용하여 변경사항을 적용하거나 되돌릴 수 있음

-- * TRUNCATE - 데이터 정의어(DDL)
--   - 모든 행을 삭제한다.
--   - 삭제된 데이터를 되돌릴 수 없음



-- 79.
-- 테이블의 속성을 삭제하시오.
-- * MS_BOARD 테이블의 WRITER 속성
-- * MS_FILE 테이블의 BOARD_NO 속성
-- * MS_REPLY 테이블의 BOARD_NO 속성

ALTER TABLE MS_BOARD DROP COLUMN WRITER;
ALTER TABLE MS_FILE DROP COLUMN BOARD_NO;
ALTER TABLE MS_REPLY DROP COLUMN BOARD_NO ;
-- 80.
-- 각 테이블에 속성들을 추가한 뒤, 외래키로 지정하시오.
-- 해당 외래키에 대하여 참조 테이블의 데이터 삭제 시,
-- 연결된 속성의 값도 삭제하는 옵션도 지정하시오.

-- 1)
-- MS_BOARD 에 WRITER 속성 추가
ALTER TABLE MS_BOARD ADD WRITER NUMBER NOT NULL;

-- WRITER 속성을 외래키로 지정
-- + 참조 테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ALTER TABLE MS_BOARD
ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY (WRITER) REFERENCES MS_USER(USER_NO)
ON DELETE CASCADE
;
-- ON DELETE [NO ACTION, RESTRICT, CASCADE, SET NULL]
-- * NO ACTION  : 아무 행위도 안함.
-- * RESTRICT   : 자식 테이블의 데이터가 존재하면, 삭제 안 함
-- * CASCADE    : 자식 테이블의 데이터도 함께 삭제
-- * SET NULL   : 자식 테이블의 데이터를 NULL 로 지정


-- 2)
-- MS_FILE 에 BOARD_NO 속성 추가
ALTER TABLE MS_FILE ADD BOARD_NO NUMBER NOT NULL;

-- BOARD_NO 속성을 외래키로 추가
-- 참조테이블 : MS_BOARD, 참조 속성 : BOARD_NO
-- + 참조 테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ALTER TABLE MS_FILE
ADD CONSTRAINT MS_FILE_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
ON DELETE CASCADE
;

-- 3)
-- MS_REPLY 에 BOARD_NO 속성 추가
ALTER TABLE MS_REPLY ADD BOARD_NO NUMBER NOT NULL;

-- BOARD_NO 속성을 외래키로 추가
-- 참조테이블 : MS_BOARD, 참조 속성 : BOARD_NO
-- + 참조 테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ALTER TABLE MS_REPLY
ADD CONSTRAINT MS_REPLY_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
ON DELETE CASCADE
;


SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;
SELECT * FROM MS_REPLY;

-- 회원 탈퇴 (회원번호 : 1)
DELETE FROM MS_USER WHERE USER_NO = 1;


-- 외래키 제약 조건
ALTER TABLE 테이블명
ADD CONSTRAINT 제약조건명 FOREIGN KEY (외래키 속성)
REFERENCES 참조테이블(참조 속성)
ON UPDATE [NO ACTION, RESTRICT, CASCADE, SET NULL]
ON DELETE [NO ACTION, RESTRICT, CASCADE, SET NULL]
;

-- 옵션
-- ON UPDATE            -- 참조 테이블 수정 시,
--  * CASCADE           : 자식 데이터 수정
--  * SET NULL          : 자식 데이터는 NULL 
--  * SET DEFAULT       : 자식 데이터는 기본값
--  * RESTRICT          : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 수정 불가
--  * NO ACTION         : 아무런 행위도 취하지 않는다 (기본값)

-- ON DELETE            -- 참조 테이블 삭제 시,
--  * CASCADE           : 자식 데이터 삭제
--  * SET NULL          : 자식 데이터는 NULL 
--  * SET DEFAULT       : 자식 데이터는 기본값
--  * RESTRICT          : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 삭제 불가
--  * NO ACTION         : 아무런 행위도 취하지 않는다 (기본값)






-- 81.
-- EMPLOYEE, DEPARTMENT, JOB 테이블을 사용하여
-- 스칼라 서브쿼리로 출력결과와 같이 조회하시오.

SELECT * FROM EMPLOYEE;     -- 사원
SELECT * FROM DEPARTMENT;   -- 부서
SELECT * FROM JOB;          -- 직급

-- 스칼라 서브쿼리
-- 사원번호, 직원명, 부서명, 직급명
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,(SELECT DEPT_TITLE FROM DEPARTMENT d WHERE e.DEPT_CODE = d.DEPT_ID) 부서명
      ,(SELECT JOB_NAME FROM JOB j WHERE e.JOB_CODE = j.JOB_CODE) 직급명
FROM EMPLOYEE e
;


-- 82.
-- 출력결과를 참고하여,
-- 인라인 뷰를 이용해 부서별로 최고급여를 받는 직원을 조회하시오.

-- 1. 부서별로 최고급여를 조회 (서브쿼리)
SELECT  DEPT_CODE   부서코드
       ,MAX(salary) 최고급여
       ,MIN(salary) 최저급여
       ,AVG(salary) 평균급여
FROM EMPLOYEE
GROUP BY DEPT_CODE
;


-- 2. 부서별로 최고급여 조회결과를 서브쿼리(인라인 뷰)로 지정
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_TITLE 부서명
      ,e.SALARY 급여
      ,t.MAX_SAL 최고급여
      ,t.MIN_SAL 최저급여
      ,ROUND(t.AVG_SAL, 2) 평균급여
FROM EMPLOYEE e, DEPARTMENT d,
    (
        SELECT  DEPT_CODE   부서코드
       ,MAX(salary) MAX_SAL
       ,MIN(salary) MIN_SAL
       ,AVG(salary) AVG_SAL
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
    ) t
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY = t.MAX_SAL
;







-- 83.
-- 서브쿼리를 이용하여,
-- 직원명이 '이태림' 인 사원과 같은 부서의 직원들을 조회하시오.

SELECT EMP_ID 사원번호
      ,EMP_NAME 직원명
      ,EMAIL 이메일
      ,PHONE 전화번호
FROM EMPLOYEE
WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '이태림'
                  )
;





-- 84.
-- 사원 테이블에 존재하는 부서코드만 포함하는 부서를 조회하시오.
-- (사원이 존재하는 부서만 조회하시오.)

SELECT DEPT_ID FROM DEPARTMENT;                 -- D1~D9 (9개)
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE ORDER BY DEPT_CODE ASC; -- D1,D2,D5,D6,D8,D9,NULL
-- 사원이 없는 부서 : D3, D4, D7

-- 1) 서브쿼리
SELECT DEPT_ID 부서번호
      ,DEPT_TITLE 부서명
      ,LOCATION_ID 지역명
FROM DEPARTMENT
WHERE DEPT_ID IN (
                    SELECT DISTINCT DEPT_CODE 
                    FROM EMPLOYEE
                    WHERE DEPT_CODE IS NOT NULL
                  )
; 

-- 2) EXISTS
SELECT DEPT_ID 부서번호
      ,DEPT_TITLE 부서명
      ,LOCATION_ID 지역명
FROM DEPARTMENT d
WHERE EXISTS ( 
               SELECT * 
               FROM EMPLOYEE e
               WHERE d.DEPT_ID = e.DEPT_CODE
             )

;




-- 85.
-- 사원 테이블에 존재하지 않는 부서코드만 포함하는 부서를 조회하시오.
-- (사원이 존재하지 않는 부서만 조회하시오.)

-- 사원이 있는 부서 : D1, D2, D5, D6, D8, D9
-- 사원이 없는 부서 : D3, D4, D7 

-- 1) 서브쿼리
SELECT DEPT_ID 부서번호
      ,DEPT_TITLE 부서명
      ,LOCATION_ID 지역명
FROM DEPARTMENT
WHERE DEPT_ID NOT IN (
                    SELECT DISTINCT DEPT_CODE 
                    FROM EMPLOYEE
                    WHERE DEPT_CODE IS NOT NULL
                  )
; 

-- 2) EXISTS
SELECT DEPT_ID 부서번호
      ,DEPT_TITLE 부서명
      ,LOCATION_ID 지역명
FROM DEPARTMENT d
WHERE NOT EXISTS ( 
               SELECT * 
               FROM EMPLOYEE e
               WHERE d.DEPT_ID = e.DEPT_CODE
             )

;



-- 86.
-- EMPLOYEE 테이블의 DEPT_CODE 가 'D1' 인 부서의 최대급여 보다
-- 더 큰 급여를 받는 사원을 조회하시오.

SELECT *
FROM EMPLOYEE, DEPARTMENT;    -- 사원X부서 : 23 X 9 = 207

SELECT * FROM EMPLOYEE;       -- 사원 : 23
SELECT * FROM DEPARTMENT;     -- 부서 : 9

-- 사원번호, 직원명, 부서번호, 부서명, 급여
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,e.SALARY 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
;

-- 1) 
-- 1. 부서코드가 'D1'인 사원의 최대급여
SELECT MAX(salary)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'
;


-- 2. 급여가 3660000 보다 큰 사원을 조회
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,TO_CHAR(e.SALARY, '999,999,999,999') 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > 3660000
;

-- 3. 3660000 자리에 1번 쿼리를 대입
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,TO_CHAR(e.SALARY, '999,999,999,999') 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > (
                   SELECT MAX(salary)
                   FROM EMPLOYEE
                   WHERE DEPT_CODE = 'D1'
                  )
;



-- 2)
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,TO_CHAR(e.SALARY, '999,999,999,999') 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > ALL (
                        SELECT salary
                        FROM EMPLOYEE
                        WHERE DEPT_CODE = 'D1'
                     )
;



-- 87.
-- EMPLOYEE 테이블의 DEPT_CODE 가 'D9' 인 부서의 최저급여 보다
-- 더 큰 급여를 받는 사원을 조회하시오.

-- 1) 
-- 1. 부서코드가 'D9'인 사원의 최저급여
SELECT MIN(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'
;

-- 2. 급여 > 최저급여
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,TO_CHAR(e.SALARY, '999,999,999,999') 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > (
                    SELECT MIN(SALARY)
                    FROM EMPLOYEE
                    WHERE DEPT_CODE = 'D9'
                 )
;


-- 2)
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,TO_CHAR(e.SALARY, '999,999,999,999') 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > ANY (
                        SELECT salary
                        FROM EMPLOYEE
                        WHERE DEPT_CODE = 'D9'
                     )
;


-- 88.
-- EMPLOYEE 와 DEPARTMENT 테이블을 조인하여 출력하되,
-- 부서가 없는 직원도 포함하여 출력하시오.

-- 사원번호, 직원명, 부서번호, 부서명

SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,NVL(d.DEPT_ID, '(없음)') 부서번호
      ,NVL(d.DEPT_TITLE, '(없음)') 부서명
FROM EMPLOYEE e 
     LEFT JOIN DEPARTMENT d
     ON (e.DEPT_CODE = d.DEPT_ID)
;

-- NULL 나오는 사원 : 부서가 없는 사원


-- 89.
-- EMPLOYEE 와 DEPARTMENT 테이블을 조인하여 출력하되,
-- 직원이 없는 부서도 포함하여 출력하시오.

SELECT NVL(e.EMP_ID, '(없음)') 사원번호
      ,NVL(e.EMP_NAME, '(없음)') 직원명
      ,d.DEPT_ID  부서번호
      ,d.DEPT_TITLE  부서명
FROM EMPLOYEE e 
     RIGHT JOIN DEPARTMENT d
     ON (e.DEPT_CODE = d.DEPT_ID)
;



-- NULL 이 나오는 데이터 : 사원이 없는 부서




--90.
-- 직원 및 부서 유무에 상관없이 출력하는 SQL문을 작성하시오.
SELECT NVL(e.EMP_ID, '(없음)') 사원번호
      ,NVL(e.EMP_NAME, '(없음)') 직원명
      ,NVL(d.DEPT_ID, '(없음)')  부서번호
      ,NVL(d.DEPT_TITLE, '(없음)')  부서명
FROM EMPLOYEE e 
     FULL JOIN DEPARTMENT d
     ON (e.DEPT_CODE = d.DEPT_ID)
;





-- 91.
-- 사원번호, 직원명, 부서번호, 지역명, 국가명, 급여, 입사일자를 출력하시오.

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
SELECT * FROM NATIONAL;

SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_ID 부서번호
      ,D.DEPT_TITLE 부서명
      ,L.LOCAL_NAME 지역명
      ,N.NATIONAL_NAME 국가명
      ,E.SALARY 급여
      ,E.HIRE_DATE 입사일자
FROM EMPLOYEE E
     LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
     LEFT JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
     LEFT JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
;



-- 92.
-- 사원들 중 매니저를 출력하시오.
-- 사원번호, 직원명, 부서명, 직급, 구분('매니저')

-- 1. 
-- MANAGER_ID 컬럼이 NULL 이 아닌 사원을 중복없이 조회
-- ➡ 매니저들의 사원 번호
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2.
-- EMPLOYEE, DEPARTMENT, JOB 테이블을 조인하여 조회
SELECT *
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
;


-- 3.
-- 조인 결과 중, EMP_ID 매니저 사원번호인 경우만 조회
SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,'매니저' 직급
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.EMP_ID IN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL
                  )
;





-- 93.
-- 사원(매니저가 아닌)만 조회하시오.
SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,'사원' 직급
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.EMP_ID NOT IN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL
                  )
;



-- 94.
-- UNION 키워드를 사용하여,
-- 매니저와 사원 구분하여 조회하시오.
SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,'매니저' 직급
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.EMP_ID IN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL
                  )
UNION
SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,'사원' 직급
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.EMP_ID NOT IN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL
                  )
;




-- 95.
-- CASE 키워드를 사용하여,
-- 매니저와 사원을 구분하여 출력하시오
SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,CASE
            WHEN EMP_ID IN (
                              SELECT DISTINCT MANAGER_ID
                              FROM EMPLOYEE
                              WHERE MANAGER_ID IS NOT NULL
                            )
            THEN '매니저'
            ELSE '사원'
       END 구분
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
;



-- 96.
-- EMPLOYEE, DEPARTMENT, JOB 테이블을 조인하여 조회하시오
-- 사원의 나이와 성별을 구하여 출력하고,
-- 주민등록번호 뒷자리 첫글자를 제외하고 마스킹하여 출력하시오.

SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,CASE
            WHEN EMP_ID IN (
                              SELECT DISTINCT MANAGER_ID
                              FROM EMPLOYEE
                              WHERE MANAGER_ID IS NOT NULL
                            )
            THEN '매니저'
            ELSE '사원'
       END 구분
       -- 성별
       -- * 주민등록번호(EMP_NO) 뒷자리 첫글자
       -- 1,3 (남자), 2,4(여자)
       , 
       CASE
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('2','4') THEN '여자'
       END 성별
      
      -- 나이
      -- 1900년대 출생 (주민번호 뒷자리 첫글자가 1,2)
      -- 2000년대 출생 (주민번호 뒷자리 첫글자가 3,4)
      ,TO_CHAR(sysdate, 'YYYY')
      -
      (
            CASE 
                  WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN '19'  
                  WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN '20'  
            END || SUBSTR(EMP_NO, 1, 2)
      ) + 1 현재나이
      -- 만나이
      -- * 태어나면 0살, 햇수가 아니라 생일이 지나야 +1살
      ,TRUNC(
            MONTHS_BETWEEN(  SYSDATE, 
                              TO_DATE(
                                    CASE 
                                          WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN '19'  
                                          WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN '20'  
                                    END || SUBSTR(EMP_NO, 1, 6)
                              , 'YYYYMMDD') -- 생년월일(문자) -- (날짜)
                        ) / 12
      ) 만나이
      -- 주민번호 마스킹
      ,RPAD( SUBSTR(EMP_NO, 1, 8), 14, '*' ) 주민등록번호
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
      JOIN JOB J USING(JOB_CODE)

;

-- USING : 조인하고자 하는 두 테이블 컬럼명이 같으면,
--         ON 키워드 대신 조인 조건을 간단하게 작성하는 키워드



-- 생년월일
SELECT 
      TO_DATE(
            CASE 
                  WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN '19'  
                  WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN '20'  
            END || SUBSTR(EMP_NO, 1, 6)
      , 'YYYYMMDD') -- 생년월일(문자) -- (날짜)
FROM EMPLOYEE
;

-- 오늘 날짜
SELECT SYSDATE
FROM DUAL;


-- 만나이
-- MONTHS_BETWEEN( 오늘날짜, 생년월일 ) 
SELECT TRUNC(
            MONTHS_BETWEEN(  SYSDATE, 
                              TO_DATE(
                                    CASE 
                                          WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN '19'  
                                          WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN '20'  
                                    END || SUBSTR(EMP_NO, 1, 6)
                              , 'YYYYMMDD') -- 생년월일(문자) -- (날짜)
                        ) / 12
      ) 만나이
FROM EMPLOYEE
;


-- 97.
-- 96번 조회결과에 
-- 순번, 만나이, 근속연수, 입사일자, 연봉을 추가하시오.

SELECT ROWNUM 순번
      ,E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,CASE
            WHEN EMP_ID IN (
                              SELECT DISTINCT MANAGER_ID
                              FROM EMPLOYEE
                              WHERE MANAGER_ID IS NOT NULL
                            )
            THEN '매니저'
            ELSE '사원'
       END 구분
       -- 성별
       -- * 주민등록번호(EMP_NO) 뒷자리 첫글자
       -- 1,3 (남자), 2,4(여자)
       , 
       CASE
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('2','4') THEN '여자'
       END 성별
      
      -- 나이
      -- 1900년대 출생 (주민번호 뒷자리 첫글자가 1,2)
      -- 2000년대 출생 (주민번호 뒷자리 첫글자가 3,4)
      ,TO_CHAR(sysdate, 'YYYY')
      -
      (
            CASE 
                  WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN '19'  
                  WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN '20'  
            END || SUBSTR(EMP_NO, 1, 2)
      ) + 1 현재나이
      -- 만나이
      -- * 태어나면 0살, 햇수가 아니라 생일이 지나야 +1살
      ,TRUNC(
            MONTHS_BETWEEN(  SYSDATE, 
                              TO_DATE(
                                    CASE 
                                          WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN '19'  
                                          WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN '20'  
                                    END || SUBSTR(EMP_NO, 1, 6)
                              , 'YYYYMMDD') -- 생년월일(문자) -- (날짜)
                        ) / 12
      ) 만나이
      -- 근속연수
      ,TRUNC(
            MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12
      ) 근속연수
      -- 주민번호 마스킹
      ,RPAD( SUBSTR(EMP_NO, 1, 8), 14, '*' ) 주민등록번호
      -- 입사일자
      ,TO_CHAR(HIRE_DATE, 'YYYY.MM.DD') 입사일자
      -- 연봉 :  (급여 + (급여*보너스)) * 12
      ,TO_CHAR( 
            (SALARY + (SALARY * NVL(BONUS,0) )) * 12
            , '999,999,999,999'
      ) 연봉
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
      JOIN JOB J USING(JOB_CODE)

;


-- 98.
-- employee, department 테이블을 조인하여,
-- 사원번호, 직원명, 부서번호, 부서명, 이메일, 전화번호
-- 주민번호, 입사일자, 급여, 연봉을 조회하시오.
-- CREATE OR REPLACE 객체
-- - 없으면, 새로 생성
-- - 있으면, 대체 (기존에 생성 되어 있어도 에러발생X)


-- 뷰 생성
CREATE OR REPLACE VIEW VE_EMP_DEPT AS
SELECT E.EMP_ID 
      ,E.EMP_NAME 
      ,D.DEPT_TITLE 
      ,E.EMAIL 
      ,E.PHONE 
      ,RPAD( SUBSTR(EMP_NO, 1, 8), 14, '*' ) EMP_NO
      ,TO_CHAR(HIRE_DATE, 'YYYY.MM.DD') HIRE_DATE
      ,E.SALARY 
      ,TO_CHAR( 
            (SALARY + (SALARY * NVL(BONUS,0) )) * 12
            , '999,999,999,999'
      ) YR_SALARY
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
;


-- 뷰 조회
SELECT *
FROM VE_EMP_DEPT
;



-- 99.
-- 시퀀스를 생성하시오.
-- SEQ_MS_USER
-- SEQ_MS_BOARD
-- SEQ_MS_FILE
-- SEQ_MS_REPLY
-- (시작: 1, 증가값: 1, 최솟값: 1, 최댓값: 1000000)
-- 시퀀스 생성

CREATE SEQUENCE SEQ_MS_USER
INCREMENT BY 1          -- 증가값
START WITH 1            -- 시작값
MINVALUE 1              -- 최솟값
MAXVALUE 10000000;      -- 최댓값

CREATE SEQUENCE SEQ_MS_BOARD
INCREMENT BY 1          -- 증가값
START WITH 1            -- 시작값
MINVALUE 1              -- 최솟값
MAXVALUE 10000000;      -- 최댓값

CREATE SEQUENCE SEQ_MS_FILE
INCREMENT BY 1          -- 증가값
START WITH 1            -- 시작값
MINVALUE 1              -- 최솟값
MAXVALUE 10000000;      -- 최댓값

CREATE SEQUENCE SEQ_MS_REPLY
INCREMENT BY 1          -- 증가값
START WITH 1            -- 시작값
MINVALUE 1              -- 최솟값
MAXVALUE 10000000;      -- 최댓값




-- 100.
-- SEQ_MS_USER 의 다음 번화와 현재 번호를 출력하시오.

-- 다음 시퀀스 번호
SELECT SEQ_MS_USER.NEXTVAL FROM DUAL;

-- 현재 시퀀스 번호
SELECT SEQ_MS_USER.CURRVAL FROM DUAL;


-- 101.
-- SEQ_MS_USER 를 삭제하시오.

DROP SEQUENCE SEQ_MS_USER;



-- 102.
-- SEQ_MS_USER 를 이용하여, MS_USER 의 user_no 가
-- 시퀀스 번호로 적용될 수 있도록 데이터를 추가해보시오.

INSERT INTO MS_USER ( USER_NO, USER_ID, USER_PW, USER_NAME,
                      BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE, CTZ_NO, GENDER
                      )
VALUES (
      SEQ_MS_USER.NEXTVAL, 'ALOHA', '123456', '김조은',
      '2024/03/06', '010-1234-1234', '인천 부평구', SYSDATE, SYSDATE,
      '020101-4123123', '여'
);

INSERT INTO MS_USER ( USER_NO, USER_ID, USER_PW, USER_NAME,
                      BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE, CTZ_NO, GENDER
                      )
VALUES (
      SEQ_MS_USER.NEXTVAL, 'JOEUN', '123456', '박조은',
      '2024/03/06', '010-1234-1234', '서울 구로구', SYSDATE, SYSDATE,
      '970101-4123123', '여'
);

SELECT * FROM MS_USER;


-- 103.
-- 시퀀스 SEQ_MS_USER 의 최댓값을 100,000,000 으로 수정하시오.

ALTER SEQUENCE SEQ_MS_USER MAXVALUE 100000000;



-- 104.
-- USER_IND_COLUMNS 테이블을 조회하시오.
-- * 사용자가 정의한 인덱스 정보가 들어있다.
SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS;



-- 105.
-- MS_USER 테이블의 USER_NAME 에 대한
-- 인덱스 IDX_MS_USER_NAME 을 생성하시오.

-- 인덱스 생성
CREATE INDEX IDX_MS_USER_NAME ON MS_USER(user_name);

-- 인덱스 삭제
DROP INDEX IDX_MS_USER_NAME;



-- 그룹 관련 함수

-- ROLLUP
SELECT DEPT_CODE, JOB_CODE
      ,COUNT(*), MAX(SALARY), SUM(SALARY), TRUNC( AVG(SALARY), 2)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
  AND JOB_CODE IS NOT NULL
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE
;


-- CUBE
SELECT DEPT_CODE, JOB_CODE
      ,COUNT(*), MAX(SALARY), SUM(SALARY), TRUNC( AVG(SALARY), 2)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
  AND JOB_CODE IS NOT NULL
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE
;



-- GROUPING SETS
-- 그룹기준 별도로 그룹
SELECT dept_code, job_code, COUNT(*)
FROM employee
GROUP BY GROUPING SETS( (dept_code), (job_code) )
ORDER BY dept_code, job_code
;

--
SELECT dept_code, job_code, COUNT(*)
FROM employee
GROUP BY dept_code, job_code
ORDER BY dept_code, job_code
; 


-- GROUPING
SELECT dept_code
      , job_code
      , COUNT(*)
      , MAX(salary)
      , SUM(salary)
      , TRUNC( AVG(salary), 2)
      , GROUPING(dept_code) "부서코드 그룹여부"
      , GROUPING(job_code) "직급코드 그룹여부"
      , CASE 
            WHEN GROUPING(dept_code) = 0 AND GROUPING(job_code) = 1 THEN DEPT_CODE || '의 합계'  
            WHEN GROUPING(dept_code) = 1 AND GROUPING(job_code) = 0 THEN JOB_CODE || '의 합계'  
            WHEN GROUPING(dept_code) = 1 AND GROUPING(job_code) = 1 THEN '전체 합계'  
       END 합계기준
FROM employee
WHERE dept_code IS NOT NULL
  AND job_code IS NOT NULL
GROUP BY CUBE(dept_code, job_code)
ORDER BY dept_code, job_code
;



-- LISTAGG
SELECT dept_code 부서코드
      ,LISTAGG( emp_name, ', ')
       WITHIN GROUP(ORDER BY emp_name) "부서별 사원이름목록"
FROM employee
GROUP BY dept_code
ORDER BY dept_code
;



-- PIVOT

SELECT *
FROM (
        SELECT dept_code, job_code, salary
        FROM employee
     )
     PIVOT (
        MAX(salary)
        -- 열에 올릴 컬럼들
        FOR dept_code IN ('D1','D2','D3','D4','D5','D6','D7','D8','D9')
        
     )
ORDER BY job_code;


-- UNPIVOT

SELECT *
FROM (
        SELECT dept_code
              ,MAX( DECODE(job_code, 'J1', salary ) ) J1 
              ,MAX( DECODE(job_code, 'J2', salary ) ) J2 
              ,MAX( DECODE(job_code, 'J3', salary ) ) J3 
              ,MAX( DECODE(job_code, 'J4', salary ) ) J4 
              ,MAX( DECODE(job_code, 'J5', salary ) ) J5 
              ,MAX( DECODE(job_code, 'J6', salary ) ) J6 
              ,MAX( DECODE(job_code, 'J7', salary ) ) J7 
        FROM employee
        GROUP BY dept_code
        ORDER BY dept_code
     )
     UNPIVOT (
        salary
        FOR job_code IN (J1, J2, J3, J4, J5, J6, J7)
     )
;




--
SELECT dept_code
              ,MAX( DECODE(job_code, 'J1', salary ) ) J1 
              ,MAX( DECODE(job_code, 'J2', salary ) ) J2 
              ,MAX( DECODE(job_code, 'J3', salary ) ) J3 
              ,MAX( DECODE(job_code, 'J4', salary ) ) J4 
              ,MAX( DECODE(job_code, 'J5', salary ) ) J5 
              ,MAX( DECODE(job_code, 'J6', salary ) ) J6 
              ,MAX( DECODE(job_code, 'J7', salary ) ) J7 
        FROM employee
        GROUP BY dept_code
        ORDER BY dept_code
;









-- RANK

SELECT employee_id, salary
     , RANK() 
	 OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;




-- DENSE_RANK
SELECT employee_id
       ,salary
       ,DENSE_RANK() 
        OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM employees;


-- ROW_NUMBER
SELECT employee_id
			,salary
			,ROW_NUMBER() 
				OVER (ORDER BY salary DESC) AS row_num
FROM employees;


-- FIRST_VALUE
SELECT department_id
    , employee_id
    , salary
    ,FIRST_VALUE(salary) 
        OVER (PARTITION BY department_id 
              ORDER BY hire_date) AS first_salary
FROM employees;




-- LAST_VALUE
SELECT department_id
    , employee_id
    , salary
    , LAST_VALUE(salary) 
        OVER (PARTITION BY department_id 
              ORDER BY hire_date
              ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_salary
FROM employees;


-- LAG
SELECT employee_id, first_name, hire_date,
       LAG(first_name) OVER (ORDER BY hire_date) AS previous_name,
       LAG(hire_date) OVER (ORDER BY hire_date) AS previous_hire_date
FROM employees;



-- LEAD
SELECT employee_id, first_name, hire_date,
       LEAD(first_name) OVER (ORDER BY hire_date) AS next_first_name,
       LEAD(hire_date) OVER (ORDER BY hire_date) AS next_hire_date
FROM employees;


-- CUME_DIST() 
SELECT employee_id
    , salary
    , CUME_DIST() 
        OVER (ORDER BY salary DESC) AS cumulative_distribution
FROM employees;


-- PERCENT_RANK

SELECT employee_id
    , salary
    , PERCENT_RANK() 
        OVER (ORDER BY salary DESC) AS percent_rank
FROM employees;



-- NTILE

SELECT employee_id
    , salary
    , NTILE(4) 
        OVER (ORDER BY salary DESC) AS quartile
FROM employees;


--

SELECT department_id
    , employee_id
    , salary
    , RATIO_TO_REPORT(salary) 
        OVER (PARTITION BY department_id) AS salary_ratio
FROM employees;






-- CONNECT BY
SELECT LEVEL
    , employee_id
    , first_name
    , last_name
    , job_id
    , manager_id
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;