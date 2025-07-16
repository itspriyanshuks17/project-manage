#!/bin/bash

# Simple Docker Deployment Script
echo "🚀 Asset Management System - Docker Deployment"
echo "=============================================="

# Navigate to docker directory
cd "$(dirname "$0")"

# Check if we need sudo
if ! docker info &> /dev/null; then
    echo "ℹ️  Using sudo for Docker commands (logout/login to avoid this)"
    SUDO_CMD="sudo"
else
    SUDO_CMD=""
fi

echo "📦 Building Docker image..."
$SUDO_CMD /usr/local/bin/docker-compose build

echo "🚀 Starting containers..."
$SUDO_CMD /usr/local/bin/docker-compose up -d

echo "⏳ Waiting for containers to be ready..."
sleep 10

echo "🔍 Checking container status..."
$SUDO_CMD docker ps

echo ""
echo "✅ Deployment completed!"
echo "🌐 Access your application at:"
echo "   - Local: http://localhost:8080"
echo "   - Health Check: http://localhost:8080/health"
echo ""
echo "📊 To view logs: $SUDO_CMD docker logs asset-app"
echo "🛑 To stop: $SUDO_CMD /usr/local/bin/docker-compose down"

# Get IP address for network access
LOCAL_IP=$(hostname -I | awk '{print $1}')
echo "🌍 Network access: http://$LOCAL_IP:8080"
