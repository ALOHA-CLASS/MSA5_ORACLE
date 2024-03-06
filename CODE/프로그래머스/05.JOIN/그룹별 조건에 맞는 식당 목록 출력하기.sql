--  리뷰를 가장 많이 작성한 회원
SELECT MEMBER_ID
FROM REST_REVIEW
GROUP BY MEMBER_ID 
HAVING COUNT(*) = (
                    SELECT MAX(COUNT(*))
                    FROM REST_REVIEW
                    GROUP BY MEMBER_ID
                  ) -- 리뷰 최대 개수
;

-- JOIN
-- MEMBER_PROFILE
-- REST_REVIEW
SELECT M.MEMBER_NAME
      ,R.REVIEW_TEXT
      ,TO_CHAR(R.REVIEW_DATE, 'YYYY-MM-DD') REVIEW_DATE
FROM MEMBER_PROFILE M
    ,REST_REVIEW R
WHERE M.MEMBER_ID = R.MEMBER_ID
  AND R.MEMBER_ID IN (  --  리뷰를 가장 많이 작성한 회원 
                        SELECT MEMBER_ID
                        FROM REST_REVIEW
                        GROUP BY MEMBER_ID 
                        HAVING COUNT(*) = (
                                            SELECT MAX(COUNT(*))
                                            FROM REST_REVIEW
                                            GROUP BY MEMBER_ID
                                        ) -- 리뷰 최대 개수

                      )
ORDER BY R.REVIEW_DATE ASC, R.REVIEW_TEXT ASC
;