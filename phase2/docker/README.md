# Phase 2: Docker & Cloud‑Native Observability

In Phase 2 I transformed isolated application code into reproducible, production‑grade
container images and orchestrated multi‑service stacks with Docker Compose for the first time.
I also deployed a Prometheus/Grafana monitoring stack – the same tools used by
Site Reliability Engineering (SRE) teams at Catalyst Cloud to maintain cloud services. This is a very simple lab that I created to get familiar with Docker capabilities.

| Area | Tools & Practices |
|------|-------------------|
| **Containerisation** | Dockerfiles (multi‑stage builds), image optimisation, non‑root users |
| **Orchestration** | Docker Compose, service dependencies, health checks, restart policies |
| **Networking** | Custom bridge networks, service discovery, reverse proxies (Nginx) |
| **Persistence** | Named volumes, bind mounts, database storage |
| **Observability** | Prometheus metrics scraping, Node Exporter, Grafana dashboards |
| **Security** | Non‑root container users, firewall (UFW), `.dockerignore`, HEALTHCHECK |
| **Infrastructure Awareness** | OpenStack concepts (Nova, Cinder, Swift, Neutron, Keystone, Glance) |
| **Sovereignty** | All services run locally respecting data sovereignty principles |

## Projects

### 1. First Custom Image (`first-app/`)
Dockerfiles are just recipes. You tell Docker what base image to use, what to install, and how to run your app. The hardest part was getting the triple-quote syntax right — Python is picky (case sensitive).

- **Stack:** Python Flask
- Dockerfile syntax, layer caching, HEALTHCHECK, running as non‑root
- **Run it:**
```bash
cd ~/devops-lab/phase2/docker/first-app # Go to the folder with the Dockerfile and app code
docker build -t devops-flask:v1 .  # Build the image from the Dockerfile (the "." means "current directory")
docker run -d --name flask-app -p 5000:5000 devops-flask:v1 # Run the container in detached mode (-d), give it a name, map port 5000
curl http://localhost:5000 # Test if the app responds — should return HTML
docker rm -f flask-app # Force-remove the container when done
```
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/4-docker-demo1.png" width="850" alt="Docker Demo 1"/>

Testing via `curl` will show the following outcome.

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/4-docker-demo2.png" width="400" alt="Docker Demo 2"/>

### 2. Multi‑Service App (`compose-app/`)
Docker Compose lets you run multiple containers that talk to each other. MySQL takes forever to start, so the `depends_on` with `condition: service_healthy` was a lifesaver — no more guessing when the database is ready.

- **Stack:** Flask + MySQL + Adminer
- Service dependencies (`depends_on` with health checks), database persistence, multi‑container networking
- **Run it via:**
```bash
cd ~/devops-lab/phase2/docker/compose-app # Go to the multi-service project folder
docker compose up -d # Start all services (Flask app, MySQL database, Adminer UI) in the background
docker compose ps # Check that all three containers are running and healthy
curl http://localhost:5000 # Test the Flask app's main page
curl http://localhost:5000/db-test #If you are using SSH on Gitbash/ PS use the VM IP
docker compose down -v # For clean start next time
```
Testing via `curl` will show the following outcome.

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/5-compose1.png" width="850" alt="Docker Compose Up"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/5-compose2.png" width="300" alt="Database Connected"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/5-compose3.png" width="400" alt="Adminer Login"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/5-compose4.png" width="400" alt="Adminer Database"/>

### 3. Portfolio App (`portfolio-app/`)
**Stack:** Nginx reverse proxy → Flask (Gunicorn) ↔ Redis

Nginx acts like a receptionist for the apps, it handles incoming traffic and passes requests to Flask. Redis is just a fast notepad for counting visits. Simple tools, powerful combo.

```bash
cd ~/devops-lab/phase2/docker/portfolio-app #position within the continer location to deploy the app
docker compose up -d --build
docker compose ps # Check that all three services are running and healthy
curl http://localhost/  # Test the main entrance — asks the app "who are you?"
curl http://localhost/health # Test the health check — asks "are you okay?"
curl http://localhost/api/info # Test the info endpoint — asks "what environment are you running in?"
docker compose down -v
```
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/nginx1.png" width="950" alt="Portfolio App Nginx"/>

### 4. Observability Stack (`monitoring/`)
**Stack:** Prometheus + Node Exporter + Grafana

Collects real-time system metrics (CPU, memory, disk, network) from the VM and displays them on a dashboard – the same tools used by SRE teams at Catalyst Cloud. Prometheus scrapes system metrics, Grafana visualises them.

```bash
cd ~/devops-lab/phase2/docker/monitoring
docker compose up -d # Start Prometheus, Node Exporter, and Grafana in the background
docker compose ps # Verify all three services are running
curl http://localhost:9090/-/healthy # Check Prometheus health – it's ready to scrape metrics
curl http://localhost:9100/metrics | head -5 # View raw system metrics from Node Exporter
docker compose down -v # Remove everything when finished
```
Access Grafana at `http://<VM-IP>:3000 (login admin/admin)`, add Prometheus data source `(URL: http://prometheus:9090)`, and import `Node Exporter Full dashboard (ID: 1860)`.

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/prome-grafa1.png" width="900" alt="Prometheus and Node Exporter health"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/prome-grafa2.png" width="850" alt="Grafana dashboard showing system metrics"/>
