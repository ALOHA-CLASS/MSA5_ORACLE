SELECT DEPARTMENT_ID
      ,FIRST_NAME
      ,SALARY
      ,COUNT(*) -- 개수를 구함
        OVER(PARTITION BY DEPARTMENT_ID   -- 부서번호를 기준으로 나눔
             ORDER BY SALARY DESC         -- 급여 기준 내림차순
             -- 급여가 2000 차이. 
             -- 이전행(PRECEDING)~현재행(CURRENT ROW)
             RANGE BETWEEN 2000 PRECEDING AND CURRENT ROW) AS SALARY2  
FROM EMPLOYEES
;