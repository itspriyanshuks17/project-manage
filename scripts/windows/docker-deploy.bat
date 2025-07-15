@echo off
setlocal enabledelayedexpansion

REM Docker Build and Deploy Script for Windows
echo.
echo 🐳 Docker Build and Deploy Script (Windows)
echo ==========================================
echo.

REM Configuration
set DOCKER_USERNAME=
set IMAGE_NAME=asset-management-system
set VERSION=1.0.0
set LATEST_TAG=latest

REM Get Docker Hub username
if "%DOCKER_USERNAME%"=="" (
    echo Please enter your Docker Hub username:
    set /p DOCKER_USERNAME=
    
    if "!DOCKER_USERNAME!"=="" (
        echo ✗ Docker Hub username is required
        pause
        exit /b 1
    )
)

set FULL_IMAGE_NAME=%DOCKER_USERNAME%/%IMAGE_NAME%

echo ℹ Building Docker image: %FULL_IMAGE_NAME%
echo.

REM Check if Docker is installed
where docker >nul 2>nul
if %errorlevel% neq 0 (
    echo ✗ Docker is not installed or not in PATH
    pause
    exit /b 1
)

REM Check if Docker is running
docker info >nul 2>nul
if %errorlevel% neq 0 (
    echo ✗ Docker is not running. Please start Docker and try again.
    pause
    exit /b 1
)

echo ✓ Docker is installed and running

REM Build the Docker image
echo ℹ Building Docker image...
docker build -f docker/Dockerfile -t "%FULL_IMAGE_NAME%:%VERSION%" -t "%FULL_IMAGE_NAME%:%LATEST_TAG%" .
if %errorlevel% neq 0 (
    echo ✗ Failed to build Docker image
    pause
    exit /b 1
)
echo ✓ Docker image built successfully

REM Display image info
echo.
echo ℹ Image details:
docker images "%FULL_IMAGE_NAME%" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

REM Ask if user wants to test locally
echo.
echo Would you like to test the image locally before pushing? (y/n):
set /p TEST_LOCAL=

if /i "%TEST_LOCAL%"=="y" (
    echo ℹ Starting test container...
    
    REM Stop any existing test container
    docker stop asset-management-test >nul 2>nul
    docker rm asset-management-test >nul 2>nul
    
    REM Run test container
    docker run -d --name asset-management-test -p 8081:8080 "%FULL_IMAGE_NAME%:%LATEST_TAG%"
    if %errorlevel% neq 0 (
        echo ✗ Failed to start test container
        pause
        exit /b 1
    )
    
    echo ✓ Test container started on http://localhost:8081
    echo ⚠ Press Enter after testing to continue with deployment...
    pause
    
    REM Stop and remove test container
    docker stop asset-management-test
    docker rm asset-management-test
    echo ✓ Test container cleaned up
)

REM Login to Docker Hub
echo.
echo ℹ Logging in to Docker Hub...
docker login
if %errorlevel% neq 0 (
    echo ✗ Failed to login to Docker Hub
    pause
    exit /b 1
)
echo ✓ Successfully logged in to Docker Hub

REM Push the image
echo.
echo ℹ Pushing image to Docker Hub...

REM Push version tag
docker push "%FULL_IMAGE_NAME%:%VERSION%"
if %errorlevel% neq 0 (
    echo ✗ Failed to push version tag
    pause
    exit /b 1
)
echo ✓ Successfully pushed %FULL_IMAGE_NAME%:%VERSION%

REM Push latest tag
docker push "%FULL_IMAGE_NAME%:%LATEST_TAG%"
if %errorlevel% neq 0 (
    echo ✗ Failed to push latest tag
    pause
    exit /b 1
)
echo ✓ Successfully pushed %FULL_IMAGE_NAME%:%LATEST_TAG%

REM Success message
echo.
echo 🎉 Deployment completed successfully!
echo.
echo Your Docker image is now available at:
echo   https://hub.docker.com/r/%DOCKER_USERNAME%/%IMAGE_NAME%
echo.
echo To run your image anywhere:
echo   docker run -d -p 8080:8080 %FULL_IMAGE_NAME%:%LATEST_TAG%
echo.
echo To run with Docker Compose:
echo   docker-compose up -d
echo.
echo Image tags pushed:
echo   • %FULL_IMAGE_NAME%:%VERSION%
echo   • %FULL_IMAGE_NAME%:%LATEST_TAG%
echo.
echo ✓ Deployment complete! 🚀
echo.
pause
