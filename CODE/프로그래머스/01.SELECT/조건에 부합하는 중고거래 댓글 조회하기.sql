-- 조건에 부합하는 중고거래 댓글 조회하기
/*
USED_GOODS_BOARD와 USED_GOODS_REPLY 테이블에서 
2022년 10월에 작성된 
게시글 제목, 게시글 ID, 댓글 ID, 댓글 작성자 ID, 댓글 내용, 댓글 작성일을 
조회하는 SQL문을 작성해주세요. 
결과는 댓글 작성일을 기준으로 오름차순 정렬해주시고, 
댓글 작성일이 같다면 게시글 제목을 기준으로 오름차순 정렬해주세요.
*/

-- 분석
/*
  USED_GOODS_BOARD, USED_GOODS_REPLY 테이블을 조인하여 조회
  - 테이블 : USED_GOODS_BOARD → a
            USED_GOODS_REPLY → b
  - 조인 조건 : a.board_id = b.board_id
  - 문제 조건 : 2022년 10월 작성된 게시글
               TO_CHAR(a.created_date, 'YYYY-MM') = '2022-10'
  - 정렬 조건 : 1) 댓글 작성일 (오름)
               2) 게시글 제목 (오름)
  - 조회 컬럼 :
  게시글 제목, 게시글 ID, 댓글 ID, 댓글 작성자 ID, 댓글 내용, 댓글 작성일
  * 유의사항
   댓글 작성일 포맷 : 'YYYY-MM-DD'
*/
SELECT a.title
      ,a.board_id
      ,b.reply_id
      ,b.writer_id
      ,b.contents
      ,TO_CHAR(b.created_date, 'YYYY-MM-DD') create_date
FROM USED_GOODS_BOARD a, USED_GOODS_REPLY b
WHERE a.board_id = b.board_id
  AND TO_CHAR(a.created_date, 'YYYY-MM') = '2022-10'
ORDER BY b.created_date ASC
        ,a.title ASC
;