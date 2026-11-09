-- CUSTOMER BEHAVIOR ANALYSIS
-- CODEVEDX Internship Project
-- Database: customer_analysis

-- 1. CREATE TABLES

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    city VARCHAR(50),
    signup_date DATE
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
    order_date DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT
);

-- 2. INSERT CUSTOMER DATA

INSERT INTO customers VALUES
(1, 'Arun', 22, 'Male', 'Chennai', '2026-01-10'),
(2, 'Priya', 24, 'Female', 'Madurai', '2026-01-15'),
(3, 'Rahul', 25, 'Male', 'Coimbatore', '2026-02-01'),
(4, 'Divya', 23, 'Female', 'Chennai', '2026-02-12'),
(5, 'Karthik', 27, 'Male', 'Trichy', '2026-03-05'),
(6, 'Meena', 21, 'Female', 'Madurai', '2026-03-18'),
(7, 'Vijay', 29, 'Male', 'Chennai', '2026-04-02'),
(8, 'Anitha', 26, 'Female', 'Coimbatore', '2026-04-15');

-- 3. INSERT PRODUCT DATA

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 55000),
(2, 'Mobile', 'Electronics', 20000),
(3, 'Headphones', 'Accessories', 1500),
(4, 'Keyboard', 'Accessories', 1000),
(5, 'Smart Watch', 'Electronics', 5000),
(6, 'Mouse', 'Accessories', 800);

-- 4. INSERT ORDER DATA

INSERT INTO orders VALUES
(101, 1, '2026-04-01', 55000),
(102, 2, '2026-04-02', 20000),
(103, 3, '2026-04-03', 3000),
(104, 4, '2026-04-04', 1000),
(105, 5, '2026-04-05', 5000),
(106, 1, '2026-04-10', 20000),
(107, 2, '2026-04-12', 4500),
(108, 6, '2026-04-15', 1500),
(109, 7, '2026-04-18', 55000),
(110, 8, '2026-04-20', 2500);

-- 5. INSERT ORDER ITEMS

INSERT INTO order_items VALUES
(1, 101, 1, 1),
(2, 102, 2, 1),
(3, 103, 3, 2),
(4, 104, 4, 1),
(5, 105, 5, 1),
(6, 106, 2, 1),
(7, 107, 3, 3),
(8, 108, 6, 2),
(9, 109, 1, 1),
(10, 110, 3, 1);

-- 6. CORRECT ORDER AMOUNTS

UPDATE orders SET total_amount = 1600 WHERE order_id = 108;
UPDATE orders SET total_amount = 1500 WHERE order_id = 110;

-- 7. CUSTOMER ANALYSIS QUERIES

-- Query 1: Total customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Query 2: Total revenue
SELECT SUM(total_amount) AS total_revenue
FROM orders;

-- Query 3: Customer-wise spending
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Query 4: Repeat customers
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

-- Query 5: City-wise customer count
SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- Query 6: Most purchased products
SELECT p.product_name, SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC;

-- Query 7: Average order value
SELECT AVG(total_amount) AS average_order_value
FROM orders;

-- Query 8: Category-wise revenue
SELECT p.category, SUM(o.total_amount) AS category_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Query 9: Customer spending rank
SELECT c.customer_name,
       SUM(o.total_amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- Query 10: Monthly sales trend
SELECT TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
       SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY sales_month;

-- Query 11: Highest value orders
SELECT order_id, customer_id, total_amount
FROM orders
WHERE total_amount = (SELECT MAX(total_amount) FROM orders);

-- Query 12: Product-wise revenue
SELECT p.product_name,
       SUM(oi.quantity * p.price) AS product_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC;
