SELECT
  trafficSource.source        AS source,
  trafficSource.medium        AS medium,
  COUNT(*)                    AS total_sessions,
  COALESCE(SUM(totals.transactions),0)    AS total_transactions,
  ROUND(COALESCE(SUM(totals.totalTransactionRevenue), 0) / 1e6, 2) AS revenue_usd
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
GROUP BY source, medium
ORDER BY total_sessions DESC
LIMIT 20