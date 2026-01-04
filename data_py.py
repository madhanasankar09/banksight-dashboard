import sqlite3
import pandas as pd

# Connect to database
conn = sqlite3.connect("database.db")

# Read CSV files
customers = pd.read_csv("data/customers.csv")
accounts = pd.read_csv("data/accounts.csv")
transactions = pd.read_csv("data/transactions.csv")

# Load data into tables
customers.to_sql("customers", conn, if_exists="replace", index=False)
accounts.to_sql("accounts", conn, if_exists="replace", index=False)
transactions.to_sql("transactions", conn, if_exists="replace", index=False)

print("Data loaded successfully!")

conn.close()




import sqlite3
import pandas as pd

conn = sqlite3.connect("database.db")

query = """
SELECT 
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    ROUND(AVG(a.account_balance), 2) AS avg_account_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.city;
"""

df = pd.read_sql(query, conn)
print(df)

conn.close()

