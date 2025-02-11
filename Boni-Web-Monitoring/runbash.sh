#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Banner
echo -e "${BLUE}"
cat << "EOF"
 ____              _    __        __   _     
| __ )  ___  _ __ (_)   \ \      / /__| |__  
|  _ \ / _ \| '_ \| |____\ \ /\ / / _ \ '_ \ 
| |_) | (_) | | | | |_____\ V  V /  __/ |_) |
|____/ \___/|_| |_|_|      \_/\_/ \___|_.__/ 
                                             
    Monitoring & Observability Platform
EOF
echo -e "${NC}"

# Author Information
echo -e "${GREEN}=============================================${NC}"
echo -e "${YELLOW}Author: ${NC}Boni Yeamin"
echo -e "${YELLOW}Role: ${NC}Cyber Security Engineer"
echo -e "${YELLOW}Organization: ${NC}Akij Group"
echo -e "${YELLOW}Contact: ${NC}boniyeamin.cse@gmail.com"
echo -e "${GREEN}=============================================${NC}"
echo

# Function to check and create directories
create_directories() {
    echo -e "${BLUE}Creating project structure...${NC}"
    mkdir -p {prometheus/{rules,config},grafana/{provisioning/{dashboards,datasources},config},loki/config,uptime-kuma/config,security/{certs,nginx,fail2ban},docs}
}

# Function to check system requirements
check_requirements() {
    echo -e "${BLUE}Checking system requirements...${NC}"
    
    # Check CPU cores
    CPU_CORES=$(nproc)
    if [ "$CPU_CORES" -lt 4 ]; then
        echo -e "${RED}Warning: Less than 4 CPU cores available (Found: $CPU_CORES)${NC}"
    fi
    
    # Check RAM
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$TOTAL_RAM" -lt 8 ]; then
        echo -e "${RED}Warning: Less than 8GB RAM available (Found: ${TOTAL_RAM}GB)${NC}"
    fi
    
    # Check Storage
    FREE_STORAGE=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$FREE_STORAGE" -lt 100 ]; then
        echo -e "${RED}Warning: Less than 100GB storage available (Found: ${FREE_STORAGE}GB)${NC}"
    fi
}

# Function to install dependencies
install_dependencies() {
    echo -e "${BLUE}Installing dependencies...${NC}"
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}Installing Docker...${NC}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
    fi
    
    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${YELLOW}Installing Docker Compose...${NC}"
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
}

# Function to generate SSL certificates
generate_certificates() {
    echo -e "${BLUE}Generating SSL certificates...${NC}"
    if [ ! -f "./security/certs/server.crt" ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout ./security/certs/server.key \
            -out ./security/certs/server.crt \
            -subj "/C=BD/ST=Dhaka/L=Dhaka/O=Akij Group/OU=IT/CN=monitoring.akij.net"
    fi
}

# Function to set up environment
setup_environment() {
    echo -e "${BLUE}Setting up environment...${NC}"
    if [ ! -f .env ]; then
        cat > .env << EOL
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=admin
PROMETHEUS_RETENTION_TIME=15d
LOKI_RETENTION_PERIOD=168h
DOMAIN_NAME=monitoring.akij.net
EOL
    fi
}

# Function to configure services
configure_services() {
    echo -e "${BLUE}Configuring services...${NC}"
    
    # Set permissions
    sudo chown -R 472:472 grafana
    sudo chown -R 65534:65534 prometheus
    
    # Copy default configurations if they don't exist
    [ ! -f prometheus/prometheus.yml ] && cp templates/prometheus.yml prometheus/
    [ ! -f grafana/grafana.ini ] && cp templates/grafana.ini grafana/
    [ ! -f loki/config.yml ] && cp templates/loki.yml loki/config.yml
}

# Function to start services
start_services() {
    echo -e "${BLUE}Starting services...${NC}"
    docker-compose pull
    docker-compose up -d
    
    # Wait for services to be ready
    echo -e "${YELLOW}Waiting for services to be ready...${NC}"
    sleep 30
}

# Function to verify services
verify_services() {
    echo -e "${BLUE}Verifying services...${NC}"
    
    services=("grafana:3000" "prometheus:9090" "alertmanager:9093" "loki:3100" "uptime-kuma:3001")
    
    for service in "${services[@]}"; do
        name="${service%%:*}"
        port="${service#*:}"
        if curl -s "http://localhost:$port" > /dev/null; then
            echo -e "${GREEN}✓ $name is running on port $port${NC}"
        else
            echo -e "${RED}✗ $name is not responding on port $port${NC}"
        fi
    done
}

# Main execution
main() {
    echo -e "${GREEN}Starting Boni-Web-Monitoring Setup...${NC}"
    
    check_requirements
    create_directories
    install_dependencies
    generate_certificates
    setup_environment
    configure_services
    start_services
    verify_services
    
    echo -e "${GREEN}=============================================${NC}"
    echo -e "${GREEN}Setup complete! Access the services at:${NC}"
    echo -e "${YELLOW}Grafana:${NC} http://localhost:3000"
    echo -e "${YELLOW}Prometheus:${NC} http://localhost:9090"
    echo -e "${YELLOW}Alertmanager:${NC} http://localhost:9093"
    echo -e "${YELLOW}Uptime Kuma:${NC} http://localhost:3001"
    echo -e "${YELLOW}Loki:${NC} http://localhost:3100"
    echo -e "${GREEN}=============================================${NC}"
    echo
    echo -e "${BLUE}For support or issues, contact:${NC}"
    echo -e "${YELLOW}Email:${NC} boniyeamin.cse@gmail.com"
    echo -e "${GREEN}=============================================${NC}"
}

# Execute main function
main
