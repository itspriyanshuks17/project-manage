# Asset Management System Setup Script for Windows PowerShell
# PowerShell version provides better error handling and colored output

param(
    [switch]$SkipPrerequisites = $false
)

# Set execution policy for current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Clear screen and show header
Clear-Host
Write-Host ""
Write-Host "Asset Management System Setup (PowerShell)" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Function to print colored output
function Write-Success {
    param([string]$Message)
    Write-Host "+ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "! $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "x $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "> $Message" -ForegroundColor Blue
}

function Test-Command {
    param([string]$CommandName)
    $command = Get-Command $CommandName -ErrorAction SilentlyContinue
    return $command -ne $null
}

# Check prerequisites unless skipped
if (-not $SkipPrerequisites) {
    Write-Info "Checking prerequisites..."
    
    # Check if Node.js is installed
    if (-not (Test-Command "node")) {
        Write-Error-Custom "Node.js is not installed. Please install Node.js version 14 or higher."
        Write-Host "   Download from: https://nodejs.org/" -ForegroundColor Gray
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    # Check Node.js version
    $nodeVersion = node --version
    Write-Host "   Node.js version: $nodeVersion" -ForegroundColor Gray
    
    # Check if npm is installed
    if (-not (Test-Command "npm")) {
        Write-Error-Custom "npm is not installed. Please install npm."
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    # Check npm version
    $npmVersion = npm --version
    Write-Host "   npm version: $npmVersion" -ForegroundColor Gray
    
    # Check if MySQL is installed
    if (-not (Test-Command "mysql")) {
        Write-Error-Custom "MySQL is not installed. Please install MySQL Server."
        Write-Host "   Download from: https://dev.mysql.com/downloads/mysql/" -ForegroundColor Gray
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Success "All prerequisites are installed"
    Write-Host ""
}

# Install npm dependencies
Write-Info "Installing npm dependencies..."
try {
    $installResult = npm install 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Dependencies installed successfully"
    } else {
        Write-Error-Custom "Failed to install dependencies"
        Write-Host $installResult -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} catch {
    Write-Error-Custom "Failed to install dependencies: $($_.Exception.Message)"
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

# Database setup
Write-Info "Setting up database..."
Write-Host "Please enter your MySQL root password when prompted." -ForegroundColor Yellow
Write-Host ""

# Create database
Write-Info "Creating database 'asset_management'..."
try {
    $createDbResult = mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS asset_management;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Database 'asset_management' created/verified"
    } else {
        Write-Error-Custom "Failed to create database. Please check your MySQL credentials."
        Write-Host $createDbResult -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} catch {
    Write-Error-Custom "Failed to create database: $($_.Exception.Message)"
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

# Import database schema
Write-Info "Importing database schema..."
try {
    # Check if database.sql exists
    if (-not (Test-Path "database.sql")) {
        Write-Error-Custom "database.sql file not found in current directory"
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    $importResult = mysql -u root -p asset_management -e "source database.sql" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Database schema imported successfully"
    } else {
        # Try alternative method for Windows
        Get-Content "database.sql" | mysql -u root -p asset_management
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Database schema imported successfully"
        } else {
            Write-Error-Custom "Failed to import database schema"
            Write-Host $importResult -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
} catch {
    Write-Error-Custom "Failed to import database schema: $($_.Exception.Message)"
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

# Create default users
Write-Info "Creating default users..."
try {
    # Check if create-users.js exists
    if (-not (Test-Path "create-users.js")) {
        Write-Error-Custom "create-users.js file not found in current directory"
        Read-Host "Press Enter to exit"
        Write-Error-Custom "create-users.js file not found in current directory"
        exit 1
    }
    
    $createUsersResult = node create-users.js 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Default users created successfully"
    } else {
        Write-Error-Custom "Failed to create default users"
        Write-Host $createUsersResult -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Error-Custom "Failed to create default users: $($_.Exception.Message)"
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

# Verify setup
Write-Info "Verifying setup..."
if (Test-Path "test-setup.js") {
    try {
        node test-setup.js
        Write-Success "Setup verification completed"
    } catch {
        Write-Warning "Setup verification failed, but continuing..."
    }
} else {
    Write-Warning "test-setup.js not found, skipping verification"
}
Write-Host ""

# Success message
Write-Host ""
Write-Host "Setup completed successfully!" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Start the application: " -NoNewline; Write-Host "npm run dev" -ForegroundColor Yellow
Write-Host "2. Open your browser: " -NoNewline; Write-Host "http://localhost:8080" -ForegroundColor Yellow
Write-Host "3. Login with these credentials:" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Admin:    " -NoNewline; Write-Host "admin / admin123" -ForegroundColor Green
Write-Host "   Manager:  " -NoNewline; Write-Host "manager1 / manager123" -ForegroundColor Green  
Write-Host "   Employee: " -NoNewline; Write-Host "employee1 / employee123" -ForegroundColor Green
Write-Host ""
Write-Host "Happy coding!" -ForegroundColor Magenta
Write-Host ""

# Optional: Ask if user wants to start the application now
$startNow = Read-Host "Would you like to start the application now? (y/n)"
if ($startNow -eq "y" -or $startNow -eq "Y" -or $startNow -eq "yes") {
    Write-Host ""
    Write-Info "Starting the application..."
    npm run dev
}

Read-Host "Press Enter to exit"
