# Phase 1: DevOps Linux Fundamentals

Phase 1 transformed a simple Ubuntu Server 26.04 LTS VM into a hardened, DevOps-stable environment from which I performed essential Linux administration skills through hands-on practice and built three production-quality bash scripts. You can add any other you believe is necessary for your portfolio. 

| Skill | Commands/Tools |
|-------|---------------|
| **User & Group Management** | `useradd`, `usermod`, `groupadd`, `chown` |
| **File Permissions** | `chmod` (numeric & symbolic), `ls -la` |
| **Process Management** | `ps aux`, `kill`, `systemctl`, background processes |
| **Networking** | `ip addr`, `ss`, `netstat`, DNS resolution |
| **Firewall Configuration** | `ufw` (default deny, allow SSH) |
| **Shell Scripting** | Variables, conditionals, functions, error handling |

## Scripts

### 1. `server-setup.sh`
**Purpose:** Fully automated update packages, installs DevOps tools, configures firewall, hardens SSH, creates lab directory structure  
**Run with:** `sudo ./server-setup.sh`

<div align="center">
  <img src="screenshots/1. system-check.png" width="950" alt="PowerShell pre-installation verification results"/>
  </div>

### 2. `system-check.sh`
**Purpose:** Quick system health report  
**What it does:** Displays CPU usage, memory stats, disk usage, top processes, network info  
**Run with:** `./system-check.sh`

### 3. `backup.sh`
**Purpose:** Automated directory backup with validation  
**What it does:** Creates timestamped `.tar.gz` archives with input validation and error handling  
**Run with:** `./backup.sh <source_dir> <backup_name>`

## Why This Matters for DevOps
- Linux is the operating system of the cloud — 96% of servers run Linux
- Scripting automation is the foundation of Infrastructure-as-Code
- Security hardening (firewall, SSH) is mandatory for production systems
- These scripts demonstrate the automation mindset that separates DevOps engineers from manual operators

## Environment
- OS: Ubuntu Server 26.04 LTS (Resolute Raccoon)
- Kernel: 7.0.0-15-generic
- Virtualization: VirtualBox
- User: ofendor

## References
- Ubuntu. (2026). *Ubuntu Server Guide*. https://ubuntu.com/server/docs
- Linux Foundation. (2024). *Introduction to Linux*. https://training.linuxfoundation.org/
