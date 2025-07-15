# Docker Configuration Files

This directory contains all Docker-related configuration files for the Asset Management System.

## 📦 Files Overview

### Core Docker Files
- **`Dockerfile`** - Main container definition with Node.js Alpine base
- **`.dockerignore`** - Files to exclude from Docker build context
- **`docker-compose.yml`** - Multi-container orchestration (app + MySQL)
- **`healthcheck.js`** - Container health monitoring script
- **`docker-init.sql`** - Database initialization and sample data

### Documentation
- **`DOCKER.md`** - Comprehensive Docker deployment guide

## 🚀 Quick Usage

### Using Docker Compose (from project root)
```bash
# Start the entire stack
cd docker && docker-compose up -d

# View logs
docker-compose logs -f

# Stop the stack
docker-compose down
```

### Building Image Manually (from project root)
```bash
# Build the image
docker build -f docker/Dockerfile -t asset-management .

# Run the container
docker run -d -p 8080:8080 asset-management
```

## 🔧 Configuration

The Docker setup includes:
- **Node.js 18 Alpine** base image for minimal size
- **Non-root user** (nodejs:1001) for security
- **Health checks** for monitoring
- **Multi-stage build** optimization
- **Persistent MySQL storage**
- **Automatic database initialization**

## 📁 File Structure
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
