-- PART I: Basic Querying & String Manipulations

-- 1. Conditional Categorization (CASE)
SELECT 
    name,
    CASE 
        WHEN transaction_count > 10 THEN 'VIP'
        ELSE 'Regular'
    END AS customer_status
FROM customers;

-- 2. Extracting Email Domain (SUBSTRING & POSITION)
SELECT 
    name,
    SUBSTRING(email FROM POSITION('@' IN email) + 1) AS email_domain
FROM customers;

-- 3. Inner Join Basics
SELECT 
    c.name AS customer_name,
    cmp.name AS campaign_name
FROM customers c
JOIN campaigns cmp ON c.customer_id = cmp.customer_id;

-- PART II: Aggregations & Subqueries

-- 4. Department Average Salary (GROUP BY & AVG)
SELECT 
    d.department_name,
    AVG(e.salary) AS average_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 5. Filtering Above Average Salary (Correlated Subquery)
SELECT 
    e.employee_id,
    e.name,
    e.position,
    e.salary,
    e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(emp.salary)
    FROM employees emp
    WHERE emp.department_id = e.department_id
);

-- 6. Monthly Order Aggregation (DATE Functions)
SELECT 
    EXTRACT(MONTH FROM order_date) AS order_month,
    COUNT(order_id) AS order_count,
    SUM(amount) AS total_amount
FROM orders
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY order_month;

-- 7. High-Value Customer Filtering (HAVING Clause)
SELECT 
    c.customer_id,
    c.name,
    c.city,
    SUM(o.amount) AS total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY c.customer_id, c.name, c.city
HAVING SUM(o.amount) > 3000;

-- PART III: Common Table Expressions (CTE)

-- 8. Customer Registration & Expenditure Analysis
WITH EligibleCustomers AS (
    SELECT Customer_ID, Customer_Name, Email
    FROM Customers
    WHERE Registration_Date < '2025-01-01'
)
SELECT 
    ec.Customer_ID,
    ec.Customer_Name,
    ec.Email,
    SUM(o.Total_Amount) AS Total_Spent
FROM EligibleCustomers ec
JOIN Orders o ON ec.Customer_ID = o.Customer_ID
GROUP BY ec.Customer_ID, ec.Customer_Name, ec.Email;

-- PART IV: Relational Join Operations

-- 9.1 INNER JOIN
SELECT c.first_name, c.last_name, s.product_name, s.amount
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id;

-- 9.2 LEFT JOIN
SELECT c.first_name, c.last_name, s.product_name, s.amount
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id;

-- 9.3 RIGHT JOIN
SELECT c.first_name, c.last_name, s.product_name, s.amount
FROM customers c
RIGHT JOIN sales s ON c.customer_id = s.customer_id;

-- 9.4 FULL OUTER JOIN
SELECT c.first_name, c.last_name, s.product_name, s.amount
FROM customers c
FULL OUTER JOIN sales s ON c.customer_id = s.customer_id;
