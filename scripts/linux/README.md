# Linux/Mac Scripts

This directory contains shell scripts for Linux and macOS systems.

## 📜 Scripts Overview

### Setup Scripts
- **`setup.sh`** - Complete development environment setup
  - Installs npm dependencies
  - Creates MySQL database and schema
  - Creates default users
  - Provides colored output and error handling

### Deployment Scripts
- **`docker-deploy.sh`** - Docker build and Docker Hub deployment
  - Builds optimized Docker images
  - Optional local testing
  - Automated Docker Hub publishing
  - Comprehensive error handling

## 🚀 Usage

### Initial Setup
```bash
# Make scripts executable
chmod +x scripts/linux/*.sh

# Run complete setup
./scripts/linux/setup.sh
```

### Docker Deployment
```bash
# Deploy to Docker Hub
./scripts/linux/docker-deploy.sh
```

## 🔧 Features

### Enhanced User Experience
- **Colored Output**: Green for success, red for errors, blue for info
- **Error Handling**: Comprehensive error checking and helpful messages
- **Prerequisites Check**: Validates Node.js, npm, and MySQL installation
- **Interactive Prompts**: User-friendly input for configuration

### Docker Integration
- **Automated Building**: Builds Docker images with proper tagging
- **Local Testing**: Optional container testing before deployment
- **Multi-tag Support**: Creates both version and latest tags
- **Docker Hub Integration**: Automated login and push to repository

## 📋 Prerequisites

Before running these scripts, ensure you have:
- **Node.js** (v14 or higher)
- **npm** package manager
- **MySQL Server** (for setup.sh)
- **Docker** (for docker-deploy.sh)
- **Docker Hub account** (for deployment)

## 🔗 Related Files
- **Docker Configuration**: `../docker/`
- **Windows Scripts**: `../windows/`
- **Project Root**: `../../`

Run scripts from the project root directory for proper path resolution.
