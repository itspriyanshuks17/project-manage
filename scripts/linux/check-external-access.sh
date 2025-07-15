#!/bin/bash

# External Access Test Script for Asset Management System

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

echo "🌐 Asset Management System - External Access Information"
echo "======================================================="
echo ""

# Get server IP address
SERVER_IP=$(hostname -I | awk '{print $1}')
EXTERNAL_PORT="8081"

print_info "Server Information:"
echo "  Server IP Address: $SERVER_IP"
echo "  Application Port: $EXTERNAL_PORT"
echo ""

print_info "Access URLs:"
echo "  Local Access:     http://localhost:$EXTERNAL_PORT"
echo "  Network Access:   http://$SERVER_IP:$EXTERNAL_PORT"
echo ""

print_info "Health Check:"
HEALTH_STATUS=$(curl -s http://localhost:$EXTERNAL_PORT/health | jq -r '.status' 2>/dev/null || echo "unknown")
if [ "$HEALTH_STATUS" = "healthy" ]; then
    print_status "Application is running and healthy"
else
    print_warning "Health check failed or jq not installed"
fi

echo ""
print_info "Testing External Access:"

# Test if port is accessible externally
if nc -z $SERVER_IP $EXTERNAL_PORT 2>/dev/null; then
    print_status "Port $EXTERNAL_PORT is accessible on $SERVER_IP"
else
    print_warning "Port $EXTERNAL_PORT may not be accessible externally"
    echo "  This could be due to:"
    echo "  - Firewall blocking the port"
    echo "  - Network configuration"
    echo "  - Docker networking issues"
fi

echo ""
print_info "Firewall Check:"
# Check if ufw is active
if command -v ufw >/dev/null 2>&1; then
    UFW_STATUS=$(sudo ufw status | head -1)
    echo "  UFW Status: $UFW_STATUS"
    if echo "$UFW_STATUS" | grep -q "active"; then
        print_warning "UFW firewall is active - you may need to allow port $EXTERNAL_PORT"
        echo "  Run: sudo ufw allow $EXTERNAL_PORT"
    fi
else
    echo "  UFW not installed - check your system firewall"
fi

echo ""
print_info "To access from other devices:"
echo "  1. Connect devices to the same network"
echo "  2. Open browser on other device"
echo "  3. Go to: http://$SERVER_IP:$EXTERNAL_PORT"
echo "  4. Use these login credentials:"
echo ""
echo "     Admin:    admin / admin123"
echo "     Manager:  manager1 / manager123"
echo "     Employee: employee1 / employee123"

echo ""
print_info "Container Status:"
sudo docker-compose ps 2>/dev/null || echo "  Run from docker directory for container status"

echo ""
print_info "Troubleshooting:"
echo "  - If access fails, check firewall settings"
echo "  - Ensure devices are on same network"
echo "  - Try different browsers"
echo "  - Check container logs: sudo docker-compose logs asset-management"
echo ""
