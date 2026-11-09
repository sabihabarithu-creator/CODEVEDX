 -- SALES DATA ANALYSIS PROJECT
-- DATABASE TABLE CREATION

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE
);

ALTER TABLE orders
ADD COLUMN product_id INT REFERENCES products(product_id),
ADD COLUMN quantity INT;

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    amount DECIMAL(10,2),
    payment_date DATE
);

-- INSERT SAMPLE DATA

INSERT INTO customers VALUES
(1, 'Arun', 'Chennai', 'arun@gmail.com'),
(2, 'Priya', 'Madurai', 'priya@gmail.com'),
(3, 'Rahul', 'Coimbatore', 'rahul@gmail.com'),
(4, 'Divya', 'Chennai', 'divya@gmail.com'),
(5, 'Karthik', 'Trichy', 'karthik@gmail.com');

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 55000),
(2, 'Mobile', 'Electronics', 20000),
(3, 'Headphones', 'Accessories', 1500),
(4, 'Keyboard', 'Accessories', 1000),
(5, 'Smart Watch', 'Electronics', 5000);

INSERT INTO orders
(order_id, customer_id, order_date, product_id, quantity)
VALUES
(101, 1, '2026-10-01', 1, 1),
(102, 2, '2026-10-02', 2, 2),
(103, 3, '2026-10-03', 3, 2),
(104, 4, '2026-10-04', 4, 1),
(105, 5, '2026-10-05', 5, 1),
(106, 1, '2026-10-06', 2, 1),
(107, 2, '2026-10-07', 3, 3),
(108, 3, '2026-10-08', 1, 1);

INSERT INTO payments VALUES
(201, 101, 55000, '2026-10-01'),
(202, 102, 40000, '2026-10-02'),
(203, 103, 3000, '2026-10-03'),
(204, 104, 1000, '2026-10-04'),
(205, 105, 5000, '2026-10-05'),
(206, 106, 20000, '2026-10-06'),
(207, 107, 4500, '2026-10-07'),
(208, 108, 55000, '2026-10-08');

-- SALES DATA ANALYSIS QUERIES

-- 1. Total Sales
SELECT SUM(amount) AS total_sales
FROM payments;

-- 2. Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 3. Product-wise Sales
SELECT p.product_name,
       SUM(o.quantity * p.price) AS product_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_sales DESC;

-- 4. City-wise Sales
SELECT c.city,
       SUM(p.amount) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.city
ORDER BY total_sales DESC;

-- 5. Customer-wise Spending
SELECT c.customer_name,
       SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 6. Daily Sales
SELECT o.order_date,
       SUM(p.amount) AS daily_sales
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- 7. Best-selling Product by Quantity
SELECT p.product_name,
       SUM(o.quantity) AS total_quantity
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC;

-- 8. Average Order Amount
SELECT AVG(amount) AS average_order_amount
FROM payments;

-- 9. Category-wise Sales
SELECT pr.category,
       SUM(pm.amount) AS category_sales
FROM products pr
JOIN orders o ON pr.product_id = o.product_id
JOIN payments pm ON o.order_id = pm.order_id
GROUP BY pr.category
ORDER BY category_sales DESC;

-- 10. Repeat Customer Analysis
SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- 11. Full Sales Report
SELECT o.order_id,
       c.customer_name,
       p.product_name,
       o.quantity,
       p.price,
       pm.amount,
       o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
JOIN payments pm ON o.order_id = pm.order_id
ORDER BY o.order_id;

-- 12. Highest Sales Orders
SELECT o.order_id,
       c.customer_name,
       pm.amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN payments pm ON o.order_id = pm.order_id
WHERE pm.amount = (
    SELECT MAX(amount)
    FROM payments
);
