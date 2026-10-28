CREATE TABLE pricing_data (
    order_id TEXT,
    order_date DATE,
    product_id TEXT,
    category VARCHAR(50),
    region VARCHAR(20),
    channel VARCHAR(20),
    list_price NUMERIC(12,2),
    unit_cost NUMERIC(12,2),
    discount_pct NUMERIC(5,4),
    selling_price NUMERIC(12,2),
    quantity INTEGER,
    gross_revenue NUMERIC(14,2),
    net_revenue NUMERIC(14,2),
    discount_amount NUMERIC(14,2),
    total_cost NUMERIC(14,2),
    profit NUMERIC(14,2),
    margin_pct NUMERIC(8,2)
);



SELECT * FROM pricing_data;



-- Business Question 1: Category Profitability
-- Purpose: Identify the most and least profitable product categories.
SELECT
    category,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM pricing_data
GROUP BY category
ORDER BY total_profit DESC;



-- Business Question 2: Discount Impact Analysis
-- Purpose: Compare profitability across different discount ranges.
SELECT
    CASE
        WHEN discount_pct < 0.10 THEN '0–9%'
        WHEN discount_pct < 0.20 THEN '10–19%'
        WHEN discount_pct < 0.30 THEN '20–29%'
        WHEN discount_pct < 0.40 THEN '30–39%'
        ELSE '40%+'
    END AS discount_range,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        100.0 * SUM(profit) / NULLIF(SUM(net_revenue), 0), 2
    ) AS profit_margin_pct
FROM pricing_data
GROUP BY discount_range
ORDER BY MIN(discount_pct);



-- Business Question 3: Regional Performance
-- Purpose: Compare revenue and profitability across regions.
SELECT
    region,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM pricing_data
GROUP BY region
ORDER BY total_profit DESC;



-- Business Question 4: Sales Channel Performance
-- Purpose: Compare revenue and profit across sales channels.
SELECT
    channel,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM pricing_data
GROUP BY channel
ORDER BY total_profit DESC;




-- Business Question 5: Top 10 Profitable Products
-- Purpose: Identify products generating the highest total profit.
SELECT
    product_id,
    SUM(quantity) AS units_sold,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM pricing_data
GROUP BY product_id
ORDER BY total_profit DESC
LIMIT 10;



-- Business Question 6: Monthly Profit Trends
-- Purpose: Track monthly revenue and profit to identify trends.
SELECT
    DATE_TRUNC('month', order_date)::DATE AS order_month,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM pricing_data
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;



-- Business Question 7: Loss-Making Orders
-- Purpose: Identify categories with the most unprofitable orders.
SELECT
    category,
    COUNT(*) AS loss_orders,
    ROUND(SUM(profit), 2) AS total_loss
FROM pricing_data
WHERE profit < 0
GROUP BY category
ORDER BY loss_orders DESC;



-- Business Question 8: Loss-Making Orders by Discount Range
-- Purpose: Identify discount ranges with the most unprofitable orders.
SELECT
    CASE
        WHEN discount_pct < 0.10 THEN '0–9%'
        WHEN discount_pct < 0.20 THEN '10–19%'
        WHEN discount_pct < 0.30 THEN '20–29%'
        WHEN discount_pct < 0.40 THEN '30–39%'
        ELSE '40%+'
    END AS discount_range,
    COUNT(*) AS loss_orders,
    ROUND(SUM(profit), 2) AS total_loss
FROM pricing_data
WHERE profit < 0
GROUP BY discount_range
ORDER BY loss_orders DESC;



-- Business Question 9: Category-Wise Discount Analysis
-- Purpose: Identify product categories and discount ranges that generate the highest total losses.
SELECT
    category,
    CASE
        WHEN discount_pct < 0.10 THEN '0–9%'
        WHEN discount_pct < 0.20 THEN '10–19%'
        WHEN discount_pct < 0.30 THEN '20–29%'
        WHEN discount_pct < 0.40 THEN '30–39%'
        ELSE '40%+'
    END AS discount_range,
    COUNT(*) AS loss_orders,
    ROUND(SUM(profit), 2) AS total_loss
FROM pricing_data
WHERE profit < 0
GROUP BY category, discount_range
ORDER BY SUM(profit) ASC;



-- Business Question 10: Category-Wise Profit Margin
-- Purpose: Identify categories with the highest and lowest profit margins.
SELECT
    category,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        100.0 * SUM(profit) / NULLIF(SUM(net_revenue), 0), 2
    ) AS profit_margin_pct
FROM pricing_data
GROUP BY category
ORDER BY profit_margin_pct DESC;