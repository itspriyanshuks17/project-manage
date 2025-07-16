#!/bin/bash

# Google Cloud Platform Deployment Script for Asset Management System
# This script sets up and deploys the application to Google App Engine

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_header() {
    echo -e "${BLUE}============================================"
    echo -e "🚀 Asset Management System - GCP Deployment"
    echo -e "============================================${NC}"
}

print_header

# Check if gcloud CLI is installed
if ! command -v gcloud &> /dev/null; then
    print_error "Google Cloud CLI is not installed."
    print_info "Please install it from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    print_error "You are not authenticated with Google Cloud."
    print_info "Please run: gcloud auth login"
    exit 1
fi

# Get current project
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    print_error "No Google Cloud project is set."
    print_info "Please run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

print_status "Using project: $PROJECT_ID"

# Prompt for configuration
echo ""
print_info "Please provide the following information:"
read -p "Enter Cloud SQL instance name (default: asset-db): " SQL_INSTANCE
SQL_INSTANCE=${SQL_INSTANCE:-asset-db}

read -p "Enter region (default: us-central1): " REGION
REGION=${REGION:-us-central1}

read -p "Enter database password: " -s DB_PASSWORD
echo ""

read -p "Enter session secret key: " -s SESSION_SECRET
echo ""

# Update app.yaml with actual values
print_status "Updating app.yaml configuration..."
sed -i "s/PROJECT_ID/$PROJECT_ID/g" gcp/app.yaml
sed -i "s/REGION/$REGION/g" gcp/app.yaml
sed -i "s/INSTANCE_NAME/$SQL_INSTANCE/g" gcp/app.yaml
sed -i "s/your-secure-password/$DB_PASSWORD/g" gcp/app.yaml
sed -i "s/your-super-secure-session-secret-key/$SESSION_SECRET/g" gcp/app.yaml

# Enable required APIs
print_status "Enabling required Google Cloud APIs..."
gcloud services enable appengine.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Create Cloud SQL instance
print_status "Creating Cloud SQL instance..."
if ! gcloud sql instances describe $SQL_INSTANCE --quiet 2>/dev/null; then
    gcloud sql instances create $SQL_INSTANCE \
        --database-version=MYSQL_8_0 \
        --tier=db-f1-micro \
        --region=$REGION \
        --storage-type=SSD \
        --storage-size=10GB \
        --backup-start-time=03:00 \
        --enable-bin-log \
        --maintenance-window-day=SUN \
        --maintenance-window-hour=04
    
    print_status "Cloud SQL instance created successfully"
else
    print_warning "Cloud SQL instance already exists"
fi

# Set database password
print_status "Setting database root password..."
gcloud sql users set-password root --host=% --instance=$SQL_INSTANCE --password=$DB_PASSWORD

# Create database
print_status "Creating database..."
gcloud sql databases create asset_management --instance=$SQL_INSTANCE || true

# Import database schema
print_status "Importing database schema..."
gcloud sql import sql $SQL_INSTANCE gcp/cloud-sql-init.sql --database=asset_management

# Create App Engine application
print_status "Creating App Engine application..."
if ! gcloud app describe --quiet 2>/dev/null; then
    gcloud app create --region=$REGION
    print_status "App Engine application created"
else
    print_warning "App Engine application already exists"
fi

# Deploy the application
print_status "Deploying application to App Engine..."
gcloud app deploy gcp/app.yaml --quiet

# Get the deployed URL
APP_URL=$(gcloud app describe --format="value(defaultHostname)")

print_status "Deployment completed successfully!"
echo ""
print_info "🌐 Your application is now live at: https://$APP_URL"
print_info "🔗 Direct link: https://$APP_URL"
echo ""
print_info "Default login credentials:"
print_info "  Admin:    admin / admin123"
print_info "  Manager:  manager1 / manager123"
print_info "  Employee: employee1 / employee123"
echo ""
print_warning "Remember to change default passwords after first login!"
echo ""
print_info "To view logs: gcloud app logs tail -s default"
print_info "To manage your app: https://console.cloud.google.com/appengine"
