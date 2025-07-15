# Setup and Deployment Scripts

This directory contains platform-specific scripts for setting up and deploying the Asset Management System.

## 📁 Directory Structure

```
scripts/
├── linux/                 # Linux and macOS scripts
│   ├── setup.sh           # Development environment setup
│   ├── docker-deploy.sh   # Docker Hub deployment
│   └── README.md          # Linux-specific documentation
├── windows/               # Windows scripts
│   ├── setup.bat          # Basic Windows setup (Command Prompt)
│   ├── setup.ps1          # Enhanced PowerShell setup
│   ├── docker-deploy.bat  # Windows Docker deployment
│   └── README.md          # Windows-specific documentation
└── README.md              # This file
```

## 🚀 Quick Start

### Choose Your Platform

**Linux/macOS Users:**
```bash
# Make executable and run
chmod +x scripts/linux/*.sh
./scripts/linux/setup.sh
```

**Windows Users (Command Prompt):**
```cmd
scripts\windows\setup.bat
```

**Windows Users (PowerShell - Recommended):**
```powershell
.\scripts\windows\setup.ps1
```

## 🔧 Script Functions

### Setup Scripts
All setup scripts perform the same core functions:
- ✅ Check prerequisites (Node.js, npm, MySQL)
- ✅ Install npm dependencies
- ✅ Create and configure MySQL database
- ✅ Import database schema
- ✅ Create default users with hashed passwords
- ✅ Verify installation

### Deployment Scripts
All deployment scripts provide:
- 🐳 Docker image building with optimization
- 🏷️ Multi-tag support (version + latest)
- 🧪 Optional local testing
- 🚀 Automated Docker Hub deployment
- 📊 Deployment verification

## 🎯 Platform-Specific Features

### Linux/macOS (Bash)
- **Colored Terminal Output**: Full ANSI color support
- **Signal Handling**: Proper SIGTERM/SIGINT handling
- **Package Manager Integration**: Works with system package managers
- **Service Integration**: Can integrate with systemd services

### Windows (Batch)
- **Broad Compatibility**: Works on all Windows versions
- **Simple Interface**: Basic but reliable functionality
- **Limited Colors**: Basic output formatting
- **CMD Integration**: Full Command Prompt support

### Windows (PowerShell)
- **Rich User Experience**: Full color support and progress indicators
- **Advanced Error Handling**: Try-catch blocks with detailed messages
- **Object-Oriented**: PowerShell object pipeline support
- **Windows Integration**: Native Windows features and services

## 📋 Prerequisites by Platform

### All Platforms
- Node.js (v14 or higher)
- npm package manager
- MySQL Server
- Docker (for deployment scripts)

### Platform-Specific Requirements

**Linux/macOS:**
- Bash shell (usually included)
- curl or wget (for downloads)
- Basic Unix utilities

**Windows:**
- Windows 10 or higher (recommended)
- PowerShell 5.1+ (for .ps1 scripts)
- Windows Subsystem for Linux (optional)

## 🔗 Integration with Project

### File Relationships
```
project-manage/
├── docker/                # Docker configuration files
├── scripts/               # This directory
│   ├── linux/            # Unix/Linux scripts
│   └── windows/          # Windows scripts
├── app.js                # Main application
├── package.json          # Dependencies
├── database.sql          # Database schema
└── create-users.js       # User creation script
```

### Execution Context
All scripts should be run from the **project root directory** to ensure proper path resolution:

```bash
# Correct - from project root
./scripts/linux/setup.sh

# Incorrect - from scripts directory
cd scripts/linux && ./setup.sh  # May cause path issues
```

## 🚦 Execution Order

For new development setup:
1. **Choose your platform scripts**
2. **Run setup script first** (creates environment)
3. **Test the application** (`npm run dev`)
4. **Run deployment script** (if deploying to Docker Hub)

### Example Workflow

**Linux/macOS:**
```bash
# 1. Setup development environment
./scripts/linux/setup.sh

# 2. Test application
npm run dev

# 3. Deploy to Docker Hub (optional)
./scripts/linux/docker-deploy.sh
```

**Windows PowerShell:**
```powershell
# 1. Setup development environment
.\scripts\windows\setup.ps1

# 2. Test application
npm run dev

# 3. Deploy to Docker Hub (optional)
.\scripts\windows\docker-deploy.bat
```

## 🔄 Maintenance and Updates

### Keeping Scripts Updated
- Scripts are version-controlled with the project
- Updates should maintain backward compatibility
- Platform-specific optimizations are encouraged
- Test scripts on target platforms before releasing

### Contributing Script Improvements
- Follow platform conventions (Unix vs Windows)
- Maintain consistent functionality across platforms
- Add comprehensive error handling
- Update documentation when adding features

## 📞 Support

For platform-specific issues:
- **Linux/macOS**: See `linux/README.md`
- **Windows**: See `windows/README.md`
- **Docker**: See `../docker/DOCKER.md`
- **General**: See project root `README.md`

These scripts provide a consistent, reliable way to set up and deploy the Asset Management System across different operating systems and environments.
