-- 조인
-- BOOK
-- AUTHOR
-- 조건 : '경제' 카테고리
-- 컬럼 : 도서 ID, 저자명, 출판일
-- 정렬 : 출판일 (오름차순)
SELECT b.BOOK_ID
      ,a.AUTHOR_NAME
      ,TO_CHAR(b.PUBLISHED_DATE, 'YYYY-MM-DD') PUBLISHED_DATE
FROM BOOK b
    ,AUTHOR a
WHERE b.AUTHOR_ID = a.AUTHOR_ID
  AND b.CATEGORY = '경제'
ORDER BY PUBLISHED_DATE ASC
;