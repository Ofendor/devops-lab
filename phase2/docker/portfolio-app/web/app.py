from flask import Flask, jsonify
import redis
import os
import socket
import time
from datetime import datetime

app = Flask(__name__)

def get_redis():
    retries = 5
    while retries > 0:
        try:
            r = redis.Redis(host=os.getenv('REDIS_HOST', 'redis'), port=6379, decode_responses=True)
            r.ping()
            return r
        except redis.ConnectionError:
            retries -= 1
            time.sleep(2)
    raise Exception("Redis connection failed")

redis_client = get_redis()

@app.route('/')
def index():
    visits = redis_client.incr('visits')
    return jsonify({
        'app': 'DevOps Portfolio App',
        'version': os.getenv('APP_VERSION', '1.0.0'),
        'hostname': socket.gethostname(),
        'visits': visits,
        'timestamp': datetime.now().isoformat(),
        'status': 'running'
    })

@app.route('/health')
def health():
    try:
        redis_client.ping()
        return jsonify({'status': 'healthy', 'redis': 'connected'}), 200
    except:
        return jsonify({'status': 'unhealthy'}), 503

@app.route('/api/info')
def info():
    return jsonify({'environment': os.getenv('ENVIRONMENT', 'development')})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
