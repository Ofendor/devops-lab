#!/bin/bash

#############################################
# Basic System Health Check Script
# Date: 2026-05
#
# Purpose:
#   This generates a quick health report showing
#   CPU, memory, disk, and network statistics.
#
# Usage:
#   ./system-check.sh
#
# Skills demonstrated (you can add any other check you believe is necessary):
#   - System monitoring commands (top, free, df)
#   - Process inspection (ps aux)
#   - Command substitution ($(command))
#   - Formatted terminal output
#############################################

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
