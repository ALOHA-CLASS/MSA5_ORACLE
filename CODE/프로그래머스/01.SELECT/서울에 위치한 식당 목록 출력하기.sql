-- 서울에 위치한 식당 목록 출력하기

/*
    REST_INFO와 REST_REVIEW 테이블에서 
    서울에 위치한 식당들의 
    식당 ID, 식당 이름, 음식 종류, 즐겨찾기수, 주소, 리뷰 평균 점수를 
    조회하는 SQL문을 작성해주세요. 
    이때 리뷰 평균점수는 소수점 세 번째 자리에서 반올림 해주시고 
    결과는 평균점수를 기준으로 내림차순 정렬해주시고, 
    평균점수가 같다면 즐겨찾기수를 기준으로 내림차순 정렬해주세요.
*/

-- 분석
/* 
    REST_INFO와, REST_REVIEW 테이블을 조인하여 조회
  - 테이블 : REST_INFO와 → a
            REST_REVIEW → b
  - 조인 조건 : a.rest_id = b.rest_id
  - 문제 조건 : 서울에 위치한 식당 

  - 그룹 조건 : 식당 별(rest_id) --> [평균점수]
               
  - 정렬 조건 : 1) 평균점수 (내림)
               2) 즐겨찾기수 (내림)
  - 조회 컬럼 :
  식당 ID, 식당 이름, 음식 종류, 즐겨찾기수, 주소, 리뷰 평균 점수
  * 유의사항
   평균점수 : 소수점 세 번째 자리에서 반올림
 */
 SELECT a.rest_id
       ,a.rest_name
       ,a.food_type
       ,a.favorites
       ,a.address
       ,ROUND(AVG(b.review_score), 2) score
 FROM REST_INFO a
     ,REST_REVIEW b
WHERE a.rest_id = b.rest_id
  AND a.address LIKE '%서울%'
GROUP BY a.rest_id
        ,a.rest_name
        ,a.food_type
        ,a.favorites
        ,a.address
ORDER BY score DESC
         ,a.favorites DESC
;


--
 SELECT a.rest_id
       ,a.rest_name
       ,a.food_type
       ,a.favorites
       ,a.address
       ,ROUND(AVG(b.review_score), 2) score
 FROM REST_INFO a
     ,REST_REVIEW b
WHERE a.rest_id = b.rest_id
  AND a.address LIKE '%서울%'
GROUP BY a.rest_id
        ,a.rest_name
        ,a.food_type
        ,a.favorites
        ,a.address
ORDER BY score DESC
         ,a.favorites DESC
;

-- 식당별 식당ID, 리뷰평균점수 조회
SELECT rest_id
      ,ROUND(AVG(review_score), 2) score
FROM REST_REVIEW
GROUP BY rest_id 
;


-- 
SELECT  a.rest_id
       ,a.rest_name
       ,a.food_type
       ,a.favorites
       ,a.address
       ,b.score
FROM REST_INFO a
     ,(
        SELECT rest_id
              ,ROUND(AVG(review_score), 2) score
        FROM REST_REVIEW
        GROUP BY rest_id 
     ) b
WHERE a.rest_id = b.rest_id
  AND a.address LIKE '서울%'
ORDER BY score DESC
        ,a.favorites DESC
;




