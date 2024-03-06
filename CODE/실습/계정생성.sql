-- HR 계정 생성 
-- C## 접두사 없이도 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- 계정 생성
CREATE USER HR IDENTIFIED BY 123456;
-- 테이블 스테이스 지정
ALTER USER HR DEFAULT TABLESPACE users;
-- 용량 설정
ALTER USER HR QUOTA UNLIMITED ON users;
-- 권한 부여
GRANT connect, resource TO HR;