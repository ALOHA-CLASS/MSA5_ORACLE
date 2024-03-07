SELECT ROWNUM
FROM EMPLOYEE
WHERE ROWNUM = 2
;


SELECT BONUS
FROM EMPLOYEE
ORDER BY BONUS
;

---
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
            -- ELSE '사원'
       END 구분
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE