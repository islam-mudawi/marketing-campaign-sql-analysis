SELECT
  h.page.pagePath                                               AS landing_page,
  COUNT(DISTINCT fullVisitorId)                                 AS unique_visitors,
  COUNTIF(totals.transactions >= 1)                             AS sessions_with_purchase,
  ROUND(COALESCE(SUM(totals.totalTransactionRevenue), 0) / 1e6, 2) AS revenue_usd
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST(hits) AS h
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
  AND h.type = 'PAGE'
  AND h.hitNumber = 1
GROUP BY landing_page
HAVING unique_visitors > 50
ORDER BY revenue_usd DESC
LIMIT 15