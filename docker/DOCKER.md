# Docker Deployment Guide

This guide explains how to containerize and deploy your Asset Management System using Docker.

## 📦 Docker Files Overview

### Core Docker Files
- **`Dockerfile`** - Main container definition
- **`.dockerignore`** - Files to exclude from Docker build
- **`docker-compose.yml`** - Multi-container orchestration
- **`healthcheck.js`** - Container health monitoring
- **`docker-init.sql`** - Database initialization for containers

### Deployment Scripts
- **`docker-deploy.sh`** - Linux/Mac deployment script
- **`docker-deploy.bat`** - Windows deployment script

## 🚀 Quick Start

### Option 1: Using Docker Compose (Recommended)
```bash
# Start the entire stack (app + database)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the stack
docker-compose down
```

### Option 2: Manual Docker Commands
```bash
# Build the image
docker build -t asset-management .

# Run with external MySQL
docker run -d -p 8080:8080 \
  -e DB_HOST=your-mysql-host \
  -e DB_USER=your-username \
  -e DB_PASSWORD=your-password \
  -e DB_NAME=asset_management \
  asset-management
```

## 🏗️ Building and Deploying to Docker Hub

### Linux/Mac
```bash
# Make script executable
chmod +x docker-deploy.sh

# Run deployment script
./docker-deploy.sh
```

### Windows
```cmd
# Run deployment script
docker-deploy.bat
```

### Manual Docker Hub Upload
```bash
# 1. Build the image
docker build -t yourusername/asset-management:1.0.0 .

# 2. Tag for latest
docker tag yourusername/asset-management:1.0.0 yourusername/asset-management:latest

# 3. Login to Docker Hub
docker login

# 4. Push both tags
docker push yourusername/asset-management:1.0.0
docker push yourusername/asset-management:latest
```

## 🔧 Configuration

### Environment Variables

The Docker container supports these environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | `production` | Application environment |
| `PORT` | `8080` | Application port |
| `DB_HOST` | `localhost` | MySQL hostname |
| `DB_USER` | `root` | MySQL username |
| `DB_PASSWORD` | (empty) | MySQL password |
| `DB_NAME` | `asset_management` | Database name |
| `DB_PORT` | `3306` | MySQL port |
| `SESSION_SECRET` | (generated) | Session encryption key |

### Docker Compose Configuration

The `docker-compose.yml` includes:
- **Asset Management App** on port 8080
- **MySQL 8.0 Database** on port 3306
- **Persistent volume** for database data
- **Health checks** for both services
- **Automatic database initialization**

## 🩺 Health Monitoring

### Health Check Endpoint
The application provides a health check at `/health`:

```bash
# Check container health
curl http://localhost:8080/health
```

Response format:
```json
{
  "status": "healthy",
  "database": "connected",
  "timestamp": "2025-07-15T10:30:00.000Z",
  "uptime": 3600
}
```

### Docker Health Check
The container includes automatic health monitoring:
```bash
# View health status
docker ps

# See health check logs
docker inspect --format='{{json .State.Health}}' container-name
```

## 🔐 Security Features

### Container Security
- **Non-root user**: Application runs as `nodejs` user (UID 1001)
- **Minimal attack surface**: Alpine Linux base image
- **Production dependencies only**: No dev dependencies in final image
- **Health monitoring**: Automatic container restart on failure

### Network Security
- **Internal network**: Services communicate via Docker network
- **Port isolation**: Only necessary ports exposed
- **Environment isolation**: Secrets via environment variables

## 📊 Production Deployment

### Using Docker Hub Image
```bash
# Pull and run from Docker Hub
docker run -d \
  --name asset-management \
  -p 8080:8080 \
  -e DB_HOST=your-production-db \
  -e DB_USER=production_user \
  -e DB_PASSWORD=secure_password \
  -e SESSION_SECRET=your-super-secret-key \
  yourusername/asset-management:latest
```

### With Docker Compose in Production
```yaml
# Production docker-compose.yml
version: '3.8'
services:
  asset-management:
    image: yourusername/asset-management:latest
    ports:
      - "80:8080"
    environment:
      - NODE_ENV=production
      - DB_HOST=production-mysql
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - SESSION_SECRET=${SESSION_SECRET}
    restart: unless-stopped
```

## 🐛 Troubleshooting

### Common Issues

**1. Container won't start**
```bash
# Check logs
docker logs container-name

# Check health
docker exec -it container-name node healthcheck.js
```

**2. Database connection issues**
```bash
# Test database connectivity
docker exec -it container-name ping mysql-host

# Check environment variables
docker exec -it container-name env | grep DB_
```

**3. Port conflicts**
```bash
# Find what's using port 8080
lsof -i :8080

# Use different port
docker run -p 8081:8080 asset-management
```

**4. Permission issues**
```bash
# Check file permissions
docker exec -it container-name ls -la /app

# Rebuild with correct permissions
docker build --no-cache -t asset-management .
```

### Debug Commands
```bash
# Enter container shell
docker exec -it container-name sh

# View real-time logs
docker logs -f container-name

# Check resource usage
docker stats container-name

# Inspect container configuration
docker inspect container-name
```

## 📈 Performance Optimization

### Image Size Optimization
- **Multi-stage build**: Separate build and runtime stages
- **Alpine Linux**: Minimal base image (~5MB)
- **Dependency cleanup**: Remove unnecessary packages
- **Layer caching**: Optimize Dockerfile layer order

### Runtime Optimization
- **Resource limits**: Set memory and CPU limits
- **Health checks**: Monitor application health
- **Graceful shutdown**: Handle SIGTERM properly
- **Log management**: Configure log rotation

### Example with Resource Limits
```bash
docker run -d \
  --name asset-management \
  --memory=512m \
  --cpus=1.0 \
  -p 8080:8080 \
  asset-management
```

## 🔄 CI/CD Integration

### GitHub Actions Example
```yaml
name: Build and Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and push Docker image
        run: |
          docker build -t ${{ secrets.DOCKER_USERNAME }}/asset-management .
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker push ${{ secrets.DOCKER_USERNAME }}/asset-management
```

## 📋 Maintenance

### Regular Tasks
```bash
# Update to latest image
docker pull yourusername/asset-management:latest
docker-compose up -d

# Backup database
docker exec mysql mysqldump -u root -p asset_management > backup.sql

# Clean up unused images
docker image prune -a

# View resource usage
docker system df
```

### Monitoring
- Monitor container health via `/health` endpoint
- Set up log aggregation (ELK stack, Splunk)
- Configure alerting for container failures
- Track resource usage and performance metrics

This comprehensive Docker setup ensures your Asset Management System can be easily deployed, scaled, and maintained in any Docker-compatible environment.
