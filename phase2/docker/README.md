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
- **Stack:** Python Flask
- Dockerfile syntax, layer caching, HEALTHCHECK, running as non‑root
- **Run it:**
```bash
cd ~/devops-lab/phase2/docker/first-app
docker build -t devops-flask:v1 .
docker run -d --name flask-app -p 5000:5000 devops-flask:v1
curl http://localhost:5000
docker rm -f flask-app
```
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/4-docker-demo1.png" width="600" alt="Docker Demo 1"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/4-docker-demo2.png" width="600" alt="Docker Demo 2"/>

### 2. Multi‑Service App (`compose-app/`)
- **Stack:** Flask + MySQL + Adminer
- Service dependencies (`depends_on` with health checks), database persistence, multi‑container networking
- **Run it via:**
```bash
cd ~/devops-lab/phase2/docker/compose-app
docker compose up -d
docker compose ps
curl http://localhost:5000
curl http://localhost:5000/db-test #If you are using SSH on Gitbash/ PS use the VM IP
docker compose down -v
```
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/5-compose1.png" width="600" alt="Docker Compose Up"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/5-compose2.png" width="600" alt="Database Connected"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/5-compose3.png" width="400" alt="Adminer Login"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/5-compose4.png" width="600" alt="Adminer Database"/>
