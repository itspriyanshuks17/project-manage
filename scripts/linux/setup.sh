#!/bin/bash

# Asset Management System Setup Script
echo "🚀 Asset Management System Setup"
echo "================================="

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

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js version 14 or higher."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm."
    exit 1
fi

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    print_error "MySQL is not installed. Please install MySQL Server."
    exit 1
fi

print_status "All prerequisites are installed"

# Install npm dependencies
echo ""
print_info "Installing npm dependencies..."
if npm install; then
    print_status "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Database setup
echo ""
print_info "Setting up database..."
echo "Please enter your MySQL root password when prompted."

# Create database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS asset_management;" 2>/dev/null

if [ $? -eq 0 ]; then
    print_status "Database 'asset_management' created/verified"
else
    print_error "Failed to create database. Please check your MySQL credentials."
    exit 1
fi

# Import database schema
echo ""
print_info "Importing database schema..."
mysql -u root -p asset_management < database.sql

if [ $? -eq 0 ]; then
    print_status "Database schema imported successfully"
else
    print_error "Failed to import database schema"
    exit 1
fi

# Create default users
echo ""
print_info "Creating default users..."
if node create-users.js; then
    print_status "Default users created successfully"
else
    print_error "Failed to create default users"
    exit 1
fi

# Success message
echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Start the application: npm run dev"
echo "2. Open your browser: http://localhost:3000"
echo "3. Login with these credentials:"
echo ""
echo "   Admin:    admin / admin123"
echo "   Manager:  manager1 / manager123"
echo "   Employee: employee1 / employee123"
echo ""
echo "Happy coding! 🚀"
