# Boni-Web-Monitoring Administrator Guide
Version: 1.0.0
Author: Boni Yeamin
Last Updated: 2024

## Table of Contents
1. [System Overview](#1-system-overview)
2. [Installation](#2-installation)
3. [Configuration](#3-configuration)
4. [Security](#4-security)
5. [Maintenance](#5-maintenance)
6. [Troubleshooting](#6-troubleshooting)
7. [Backup & Recovery](#7-backup--recovery)
8. [Monitoring & Alerts](#8-monitoring--alerts)

## 1. System Overview

### 1.1 Architecture
```
[Client Browsers] → [Nginx Reverse Proxy] → [Services]
                                            ├── Grafana (3000)
                                            ├── Prometheus (9090)
                                            ├── Alertmanager (9093)
                                            ├── Loki (3100)
                                            └── Uptime Kuma (3001)
```

### 1.2 Components
- **Grafana**: Visualization and dashboards
- **Prometheus**: Metrics collection and storage
- **Alertmanager**: Alert handling and notifications
- **Loki**: Log aggregation
- **Uptime Kuma**: Uptime monitoring

## 2. Installation

### 2.1 Prerequisites
```bash
# System Requirements
- CPU: 4 cores minimum
- RAM: 8GB minimum
- Storage: 100GB minimum
- OS: Ubuntu 20.04 LTS or later
```

### 2.2 Initial Setup
```bash
# Clone repository
git clone https://github.com/yourusername/Boni-Web-Monitoring.git
cd Boni-Web-Monitoring

# Set up environment
cp .env.example .env
nano .env  # Configure environment variables

# Start services
./runbash.sh
```

## 3. Configuration

### 3.1 Environment Variables
```bash
# Required Variables
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=secure_password
PROMETHEUS_RETENTION_TIME=15d
LOKI_RETENTION_PERIOD=168h
```

### 3.2 Service Ports
```plaintext
Grafana: 3000
Prometheus: 9090
Alertmanager: 9093
Loki: 3100
Uptime Kuma: 3001
```

### 3.3 Volume Management
```bash
# Data Locations
/var/lib/docker/volumes/prometheus_data
/var/lib/docker/volumes/grafana_data
/var/lib/docker/volumes/loki_data
/var/lib/docker/volumes/uptime_kuma_data
```

## 4. Security

### 4.1 Access Control
```nginx
# Nginx Security Headers
add_header X-Frame-Options "SAMEORIGIN";
add_header X-XSS-Protection "1; mode=block";
add_header X-Content-Type-Options "nosniff";
```

### 4.2 SSL/TLS Configuration
```bash
# Generate certificates
./scripts/setup-ssl.sh

# SSL configuration location
/security/certs/
```

### 4.3 Firewall Rules
```bash
# Required Ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 3000/tcp
sudo ufw allow 9090/tcp
```

## 5. Maintenance

### 5.1 Regular Tasks
```bash
# Daily
./scripts/healthcheck.sh

# Weekly
./scripts/backup.sh /backup/weekly/

# Monthly
./scripts/update.sh all
```

### 5.2 Updates
```bash
# Update specific service
docker-compose pull [service_name]
docker-compose up -d [service_name]

# Update all services
./scripts/update.sh all
```

## 6. Troubleshooting

### 6.1 Common Issues

#### Service Not Starting
```bash
# Check logs
docker-compose logs [service_name]

# Check status
docker-compose ps

# Restart service
docker-compose restart [service_name]
```

#### Data Persistence Issues
```bash
# Check volume permissions
ls -la /var/lib/docker/volumes/

# Fix permissions
sudo chown -R 472:472 /var/lib/docker/volumes/grafana_data
```

## 7. Backup & Recovery

### 7.1 Backup Procedures
```bash
# Full backup
./scripts/backup.sh /path/to/backup/

# Specific service backup
./scripts/backup.sh --service grafana /path/to/backup/
```

### 7.2 Recovery Procedures
```bash
# Full restore
./scripts/restore.sh /path/to/backup/

# Specific service restore
./scripts/restore.sh --service prometheus /path/to/backup/
```

## 8. Monitoring & Alerts

### 8.1 Alert Rules
```yaml
# Location: prometheus/rules/
- alert: InstanceDown
  expr: up == 0
  for: 5m
  labels:
    severity: critical
```

### 8.2 Dashboard Management
```bash
# Import dashboard
./scripts/import-dashboard.sh /path/to/dashboard.json

# Export dashboard
./scripts/export-dashboard.sh dashboard_uid
```

### 8.3 Log Management
```bash
# View service logs
docker-compose logs -f [service_name]

# Rotate logs
./scripts/rotate-logs.sh
```

## Contact Information

For support or issues:
- **Author**: Boni Yeamin
- **Role**: Cyber Security Engineer
- **Email**: boniyeamin.cse@gmail.com
- **Organization**: Akij Group

## Version History

- 1.0.0 - Initial release
- 1.0.1 - Added security enhancements
- 1.0.2 - Updated backup procedures 

# Add these functions after the install_dependencies() function:

# Function to detect Linux distribution
detect_linux_distro() {
    echo -e "${BLUE}Detecting Linux distribution...${NC}"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        echo -e "${GREEN}Detected distribution: $DISTRO${NC}"
    else
        echo -e "${RED}Could not detect Linux distribution${NC}"
        DISTRO="unknown"
    fi
}

# Function to configure firewall
configure_firewall() {
    echo -e "${BLUE}Configuring firewall...${NC}"
    
    # Required ports for the monitoring stack
    PORTS=(80 443 3000 9090 9093 3100 3001)
    
    case $DISTRO in
        "ubuntu"|"debian")
            # Install UFW if not present
            if ! command -v ufw &> /dev/null; then
                echo -e "${YELLOW}Installing UFW firewall...${NC}"
                sudo apt update
                sudo apt install -y ufw
            fi
            
            # Configure UFW
            sudo ufw status | grep -q "Status: active" || {
                echo -e "${YELLOW}Enabling UFW...${NC}"
                sudo ufw --force enable
            }
            
            # Allow required ports
            for port in "${PORTS[@]}"; do
                sudo ufw status | grep -q "$port/tcp" || {
                    echo -e "${YELLOW}Opening port $port...${NC}"
                    sudo ufw allow $port/tcp
                }
            done
            ;;
            
        "centos"|"rhel"|"fedora"|"rocky"|"almalinux")
            # Install firewalld if not present
            if ! command -v firewall-cmd &> /dev/null; then
                echo -e "${YELLOW}Installing firewalld...${NC}"
                sudo dnf install -y firewalld
                sudo systemctl enable firewalld
                sudo systemctl start firewalld
            fi
            
            # Configure firewalld
            for port in "${PORTS[@]}"; do
                sudo firewall-cmd --list-ports | grep -q "$port/tcp" || {
                    echo -e "${YELLOW}Opening port $port...${NC}"
                    sudo firewall-cmd --permanent --add-port=$port/tcp
                }
            done
            sudo firewall-cmd --reload
            ;;
            
        "suse"|"opensuse-leap"|"opensuse-tumbleweed")
            # Install SuSEfirewall2 if not present
            if ! command -v SuSEfirewall2 &> /dev/null; then
                echo -e "${YELLOW}Installing SuSEfirewall2...${NC}"
                sudo zypper install -y SuSEfirewall2
            fi
            
            # Configure SuSEfirewall2
            for port in "${PORTS[@]}"; do
                echo -e "${YELLOW}Opening port $port...${NC}"
                sudo SuSEfirewall2 open EXT TCP $port
            done
            sudo SuSEfirewall2 start
            ;;
            
        "arch")
            # Install iptables if not present
            if ! command -v iptables &> /dev/null; then
                echo -e "${YELLOW}Installing iptables...${NC}"
                sudo pacman -S --noconfirm iptables
            fi
            
            # Configure iptables
            for port in "${PORTS[@]}"; do
                sudo iptables -C INPUT -p tcp --dport $port -j ACCEPT 2>/dev/null || {
                    echo -e "${YELLOW}Opening port $port...${NC}"
                    sudo iptables -A INPUT -p tcp --dport $port -j ACCEPT
                }
            done
            sudo iptables-save > /etc/iptables/iptables.rules
            ;;
            
        *)
            echo -e "${RED}Unsupported distribution for automatic firewall configuration${NC}"
            echo -e "${YELLOW}Please manually configure your firewall to allow ports: ${PORTS[*]}${NC}"
            ;;
    esac
    
    echo -e "${GREEN}Firewall configuration completed${NC}"
}

# Function to verify firewall configuration
verify_firewall() {
    echo -e "${BLUE}Verifying firewall configuration...${NC}"
    
    case $DISTRO in
        "ubuntu"|"debian")
            sudo ufw status
            ;;
        "centos"|"rhel"|"fedora"|"rocky"|"almalinux")
            sudo firewall-cmd --list-all
            ;;
        "suse"|"opensuse-leap"|"opensuse-tumbleweed")
            sudo SuSEfirewall2 status
            ;;
        "arch")
            sudo iptables -L
            ;;
        *)
            echo -e "${YELLOW}Please verify firewall configuration manually${NC}"
            ;;
    esac
} 