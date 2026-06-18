DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS monthly_targets;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS sales_reps;

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(20),
    signup_date DATE
);

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100),
    unit_price NUMERIC(10,2),
    cost_price NUMERIC(10,2)
);

CREATE TABLE sales_reps (
    rep_id VARCHAR(10) PRIMARY KEY,
    rep_name VARCHAR(60),
    region VARCHAR(20),
    team VARCHAR(50)
);

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE,
    customer_id VARCHAR(10) REFERENCES customers(customer_id),
    rep_id VARCHAR(10) REFERENCES sales_reps(rep_id),
    payment_mode VARCHAR(30),
    order_status VARCHAR(30),
    discount_pct NUMERIC(5,2)
);

CREATE TABLE order_items (
    order_item_id VARCHAR(12) PRIMARY KEY,
    order_id VARCHAR(10) REFERENCES orders(order_id),
    product_id VARCHAR(10) REFERENCES products(product_id),
    quantity INT,
    selling_price NUMERIC(10,2)
);

CREATE TABLE shipments (
    shipment_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10) REFERENCES orders(order_id),
    ship_mode VARCHAR(30),
    ship_date DATE,
    delivery_date DATE,
    shipping_cost NUMERIC(10,2)
);

CREATE TABLE monthly_targets (
    target_id VARCHAR(10) PRIMARY KEY,
    target_month DATE,
    region VARCHAR(20),
    category VARCHAR(50),
    sales_target NUMERIC(12,2),
    profit_target NUMERIC(12,2)
);