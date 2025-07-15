#!/bin/bash

# Production Server Deployment Script for Asset Management System
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

echo "🚀 Asset Management System - Production Deployment"
echo "=================================================="
echo ""

# Check if running as root or with sudo
if [[ $EUID -eq 0 ]]; then
   print_warning "Running as root. Consider using a dedicated user for production."
fi

# Check Docker installation
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    print_status "Docker installed. Please log out and back in, then run this script again."
    exit 1
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Installing..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_status "Docker Compose installed"
fi

print_status "Docker and Docker Compose are ready"

# Get server configuration
echo ""
print_info "Server Configuration Setup"
echo "Enter your server details (press Enter for defaults):"

read -p "Domain name or IP address [localhost]: " DOMAIN
DOMAIN=${DOMAIN:-localhost}

read -p "HTTP Port [80]: " HTTP_PORT
HTTP_PORT=${HTTP_PORT:-80}

read -p "Database password [SecurePassword123!]: " DB_PASSWORD
DB_PASSWORD=${DB_PASSWORD:-SecurePassword123!}

read -p "Session secret (leave empty to generate): " SESSION_SECRET
if [ -z "$SESSION_SECRET" ]; then
    SESSION_SECRET=$(openssl rand -base64 32)
fi

# Create production environment file
print_info "Creating production configuration..."
cat > docker/.env.prod << EOF
# Production Environment Configuration
DOMAIN=$DOMAIN
HTTP_PORT=$HTTP_PORT
DB_PASSWORD=$DB_PASSWORD
SESSION_SECRET=$SESSION_SECRET
NODE_ENV=production
EOF

print_status "Configuration saved to docker/.env.prod"

# Stop any existing containers
print_info "Stopping existing containers..."
cd docker
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Build and start production containers
print_info "Building and starting production containers..."
docker-compose -f docker-compose.prod.yml up --build -d

# Wait for services to be ready
print_info "Waiting for services to start..."
sleep 10

# Check if services are running
if docker-compose -f docker-compose.prod.yml ps | grep -q "Up"; then
    print_status "Services are running successfully!"
    
    echo ""
    echo "🎉 Deployment Complete!"
    echo ""
    echo "Your Asset Management System is now accessible at:"
    echo "  http://$DOMAIN:$HTTP_PORT"
    echo ""
    echo "Default login credentials:"
    echo "  Admin:    admin / admin123"
    echo "  Manager:  manager1 / manager123"
    echo "  Employee: employee1 / employee123"
    echo ""
    echo "Important Security Notes:"
    echo "1. Change default passwords immediately"
    echo "2. Configure firewall rules"
    echo "3. Set up SSL certificate for HTTPS"
    echo "4. Regular backup of the database"
    echo ""
    echo "Management Commands:"
    echo "  View logs:    docker-compose -f docker-compose.prod.yml logs -f"
    echo "  Stop server:  docker-compose -f docker-compose.prod.yml down"
    echo "  Restart:      docker-compose -f docker-compose.prod.yml restart"
    echo ""
else
    print_error "Some services failed to start. Check logs:"
    docker-compose -f docker-compose.prod.yml logs
    exit 1
fi

# Setup firewall (optional)
read -p "Configure firewall to allow HTTP traffic? (y/n): " SETUP_FIREWALL
if [[ $SETUP_FIREWALL =~ ^[Yy]$ ]]; then
    if command -v ufw &> /dev/null; then
        sudo ufw allow $HTTP_PORT
        sudo ufw --force enable
        print_status "Firewall configured to allow traffic on port $HTTP_PORT"
    else
        print_warning "UFW not found. Please manually configure your firewall."
    fi
fi

echo ""
print_status "Production deployment completed successfully! 🚀"
