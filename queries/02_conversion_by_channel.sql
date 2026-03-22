SELECT
  trafficSource.medium                                          AS medium,
  COUNT(*)                                                      AS sessions,
  COUNTIF(totals.transactions >= 1)                             AS converting_sessions,
  ROUND(
    COUNTIF(totals.transactions >= 1) / COUNT(*) * 100
  , 2)                                                          AS conversion_rate_pct,
  ROUND(COALESCE(SUM(totals.totalTransactionRevenue), 0) / 1e6, 2) AS revenue_usd
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
  AND trafficSource.medium IS NOT NULL
GROUP BY medium
HAVING sessions > 100
ORDER BY conversion_rate_pct DESC