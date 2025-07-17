# Google Cloud Platform (GCP) Deployment Guide

This directory contains all the necessary files to deploy the Asset Management System to Google Cloud Platform using Google App Engine and Cloud SQL.

## 📋 Prerequisites

Before deploying, ensure you have:

1. **Google Cloud Platform Account**
   - Create an account at [console.cloud.google.com](https://console.cloud.google.com)
   - Create a new project or select an existing one

2. **Google Cloud CLI**
   - Install from: https://cloud.google.com/sdk/docs/install
   - Authenticate: `gcloud auth login`
   - Set project: `gcloud config set project YOUR_PROJECT_ID`

3. **Billing Account**
   - Enable billing for your GCP project
   - Required for App Engine and Cloud SQL

## 🚀 Quick Deployment

### Option 1: Automated Deployment (Recommended)
```bash
# Make the script executable
chmod +x gcp/deploy.sh

# Run the deployment script
./gcp/deploy.sh
```

### Option 2: Manual Deployment
```bash
# 1. Enable required APIs
gcloud services enable appengine.googleapis.com
gcloud services enable sqladmin.googleapis.com

# 2. Create Cloud SQL instance
gcloud sql instances create asset-db \
    --database-version=MYSQL_8_0 \
    --tier=db-f1-micro \
    --region=us-central1

# 3. Create database
gcloud sql databases create asset_management --instance=asset-db

# 4. Import schema
gcloud sql import sql asset-db gcp/cloud-sql-init.sql --database=asset_management

# 5. Create App Engine app
gcloud app create --region=us-central1

# 6. Deploy
gcloud app deploy gcp/app.yaml
```

## 🔧 Configuration Files

### `app.yaml`
Google App Engine configuration file that defines:
- Runtime environment (Node.js 20)
- Environment variables
- Cloud SQL connection
- Scaling settings
- Health checks

### `cloud-sql-init.sql`
Database initialization script that creates:
- Database schema (users, products, requests)
- Default users with hashed passwords
- Sample product data

### `.gcloudignore`
Specifies files to exclude from deployment (similar to .gitignore)

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Users/Devices │────│  App Engine     │────│   Cloud SQL     │
│                 │    │  (Node.js App)  │    │   (MySQL 8.0)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                │
                       ┌─────────────────┐
                       │  Cloud Storage  │
                       │  (Static Files) │
                       └─────────────────┘
```

## 💰 Cost Estimation

### App Engine (F1 instance)
- **Free tier**: 28 instance hours per day
- **Paid**: ~$0.05/hour after free tier

### Cloud SQL (db-f1-micro)
- **Cost**: ~$7-10/month
- **Storage**: 10GB included
- **Backup**: Included

### Total estimated cost: **$7-15/month** for small to medium usage

## 🌐 Features

### Production Ready
- ✅ Auto-scaling based on traffic
- ✅ Load balancing
- ✅ SSL/HTTPS enabled by default
- ✅ Health monitoring
- ✅ Automated backups

### Security
- ✅ Managed SSL certificates
- ✅ Database encryption at rest
- ✅ Network isolation
- ✅ IAM-based access control

## 🔐 Environment Variables

The deployment uses these environment variables:
- `DB_HOST`: Cloud SQL connection string
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password
- `SESSION_SECRET`: Session encryption key
- `NODE_ENV`: Set to "production"

## 📊 Monitoring & Logs

### View Application Logs
```bash
# Real-time logs
gcloud app logs tail -s default

# Historical logs
gcloud app logs read -s default
```

### Monitoring Dashboard
- Visit: https://console.cloud.google.com/appengine
- Monitor: CPU, memory, requests, errors
- Set up alerts for critical issues

## 🛠️ Troubleshooting

### Common Issues

1. **Deployment fails with "billing not enabled"**
   - Enable billing in GCP Console
   - Ensure you have a valid payment method

2. **Database connection fails**
   - Check Cloud SQL instance is running
   - Verify connection string in app.yaml
   - Ensure database user has proper permissions

3. **App doesn't start**
   - Check logs: `gcloud app logs tail -s default`
   - Verify environment variables
   - Check health endpoint: `/health`

### Useful Commands
```bash
# Check deployment status
gcloud app versions list

# Access Cloud SQL
gcloud sql connect asset-db --user=root

# Update environment variables
gcloud app deploy gcp/app.yaml --quiet

# Scale application
gcloud app versions migrate VERSION_ID
```

## 🔄 Updates & Maintenance

### Deploying Updates
```bash
# Deploy new version
gcloud app deploy gcp/app.yaml

# Rollback if needed
gcloud app versions migrate PREVIOUS_VERSION_ID
```

### Database Maintenance
```bash
# Create backup
gcloud sql backups create --instance=asset-db

# Restore from backup
gcloud sql backups restore BACKUP_ID --restore-instance=asset-db
```

## 📱 Access Your Application

After deployment, your application will be available at:
- **URL**: `https://YOUR_PROJECT_ID.appspot.com`
- **Custom Domain**: Can be configured in App Engine settings

### Default Login Credentials
- **Admin**: admin / admin123
- **Manager**: manager1 / manager123
- **Employee**: employee1 / employee123

**⚠️ Important**: Change default passwords after first login!

## 🎯 Next Steps

1. **Custom Domain**: Configure your own domain name
2. **SSL Certificate**: Set up custom SSL (if using custom domain)
3. **Monitoring**: Set up alerting for critical issues
4. **Backup Strategy**: Configure automated backups
5. **Security**: Review and harden security settings

## 🆘 Support

For issues:
1. Check application logs
2. Review GCP Console for errors
3. Consult Google Cloud documentation
4. Check the health endpoint: `/health`

---

Happy deploying! 🚀
