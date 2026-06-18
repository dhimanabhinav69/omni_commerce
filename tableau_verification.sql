-- 1. Check row counts after CSV load
SELECT * FROM customers

-- 2. KPI verification: total sales, profit, orders, quantity
SELECT
    ROUND(SUM(line_sales), 2) AS total_sales,
    ROUND(SUM(line_profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(line_profit) / NULLIF(SUM(line_sales), 0) * 100, 2) AS profit_margin_pct
FROM (
    SELECT
        o.order_id,
        oi.quantity,
        oi.quantity * oi.selling_price * (1 - o.discount_pct) AS line_sales,
        oi.quantity * p.cost_price AS product_cost,
        s.shipping_cost / COUNT(*) OVER (PARTITION BY o.order_id) AS allocated_shipping,
        oi.quantity * oi.selling_price * (1 - o.discount_pct)
            - oi.quantity * p.cost_price
            - s.shipping_cost / COUNT(*) OVER (PARTITION BY o.order_id) AS line_profit
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN shipments s ON o.order_id = s.order_id
    WHERE o.order_status = 'Completed'
) x;

-- 3. Bar chart: sales by sub-category
SELECT
    p.sub_category,
    ROUND(SUM(oi.quantity * oi.selling_price * (1 - o.discount_pct)), 2) AS sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.sub_category
ORDER BY sales DESC;

-- 4. Stacked bar: sales by region and customer segment
SELECT
    c.region,
    c.segment,
    ROUND(SUM(oi.quantity * oi.selling_price * (1 - o.discount_pct)), 2) AS sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.region, c.segment
ORDER BY c.region, sales DESC;

-- 5. Donut or pie chart: sales share by category
SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.selling_price * (1 - o.discount_pct)), 2) AS sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY sales DESC;

-- 6. Map chart: sales by state
SELECT
    c.state,
    c.country,
    ROUND(SUM(oi.quantity * oi.selling_price * (1 - o.discount_pct)), 2) AS sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.state, c.country
ORDER BY sales DESC;

-- 7. Scatter chart: customer sales vs profit
SELECT
    customer_name,
    ROUND(SUM(line_sales), 2) AS sales,
    ROUND(SUM(line_profit), 2) AS profit,
    COUNT(DISTINCT order_id) AS orders
FROM (
    SELECT
        c.customer_name,
        o.order_id,
        oi.quantity * oi.selling_price * (1 - o.discount_pct) AS line_sales,
        oi.quantity * oi.selling_price * (1 - o.discount_pct)
            - oi.quantity * p.cost_price
            - s.shipping_cost / COUNT(*) OVER (PARTITION BY o.order_id) AS line_profit
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN shipments s ON o.order_id = s.order_id
    WHERE o.order_status = 'Completed'
) x
GROUP BY customer_name
ORDER BY sales DESC;

-- 8. Bubble chart: quantity by sub-category
SELECT
    p.sub_category,
    SUM(oi.quantity) AS total_quantity,
    ROUND(SUM(oi.quantity * oi.selling_price * (1 - o.discount_pct)), 2) AS sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.sub_category
ORDER BY total_quantity DESC;

-- 9. Dual axis chart: monthly sales and profit
SELECT
    month,
    ROUND(SUM(line_sales), 2) AS sales,
    ROUND(SUM(line_profit), 2) AS profit
FROM (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS month,
        o.order_id,
        oi.quantity * oi.selling_price * (1 - o.discount_pct) AS line_sales,
        oi.quantity * oi.selling_price * (1 - o.discount_pct)
            - oi.quantity * p.cost_price
            - s.shipping_cost / COUNT(*) OVER (PARTITION BY o.order_id) AS line_profit
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN shipments s ON o.order_id = s.order_id
    WHERE o.order_status = 'Completed'
) x
GROUP BY month
ORDER BY month;

-- 10. Gantt chart: order processing and delivery duration
SELECT
    o.order_id,
    o.order_date,
    s.ship_date,
    s.delivery_date,
    s.ship_date - o.order_date AS days_to_ship,
    s.delivery_date - s.ship_date AS days_in_delivery,
    s.delivery_date - o.order_date AS total_fulfilment_days,
    s.ship_mode
FROM orders o
JOIN shipments s ON o.order_id = s.order_id
WHERE o.order_status = 'Completed'
ORDER BY total_fulfilment_days DESC;

-- 11. Heatmap: profit margin by state and category
SELECT
    state,
    category,
    ROUND(SUM(line_profit), 2) AS profit,
    ROUND(SUM(line_profit) / NULLIF(SUM(line_sales), 0) * 100, 2) AS profit_margin_pct
FROM (
    SELECT
        c.state,
        p.category,
        o.order_id,
        oi.quantity * oi.selling_price * (1 - o.discount_pct) AS line_sales,
        oi.quantity * oi.selling_price * (1 - o.discount_pct)
            - oi.quantity * p.cost_price
            - s.shipping_cost / COUNT(*) OVER (PARTITION BY o.order_id) AS line_profit
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN shipments s ON o.order_id = s.order_id
) x
GROUP BY state, category
ORDER BY state, category;

-- 12. Text table: top products with rank
SELECT
    product_name,
    category,
    sales,
    profit,
    sales_rank
FROM (
    SELECT
        product_name,
        category,
        ROUND(SUM(line_sales), 2) AS sales,
        ROUND(SUM(line_profit), 2) AS profit,
        RANK() OVER (ORDER BY SUM(line_sales) DESC) AS sales_rank
    FROM (
        SELECT
            p.product_name,
            p.category,
            o.order_id,
            oi.quantity * oi.selling_price * (1 - o.discount_pct) AS line_sales,
            oi.quantity * oi.selling_price * (1 - o.discount_pct)
                - oi.quantity * p.cost_price
                - s.shipping_cost / COUNT(*) OVER (PARTITION BY o.order_id) AS line_profit
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        JOIN products p ON oi.product_id = p.product_id
        JOIN shipments s ON o.order_id = s.order_id
    ) line_data
    GROUP BY product_name, category
) ranked_products
WHERE sales_rank <= 10
ORDER BY sales_rank;

-- 13. Window function: monthly sales trend with previous month comparison
SELECT
    month,
    sales,
    LAG(sales) OVER (ORDER BY month) AS previous_month_sales,
    sales - LAG(sales) OVER (ORDER BY month) AS sales_change
FROM (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS month,
        ROUND(SUM(oi.quantity * oi.selling_price * (1 - o.discount_pct)), 2) AS sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)::date
) monthly_sales
ORDER BY month;

-- 14. Window function: top 3 products in each category
SELECT
    category,
    product_name,
    sales,
    product_rank
FROM (
    SELECT
        p.category,
        p.product_name,
        ROUND(SUM(oi.quantity * oi.selling_price * (1 - o.discount_pct)), 2) AS sales,
        ROW_NUMBER() OVER (
            PARTITION BY p.category
            ORDER BY SUM(oi.quantity * oi.selling_price * (1 - o.discount_pct)) DESC
        ) AS product_rank
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category, p.product_name
) ranked
WHERE product_rank <= 3
ORDER BY category, product_rank;

-- 15. Box & Whisker Plot
SELECT
    o.order_id,
    s.ship_mode,
    o.order_date,
    s.delivery_date,
    s.delivery_date - o.order_date AS total_fulfilment_days
FROM orders o
JOIN shipments s 
    ON o.order_id = s.order_id
WHERE o.order_status = 'Completed'
ORDER BY s.ship_mode, total_fulfilment_days;