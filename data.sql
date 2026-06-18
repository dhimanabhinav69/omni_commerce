TRUNCATE TABLE
    order_items, orders, products, customers, monthly_targets, shipments, sales_reps
RESTART IDENTITY CASCADE;


\copy customers FROM 'data/customers.csv' WITH (FORMAT csv, HEADER true);
\copy products FROM 'data/products.csv' WITH (FORMAT csv, HEADER true);
\copy sales_reps FROM 'data/sales_reps.csv' WITH (FORMAT csv, HEADER true);
\copy orders FROM 'data/orders.csv' WITH (FORMAT csv, HEADER true);
\copy order_items FROM 'data/order_items.csv' WITH (FORMAT csv, HEADER true);
\copy shipments FROM 'data/shipments.csv' WITH (FORMAT csv, HEADER true);