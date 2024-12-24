#!/bin/bash

# Validate host requirements for OVN installation
set -e

# Check Ubuntu version
if ! grep -q "Ubuntu 22.04" /etc/os-release; then
    echo "Error: This script requires Ubuntu 22.04"
    exit 1
fi

# Check system resources
CPU_CORES=$(nproc)
TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
FREE_DISK=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')

echo "System Requirements Check:"
echo "------------------------"
echo "CPU Cores: $CPU_CORES"
echo "Total Memory (GB): $TOTAL_MEM"
echo "Free Disk Space (GB): $FREE_DISK"

# Minimum requirements
MIN_CPU=2
MIN_MEM=4
MIN_DISK=20

# Validate requirements
if [ $CPU_CORES -lt $MIN_CPU ]; then
    echo "Error: Insufficient CPU cores. Minimum required: $MIN_CPU"
    exit 1
fi

if [ $TOTAL_MEM -lt $MIN_MEM ]; then
    echo "Error: Insufficient memory. Minimum required: ${MIN_MEM}GB"
    exit 1
fi

if [ $FREE_DISK -lt $MIN_DISK ]; then
    echo "Error: Insufficient disk space. Minimum required: ${MIN_DISK}GB"
    exit 1
fi

echo "Host meets minimum requirements"
exit 0
