from flask import Flask, jsonify
import redis
import os
import socket

app = Flask(__name__)

redis_host = os.getenv('REDIS_HOST', 'redis-service')
r = redis.Redis(host=redis_host, port=6379, decode_responses=True, socket_connect_timeout=2)

@app.route('/')
def index():
    try:
        visits = r.incr('visits')
    except:
        visits = -1
    return jsonify({
        'app': 'DevOps Final Project',
        'hostname': socket.gethostname(),
        'visits': visits,
        'status': 'running'
    })

@app.route('/health')
def health():
    try:
        r.ping()
        redis_status = 'connected'
    except:
        redis_status = 'disconnected'
    return jsonify({'status': 'healthy' if redis_status == 'connected' else 'degraded', 'redis': redis_status})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
