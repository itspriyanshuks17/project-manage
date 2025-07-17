#!/bin/bash

# GCP Deployment Wrapper Script
echo "🚀 Asset Management System - GCP Deployment"
echo "============================================"
echo ""
echo "This will deploy your Asset Management System to Google Cloud Platform"
echo "Your application will be accessible from anywhere in the world!"
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ Google Cloud CLI is not installed."
    echo "📥 Please install it from: https://cloud.google.com/sdk/docs/install"
    echo ""
    echo "Quick install commands:"
    echo "  curl https://sdk.cloud.google.com | bash"
    echo "  exec -l \$SHELL"
    echo "  gcloud init"
    exit 1
fi

# Navigate to project root and run GCP deployment
cd "$(dirname "$0")"
./gcp/deploy.sh

echo ""
echo "🌟 Your Asset Management System is now deployed to Google Cloud!"
echo "🔗 You can access it from any device, anywhere in the world!"
echo ""
echo "📱 Perfect for accessing from different networks and devices!"
