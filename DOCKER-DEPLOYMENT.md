# 🚀 Asset Management System - Docker Deployment

This guide will help you deploy the Asset Management System using Docker, making it accessible from any device on your network.

## 🎯 Quick Start

### Option 1: Interactive Setup (Recommended)
```bash
# Make scripts executable
chmod +x docker-manager.sh setup-docker.sh

# Run the interactive Docker manager
./docker-manager.sh
```

### Option 2: Command Line
```bash
# Build and start the application
./docker-manager.sh build
./docker-manager.sh start

# Check status
./docker-manager.sh status

# Get network IP for external access
./docker-manager.sh ip
```

## 📋 Prerequisites

### Install Docker (if not already installed)
```bash
# Run the setup script
./setup-docker.sh
```

Or install manually:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER
```

## 🔧 Configuration

### Environment Variables
The system uses `.env.docker` for Docker-specific configuration:

```env
# Database Configuration
DB_HOST=mysql
DB_USER=sigma
DB_PASSWORD=sigma
DB_NAME=asset_management
DB_PORT=3306

# Application Configuration
PORT=8080
NODE_ENV=production
SESSION_SECRET=your-secure-session-secret
```

### Custom Configuration
1. Copy `.env.docker` to `.env.docker.local`
2. Modify the values as needed
3. The system will automatically use your local configuration

## 🚀 Deployment Options

### Development Mode
```bash
# Start with development settings
./docker-manager.sh start

# Access at: http://localhost:8080
# Database at: localhost:3307
```

### Production Mode
```bash
# Start with production settings
./docker-manager.sh start-prod

# Access at: http://localhost (port 80)
# More secure database configuration
```

## 🌐 Network Access

### Local Network Access
```bash
# Get your machine's IP address
./docker-manager.sh ip

# Users can access via: http://YOUR_IP:8080
```

### Port Configuration
- **Development**: `localhost:8080`
- **Production**: `localhost:80` (standard web port)
- **Database**: `localhost:3307` (development only)

## 📊 Management Commands

### Essential Commands
```bash
# Build application
./docker-manager.sh build

# Start application
./docker-manager.sh start

# Stop application
./docker-manager.sh stop

# Restart application
./docker-manager.sh restart

# View logs
./docker-manager.sh logs

# Check status
./docker-manager.sh status

# Backup database
./docker-manager.sh backup

# Clean up everything
./docker-manager.sh cleanup
```

### Manual Docker Commands
```bash
# Build and start
docker-compose up -d

# Stop
docker-compose down

# View logs
docker-compose logs -f

# Production mode
docker-compose -f docker-compose.prod.yml up -d
```

## 🗄️ Database Management

### Initial Setup
The database is automatically initialized with:
- Database schema (`database.sql`)
- Initial data (`docker/docker-init.sql`)

### Backup Database
```bash
# Create backup
./docker-manager.sh backup

# Manual backup
docker exec asset-db mysqldump -u sigma -psigma asset_management > backup.sql
```

### Restore Database
```bash
# Restore from backup
docker exec -i asset-db mysql -u sigma -psigma asset_management < backup.sql
```

## 🔒 Security Considerations

### Production Security
1. **Change default passwords** in `.env.docker`
2. **Use strong session secrets**
3. **Configure SSL/TLS** for HTTPS
4. **Firewall configuration** for external access
5. **Regular security updates**

### Network Security
```bash
# Allow specific ports through firewall
sudo ufw allow 8080/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

## 🐛 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using the port
sudo lsof -i :8080

# Stop other services or change port in docker-compose.yml
```

#### Database Connection Issues
```bash
# Check database logs
docker logs asset-db

# Restart database
docker restart asset-db
```

#### Application Won't Start
```bash
# Check application logs
docker logs asset-app

# Rebuild image
./docker-manager.sh build
```

### Health Checks
```bash
# Check application health
curl http://localhost:8080/health

# Check database health
docker exec asset-db mysqladmin ping -h localhost -u sigma -psigma
```

## 📱 Mobile/External Access

### Same Network Access
1. Get your machine's IP: `./docker-manager.sh ip`
2. Share the URL: `http://YOUR_IP:8080`
3. Users can access from phones/tablets on the same WiFi

### Internet Access (Advanced)
1. Configure port forwarding on your router
2. Use a service like ngrok for temporary access
3. Deploy to cloud services (AWS, Azure, etc.)

## 🔄 Updates and Maintenance

### Update Application
```bash
# Pull latest code
git pull origin main

# Rebuild and restart
./docker-manager.sh build
./docker-manager.sh restart
```

### Database Maintenance
```bash
# Backup before maintenance
./docker-manager.sh backup

# Update database schema if needed
docker exec -i asset-db mysql -u sigma -psigma asset_management < new_schema.sql
```

## 📞 Support

### Logs Location
- Application logs: `docker logs asset-app`
- Database logs: `docker logs asset-db`
- Docker Compose logs: `docker-compose logs`

### Performance Monitoring
```bash
# Check container resource usage
docker stats asset-app asset-db
```

## 🎉 Success!

Once running, your Asset Management System will be accessible to:
- **You**: `http://localhost:8080`
- **Local network users**: `http://YOUR_IP:8080`
- **Mobile devices**: Same network access

The system includes three user roles:
- **Admin**: Full system access
- **Manager**: Approve/reject requests
- **Employee**: Submit requests and view records

Happy managing! 🚀
