CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20),
    age_group VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    supplier_id INT REFERENCES suppliers(supplier_id),
    brand VARCHAR(50),
    cost_price NUMERIC(10,2),
    selling_price NUMERIC(10,2)
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    warehouse_city VARCHAR(50),
    stock_quantity INT,
    reorder_level INT,
    updated_date DATE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    order_status VARCHAR(30),
    sales_channel VARCHAR(30),
    delivery_city VARCHAR(50),
    delivery_state VARCHAR(50)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price NUMERIC(10,2),
    discount_amount NUMERIC(10,2)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    amount_paid NUMERIC(10,2)
);

CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    shipment_date DATE,
    delivery_date DATE,
    shipping_partner VARCHAR(50),
    shipping_status VARCHAR(30),
    shipping_cost NUMERIC(10,2)
);

CREATE TABLE returns (
    return_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    return_date DATE,
    return_reason VARCHAR(100),
    refund_amount NUMERIC(10,2)
);

CREATE TABLE campaigns (
    campaign_id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(100),
    channel VARCHAR(30),
    start_date DATE,
    end_date DATE,
    budget NUMERIC(10,2)
);

CREATE TABLE coupons (
    coupon_id SERIAL PRIMARY KEY,
    coupon_code VARCHAR(30),
    campaign_id INT REFERENCES campaigns(campaign_id),
    discount_type VARCHAR(20),
    discount_value NUMERIC(10,2)
);

CREATE TABLE order_coupons (
    order_id INT REFERENCES orders(order_id),
    coupon_id INT REFERENCES coupons(coupon_id),
    discount_amount NUMERIC(10,2),
    PRIMARY KEY (order_id, coupon_id)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    rating INT,
    review_date DATE,
    review_text TEXT
);