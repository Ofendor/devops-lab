#!/bin/bash
################################################
# DevOps Lab: Automated Ubuntu Server Setup
# Author: Ofendor [Emilio Mardones]
# Date: $(date +%Y-%m%d)
# Version: 1.0
# Description: Configures a fresh Ubuntu server
#	       with DevOps tools and security
################################################

set -euo pipefail

#Configuration of the script
LOG_FILE="/var/log/server-setup.log"
APP_USER="ofendor"
APP_GROUP="devops-team"
SSH_PORT=22

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0' #no colour

# The functions 
log() {
     echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

error() {
     echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE"
     exit1
}

# This checks if  you are running as root
if [[ $EUID -ne 0 ]]; then
     error "This script must be run as root: sudo $0"
fi

# Create a log
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

log "================================="
log " Starting server setup..."
log "================================="

# 1. System update
log "1/4 U[dating system packages..."
apt update && apt upgrade -y >> "$LOG_FILE" 2>&1
log "[DONE] System Updated!"

# 2. Install Essential Packages
log "2/4 Installing essential packages..."
apt install -y \
	curl wget git vim htop net-tools tree unzip\
	build-essential software-properties-common \
	ca-certificates gnupg lsb-release \
	ufw fail2ban >> "$LOG_FILE" 2>&1
log "[DONE] Essential packages installed!"

# 3. Verify User & Group
log "3/4 Verifying user and group..."
id "$APP_USER" &>/dev/null && log "[OK] User $APP_USER exists" || log "[WARN] User $APP_USER not found"
getent group "$APP_GROUP" &>/dev/null && log "[OK] Group $APP_GROUP exists" || log "[WARN] Group $APP_GROUP not found"

# 4. Configuring Firewall
log "4/4 Configuring Firewall..."
sudo ufw default deny incoming >> "$LOG_FILE" 2>&1
sudo ufw default allow outgoing >> "$LOG_FILE" 2>&1
sudo ufw allow "$SSH_PORT"/tcp >> "$LOG_FILE" 2>&1
sudo ufw --force enable >> "$LOG_FILE" 2>&1
log "[OK] Firewall configured!"

cat > /etc/motd << 'EOF'
===========================================
	WELCOME TO DEVOPS LAB SERVER
	"Automate everything :)"
===========================================
EOF

log "[OK] Lab environment ready"

log "====================================="
log "SETUP COMPLETE!"
log "====================================="
log "User: $APP_USER"
log "SHH Port: $SSH_PORT"
log "====================================="
