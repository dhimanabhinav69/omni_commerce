
'''customer and location tables'''

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(20) CHECK (gender IN ('Male', 'Female', 'Other')),
    email VARCHAR(120) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    signup_date DATE NOT NULL DEFAULT CURRENT_DATE,
    customer_segment VARCHAR(30) NOT NULL DEFAULT 'Regular'
        CHECK (customer_segment IN ('New', 'Regular', 'Premium', 'VIP')),
    loyalty_points INT NOT NULL DEFAULT 0 CHECK (loyalty_points >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    address_type VARCHAR(30),
    address_line1 VARCHAR(150),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20)
);

'''product tables'''

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100),
    parent_category_id INT REFERENCES categories(category_id)
);

CREATE TABLE brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(150),
    category_id INT REFERENCES categories(category_id),
    brand_id INT REFERENCES brands(brand_id),
    description TEXT,
    base_price NUMERIC(10,2),
    cost_price NUMERIC(10,2),
    launch_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE product_variants (
    variant_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    sku VARCHAR(50) UNIQUE,
    color VARCHAR(50),
    size VARCHAR(50),
    weight_kg NUMERIC(8,2),
    selling_price NUMERIC(10,2),
    stock_status VARCHAR(30)
);

'''stores and inventory tables'''

CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100),
    store_type VARCHAR(30),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    opening_date DATE,
    manager_name VARCHAR(100)
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    store_id INT REFERENCES stores(store_id),
    variant_id INT REFERENCES product_variants(variant_id),
    quantity_available INT,
    reorder_level INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

'''orders and sales tables'''

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    store_id INT REFERENCES stores(store_id),
    order_date TIMESTAMP,
    order_status VARCHAR(30),
    sales_channel VARCHAR(30),
    shipping_address_id INT REFERENCES addresses(address_id),
    billing_address_id INT REFERENCES addresses(address_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    variant_id INT REFERENCES product_variants(variant_id),
    quantity INT,
    unit_price NUMERIC(10,2),
    discount_amount NUMERIC(10,2) DEFAULT 0,
    tax_amount NUMERIC(10,2) DEFAULT 0
);

'''payments, coupons and shipping tables'''

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_date TIMESTAMP,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    amount_paid NUMERIC(10,2),
    transaction_id VARCHAR(100)
);

CREATE TABLE coupons (
    coupon_id SERIAL PRIMARY KEY,
    coupon_code VARCHAR(50) UNIQUE,
    discount_type VARCHAR(30),
    discount_value NUMERIC(10,2),
    start_date DATE,
    end_date DATE,
    min_order_value NUMERIC(10,2),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE order_coupons (
    order_coupon_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    coupon_id INT REFERENCES coupons(coupon_id),
    discount_applied NUMERIC(10,2)
);

CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    courier_name VARCHAR(100),
    tracking_number VARCHAR(100),
    shipment_date DATE,
    delivery_date DATE,
    shipment_status VARCHAR(30),
    shipping_cost NUMERIC(10,2)
);

'''returns and reviews tables'''

CREATE TABLE returns (
    return_id SERIAL PRIMARY KEY,
    order_item_id INT REFERENCES order_items(order_item_id),
    return_date DATE,
    return_reason VARCHAR(150),
    return_status VARCHAR(30),
    refund_amount NUMERIC(10,2)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE
);