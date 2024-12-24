#!/bin/bash

# Installation script for Open-VN on Ubuntu Server 22.04
set -e

echo "Installing Open-VN dependencies..."

# Update system
sudo apt update
sudo apt upgrade -y

# Install Python and related tools
sudo apt install -y python3.11 python3.11-venv python3-pip

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install nginx
sudo apt install -y nginx

# Create application directory
sudo mkdir -p /opt/open-vn
sudo chown $USER:$USER /opt/open-vn

# Setup Python virtual environment
python3.11 -m venv /opt/open-vn/venv
source /opt/open-vn/venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Setup PostgreSQL
sudo -u postgres psql -c "CREATE DATABASE ovn;"
sudo -u postgres psql -c "CREATE USER ovnuser WITH PASSWORD 'your_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ovn TO ovnuser;"

echo "Installation completed successfully!"
