SELECT 
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    ROUND(AVG(a.account_balance), 2) AS avg_account_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.city;


-- Q2: Account type with the highest total balance
SELECT 
    c.account_type,
    SUM(a.account_balance) AS total_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.account_type
ORDER BY total_balance DESC
LIMIT 1;


-- Q3: Top 10 customers by total account balance
SELECT 
    c.customer_id,
    c.name,
    SUM(a.account_balance) AS total_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_balance DESC
LIMIT 10;



-- Q4: Customers who joined in 2023 with account balance above 100000
SELECT 
    c.customer_id,
    c.name,
    c.join_date,
    a.account_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
WHERE strftime('%Y', c.join_date) = '2023'
  AND a.account_balance > 100000;


-- Q5: Total transaction volume by transaction type
SELECT 
    txn_type,
    SUM(amount) AS total_transaction_amount
FROM transactions
GROUP BY txn_type;


-- Q6: Failed transactions count by transaction type
SELECT 
    txn_type,
    COUNT(*) AS failed_transaction_count
FROM transactions
WHERE status = 'failed'
GROUP BY txn_type;

-- Q7: Total number of transactions per transaction type
SELECT 
    txn_type,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY txn_type;


-- Q8: Customers with 5 or more high-value transactions (> 20000)
SELECT 
    customer_id,
    COUNT(*) AS high_value_transaction_count
FROM transactions
WHERE amount > 20000
GROUP BY customer_id
HAVING COUNT(*) >= 5;


-- Q9: Average loan amount and interest rate by loan type
SELECT
    Loan_Type,
    ROUND(AVG(Loan_Amount), 2) AS avg_loan_amount,
    ROUND(AVG(Interest_Rate), 2) AS avg_interest_rate
FROM loans
GROUP BY Loan_Type;


-- Q10: Customers with more than one active or approved loan
SELECT
    Customer_ID,
    COUNT(*) AS active_or_approved_loan_count
FROM loans
WHERE Loan_Status IN ('Active', 'Approved')
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


-- Q11: Top 5 customers with highest outstanding (non-closed) loan amounts
SELECT
    Customer_ID,
    SUM(Loan_Amount) AS outstanding_loan_amount
FROM loans
WHERE Loan_Status != 'Closed'
GROUP BY Customer_ID
ORDER BY outstanding_loan_amount DESC
LIMIT 5;


-- Q12: Average loan amount per branch
SELECT
    Branch,
    ROUND(AVG(Loan_Amount), 2) AS avg_loan_amount
FROM loans
GROUP BY Branch;


-- Q13: Customer count by age group
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18–25'
        WHEN age BETWEEN 26 AND 35 THEN '26–35'
        WHEN age BETWEEN 36 AND 45 THEN '36–45'
        WHEN age BETWEEN 46 AND 55 THEN '46–55'
        ELSE '56+'
    END AS age_group,
    COUNT(*) AS customer_count
FROM customers
GROUP BY age_group
ORDER BY age_group;


-- Q14: Issue categories with longest average resolution time
SELECT
    Issue_Category,
    ROUND(AVG(julianday(Date_Closed) - julianday(Date_Opened)), 2) AS avg_resolution_days
FROM support_tickets
WHERE Date_Closed IS NOT NULL
GROUP BY Issue_Category
ORDER BY avg_resolution_days DESC;


-- Q15: Support agents with most critical tickets and high customer ratings
SELECT
    Support_Agent,
    COUNT(*) AS critical_tickets_resolved
FROM support_tickets
WHERE Priority = 'Critical'
  AND Customer_Rating >= 4
  AND Status IN ('Resolved', 'Closed')
GROUP BY Support_Agent
ORDER BY critical_tickets_resolved DESC;
