from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    return f"""
    <h1>DevOps Lab - Docker Demo</h1>
    <p>Container ID: {hostname}</p>
    <p>App Version: 2.0</p>
    <p>Environment: {os.getenv("ENVIRONMENT", "development")}</p>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
