# Phase 4: Kubernetes Security

This phase covers essential Kubernetes security controls: 
RBAC, Network Policies, Pod Security Standards, 
Secrets management, and image vulnerability scanning.


## Labs
- Lab 1 – RBAC
Limiting cluster access so a user (service account) can only
view pods, not delete them.

```bash
kubectl create serviceaccount viewer # Create a service account named "viewer"

kubectl apply -f viewer-role.yaml # Create a Role that allows only reading pods (get, watch, list)

# Bind the Role to the service account (give the badge to the employee)
kubectl create rolebinding viewer-binding --role=pod-viewer --serviceaccount=default:viewer

# Check if the viewer can GET pods (should be "yes")
kubectl auth can-i get pods --as=system:serviceaccount:default:viewer

# Check if the viewer can DELETE pods (should be "no")
kubectl auth can-i delete pods --as=system:serviceaccount:default:viewer
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase4-task1.png" width="800" alt="RBAC test"/>


- Lab 2 – Network Policies: Pod-level Firewall
Blocking all incoming traffic to a backend pod, then prove
the frontend can no longer reach it.

```
# Create two deployments: frontend and backend
kubectl create deployment frontend --image=nginx:alpine --replicas=1
kubectl create deployment backend --image=nginx:alpine --replicas=1

kubectl get pods -o wide # Find the backend pod's IP address

# Test connectivity from frontend to backend (should work)
kubectl exec <frontend-pod> -- wget -qO- --timeout=2 http://<backend-IP>

# Apply a NetworkPolicy that denies ALL ingress to the backend
kubectl apply -f deny-all-backend.yml

# Test again – this time the connection times out (blocked)
kubectl exec <frontend-pod> -- wget -qO- --timeout=2 http://<backend-IP>
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task2.1.png" width="800" alt="Network policy block – before"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task2.2.png" width="800" alt="Network policy block – after"/>

- Lab 3 – Pod Security Standards
Compare a pod that runs as root (insecure) with one that
uses a non‑root user (secure).

```
# Create a pod without any securityContext. It runs as root by default
kubectl apply -f bad-pod.yml
kubectl exec bad-pod -- id                 # uid=0(root)  ← insecure version

# Create a pod with runAsNonRoot: true and a non‑root capable image
kubectl apply -f good-pod.yml
kubectl exec good-pod -- id                # uid=101(nginx)  ← secure version
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task3.1.png" width="800" alt="Bad pod runs as root"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task3.2.png" width="800" alt="Good pod creation"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task3.3.png" width="800" alt="Good pod running"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task3.4.png" width="800" alt="Good pod non‑root user"/>


- Lab 4 – Secrets Management
Showing that Kubernetes Secrets are only base64‑encoded
(not encrypted), and demonstrate mounting them as files for safer use.

```
# Create a Secret from a literal value
kubectl create secret generic mysecret --from-literal=api-key=SuperSecret123!

# View the Secret – note the data is just base64, not encrypted
kubectl get secret mysecret -o yaml

# Decode the secret to see the original value
kubectl get secret mysecret -o jsonpath='{.data.api-key}' | base64 -d

# Mount the Secret as a file inside a pod (more secure than env vars)
kubectl apply -f secret-pod.yml

# Read the secret file from inside the container
kubectl exec secret-demo -- cat /etc/myapp/api-key   # SuperSecret123!
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task4.png" width="800" alt="Secrets demo"/>

- Lab 5 –  Image Vulnerability Scanning
Scanning container images for known vulnerabilities before
they are deployed. A modern Alpine image is compared with an old release
to show how outdated images dramatically increase risk.

```
# Install Grype (lightweight, no huge database download required)
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo sh -s -- -b /usr/local/bin

# Scan the modern nginx:alpine image
grype nginx:alpine
# → 0 critical, 4 high, 15 medium, 1 low

# Scan an older nginx:1.19 image for comparison
grype nginx:1.19
# → 40 critical, 159 high, 194 medium, 35 low
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task5.1.png" width="800" alt="Grype alpine"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/Phase4-task5.2.png" width="800" alt="Grype old nginx comparison"/>
