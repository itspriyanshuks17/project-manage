# Docker Configuration Files

This directory contains all Docker-related configuration files for the Asset Management System.

## 📦 Files Overview

### Core Docker Files
- **`Dockerfile`** - Main container definition with Node.js Alpine base
- **`.dockerignore`** - Files to exclude from Docker build context
- **`docker-compose.yml`** - Multi-container orchestration (app + MySQL)
- **`docker-compose.prod.yml`** - Production configuration
- **`.env.docker`** - Docker-specific environment variables
- **`healthcheck.js`** - Container health monitoring script
- **`docker-init.sql`** - Database initialization and sample data

### Management Scripts
- **`docker-manager.sh`** - Interactive Docker management
- **`quick-deploy.sh`** - Quick deployment script
- **`fix-deployment.sh`** - Fix common deployment issues
- **`setup-docker.sh`** - Initial Docker setup

### Documentation
- **`DOCKER.md`** - Comprehensive Docker deployment guide

## 🚀 Quick Usage

### Using Docker Compose (from docker directory)
```bash
# Navigate to docker directory
cd docker

# Start the entire stack
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the stack
docker-compose down
```

### Using Management Scripts
```bash
# From project root
./deploy.sh                # Quick deployment
./docker-manager.sh         # Interactive management

# From docker directory
./quick-deploy.sh          # Quick deployment
./docker-manager.sh        # Interactive management
./fix-deployment.sh        # Fix issues
```

## 🔧 Configuration

The Docker setup includes:
- **Node.js 20 Alpine** base image for minimal size
- **Non-root user** (nodejs:1001) for security
- **Health checks** for monitoring
- **Multi-stage build** optimization
- **Persistent MySQL storage**
- **Automatic database initialization**

## 📁 Project Structure
```
docker/
├── Dockerfile              # Container definition
├── .dockerignore           # Build context exclusions
├── docker-compose.yml      # Multi-container setup
├── healthcheck.js          # Health monitoring
├── docker-init.sql         # Database initialization
├── DOCKER.md              # Comprehensive documentation
└── README.md              # This file
```

## 🔗 Related Scripts
- **Linux/Mac Deployment**: `../scripts/linux/docker-deploy.sh`
- **Windows Deployment**: `../scripts/windows/docker-deploy.bat`

For detailed deployment instructions, see `DOCKER.md`.
