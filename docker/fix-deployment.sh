#!/bin/bash

# Fix and restart the Docker deployment
echo "🔧 Fixing Docker deployment issues..."

# Navigate to docker directory
cd "$(dirname "$0")"

# Stop current containers
sudo /usr/local/bin/docker-compose down

# Wait a moment
sleep 5

# Rebuild with better error handling
echo "🔨 Rebuilding with improved database connection handling..."
sudo /usr/local/bin/docker-compose build --no-cache

# Start containers
echo "🚀 Starting containers..."
sudo /usr/local/bin/docker-compose up -d

# Wait for database to be ready
echo "⏳ Waiting for database to initialize..."
sleep 15

# Check health
echo "🔍 Checking health..."
curl -s http://localhost:8080/health

echo ""
echo "✅ Fixed deployment completed!"
echo "🌐 Access: http://localhost:8080"
