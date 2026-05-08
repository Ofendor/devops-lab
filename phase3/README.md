# Phase 3: Kubernetes Fundamentals

Phase 3 introduces container orchestration with Kubernetes. I used a single‑node 
`K3s cluster`, I deployed applications, scaled them, exposed them via Services, 
and managed configuration securely with ConfigMaps and Secrets.

## Concepts:
- **Pod:** The smallest deployable unit in Kubernetes, wraps one or more containers.
- **Deployment:** A controller that ensures a specified number of pod replicas are running and handles updates.
- **Service:** A stable network endpoint that routes traffic to pods, even when pods come and go.
- **ConfigMap:** Stores non‑sensitive configurations (like environment variables from sensors).
- **Secret:** Stores sensitive information (passwords, keys) separately from the pod (encrypted at rest via RBAC orand Sentinel).


## Labs
- Lab 1 - First Pod
Learn the basic unit of Kubernetes – the `Pod`. I created a single nginx pod, 
checked its status, and used port‑forwarding to access it from the host.

```bash
kubectl run nginx --image=nginx:alpine # Create a pod named "nginx" using the Alpine version of nginx
kubectl get pods # Check if the pod is running (may say ContainerCreating for a few seconds)
kubectl port-forward pod/nginx 8080:80 # Forward your local port 8080 to the pod's port 80 (leave this running)
```
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/6-podtask1.png" width="600" alt="Lab 1 nginx pod"/>

```
# In another terminal:
curl http://localhost:8080 # Test the connection
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/6-podtask2.1.png" width="600" alt="Lab 2 scaling"/>

- Lab 2 - Deployments, Scaling, and Rolling Updates
Understand how a Deployment manages multiple pods. I scaled an application 
from 3 to 5 replicas, performed a rolling update without downtime, and rolled back to the previous version.

```
kubectl create deployment web --image=nginx:alpine --replicas=3 # Create a Deployment that manages 3 replicas of nginx
kubectl get pods -w # Watch the pods being created (Ctrl+C when all are Running)
kubectl scale deployment web --replicas=5 # Increase the number of replicas to 5
kubectl get pods # Verify all 5 pods are running
kubectl set image deployment/web nginx=nginx:1.25-alpine # Update the image to a newer version (rolling update with zero downtime)
kubectl rollout status deployment/web # Watch the rollout progress
kubectl rollout undo deployment/web #from here just clean up everything
kubectl delete deployment web
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/6-podtask2.2.png" width="950" alt="Lab 2 rollout/rollback"/>

- Lab 3 - Services and Networking
 Learn how to expose pods so they can talk to each other `(ClusterIP)` and to the outside world `(NodePort)`. 
I tested internal connectivity with a temporary `BusyBox` pod and accessed the service from the VM’s IP.

```
kubectl create deployment hello --image=nginx:alpine --replicas=2 # Create a Deployment with 2 replicas
kubectl expose deployment hello --port=80 --target-port=80 # Expose the deployment as a ClusterIP Service (internal only)
kubectl get svc hello # Check the Service's internal IP and port
kubectl run busybox --image=busybox --rm -it --restart=Never -- wget -qO- http://hello # Test the Service from inside the cluster using a temporary BusyBox pod
kubectl delete svc hello # Delete the internal Service
kubectl expose deployment hello --type=NodePort --port=80 --target-port=80 # Re-expose as NodePort to allow external access from the VM
kubectl get svc hello # Find the assigned NodePort (e.g., 31948)
curl http://localhost:31948   # replace with your actual port # Access the Service using the NodePort from the VM terminal
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/6-podtask3.1.png" width="950" alt="Lab 3 internal test"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/6-podtask3.2.png" width="950" alt="Lab 3 NodePort access"/>

```
# Clean up
kubectl delete deployment hello
kubectl delete svc hello
```
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/6-podtask3.3.png" width="600" alt="Lab 3 service view"/>

- Lab 4 - ConfigMaps and Secrets
Learn how to inject configuration and sensitive data into pods without hardcoding them. I created a 
`ConfigMap` and a `Secret`, mounted them as environment variables, and verified they were available inside the container.

```
kubectl create configmap app-config --from-literal=APP_COLOR=blue --from-literal=APP_MODE=production # Create a ConfigMap with two non-sensitive settings
kubectl create secret generic db-credentials --from-literal=username=admin --from-literal=password='S3cret!Pass'# Create a Secret with database credentials (passwords should be inside single quotes)

kubectl get configmap app-config # Verify both objects exist
kubectl get secret db-credentials

# Apply a pod manifest that injects the ConfigMap and Secret as environment variables
kubectl apply -f pod-config-demo.yaml

# Wait for the pod to be ready
kubectl get pods -w   # press Ctrl+C when config-demo is Running

# Check that the environment variables were correctly injected
kubectl exec config-demo -- env | grep -E "APP_|username|password"

# Clean up
kubectl delete pod config-demo
kubectl delete configmap app-config
kubectl delete secret db-credentials
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/6-podtask4.png" width="600" alt="Lab 4 environment variables"/>
