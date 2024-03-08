-- 기초 실습 계정
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER student IDENTIFIED BY 123456;

ALTER USER student DEFAULT TABLESPACE users;

ALTER USER student QUOTA UNLIMITED ON users;

GRANT connect, resource TO student;

GRANT dba TO student;

GRANT CREATE VIEW TO student;
GRANT DROP VIEW TO student;


DROP TABLE 수강;
-- 수강 테이블 생성
CREATE TABLE 수강 (
    학과 CHAR(20) PRIMARY KEY, 
    과목 CHAR(20), 
    교수 CHAR(10), 
    학점 INT 
);

-- 수강 테이블 기본키 추가
ALTER TABLE 수강 ADD PRIMARY KEY (학과);


-- 기본 수강 정보 추가
INSERT INTO 수강 ( 학과, 과목, 교수, 학점 )
VALUES ( '컴퓨터공학과', 'JAVA', '박강', 3 );

INSERT INTO 수강 ( 학과, 과목, 교수, 학점 )
VALUES ( '영어영문학과', '영어회화3', 'Steven', 3 );

INSERT INTO 수강 ( 학과, 과목, 교수, 학점 )
VALUES ( '경영학과', '경제학', '이규석', 3 );

INSERT INTO 수강 ( 학과, 과목, 교수, 학점 )
VALUES ( '뮤지컬학과', '세계연극사', '조현미', 3 );





DROP TABLE 학생;
-- 학생 테이블 생성
CREATE TABLE 학생 ( 
    학번 INT,
    성명 CHAR(10) NOT NULL,
    학과 CHAR(20),
    학점 CHAR(1),
    PRIMARY KEY (학번),
    FOREIGN KEY (학과) REFERENCES 수강(학과) 
);

-- [튜플 검색]
-- 5), 6) 
-- 작은 따옴표(') --(정정)--> 큰 따옴표(")

-- AS "A학점자 수"
-- AS "C학점자 수"


-- SELECT 문 실행순서
-- FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
SELECT 학과, COUNT(*) AS "A학점자 수"
FROM 학생
WHERE 학점 = 'A'
GROUP BY 학과 HAVING COUNT(*) >= 2
ORDER BY 학과 ASC, "A학점자 수" DESC;
;

-- 1. 학생 테이블을 검색
-- 2. 학생 테이블의 튜플 중, 학점이 'A'인 데이터만 조회
-- 3. 학점이 'A'인 튜플들을 학과를 그룹기준으로 지정
--   * 조회가능한 컬럼 : 학과, 학과기준 그룹함수
-- 4. 학과 그룹 중에서, 학과별 개수가 2 이상인 튜플만 추출(필터링)
-- 5. 조회할 컬럼을 선택
-- 6. 조회된 결과를 학번을 기준으로 오름차순 정렬



-- 실습
-- [테이블 생성]
INSERT INTO 학생 VALUES ( 20190101, '홍길동', '컴퓨터공학과', 'A');

SELECT * FROM 학생;

-- 속성 추가
ALTER TABLE 학생 ADD 학년 INT ;

UPDATE 학생
SET 학년 = 1
WHERE 성명 = '홍길동';


INSERT INTO 학생
VALUES ( 20190101, '홍길동', '컴퓨터공학과', 'A', 1);
INSERT INTO 학생
VALUES ( 20190102, '김가이', '컴퓨터공학과', 'A', 1);
INSERT INTO 학생
VALUES ( 20190103, '김루리', '컴퓨터공학과', 'B', 1);
INSERT INTO 학생
VALUES ( 20180104, '이효인', '컴퓨터공학과', 'A', 2);
INSERT INTO 학생
VALUES ( 20170105, '박설리', '컴퓨터공학과', 'A', 3);

INSERT INTO 학생
VALUES ( 20190201, '박현수', '영어영문학과', 'A', 1);
INSERT INTO 학생
VALUES ( 20190202, '정환희', '영어영문학과', 'C', 1);
INSERT INTO 학생
VALUES ( 20190203, '이천수', '영어영문학과', 'B', 1);
INSERT INTO 학생
VALUES ( 20180204, '한요한', '영어영문학과', 'C', 2);
INSERT INTO 학생
VALUES ( 20170205, '구수진', '영어영문학과', 'A', 3);
INSERT INTO 학생
VALUES ( 20180206, '한요한', '영어영문학과', 'C', 2);
INSERT INTO 학생
VALUES ( 20170207, '박설리', '영어영문학과', 'A', 3);

INSERT INTO 학생
VALUES ( 20190301, '박서연', '경영학과', 'A', 1);
INSERT INTO 학생
VALUES ( 20190302, '홍민서', '경영학과', 'F', 1);


INSERT INTO 학생
VALUES ( 20190303, '정여름', '경영학과', 'B', 1);
INSERT INTO 학생
VALUES ( 20160304, '송지우', '경영학과', 'A', 4);
INSERT INTO 학생
VALUES ( 20160305, '권수아', '경영학과', 'A', 4);
INSERT INTO 학생
VALUES ( 20180306, '강서윤', '경영학과', 'F', 2);
INSERT INTO 학생
VALUES ( 20170307, '최하린', '경영학과', 'B', 3);
INSERT INTO 학생
VALUES ( 20160307, '안아람', '경영학과', 'A', 4);

INSERT INTO 학생
VALUES ( 20160405, '원빈', '뮤지컬학과', 'C', 4);
INSERT INTO 학생
VALUES ( 20180406, '장동건', '뮤지컬학과', 'C', 2);
INSERT INTO 학생
VALUES ( 20170407, '전지현', '뮤지컬학과', 'B', 3);
INSERT INTO 학생
VALUES ( 20160407, '이나영', '뮤지컬학과', 'A', 4);


-- 
SELECT * 
FROM 학생
ORDER BY 학점, 학년 DESC;

--
SELECT * 
FROM 학생
WHERE 학과 IN ('컴퓨터공학과', '경영학과');

SELECT * 
FROM 학생
WHERE 학과 = '컴퓨터공학과' 
   OR 학과 = '경영학과';

--
SELECT 학과, COUNT(*) AS "A학점자 수"
FROM 학생
WHERE 학점 = 'A'
GROUP BY 학과;

--
SELECT 학과, COUNT(*) AS "C학점자 수"
FROM 학생
WHERE 학점 = 'C'
GROUP BY 학과 HAVING COUNT(*) >= 2;


--
SELECT * 
FROM 학생
WHERE 성명 LIKE '김%';

--
INSERT INTO 수강 (학과, 과목, 교수, 학점)
VALUES ('기계공학과', '유체역학', '김준수', 3);


--
SELECT * 
FROM 학생
     JOIN 수강 ON 학생.학과 = 수강.학과;

--
SELECT * 
FROM 학생, 수강
WHERE 학생.학과 = 수강.학과;

--
SELECT * 
FROM 학생
WHERE 학과 = '컴퓨터공학과' 
  AND 학점 = 'A';


--
SELECT * 
FROM 학생
WHERE 학점 BETWEEN 'A' AND 'B' ;








--
SELECT 학과, 학년, COUNT(*) 학생수
FROM 학생
GROUP BY 학과, 학년
ORDER BY 학과 ASC, 학년 ASC;
;



-- 뷰 생성 권한
GRANT CREATE VIEW TO student;

CREATE VIEW A학생
AS SELECT * FROM 학생
WHERE 학점 = 'A';

SELECT * FROM A학생;
