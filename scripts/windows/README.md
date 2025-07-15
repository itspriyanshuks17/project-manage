# Windows Scripts

This directory contains scripts for Windows systems, including batch files and PowerShell scripts.

## 📜 Scripts Overview

### Setup Scripts
- **`setup.bat`** - Basic Windows Command Prompt setup script
- **`setup.ps1`** - Enhanced PowerShell setup script with colored output

### Deployment Scripts
- **`docker-deploy.bat`** - Docker build and Docker Hub deployment for Windows

## 🚀 Usage

### Initial Setup

**Option 1: Basic Batch File**
```cmd
scripts\windows\setup.bat
```

**Option 2: PowerShell (Recommended)**
```powershell
# If execution policy issues occur:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run the setup
.\scripts\windows\setup.ps1

# Or with parameters
.\scripts\windows\setup.ps1 -SkipPrerequisites
```

### Docker Deployment
```cmd
scripts\windows\docker-deploy.bat
```

## 🔧 Features

### Setup Scripts

**setup.bat (Basic)**
- Command Prompt compatibility
- Basic error checking
- Simple colored output (limited)
- Prerequisites validation

**setup.ps1 (Enhanced)**
- **Rich Colored Output**: Full color support with success/error/warning indicators
- **Advanced Error Handling**: Try-catch blocks with detailed error reporting
- **Interactive Experience**: User prompts and confirmation dialogs
- **Version Checking**: Displays installed Node.js and npm versions
- **File Validation**: Checks for required files before execution
- **Optional Features**: Skip prerequisites, immediate application startup

### Deployment Script

**docker-deploy.bat**
- Docker image building and tagging
- Optional local container testing
- Automated Docker Hub authentication
- Multi-tag pushing (version + latest)
- Windows-specific error handling

## 📋 Prerequisites

### Required Software
- **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
- **MySQL Server** - [Download](https://dev.mysql.com/downloads/mysql/)
- **Docker Desktop** (for deployment) - [Download](https://www.docker.com/products/docker-desktop)

### PowerShell Requirements
- **PowerShell 5.1+** (included in Windows 10+)
- **Execution Policy**: May need to be set to RemoteSigned

## 🐛 Windows-Specific Troubleshooting

### Common Issues

**1. PowerShell Execution Policy**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**2. MySQL PATH Issues**
- Add MySQL bin directory to system PATH
- Default location: `C:\Program Files\MySQL\MySQL Server 8.0\bin`

**3. Port Conflicts**
```cmd
# Find process using port
netstat -ano | findstr :8080

# Kill process (replace PID)
taskkill /PID <PID> /F
```

**4. Docker Desktop Issues**
- Ensure Docker Desktop is running
- Check for Windows container vs Linux container mode
- Verify Windows virtualization features are enabled

## 🎨 Script Features

### Enhanced PowerShell Experience
- **Progress Indicators**: Visual feedback during long operations
- **Color Coding**: Green (success), Red (error), Yellow (warning), Blue (info)
- **Error Recovery**: Detailed error messages with suggested solutions
- **Resource Monitoring**: Optional system resource checking
- **Log Management**: Comprehensive logging with timestamps

### Cross-Platform Compatibility
- **Consistent Behavior**: Same functionality as Linux scripts
- **Windows Optimizations**: Handles Windows-specific quirks
- **Path Handling**: Proper Windows path resolution
- **Service Management**: Integration with Windows Services

## 🔗 Related Files
- **Linux Scripts**: `../linux/`
- **Docker Configuration**: `../../docker/`
- **Project Root**: `../../`

## 📝 Usage Examples

### Complete Setup Process
```powershell
# 1. Open PowerShell as Administrator (optional but recommended)
# 2. Navigate to project directory
cd path\to\project-manage

# 3. Set execution policy (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 4. Run setup
.\scripts\windows\setup.ps1

# 5. Start application
npm run dev
```

### Docker Deployment Process
```cmd
# 1. Ensure Docker Desktop is running
# 2. Open Command Prompt in project directory
cd path\to\project-manage

# 3. Run deployment script
scripts\windows\docker-deploy.bat

# 4. Follow prompts for Docker Hub credentials
```

All scripts are designed to provide the same functionality as their Linux counterparts while being optimized for the Windows environment.
