#!/bin/bash

# Simplified GCP Deployment - App Engine Only (No Cloud SQL)
# This deploys the app with a simple in-memory database for testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}============================================"
    echo -e "🚀 Asset Management - Simple GCP Deployment"
    echo -e "============================================${NC}"
}

print_header

# Check if gcloud is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    print_error "Not authenticated with Google Cloud."
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

# Enable required APIs
print_status "Enabling App Engine API..."
gcloud services enable appengine.googleapis.com

# Create App Engine application
print_status "Creating App Engine application..."
if ! gcloud app describe --quiet 2>/dev/null; then
    gcloud app create --region=us-central1
    print_status "App Engine application created"
else
    print_warning "App Engine application already exists"
fi

# Create simple app.yaml without Cloud SQL
print_status "Creating simplified app.yaml..."
cat > gcp/app-simple.yaml << EOF
runtime: nodejs20

env_variables:
  NODE_ENV: "production"
  PORT: "8080"
  DB_HOST: "localhost"
  DB_USER: "root"
  DB_PASSWORD: ""
  DB_NAME: "asset_management"
  DB_PORT: "3306"
  SESSION_SECRET: "your-session-secret-$(date +%s)"

automatic_scaling:
  min_instances: 1
  max_instances: 10
  target_cpu_utilization: 0.6

handlers:
- url: /public
  static_dir: public
  secure: always

- url: /.*
  script: auto
  secure: always
EOF

# Deploy the application
print_status "Deploying application to App Engine..."
gcloud app deploy gcp/app-simple.yaml --quiet

# Get the deployed URL
APP_URL=$(gcloud app describe --format="value(defaultHostname)")

print_status "Deployment completed successfully!"
echo ""
print_info "🌐 Your application is now live at: https://$APP_URL"
print_info "🔗 Direct link: https://$APP_URL"
echo ""
print_warning "Note: This deployment uses a simple setup without Cloud SQL"
print_warning "For production use, you'll need to set up Cloud SQL separately"
echo ""
print_info "To view logs: gcloud app logs tail -s default"
