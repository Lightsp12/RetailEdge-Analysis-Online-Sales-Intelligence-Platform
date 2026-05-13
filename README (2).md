# RetailEdge Analytics: Online Sales Intelligence Platform


---

## Executive Summary

RetailEdge Global is a fictional e-commerce retailer operating across **10 countries** with **10 product categories**. Despite generating **$127.99M in total revenue** and **$35.2M in profit** across **120,000 orders** over three years (2022–2024), leadership lacked the analytical visibility needed to make confident decisions about customers, products, markets, and operations.

This project delivers a **five-page analytics dashboard** built entirely on a 120,000-row transactional dataset. Using **BigQuery (GoogleSQL)** for all data transformation, the analysis surfaces five interconnected business problems into one unified, filter-driven reporting platform for **Power BI or Tableau**.

Key findings:
- Profit margin held a consistent **27.48%** across all 36 months — pricing is disciplined but margin expansion is limited
- **Electronics** accounts for **39.9%** of all revenue ($51.1M), making it the single most critical category
- **35.7% of customers** are classified as Lost or Needs Attention, representing a significant retention risk
- **Australia** recorded the strongest YoY growth in 2024 at **+6.74%** — the highest-priority expansion market
- Return rates average **~12%** uniformly across all shipping and payment combinations, pointing to upstream product or documentation issues rather than logistics

I recommend three immediate actions:
1. Launch a **win-back campaign** for 9,189 Lost customers who generated $21.6M historically — a 5–10% recovery = $1M+ in revenue
2. Convert **Potential Loyalists** (32,078 customers, $68.4M revenue) via a loyalty programme to increase repeat purchase rate
3. **Invest in the Australian market** — the fastest growing market in the dataset at +6.74% YoY

---

## Business Problem

RetailEdge's leadership team needed answers to five critical business questions:

> *"Where are we losing profit? Who are our best customers? Which products should we cut? Which markets should we grow? Are our operations hurting customer satisfaction?"*

Without structured SQL analysis, these questions remained unanswered across 120,000 rows of raw transactional data spanning three years and ten countries.

**Stakeholders:** CEO · Head of Sales · Marketing Director · Operations Manager · Regional Market Leads

---

## Dataset

| Attribute | Detail |
|---|---|
| Total Records | 120,000 orders |
| Time Period | January 2022 – December 2024 |
| Countries | 10 (USA, UK, Canada, Germany, France, India, Australia, Japan, Brazil, Mexico) |
| Product Categories | 10 (Electronics, Sports, Home, Clothing, Garden, Automotive, Beauty, Toys, Food, Books) |
| Key Fields | `order_id`, `date`, `customer_id`, `customer_name`, `country`, `category`, `product`, `quantity`, `unit_price`, `revenue`, `profit`, `payment_method`, `shipment_type`, `review_stars`, `return_status` |
| Database | Google BigQuery (GoogleSQL) |
| Generated With | Python (synthetic dataset with built-in seasonality) |

---

## Methodology

- **Python:** Generated a realistic 120,000-row synthetic dataset with seasonal revenue patterns, customer distribution, product pricing ranges, and return logic
- **BigQuery (GoogleSQL):** Wrote 5 production-grade SQL queries using CTEs, window functions (`LAG`, `NTILE`, `SUM OVER`), `COUNTIF`, `DATE_DIFF`, `NULLIF` safe division, and `CAST AS NUMERIC` for financial precision
- **RFM Modelling:** Built a three-layer CTE chain to score all customers on Recency, Frequency, and Monetary value using `NTILE(5)` scoring windows, then applied `CASE WHEN` segmentation logic to classify 9 customer segments
- **Multi-Dimensional Segmentation:** Analysed performance across countries, categories, products, shipment types, and payment methods to identify root causes rather than surface symptoms
- **Dashboard Design:** Defined a filter-driven dashboard structure with a master filter panel applicable across all pages

---

## Skills

**SQL:** CTEs, window functions (`LAG`, `NTILE`, `SUM OVER PARTITION BY`), aggregate functions, `COUNTIF`, `DATE_DIFF`, `NULLIF`, `CAST AS NUMERIC`, safe division patterns, multi-layer WITH chains

**Python:** Synthetic data generation, seasonality modelling, `csv` module, randomised weighted distributions

**Analytics:** RFM customer segmentation, revenue leakage quantification, YoY growth analysis, return rate benchmarking, profit margin analysis, market share decomposition

**Dashboard Design:** Master filter architecture, cross-page slicer logic, KPI card design, visual-to-business-question mapping for Power BI / Tableau

**Domain:** E-commerce revenue cycle, customer lifetime value, product portfolio management, geographic market analysis, operational efficiency

---

## Results & Business Recommendations

###  Revenue & Profitability

| Metric | Value |
|---|---|
| Total Revenue (3 years) | $127.99M |
| Total Profit | $35.20M |
| Avg Profit Margin | 27.48% |
| Total Orders | 120,000 |
| Avg Order Value | $1,066 |
| Peak Month | July 2023 — $4.81M |
| Lowest Month | December 2023 — $2.45M |

Profit margin held at 27.48% with less than 0.4% variance across all 36 months, confirming pricing discipline. The 2023 stagnation (-0.01% avg YoY growth) reversed in 2024 (+1.31%), suggesting early recovery. Without intervention, the seasonal mid-year peak and Q4 drop will repeat.

###  Customer Intelligence (RFM)

| Segment | Customers | Revenue | Action |
|---|---|---|---|
| Potential Loyalists | 32,078 | $68.4M | Loyalty programme |
| Needs Attention | 12,126 | $20.9M | Re-engagement emails |
| Lost | 9,189 | $21.6M | Win-back campaign |
| Loyal Customers | 9,952 | $5.6M | Reward and retain |
| New Customers | 281 | $696K | Onboarding sequence |
| At Risk | 91 | $52K | Urgent outreach |

50.3% of all customers are Potential Loyalists. Converting 10% to Loyal Customers would represent a meaningful uplift in lifetime value. The Lost segment ($21.6M historical revenue) is the highest-priority win-back audience.

###  Product & Category Performance

| Category | Revenue | Margin | Return Rate | Note |
|---|---|---|---|---|
| Electronics | $51.1M | 27.5% | 12.1% | Revenue engine |
| Sports | $16.6M | 27.5% | 11.4% | Lowest return rate |
| Automotive | $8.6M | 27.7% | 12.1% | Highest margin |
| Toys | $5.1M | 27.4% | 12.3% | Highest return rate |
| Books | $2.3M | 27.6% | 12.1% | Lowest revenue |

Electronics drives 39.9% of revenue but creates volume dependency. Automotive has the highest margin (27.7%) with significant headroom to grow. Toys carries the highest return rate and warrants product quality review. Books and Food (combined 4% of revenue) should be evaluated for strategic repositioning.

###  Geographic Sales Intelligence

| Country | Revenue | 2024 YoY Growth |
|---|---|---|
| USA | $31.9M | Reference market |
| UK | $19.5M | Stable |
| Canada | $15.5M | Stable |
| Germany | $12.7M | +1.31% |
| Australia | $8.9M | **+6.74%** ← Highest |
| India | $9.0M | Growth opportunity |
| Brazil | $6.5M | Underpenetrated |

USA and UK together account for 40% of global revenue. Australia is the fastest-growing market (+6.74% in 2024). India represents a large, underpenetrated opportunity relative to population size.

###  Operational Efficiency

| Shipment Type | Return Rate | Avg Satisfaction |
|---|---|---|
| Standard | 11.94% | 3.96 / 5 |
| Express | 11.96% | 3.95 / 5 |
| Next Day | 12.16% | 3.96 / 5 |

Return rates are uniform across all shipping and payment combinations (11.74%–12.22%), confirming that delivery speed and payment method are NOT the primary drivers of returns. The root cause is upstream — likely product descriptions or quality — not logistics.

---


### Key SQL Techniques Used

```sql
-- RFM scoring with NTILE window functions
NTILE(5) OVER (ORDER BY recency_days ASC)  AS r_score,
NTILE(5) OVER (ORDER BY frequency DESC)    AS f_score,
NTILE(5) OVER (ORDER BY monetary DESC)     AS m_score

-- Safe financial division (BigQuery)
ROUND(
    CAST(SUM(profit) AS NUMERIC) /
    NULLIF(CAST(SUM(revenue) AS NUMERIC), 0) * 100
, 2) AS profit_margin_pct

-- YoY growth with LAG window function
LAG(revenue) OVER (PARTITION BY country ORDER BY year) AS prev_year_revenue

-- Revenue share across all products
CAST(SUM(revenue) AS NUMERIC) /
NULLIF(SUM(SUM(revenue)) OVER (), 0) * 100 AS revenue_share_pct
```

---

## Dashboard Structure

All 5 pages share a **master filter panel**:

| Filter | Type | Pages |
|---|---|---|
| Year | Dropdown | All |
| Month | Multi-select | All |
| Country | Multi-select checkbox | All |
| Category | Multi-select checkbox | 1, 3, 4 |
| Payment Method | Multi-select | 1, 5 |
| Shipment Type | Multi-select | 1, 5 |
| Return Status | Toggle | 3, 5 |
| Review Stars | Range slider (1–5) | 3, 5 |

---

## Next Steps

- **Extract denial/return reason codes** at the product level to build a root cause taxonomy — confirming whether returns are driven by product description gaps, quality issues, or expectation mismatches
- **Conduct provider-level segmentation** (per country sales rep or fulfilment centre) to identify which operations generate disproportionate returns, enabling targeted intervention
- **Benchmark against industry standards** for e-commerce return rates (industry median 8–10%) and present the performance gap to leadership to support operational improvement investment
- **Enrich with CAC and COGS data** to calculate true net margin per category and customer segment
- **Add predictive churn modelling** to identify customers moving toward At Risk before they fully lapse, using ML on the RFM score history
- **Expand geographic analysis** with external market data (GDP, e-commerce penetration rates) to build an evidence-based expansion case for India, Brazil, and Mexico

---


## How to Run

### 1. Generate the dataset
```bash
python generate_data.py
# Outputs: sales_data.csv (120,000 rows, ~14.7MB)
```

### 2. Load into BigQuery
```bash
# Upload sales_data.csv to your BigQuery dataset
# Update the table reference in each SQL file:
# `your-project.your_dataset.sale_data_online`
```

### 3. Run the queries
```bash
# Run each .sql file in BigQuery console or via bq CLI:
bq query --use_legacy_sql=false < queries/01_revenue_profitability.sql
```

### 4. Connect to dashboard
- Export each query result as a BigQuery table or CSV
- Connect to Power BI via BigQuery connector or import CSVs directly
- Apply the master filter panel across all 5 pages

---

*Portfolio project — fictional dataset generated for analytical demonstration purposes.*
