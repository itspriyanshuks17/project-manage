#!/bin/bash

# Quick Docker Setup Script for Asset Management System
echo "🚀 Setting up Asset Management System with Docker..."
echo "================================================="

# Navigate to docker directory
cd "$(dirname "$0")"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Installing Docker..."
    
    # Install Docker on Ubuntu/Debian
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y docker.io docker-compose
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker $USER
        echo "✅ Docker installed successfully!"
        echo "⚠️  Please log out and log back in for Docker permissions to take effect."
    else
        echo "❌ Automatic Docker installation not supported on this system."
        echo "Please install Docker manually and run this script again."
        exit 1
    fi
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Installing..."
    sudo apt-get install -y docker-compose
fi

echo "✅ Docker setup completed!"
echo ""
echo "🚀 You can now run the Asset Management System with:"
echo "   ./docker-manager.sh"
echo ""
echo "Or use these quick commands:"
echo "   ./docker-manager.sh build    # Build the application"
echo "   ./docker-manager.sh start    # Start in development mode"
echo "   ./docker-manager.sh status   # Check status"
echo "   ./docker-manager.sh stop     # Stop the application"
