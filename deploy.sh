#!/bin/bash

# Quick Docker Deployment Wrapper
# This script calls the docker deployment from the docker directory

echo "🚀 Asset Management System - Docker Deployment"
echo "=============================================="

# Navigate to docker directory and run deployment
cd "$(dirname "$0")/docker"
./quick-deploy.sh

echo ""
echo "📁 All Docker files are now organized in the 'docker' directory"
echo "💡 You can also run: cd docker && ./quick-deploy.sh"
