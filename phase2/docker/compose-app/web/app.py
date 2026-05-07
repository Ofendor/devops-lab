from flask import Flask
import mysql.connector
import os
import time

app = Flask(__name__)



def get_db_connection():
    retries = 5
    while retries > 0:
        try:
            conn = mysql.connector.connect(
                host=os.getenv('DB_HOST', 'db'),
                user=os.getenv('DB_USER', 'devops'),
                password=os.getenv('DB_PASSWORD', 'devops123'),
                database=os.getenv('DB_NAME', 'devopsdb')
            )
            return conn
        except mysql.connect.Error:
            retries -= 1
            time.sleep(5)
    raise Exception("Could not connect to database")

@app.route('/')
def hello():
    return "<h1>DevOps Docker Compose Lab</h1><p><a href='/db-test'>Test Database Connection</a></p>"

@app.route('/db-test')
def db_test():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT VERSION()")
        version = cursor.fetchone()[0]
        cursor.close()
        return f"<h2>Database Connected!</h2><p>MySQL Version: {version}</p>"
    except Exception as e:
        return f"<h2>Database Error</h2><p>{str(e)}</p>"

@app.route('/health')
def health():
    return "OK", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
