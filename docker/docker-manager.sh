#!/bin/bash

# Asset Management System - Docker Management Script
# This script helps you manage your Docker deployment easily

set -e

# Navigate to docker directory
cd "$(dirname "$0")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=================================="
    echo -e "🚀 Asset Management System Docker"
    echo -e "==================================${NC}"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check for Docker Compose (prefer the new binary)
    if command -v /usr/local/bin/docker-compose &> /dev/null; then
        DOCKER_COMPOSE="/usr/local/bin/docker-compose"
    elif command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE="docker-compose"
    else
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
}

# Function to build the application
build_app() {
    print_status "Building Asset Management System Docker image..."
    $DOCKER_COMPOSE build --no-cache
    print_status "Build completed successfully!"
}

# Function to start the application (development)
start_dev() {
    print_status "Starting Asset Management System in Development mode..."
    $DOCKER_COMPOSE up -d
    print_status "Application started successfully!"
    print_status "Access the application at: http://localhost:8080"
    print_status "MySQL database is available at: localhost:3307"
}

# Function to start the application (production)
start_prod() {
    print_status "Starting Asset Management System in Production mode..."
    $DOCKER_COMPOSE -f docker-compose.prod.yml up -d
    print_status "Application started successfully!"
    print_status "Access the application at: http://localhost"
    print_warning "Make sure to configure SSL/TLS for production use!"
}

# Function to stop the application
stop_app() {
    print_status "Stopping Asset Management System..."
    $DOCKER_COMPOSE down
    $DOCKER_COMPOSE -f docker-compose.prod.yml down 2>/dev/null || true
    print_status "Application stopped successfully!"
}

# Function to view logs
view_logs() {
    print_status "Viewing application logs..."
    $DOCKER_COMPOSE logs -f app
}

# Function to restart the application
restart_app() {
    print_status "Restarting Asset Management System..."
    stop_app
    start_dev
}

# Function to show status
show_status() {
    print_status "Current Docker containers status:"
    docker ps -a --filter "name=asset-"
    echo ""
    print_status "Application health check:"
    if curl -s http://localhost:8080/health > /dev/null 2>&1; then
        print_status "✅ Application is healthy and running!"
    else
        print_warning "⚠️  Application is not responding or not running"
    fi
}

# Function to clean up
cleanup() {
    print_warning "This will remove all containers, images, and volumes!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Cleaning up Docker resources..."
        $DOCKER_COMPOSE down -v --remove-orphans
        $DOCKER_COMPOSE -f docker-compose.prod.yml down -v --remove-orphans 2>/dev/null || true
        docker system prune -f
        print_status "Cleanup completed!"
    else
        print_status "Cleanup cancelled."
    fi
}

# Function to backup database
backup_db() {
    print_status "Creating database backup..."
    BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).sql"
    docker exec asset-db mysqldump -u sigma -psigma asset_management > $BACKUP_FILE
    print_status "Database backup created: $BACKUP_FILE"
}

# Function to get IP address
get_ip() {
    LOCAL_IP=$(hostname -I | awk '{print $1}')
    print_status "Local machine IP: $LOCAL_IP"
    print_status "Access from other devices: http://$LOCAL_IP:8080"
}

# Main menu
show_menu() {
    clear
    print_header
    echo "Please select an option:"
    echo "1. 🔨 Build Application"
    echo "2. 🚀 Start (Development)"
    echo "3. 🏭 Start (Production)"
    echo "4. 🛑 Stop Application"
    echo "5. 🔄 Restart Application"
    echo "6. 📊 Show Status"
    echo "7. 📋 View Logs"
    echo "8. 🌐 Get Network IP"
    echo "9. 💾 Backup Database"
    echo "10. 🧹 Cleanup All"
    echo "11. ❌ Exit"
    echo ""
}

# Check if Docker is available
check_docker

# Main script logic
if [ $# -eq 0 ]; then
    while true; do
        show_menu
        read -p "Enter your choice (1-11): " choice
        case $choice in
            1) build_app ;;
            2) start_dev ;;
            3) start_prod ;;
            4) stop_app ;;
            5) restart_app ;;
            6) show_status ;;
            7) view_logs ;;
            8) get_ip ;;
            9) backup_db ;;
            10) cleanup ;;
            11) print_status "Goodbye! 👋"; exit 0 ;;
            *) print_error "Invalid option. Please try again." ;;
        esac
        echo ""
        read -p "Press Enter to continue..."
    done
else
    # Command line arguments
    case $1 in
        build) build_app ;;
        start) start_dev ;;
        start-prod) start_prod ;;
        stop) stop_app ;;
        restart) restart_app ;;
        status) show_status ;;
        logs) view_logs ;;
        ip) get_ip ;;
        backup) backup_db ;;
        cleanup) cleanup ;;
        *) 
            echo "Usage: $0 [build|start|start-prod|stop|restart|status|logs|ip|backup|cleanup]"
            exit 1
            ;;
    esac
fi
