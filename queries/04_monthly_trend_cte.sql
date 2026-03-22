WITH monthly_stats AS (
  SELECT
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date))              AS month,
    COUNT(*)                                                       AS sessions,
    COUNTIF(totals.transactions >= 1)                             AS orders,
    ROUND(COALESCE(SUM(totals.totalTransactionRevenue), 0) / 1e6, 2) AS revenue_usd
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
  GROUP BY month
)

SELECT
  month,
  sessions,
  orders,
  revenue_usd,
  ROUND(orders / sessions * 100, 2) AS conversion_rate_pct
FROM monthly_stats
ORDER BY month