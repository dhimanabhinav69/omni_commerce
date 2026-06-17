CREATE TABLE regions (
    region_id      INTEGER PRIMARY KEY,
    region_name    VARCHAR(50) NOT NULL UNIQUE,
    country        VARCHAR(50) NOT NULL
);

CREATE TABLE stores (
    store_id       INTEGER PRIMARY KEY,
    store_name     VARCHAR(120) NOT NULL,
    region_id      INTEGER NOT NULL REFERENCES regions(region_id),
    city           VARCHAR(80) NOT NULL,
    state          VARCHAR(80) NOT NULL,
    store_type     VARCHAR(40) NOT NULL,
    opened_date    DATE NOT NULL,
    latitude       NUMERIC(9,6),
    longitude      NUMERIC(9,6)
);

CREATE TABLE customers (
    customer_id    INTEGER PRIMARY KEY,
    first_name     VARCHAR(60) NOT NULL,
    last_name      VARCHAR(60) NOT NULL,
    email          VARCHAR(150) NOT NULL UNIQUE,
    gender         VARCHAR(30),
    age_group      VARCHAR(20),
    join_date      DATE NOT NULL,
    city           VARCHAR(80),
    state          VARCHAR(80),
    region_id      INTEGER REFERENCES regions(region_id),
    loyalty_tier   VARCHAR(30)
);

CREATE TABLE product_categories (
    category_id    INTEGER PRIMARY KEY,
    category       VARCHAR(80) NOT NULL,
    subcategory    VARCHAR(80) NOT NULL,
    UNIQUE (category, subcategory)
);

CREATE TABLE products (
    product_id     INTEGER PRIMARY KEY,
    product_name   VARCHAR(160) NOT NULL,
    category_id    INTEGER NOT NULL REFERENCES product_categories(category_id),
    brand          VARCHAR(80) NOT NULL,
    unit_cost      NUMERIC(12,2) NOT NULL CHECK (unit_cost >= 0),
    list_price     NUMERIC(12,2) NOT NULL CHECK (list_price >= 0),
    product_status VARCHAR(30) NOT NULL
);

CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY,
    customer_id     INTEGER NOT NULL REFERENCES customers(customer_id),
    store_id        INTEGER NOT NULL REFERENCES stores(store_id),
    order_date      DATE NOT NULL,
    order_status    VARCHAR(30) NOT NULL,
    payment_method  VARCHAR(40),
    shipping_method VARCHAR(40),
    promo_code      VARCHAR(40)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id    INTEGER NOT NULL REFERENCES products(product_id),
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    discount_pct  NUMERIC(5,4) NOT NULL DEFAULT 0 CHECK (discount_pct >= 0 AND discount_pct <= 1),
    returned      BOOLEAN NOT NULL DEFAULT FALSE,
    return_date   DATE
);

CREATE TABLE marketing_spend (
    spend_id      INTEGER PRIMARY KEY,
    spend_month   DATE NOT NULL,
    region_id     INTEGER NOT NULL REFERENCES regions(region_id),
    channel       VARCHAR(60) NOT NULL,
    spend_amount  NUMERIC(14,2) NOT NULL CHECK (spend_amount >= 0)
);

CREATE TABLE sales_targets (
    target_id     INTEGER PRIMARY KEY,
    target_month  DATE NOT NULL,
    region_id     INTEGER NOT NULL REFERENCES regions(region_id),
    category      VARCHAR(80) NOT NULL,
    target_sales  NUMERIC(14,2) NOT NULL CHECK (target_sales >= 0)
);

-- Staging table intentionally allows messy data for cleaning practice.
CREATE TABLE customers_dirty_staging (
    raw_customer_id INTEGER,
    first_name      TEXT,
    last_name       TEXT,
    email           TEXT,
    gender          TEXT,
    age_group       TEXT,
    join_date_text  TEXT,
    city            TEXT,
    state           TEXT,
    region_id       TEXT,
    loyalty_tier    TEXT
);
