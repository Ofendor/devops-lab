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
- **Run it:** `docker build -t devops-flask:v1 . && docker run -p 5000:5000 devops-flask:v1`

![Docker Demo 1](../screenshots/4. docker-demo1.png)
![Docker Demo 2](../screenshots/4. docker-demo2.png)
