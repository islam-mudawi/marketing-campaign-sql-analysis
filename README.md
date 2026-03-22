# Marketing Campaign Analysis — SQL on BigQuery

Exploratory analysis of the Google Merchandise Store dataset using BigQuery SQL.  
The goal was to answer 5 real business questions about traffic, conversions, and revenue — practicing joins, CTEs, and window functions along the way.

---

## Dataset

**Source:** [Google Analytics Sample — BigQuery Public Data](https://console.cloud.google.com/marketplace/details/obfuscated-ga360-data/obfuscated-ga360-data)  
**Period analysed:** January–December 2017  
**What it contains:** ~366 daily session tables from the Google Merchandise Store — traffic sources, page hits, transactions, and revenue per session.

---

## Business questions answered

| # | Question | SQL concepts used |
|---|----------|-------------------|
| 1 | Which traffic sources drive the most sessions and revenue? | `GROUP BY`, `SUM`, `ORDER BY` |
| 2 | Which channels have the highest conversion rate? | `COUNTIF`, `HAVING`, calculated fields |
| 3 | Which landing pages lead to the most purchases? | `UNNEST` (array flattening), `COUNT DISTINCT` |
| 4 | How did monthly revenue and orders trend across 2017? | CTE (`WITH`), `FORMAT_DATE`, `PARSE_DATE` |
| 5 | What was the month-over-month revenue growth rate? | Window function (`LAG OVER`), `NULLIF` |

---

## Key findings

- **Direct traffic** was the largest single segment by sessions (189k) and revenue ($717k), but lacks UTM tracking — a signal that UTM discipline across campaigns was inconsistent.
- **Google CPC** delivered only 9.2k sessions but $20.7k revenue — a much higher revenue-per-session than organic, suggesting paid search was well-targeted.
- **Email and affiliate** channels showed the highest conversion rates despite low volume, pointing to high-intent audiences.
- **Revenue peaked in November–December 2017**, consistent with seasonal e-commerce patterns. The sharpest MoM growth was in October (+38%).
- **Top landing pages** were product category pages, not the homepage — users arriving with specific intent converted at higher rates.

---

## Data quality notes

- `totalTransactionRevenue` and `transactions` are NULL in GA when a session has no purchases — the field is omitted rather than set to 0. Fixed with `COALESCE(..., 0)` across all queries.
- `(direct) / (none)` is retained as a valid traffic segment representing direct or untracked visits. It is not filtered out.
- The first row in the MoM query (January 2017) has a NULL `prev_month_revenue` by design — `LAG()` has no prior month to reference. This is documented in the query with an inline comment.

---

## Repo structure

```
├── README.md
├── notebooks/
│   └── campaign_analysis.ipynb   ← full analysis with results inline
├── queries/
│   ├── 01_traffic_sources.sql
│   ├── 02_conversion_by_channel.sql
│   ├── 03_landing_pages.sql
│   ├── 04_monthly_trend_cte.sql
│   └── 05_mom_growth_window_fn.sql
└── results/
    ├── traffic_sources.csv
    ├── conversion_by_channel.csv
    ├── landing_pages.csv
    ├── monthly_trend.csv
    └── mom_growth.csv
```

---

## How to run

1. Open [Google Colab](https://colab.research.google.com) and sign in with a Google account
2. Open `notebooks/campaign_analysis.ipynb`
3. Run the auth cell — approve the Google authentication popup
4. Run each query cell in order — results render as tables inline

No local installation required. Queries run against BigQuery's free public dataset tier.

---

## Environment

- **Database:** Google BigQuery (public dataset)
- **Notebook:** Google Colab
- **Language:** BigQuery SQL + Python (pandas for display only)
- **Dataset:** `bigquery-public-data.google_analytics_sample`
