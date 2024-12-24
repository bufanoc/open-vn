# Open-VN (OVN Web Platform)

## Overview
Open-VN is a comprehensive web interface for managing OVN (Open Virtual Network) deployments across multiple Ubuntu Server 22.04 hosts. It provides a centralized management platform that automates the deployment, configuration, and management of OVN infrastructure.

## Features
- Web-based UI for OVN management
- Dynamic host discovery and management
- Automated OVN installation and configuration
- SSH-based remote host management
- Host requirement validation
- Centralized OVN infrastructure management
- Real-time status monitoring

## System Requirements

### Server Requirements
- Ubuntu Server 22.04 LTS
- Python 3.11+
- PostgreSQL
- Node.js 18+
- nginx
- 4GB RAM (minimum)
- 2 CPU cores (minimum)
- 40GB disk space

### Managed Host Requirements
- Ubuntu Server 22.04 LTS
- SSH access
- Sudo privileges

## Architecture
The system consists of three main components:
1. **Frontend**: React-based web interface with Material-UI
2. **Backend**: FastAPI-based API server
3. **Agent**: SSH-based remote execution system

## Installation

### Server Setup
1. Update the system
```bash
sudo apt update
sudo apt upgrade -y
```

2. Clone the repository
```bash
git clone https://github.com/yourusername/open-vn.git
cd open-vn
```

3. Run the installation script
```bash
chmod +x install.sh
./install.sh
```

4. Configure the services
```bash
sudo cp backend/ovn-api.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable ovn-api
sudo systemctl start ovn-api
```

5. Configure nginx
```bash
sudo cp frontend/nginx.conf /etc/nginx/sites-available/open-vn
sudo ln -s /etc/nginx/sites-available/open-vn /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Project Structure
```
open-vn/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   ├── core/
│   │   ├── models/
│   │   └── utils/
│   └── ovn-api.service
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   └── services/
│   └── nginx.conf
├── deployment/
│   └── scripts/
├── install.sh
└── README.md
```

## Contributing
Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
