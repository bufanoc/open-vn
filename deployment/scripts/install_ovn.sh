#!/bin/bash

# Install OVN on Ubuntu Server 22.04
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Update package list
apt-get update
apt-get upgrade -y

# Install OVN dependencies
apt-get install -y ovn-central ovn-host ovn-common

# Start OVN services
systemctl enable ovn-central
systemctl start ovn-central
systemctl enable ovn-controller
systemctl start ovn-controller

echo "OVN installation completed successfully"
