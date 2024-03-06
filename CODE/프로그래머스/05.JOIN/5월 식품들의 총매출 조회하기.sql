SELECT p.product_id
      ,p.product_name
      -- ,p.price
      -- ,o.amount
      ,SUM(p.price * o.amount) total_sales
FROM FOOD_PRODUCT P
    ,FOOD_ORDER O
WHERE P.PRODUCT_ID = O.PRODUCT_ID
  AND TO_CHAR(O.PRODUCE_DATE, 'YYYY-MM') = '2022-05'
GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME
ORDER BY total_sales DESC, P.PRODUCT_ID ASC
;
    