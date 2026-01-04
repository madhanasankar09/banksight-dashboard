import streamlit as st
import sqlite3
import pandas as pd

# Page title
st.set_page_config(page_title="BankSight Dashboard", layout="wide")

st.title("🏦 BankSight: Transaction Intelligence Dashboard")

# Connect to database
conn = sqlite3.connect("database.db")

# Sidebar
st.sidebar.header("Select Analysis")

option = st.sidebar.selectbox(
    "Choose a question",
    (
        "Q1: Customers per city & avg balance",
        "Q2: Account type with highest balance",
        "Q3: Top 10 customers by balance",
        "Q4: Customers joined in 2023 with high balance",
        "Q5: Total transaction volume by type",
        "Q6: Failed transactions by type",
        "Q7: Total transactions per type",
        "Q8: Customers with high-value transactions"
    )
)

# SQL queries
queries = {
    "Q1: Customers per city & avg balance": """
        SELECT c.city,
               COUNT(DISTINCT c.customer_id) AS total_customers,
               ROUND(AVG(a.account_balance), 2) AS avg_account_balance
        FROM customers c
        JOIN accounts a ON c.customer_id = a.customer_id
        GROUP BY c.city;
    """,

    "Q2: Account type with highest balance": """
        SELECT c.account_type,
               SUM(a.account_balance) AS total_balance
        FROM customers c
        JOIN accounts a ON c.customer_id = a.customer_id
        GROUP BY c.account_type
        ORDER BY total_balance DESC
        LIMIT 1;
    """,

    "Q3: Top 10 customers by balance": """
        SELECT c.customer_id, c.name,
               SUM(a.account_balance) AS total_balance
        FROM customers c
        JOIN accounts a ON c.customer_id = a.customer_id
        GROUP BY c.customer_id, c.name
        ORDER BY total_balance DESC
        LIMIT 10;
    """,

    "Q4: Customers joined in 2023 with high balance": """
        SELECT c.customer_id, c.name, c.join_date, a.account_balance
        FROM customers c
        JOIN accounts a ON c.customer_id = a.customer_id
        WHERE strftime('%Y', c.join_date) = '2023'
          AND a.account_balance > 100000;
    """,

    "Q5: Total transaction volume by type": """
        SELECT txn_type,
               SUM(amount) AS total_transaction_amount
        FROM transactions
        GROUP BY txn_type;
    """,

    "Q6: Failed transactions by type": """
        SELECT txn_type,
               COUNT(*) AS failed_transaction_count
        FROM transactions
        WHERE status = 'failed'
        GROUP BY txn_type;
    """,

    "Q7: Total transactions per type": """
        SELECT txn_type,
               COUNT(*) AS total_transactions
        FROM transactions
        GROUP BY txn_type;
    """,

    "Q8: Customers with high-value transactions": """
        SELECT customer_id,
               COUNT(*) AS high_value_transaction_count
        FROM transactions
        WHERE amount > 20000
        GROUP BY customer_id
        HAVING COUNT(*) >= 5;
    """
}

# Execute selected query
st.subheader(option)

df = pd.read_sql(queries[option], conn)
st.dataframe(df)

conn.close()
