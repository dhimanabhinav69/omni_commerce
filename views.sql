CREATE VIEW order_item_details AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.sales_channel,
    o.delivery_city,
    o.delivery_state,
    c.customer_id,
    c.customer_name,
    c.gender,
    c.age_group,
    p.product_id,
    p.product_name,
    cat.category_name,
    p.brand,
    oi.quantity,
    oi.unit_price,
    oi.discount_amount,
    (oi.quantity * oi.unit_price) AS gross_sales,
    ((oi.quantity * oi.unit_price) - oi.discount_amount) AS net_sales,
    p.cost_price,
    (oi.quantity * p.cost_price) AS total_cost,
    (((oi.quantity * oi.unit_price) - oi.discount_amount) - (oi.quantity * p.cost_price)) AS profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id;

CREATE VIEW order_summary AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.sales_channel,
    o.delivery_city,
    o.delivery_state,
    c.customer_id,
    c.customer_name,
    SUM((oi.quantity * oi.unit_price) - oi.discount_amount) AS order_value,
    SUM(oi.quantity) AS total_items
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_date,
    o.order_status,
    o.sales_channel,
    o.delivery_city,
    o.delivery_state,
    c.customer_id,
    c.customer_name;

CREATE VIEW monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date)::DATE AS sales_month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(net_sales) AS total_sales,
    SUM(profit) AS total_profit
FROM v_order_item_details
WHERE order_status <> 'Cancelled'
GROUP BY DATE_TRUNC('month', order_date)::DATE;

CREATE VIEW product_performance AS
SELECT
    product_id,
    product_name,
    category_name,
    brand,
    SUM(quantity) AS quantity_sold,
    SUM(net_sales) AS total_sales,
    SUM(profit) AS total_profit
FROM v_order_item_details
WHERE order_status <> 'Cancelled'
GROUP BY product_id, product_name, category_name, brand;

CREATE VIEW customer_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.state,
    c.gender,
    c.age_group,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM((oi.quantity * oi.unit_price) - oi.discount_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city,
    c.state,
    c.gender,
    c.age_group;
