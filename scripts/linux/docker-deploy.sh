#!/bin/bash

# Docker Build and Deploy Script for Asset Management System
# This script builds the Docker image and pushes it to Docker Hub

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Configuration
DOCKER_USERNAME=""
IMAGE_NAME="asset-management-system"
VERSION="1.0.0"
LATEST_TAG="latest"

echo "🐳 Docker Build and Deploy Script"
echo "================================="
echo ""

# Get Docker Hub username
if [ -z "$DOCKER_USERNAME" ]; then
    echo "Please enter your Docker Hub username:"
    read -r DOCKER_USERNAME
    
    if [ -z "$DOCKER_USERNAME" ]; then
        print_error "Docker Hub username is required"
        exit 1
    fi
fi

FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME"

print_info "Building Docker image: $FULL_IMAGE_NAME"
echo ""

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed or not in PATH"
    exit 1
fi

if ! docker info &> /dev/null; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

print_status "Docker is installed and running"

# Build the Docker image
print_info "Building Docker image..."
if docker build -f docker/Dockerfile -t "$FULL_IMAGE_NAME:$VERSION" -t "$FULL_IMAGE_NAME:$LATEST_TAG" .; then
    print_status "Docker image built successfully"
else
    print_error "Failed to build Docker image"
    exit 1
fi

# Display image info
echo ""
print_info "Image details:"
docker images "$FULL_IMAGE_NAME" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

# Ask if user wants to test the image locally
echo ""
echo "Would you like to test the image locally before pushing? (y/n):"
read -r TEST_LOCAL

if [ "$TEST_LOCAL" = "y" ] || [ "$TEST_LOCAL" = "Y" ]; then
    print_info "Starting test container..."
    
    # Stop any existing test container
    docker stop asset-management-test 2>/dev/null || true
    docker rm asset-management-test 2>/dev/null || true
    
    # Run test container
    if docker run -d --name asset-management-test -p 8081:8080 "$FULL_IMAGE_NAME:$LATEST_TAG"; then
        print_status "Test container started on http://localhost:8081"
        print_warning "Press Enter after testing to continue with deployment..."
        read -r
        
        # Stop and remove test container
        docker stop asset-management-test
        docker rm asset-management-test
        print_status "Test container cleaned up"
    else
        print_error "Failed to start test container"
        exit 1
    fi
fi

# Login to Docker Hub
echo ""
print_info "Logging in to Docker Hub..."
if docker login; then
    print_status "Successfully logged in to Docker Hub"
else
    print_error "Failed to login to Docker Hub"
    exit 1
fi

# Push the image
echo ""
print_info "Pushing image to Docker Hub..."

# Push version tag
if docker push "$FULL_IMAGE_NAME:$VERSION"; then
    print_status "Successfully pushed $FULL_IMAGE_NAME:$VERSION"
else
    print_error "Failed to push version tag"
    exit 1
fi

# Push latest tag
if docker push "$FULL_IMAGE_NAME:$LATEST_TAG"; then
    print_status "Successfully pushed $FULL_IMAGE_NAME:$LATEST_TAG"
else
    print_error "Failed to push latest tag"
    exit 1
fi

# Success message
echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "Your Docker image is now available at:"
echo "  https://hub.docker.com/r/$DOCKER_USERNAME/$IMAGE_NAME"
echo ""
echo "To run your image anywhere:"
echo "  docker run -d -p 8080:8080 $FULL_IMAGE_NAME:$LATEST_TAG"
echo ""
echo "To run with Docker Compose:"
echo "  docker-compose up -d"
echo ""
echo "Image tags pushed:"
echo "  • $FULL_IMAGE_NAME:$VERSION"
echo "  • $FULL_IMAGE_NAME:$LATEST_TAG"
echo ""
print_status "Deployment complete! 🚀"
