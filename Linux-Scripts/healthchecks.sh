#!/bin/bash

# CPU
cpu_usage=$(ps -eo pid,user,%cpu,command --sort=-%cpu | head -n 2 | awk 'NR==2 {print $3}')

# Memory
mem_total=$(free -h | awk '/^Mem:/ {print $2}')
mem_used=$(free -h | awk '/^Mem:/ {print $3}')
mem_available=$(free -h | awk '/^Mem:/ {print $7}')

# Disk
disk_usage=$(df -h / | awk 'NR==2 {print $5}')

# Uptime
system_uptime=$(uptime -p)

echo "========================================"
echo "       LINUX SYSTEM HEALTH CHECK"
echo "========================================"

echo ""
echo "CPU"
echo "    CPU usage:   $cpu_usage%"

echo ""
echo "MEMORY"
echo "    Total:       $mem_total"
echo "    Used:        $mem_used"
echo "    Available:   $mem_available"

echo ""
echo "DISK"
echo "    / :           $disk_usage"

echo ""
echo "SYSTEM"
echo "    Uptime:       $system_uptime"

echo ""
echo "========================================"