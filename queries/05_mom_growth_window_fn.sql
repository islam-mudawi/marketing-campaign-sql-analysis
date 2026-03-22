WITH monthly_revenue AS (
  SELECT
    FORMAT_DATE('%Y-%m', PARSE_DATE('%Y%m%d', date))              AS month,
    ROUND(COALESCE(SUM(totals.totalTransactionRevenue), 0) / 1e6, 2) AS revenue_usd
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
  GROUP BY month
)

SELECT
  month,
  revenue_usd,
  LAG(revenue_usd) OVER (ORDER BY month)        AS prev_month_revenue,
  -- NULL in first row is expected: no prior month exists
  ROUND(
    (revenue_usd - LAG(revenue_usd) OVER (ORDER BY month))
    / NULLIF(LAG(revenue_usd) OVER (ORDER BY month), 0) * 100
  , 1)                                           AS mom_growth_pct
FROM monthly_revenue
ORDER BY month