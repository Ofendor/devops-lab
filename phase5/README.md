#Phase 5: Ansible Automation
Phase 5 introduces Ansible for configuration management
and application deployment. I'll write playbooks,
use variables and templates, organise roles, and
automated Kubernetes resource creation, 
all from a single control machine.
Ansible is widely used to manage OpenStack,
Kubernetes, and bare‑metal infrastructure.



## Labs
- Lab 1 – Ad‑hoc commands and inventory
Learning how Ansible connects to remote (or local) machines and 
executes one‑off commands without writing a full playbook.
Ad‑hoc commands are the quickest way to gather facts or troubleshoot
across many servers, they’re the swiss army knife of Ansible operations.

```bash
# Creating an inventory file that tells Ansible where the target machine is
nano inventory.ini
# Testing the connection - the ping module checks if Ansible can talk to the target
ansible -i inventory.ini local -m ping
# Gathering system facts (CPU, memory, IP addresses, etc.) from the target
ansible -i inventory.ini local -m setup | head -40
# Running a shell command directly - here we check how long the server has been running
ansible -i inventory.ini local -m shell -a "uptime"
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab1.1.png" width="600" alt="Ansible ad‑hoc ping"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab1.2.png" width="600" alt="Ansible setup facts"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab1.3.png" width="600" alt="Ansible shell uptime"/>


- Lab 2 – First playbook
Wrote a YAML playbook that installs nginx and ensures the
service is running – the fundamental Ansible building block.
A playbook is a list of plays; each play applies a set of
tasks to a group of hosts. They are idempotent; 
you can run them 100 times without breaking anything.

```
# Running the playbook (--become means “run with sudo”)
ansible-playbook -i inventory.ini webserver.yml --ask-become-pass
# Or, after making sudo passwordless for your user, simply:
ansible-playbook -i inventory.ini webserver.yml
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab2.png" width="600" alt="Playbook run and nginx status"/>

- Lab 3 – Variables and templates
Making playbooks reusable by moving configuration into variables
and generating config files dynamically with Jinja2 templates.
Hard‑coding values leads to duplicated playbooks. Variables and
templates let you deploy the same playbook to staging/production
with different settings, just by changing variable files.

```
# Creating a variables file (nginx port and server name)
nano vars.yml
# Creating a Jinja2 template for an nginx virtual host
nano nginx.conf.j2
# Wrote a playbook that uses vars_files and the template module
nano template-playbook.yml
# Running the playbook
ansible-playbook -i inventory.ini template-playbook.yml
# Verifying the template was rendered correctly
curl http://localhost:8080   # Should display "Hello from <hostname> on port 8080"
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab3.1.png" width="600" alt="Template playbook run"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab3.2.png" width="600" alt="Curl output from template"/>

- Lab 4 – Roles
Putting package tasks, handlers, templates, and variables into a reusable
Ansible Role, the industry standard for organising automation code.
Roles are like libraries: you write them once and reuse them across
projects. Ansible Galaxy hosts thousands of community roles for almost any task.

```
# Creating the scaffolding for a role named "nginx_role"
ansible-galaxy init nginx_role
# Populate the role’s tasks, handlers, templates, and variables
# and wrote a playbook that simply calls the role
nano role-playbook.yml
# Running the playbook – Ansible will execute the role’s tasks
ansible-playbook -i inventory.ini role-playbook.yml
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab4.png" width="600" alt="Role‑based playbook run"/>

- Lab 5 – Automating Kubernetes with Ansible
Use Ansible’s Kubernetes modules to create Deployments and Services
declaratively, bridging automation and container orchestration.
This is how platform teams deliver applications to Kubernetes without
manual kubectl commands, every change is audited, repeatable, and version‑controlled.

```
# Wrote a playbook that defines a Deployment and a NodePort Service
nano k8s-deploy.yml
# Running the playbook. Ansible connects to the K3s API and creates the resources
ansible-playbook -i inventory.ini k8s-deploy.yml
# Verifying with kubectl and test the service
kubectl get deployment nginx-ansible
kubectl get svc nginx-ansible-svc
PORT=$(kubectl get svc nginx-ansible-svc -o jsonpath='{.spec.ports[0].nodePort}')
curl http://localhost:$PORT   # Nginx welcome page
# Clean up once you finish
kubectl delete deployment nginx-ansible
kubectl delete svc nginx-ansible-svc
```

<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab5.1.png" width="600" alt="Ansible Kubernetes playbook run"/>
<img src="https://raw.githubusercontent.com/Ofendor/devops-lab/main/screenshots/phase5lab5.2.png" width="600" alt="Curl output from Kubernetes deployment"/>
