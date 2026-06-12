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