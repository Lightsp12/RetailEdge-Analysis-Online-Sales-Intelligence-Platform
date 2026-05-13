--Business Problem 1: Revenue & Profitability Performance
--"Are we hitting our sales targets and where is profit leaking?"

-- Monthly revenue vs profit margin trend
SELECT 
year,
month_name,
ROUND(SUM(revenue), 2) AS total_revenue,
ROUND(SUM(profit), 2) AS total_profit,
--ROUND(SUM(revenue)/ SUM(revenue) * 100, 2) AS profit_margin_pct,
ROUND(
    CAST(SUM(profit) AS NUMERIC) / 
    CAST(SUM(revenue) AS NUMERIC) * 100
, 2) AS profit_margin_pct,
SUM(quantity) AS units_sold,
COUNT(order_id) AS total_orders,
ROUND(SUM(revenue)/ COUNT(order_id), 2) AS avg_order_value


FROM `sale-analysis-495312.online_sale_data.sale_data_online` 
GROUP BY year, month, month_name
ORDER BY year, month


--Business Problem 2: Customer Segmentation (RFM Analysis)
--"Which customers are our best, at-risk, or lost — so we can target them differently?"

-- RFM: Recency, Frequency, Monetary

WITH rfm_base AS (
    SELECT
        customer_id,
        customer_name,
        COUNT(order_id)                                             AS frequency,
        ROUND(CAST(SUM(revenue) AS NUMERIC), 2)                    AS monetary,
        ROUND(CAST(SUM(profit) AS NUMERIC), 2)                     AS total_profit,
        MAX(CAST(date AS DATE))                                     AS last_order_date,
        MIN(CAST(date AS DATE))                                     AS first_order_date,
        DATE_DIFF(DATE '2024-12-31', MAX(CAST(date AS DATE)), DAY) AS recency_days,
        ROUND(CAST(SUM(revenue) AS NUMERIC) / COUNT(order_id), 2)  AS avg_order_value,
        ROUND(AVG(CAST(review_stars AS FLOAT64)), 2)               AS avg_satisfaction,
        COUNTIF(return_status = 'Returned')                        AS total_returns
    FROM `sale-analysis-495312.online_sale_data.sale_data_online`
    GROUP BY customer_id, customer_name
),
rfm_scored AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency_days ASC)  AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC)    AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC)     AS m_score
    FROM rfm_base
),
rfm_segmented AS (
    SELECT *,
        CONCAT(CAST(r_score AS STRING), 
               CAST(f_score AS STRING), 
               CAST(m_score AS STRING))            AS rfm_code,
        r_score + f_score + m_score                AS rfm_total,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
            WHEN r_score >= 4 AND f_score <= 2                  THEN 'New Customers'
            WHEN r_score >= 3 AND f_score <= 2 AND m_score >= 3 THEN 'Promising'
            WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At Risk'
            WHEN r_score <= 2 AND f_score >= 2                  THEN 'Needs Attention'
            WHEN r_score = 1  AND f_score <= 2 AND m_score <= 2 THEN 'Lost'
            ELSE 'Potential Loyalists'
        END AS segment
    FROM rfm_scored
)
SELECT
    customer_id,
    customer_name,
    segment,
    rfm_code,
    rfm_total,
    r_score,
    f_score,
    m_score,
    frequency           AS total_orders,
    monetary            AS total_revenue,
    total_profit,
    avg_order_value,
    avg_satisfaction,
    total_returns,
    recency_days,
    last_order_date,
    first_order_date
FROM rfm_segmented
ORDER BY monetary DESC;


-- Business Problem 3: Product & Category Performance
-- "Which categories and products drive the most revenue — and which are dead weight?"

-- Category performance with return impact

SELECT
    category,
    product,
    COUNT(order_id)   AS total_orders,
    SUM(quantity)     AS units_sold,
    ROUND(CAST(SUM(revenue) AS NUMERIC), 2)  AS total_revenue,
    ROUND(CAST(SUM(profit) AS NUMERIC), 2) AS total_profit,
    ROUND(
        CAST(SUM(profit) AS NUMERIC) /
        NULLIF(CAST(SUM(revenue) AS NUMERIC), 0) * 100
    , 2)   AS profit_margin_pct,
    ROUND(CAST(AVG(unit_price) AS NUMERIC), 2) AS avg_price,
    ROUND(AVG(CAST(review_stars AS FLOAT64)), 2)  AS avg_rating,
    COUNTIF(return_status = 'Returned') AS total_returns,
    ROUND(
        COUNTIF(return_status = 'Returned') /
        NULLIF(CAST(COUNT(order_id) AS NUMERIC), 0) * 100
    , 2)       AS return_rate_pct,
    -- revenue contribution % across all products
    ROUND(
        CAST(SUM(revenue) AS NUMERIC) /
        NULLIF(SUM(SUM(revenue)) OVER (), 0) * 100
    , 2)  AS revenue_share_pct
FROM `sale-analysis-495312.online_sale_data.sale_data_online`
GROUP BY category, product
ORDER BY total_revenue DESC;

-- Business Problem 4: Geographic Sales Intelligence
--"Which markets are growing, which are underperforming, and where should we expand?"

-- Country performance by year with growth rate

WITH country_yearly AS (
    SELECT
        country,
        year,
        ROUND(CAST(SUM(revenue) AS NUMERIC), 2)                        AS revenue,
        ROUND(CAST(SUM(profit) AS NUMERIC), 2)                         AS profit,
        COUNT(DISTINCT customer_id)                                     AS unique_customers,
        COUNT(order_id)                                                 AS total_orders,
        SUM(quantity)                                                   AS units_sold,
        ROUND(AVG(CAST(review_stars AS FLOAT64)), 2)                   AS avg_satisfaction,
        COUNTIF(return_status = 'Returned')                            AS total_returns,
        ROUND(
            CAST(SUM(profit) AS NUMERIC) /
            NULLIF(CAST(SUM(revenue) AS NUMERIC), 0) * 100
        , 2)                                                            AS profit_margin_pct,
        ROUND(
            CAST(SUM(revenue) AS NUMERIC) /
            NULLIF(COUNT(DISTINCT customer_id), 0)
        , 2)                                                            AS revenue_per_customer
    FROM `sale-analysis-495312.online_sale_data.sale_data_online`
    GROUP BY country, year
),
with_growth AS (
    SELECT *,
        LAG(revenue) OVER (PARTITION BY country ORDER BY year)         AS prev_year_revenue,
        LAG(unique_customers) OVER (PARTITION BY country ORDER BY year) AS prev_year_customers
    FROM country_yearly
)
SELECT
    country,
    year,
    revenue,
    profit,
    unique_customers,
    total_orders,
    units_sold,
    avg_satisfaction,
    total_returns,
    profit_margin_pct,
    revenue_per_customer,
    ROUND(
        (revenue - prev_year_revenue) /
        NULLIF(prev_year_revenue, 0) * 100
    , 2)                                                                AS yoy_revenue_growth_pct,
    ROUND(
        (CAST(unique_customers AS NUMERIC) - prev_year_customers) /
        NULLIF(prev_year_customers, 0) * 100
    , 2)                                                                AS yoy_customer_growth_pct
FROM with_growth
ORDER BY country, year;

--Business Problem 5: Operational Efficiency — Shipping & Payments
--"Are our shipping methods and payment preferences affecting satisfaction and returns?"

-- Shipping method vs payment method operational breakdown
 
 WITH base AS (
    SELECT
        shipment_type,
        payment_method,
        year,
        COUNT(order_id)                                                 AS total_orders,
        ROUND(CAST(SUM(revenue) AS NUMERIC), 2)                        AS total_revenue,
        ROUND(CAST(SUM(profit) AS NUMERIC), 2)                         AS total_profit,
        ROUND(CAST(AVG(unit_price) AS NUMERIC), 2)                     AS avg_unit_price,
        ROUND(
            CAST(SUM(revenue) AS NUMERIC) /
            NULLIF(COUNT(order_id), 0)
        , 2)                                                            AS avg_order_value,
        ROUND(AVG(CAST(review_stars AS FLOAT64)), 2)                   AS avg_satisfaction,
        COUNTIF(return_status = 'Returned')                            AS total_returns,
        ROUND(
            COUNTIF(return_status = 'Returned') /
            NULLIF(CAST(COUNT(order_id) AS NUMERIC), 0) * 100
        , 2)                                                            AS return_rate_pct,
        ROUND(
            CAST(SUM(profit) AS NUMERIC) /
            NULLIF(CAST(SUM(revenue) AS NUMERIC), 0) * 100
        , 2)                                                            AS profit_margin_pct
    FROM `sale-analysis-495312.online_sale_data.sale_data_online`
    GROUP BY shipment_type, payment_method, year
)
SELECT
    shipment_type,
    payment_method,
    year,
    total_orders,
    total_revenue,
    total_profit,
    avg_order_value,
    avg_unit_price,
    avg_satisfaction,
    total_returns,
    return_rate_pct,
    profit_margin_pct,
    -- shipment share of total orders
    ROUND(
        CAST(total_orders AS NUMERIC) /
        NULLIF(SUM(total_orders) OVER (PARTITION BY year), 0) * 100
    , 2)                                                                AS shipment_order_share_pct,
    -- payment method share of total revenue per year
    ROUND(
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (PARTITION BY year), 0) * 100
    , 2)                                                                AS payment_revenue_share_pct
FROM base
ORDER BY year, shipment_type, total_revenue DESC;






