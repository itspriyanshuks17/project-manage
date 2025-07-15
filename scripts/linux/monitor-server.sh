#!/bin/bash

# Server Monitoring Script for Asset Management System
# This script helps monitor and manage your production server

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

echo "📊 Asset Management System - Server Monitor"
echo "==========================================="
echo ""

cd docker 2>/dev/null || { print_error "Please run from project root directory"; exit 1; }

# Check if containers are running
print_info "Container Status:"
docker-compose -f docker-compose.prod.yml ps

echo ""
print_info "Resource Usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

echo ""
print_info "Health Check:"
curl -s http://localhost/health | jq . 2>/dev/null || curl -s http://localhost/health

echo ""
print_info "Recent Logs (last 20 lines):"
docker-compose -f docker-compose.prod.yml logs --tail=20

echo ""
print_info "Available Commands:"
echo "  View live logs:        docker-compose -f docker-compose.prod.yml logs -f"
echo "  Restart application:   docker-compose -f docker-compose.prod.yml restart asset-management"
echo "  Restart database:      docker-compose -f docker-compose.prod.yml restart mysql"
echo "  Stop all services:     docker-compose -f docker-compose.prod.yml down"
echo "  Update and restart:    docker-compose -f docker-compose.prod.yml up --build -d"
echo "  Backup database:       docker exec docker-mysql-1 mysqldump -u root -p asset_management > backup.sql"
echo ""
