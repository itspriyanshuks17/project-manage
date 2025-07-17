@echo off
setlocal enabledelayedexpansion

REM Asset Management System Setup Script for Windows
echo.
echo Asset Management System Setup (Windows)
echo ==========================================
echo.

REM Function to print colored output (Windows doesn't support colors easily, so using symbols)
REM Check if Node.js is installed
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo X Node.js is not installed. Please install Node.js version 14 or higher.
    echo   Download from: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if npm is installed
where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo X npm is not installed. Please install npm.
    pause
    exit /b 1
)

REM Check if MySQL is installed
where mysql >nul 2>nul
if %errorlevel% neq 0 (
    echo X MySQL is not installed. Please install MySQL Server.
    echo   Download from: https://dev.mysql.com/downloads/mysql/
    pause
    exit /b 1
)

echo + All prerequisites are installed
echo.

REM Install npm dependencies
echo i Installing npm dependencies...
call npm install
if %errorlevel% neq 0 (
    echo X Failed to install dependencies
    pause
    exit /b 1
)
echo + Dependencies installed successfully
echo.

REM Database setup
echo i Setting up database...
echo Please enter your MySQL root password when prompted.
echo.

REM Create database
echo Creating database 'asset_management'...
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS asset_management;"
if %errorlevel% neq 0 (
    echo X Failed to create database. Please check your MySQL credentials.
    pause
    exit /b 1
)
echo + Database 'asset_management' created/verified
echo.

REM Import database schema
echo i Importing database schema...
mysql -u root -p asset_management < database.sql
if %errorlevel% neq 0 (
    echo X Failed to import database schema
    pause
    exit /b 1
)
echo + Database schema imported successfully
echo.

REM Create default users
echo i Creating default users...
node create-users.js
if %errorlevel% neq 0 (
    echo X Failed to create default users
    pause
    exit /b 1
)
echo + Default users created successfully
echo.

REM Success message
echo.
echo Setup completed successfully!
echo.
echo Next steps:
echo 1. Start the application: npm run dev
echo 2. Open your browser: http://localhost:8080
echo 3. Login with these credentials:
echo.
echo    Admin:    admin / admin123
echo    Manager:  manager1 / manager123
echo    Employee: employee1 / employee123
echo.
echo Happy coding!
echo.
pause
