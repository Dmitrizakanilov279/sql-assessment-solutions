
# SQL Technical Assessment & Query Solutions

A collection of SQL queries demonstrating fundamental to advanced database operations, including Conditional Logic, String Manipulation, Aggregations, Subqueries, CTEs, and various Table Join types.

---

## PART I: Basic Querying & String Manipulations

### 1. Conditional Categorization (CASE)
Categorize customers based on transaction counts.
```sql
SELECT 
    name,
    CASE 
        WHEN transaction_count > 10 THEN 'VIP'
        ELSE 'Regular'
    END AS customer_status
FROM customers; 
```

### 2. Extracting Email Domain (SUBSTRING & POSITION)
Extract the domain name from customer email addresses.
```sql
SELECT 
    name,
    SUBSTRING(email FROM POSITION('@' IN email) + 1) AS email_domain
FROM customers;
```

### Inner Join Basics
Combine customer names with their associated campaign names.
```sql
SELECT 
    c.name AS customer_name,
    cmp.name AS campaign_name
FROM customers c
JOIN campaigns cmp ON c.customer_id = cmp.customer_id;
```

### Department Average Salary (GROUP BY & AVG)
Calculate average salary per department.
```sql
SELECT 
    d.department_name,
    AVG(e.salary) AS average_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;
```

### Filtering Above Average Salary (Correlated Subquery)
Find employees earning more than their respective department's average salary.
```sql
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
```

### Monthly Order Aggregation (DATE Functions)
Aggregate order count and total revenue grouped by month.
```sql
SELECT 
    EXTRACT(MONTH FROM order_date) AS order_month,
    COUNT(order_id) AS order_count,
    SUM(amount) AS total_amount
FROM orders
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY order_month;
```

### High-Value Customer Filtering (HAVING Clause)
Identify customers in 2024 with total order purchases exceeding 3,000.
```sql
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
```

### Customer Registration & Expenditure Analysis
Filter customers registered before 2025 and calculate their total spending using a CTE.
```sql
WITH EligibleCustomers AS 
( SELECT Customer_ID, Customer_Name, Email
  FROM Customers
  WHERE Registration_Date < '2025-01-01')
SELECT 
    ec.Customer_ID,
    ec.Customer_Name,
    ec.Email,
    SUM(o.Total_Amount) AS Total_Spent
FROM EligibleCustomers ec
JOIN Orders o ON ec.Customer_ID = o.Customer_ID
GROUP BY ec.Customer_ID, ec.Customer_Name, ec.Email;
```

PART IV: Relational Join Operations & Output Comparison
9. Comparison of Join Types
### 9.1 INNER JOIN
Returns only matching records between both tables.
```sql
SELECT c.first_name, c.last_name, s.product_name, s.amount
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id;
```

### 9.2 LEFT JOIN
Returns all records from the left table and matched records from the right table.
```sql
SELECT c.first_name, c.last_name, s.product_name, s.amount
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id;
```

### 9.3 RIGHT JOIN
Returns all records from the right table and matched records from the left table.
```sql
SELECT c.first_name, c.last_name, s.product_name, s.amount
FROM customers c
RIGHT JOIN sales s ON c.customer_id = s.customer_id;
```

### 9.4 FULL OUTER JOIN
Returns all records when there is a match in either left or right table.
```sql
SELECT c.first_name, c.last_name, s.product_name, s.amount
FROM customers c
FULL OUTER JOIN sales s ON c.customer_id = s.customer_id;
```
