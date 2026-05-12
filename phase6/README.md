# Phase 6: Integrated DevOps Project

Phase 6 brings together every skill from the previous five phases into a single 
project. A Flask API backed by Redis is containerised with Docker,
deployed to Kubernetes with security controls, and exposed through an Nginx
reverse proxy on a NodePort service. This mirrors the real-world workflow of
building, securing, and delivering an application on cloud infrastructure.

## Architecture

| Layer | Component | Purpose |
|-------|-----------|---------|
| **Entry point** | NodePort Service (port 30080) | Exposes the app outside the cluster |
| **Reverse proxy** | Nginx | Routes traffic to the Flask API |
| **Application** | Flask API (2 replicas) | Handles requests, counts visits |
| **Cache** | Redis | Stores the visit counter |
| **Security** | NetworkPolicy | Only Nginx can talk to Flask |

This project demonstrates
that I can containerise an application, deploy it to Kubernetes, protect it
with network policies, and verify it works - all skills directly applicable to
managing sovereign cloud services.

---

## Lab 1 – Build the Flask API image
Create a custom Docker image for the Flask application and make it available to K3s.

```bash
# Navigate to the application directory
cd ~/devops-lab/phase6/app
# Build the Docker image
docker build -t flask-api:latest .
# Import the image into K3s' internal container runtime
docker save flask-api:latest | sudo k3s ctr images import -
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase6lab1.png" width="600" alt="Lab 1"/>

## Lab 2 – Deploy Redis
Launch a Redis instance that the Flask API will use to store visit counts.

```
# Apply the Redis Deployment and Service
kubectl apply -f ~/devops-lab/phase6/k8s/redis.yml
# Wait for Redis to be ready
kubectl wait --for=condition=ready pod -l app=redis --timeout=60s
```

## Lab 3 – Deploy the Flask API
Run the Flask API with two replicas, connected to Redis.

```
# Apply the Flask API Deployment and Service
kubectl apply -f ~/devops-lab/phase6/k8s/flask-api.yml
# Wait for the Flask pods to be ready
kubectl wait --for=condition=ready pod -l app=flask-api --timeout=60s
```

## Lab 4 – Deploy Nginx Reverse Proxy
Set up Nginx to forward requests to the Flask API and expose the stack externally via NodePort.

```
# Apply the Nginx ConfigMap, Deployment, and Service
kubectl apply -f ~/devops-lab/phase6/k8s/nginx.yml
# Wait for Nginx to be ready
kubectl wait --for=condition=ready pod -l app=nginx --timeout=60s
```

## Lab 5 – Apply Network Policy (Security)
Restrict traffic so that only Nginx can communicate with the Flask API, reducing the attack surface.

```
# Create the NetworkPolicy
kubectl apply -f ~/devops-lab/phase6/k8s/network-policy.yml
# Verify the policy exists
kubectl get networkpolicy allow-nginx-to-flask
```

## Lab 6 – Testing the Full Stack
Verify the entire pipeline by sending requests to the public endpoint.

```
# Test the main page (should return JSON with a visit counter)
curl http://localhost:30080/
# Test the health check (should report Redis connectivity)
curl http://localhost:30080/health
```

---

## Skills demonstrated
- **Docker:** Writing a Dockerfile, building an image, importing it into K3s
- **Kubernetes:** Deployments, Services (ClusterIP and NodePort), ConfigMaps
- **Security:** NetworkPolicy isolating backend pods, non‑root containers
- **Linux:** File management, package installation, system administration
- **Testing:** Verifying the full stack with `curl`

## Final Portfolio Summary
I learned Linux administration, containerised apps with Docker, orchestrated them
with Kubernetes, hardened the cluster with security controls, automated everything
with Ansible, and tied it all together in a final integrated project. Along the way
I broke things, fixed them, and built a genuine understanding of how these tools fit
together – not just isolated commands. This portfolio is self‑directed, practical,
and directly relevant to the Cloud Engineer role at Catalyst Cloud, where operating
New Zealand’s sovereign infrastructure demands exactly this kind of hands‑on,
end‑to‑end skill set.
