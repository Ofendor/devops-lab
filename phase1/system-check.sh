#!/bin/bash

# System Health Check Script
# Created: 06 May 2026

echo "====================================="
echo "     SYSTEM HEALTH REPORT"
echo "====================================="
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo ""
echo "CPU USAGE:"
echo "-------------------------------------"
top -bn1 | head -5
echo "MEMORY USAGE:"
echo "-------------------------------------"
free -h 
echo ""
echo "TOP 5 PROCESSES BY MEMORY"
echo "-------------------------------------"
df -h /
echo ""
echo "-------------------------------------"
ps aux --sort=-%mem | head -6
echo ""
echo "NETWORK:"
echo "-------------------------------------"
echo "IP Address: $(hostname -I)"
echo "====================================="
