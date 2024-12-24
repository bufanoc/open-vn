#!/bin/bash

# Installation script for Open-VN on Ubuntu Server 22.04
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${BLUE}[*] $1${NC}"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo ./install.sh)"
    exit 1
fi

# Check Ubuntu version
if ! grep -q "Ubuntu 22.04" /etc/os-release; then
    echo "Error: This script requires Ubuntu 22.04"
    exit 1
fi

print_status "Starting Open-VN installation..."

# Update system and install dependencies
print_status "Updating system and installing dependencies..."
apt update && apt upgrade -y
apt install -y python3.11 \
    python3.11-venv \
    python3-pip \
    postgresql \
    postgresql-contrib \
    nginx \
    curl

# Install Node.js
print_status "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Create application directory
print_status "Setting up application directory..."
APP_DIR="/opt/open-vn"
mkdir -p $APP_DIR
cd $APP_DIR

# Set up PostgreSQL
print_status "Configuring PostgreSQL..."
sudo -u postgres psql -c "CREATE DATABASE ovn;" || true
sudo -u postgres psql -c "CREATE USER ovnuser WITH PASSWORD 'ovnpass';" || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ovn TO ovnuser;" || true

# Set up Python virtual environment
print_status "Setting up Python virtual environment..."
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

# Create database configuration
print_status "Creating database configuration..."
mkdir -p backend/app/config
cat > backend/app/config/database.py << EOL
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URL = "postgresql://ovnuser:ovnpass@localhost/ovn"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
EOL

# Configure nginx
print_status "Configuring nginx..."
cp frontend/nginx.conf /etc/nginx/sites-available/open-vn
ln -sf /etc/nginx/sites-available/open-vn /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx

# Set up backend service
print_status "Setting up backend service..."
cp backend/ovn-api.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable ovn-api
systemctl start ovn-api

print_success "Installation completed successfully!"
print_success "You can access the web interface at: http://$(hostname -I | awk '{print $1}')"
print_success "API is running at: http://$(hostname -I | awk '{print $1}'):8000"

# Print service status
echo -e "\nService Status:"
echo "---------------"
systemctl status nginx --no-pager
echo
systemctl status ovn-api --no-pager
echo
systemctl status postgresql --no-pager
