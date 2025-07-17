#!/bin/bash

# Asset Management System Startup Script
echo "🚀 Starting Asset Management System Server..."
echo "=================================="

# Get the local IP address
LOCAL_IP=$(hostname -I | awk '{print $1}')
PORT=8080

echo "📡 Server will be available at:"
echo "   Local:   http://localhost:$PORT"
echo "   Network: http://$LOCAL_IP:$PORT"
echo ""
echo "🔧 Make sure your database is running!"
echo "=================================="

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start the server
echo "🚀 Starting server..."
npm start
