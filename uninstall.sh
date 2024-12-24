#!/bin/bash

# Uninstallation script for Open-VN
set -e

# Colors for output
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${BLUE}[*] $1${NC}"
}

# Function to print warning messages
print_warning() {
    echo -e "${RED}[!] $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo ./uninstall.sh)"
    exit 1
fi

print_warning "This will remove Open-VN and all its data. Are you sure? (y/N)"
read -r response
if [[ ! "$response" =~ ^[yY]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Stop and remove services
print_status "Stopping and removing services..."
systemctl stop ovn-api || true
systemctl disable ovn-api || true
rm -f /etc/systemd/system/ovn-api.service
systemctl daemon-reload

# Remove nginx configuration
print_status "Removing nginx configuration..."
rm -f /etc/nginx/sites-enabled/open-vn
rm -f /etc/nginx/sites-available/open-vn
systemctl restart nginx

# Drop database and user
print_status "Removing database..."
sudo -u postgres psql -c "DROP DATABASE IF EXISTS ovn;"
sudo -u postgres psql -c "DROP USER IF EXISTS ovnuser;"

# Remove application directory
print_status "Removing application files..."
rm -rf /opt/open-vn

print_status "Uninstallation complete. The following were not removed:"
echo "1. System packages (nginx, postgresql, python3, nodejs)"
echo "2. System configurations"
echo "To remove these, use: sudo apt remove --purge nginx postgresql nodejs"

print_warning "Note: If you plan to reinstall, you can now run install.sh again."
