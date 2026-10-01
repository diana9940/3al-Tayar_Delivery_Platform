import pyodbc

SERVER = r"localhost\SQLEXPRESS"
DATABASE = "delivery"
DRIVER = "ODBC Driver 17 for SQL Server"

connection_string = (
    f"DRIVER={{{DRIVER}}};"
    f"SERVER={SERVER};"
    f"DATABASE={DATABASE};"
    f"Trusted_Connection=yes;"
)

def get_connection():
    return pyodbc.connect(connection_string)
