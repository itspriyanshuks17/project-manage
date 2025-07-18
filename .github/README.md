# GitHub Actions Workflows for Asset Management System

This repository includes a comprehensive CI/CD setup with multiple GitHub Actions workflows to automate testing, security scanning, building, and deployment.

## 🚀 Workflows Overview

### 1. **CI/CD Pipeline** (`ci-cd.yml`)
**Triggers:** Push to `main`/`develop`, Pull Requests to `main`

**Features:**
- ✅ Automated testing with MySQL database
- 🔍 Security auditing and vulnerability scanning
- 🐳 Docker image building and publishing to GitHub Container Registry
- 🌐 Deployment to Google Cloud Platform App Engine
- 🚀 Alternative Docker-based deployment
- 📧 Deployment status notifications

### 2. **Pull Request Checks** (`pr-checks.yml`)
**Triggers:** Pull Requests to `main`/`develop`

**Features:**
- ⚡ Quick validation and syntax checking
- 🛡️ Security audit
- 🧪 Application startup testing
- 🐳 Docker build verification
- 📝 Code quality checks

### 3. **Security Monitor** (`security-monitor.yml`)
**Triggers:** Weekly schedule (Mondays 9 AM UTC), Manual trigger

**Features:**
- 📦 Dependency update monitoring
- 🔒 Security vulnerability scanning
- ⚖️ License compliance checking
- 🐳 Docker image security scanning
- 🏥 Application health monitoring

### 4. **Release** (`release.yml`)
**Triggers:** Git tags matching `v*.*.*` (e.g., v1.0.0)

**Features:**
- 📋 Automatic changelog generation
- 🏷️ GitHub release creation
- 🧪 Production build testing
- 🐳 Versioned Docker image building
- 🚀 Production deployment
- 📢 Release notifications

## 🔧 Setup Instructions

### 1. Repository Secrets

You need to configure the following secrets in your GitHub repository settings (`Settings > Secrets and variables > Actions`):

#### For Google Cloud Platform Deployment:
```
GCP_SA_KEY          # Service Account JSON key for GCP
GCP_PROJECT_ID      # Your GCP Project ID
DB_PASSWORD         # Production database password
SESSION_SECRET      # Production session secret key
```

#### For Docker-based Deployment:
```
PRODUCTION_HOST     # Your production server IP/hostname
PRODUCTION_USER     # SSH username for production server
PRODUCTION_SSH_KEY  # Private SSH key for production server
```

### 2. Environment Setup

#### Google Cloud Platform
1. Create a service account with App Engine Admin permissions
2. Download the JSON key file
3. Add the JSON content as `GCP_SA_KEY` secret
4. Update `app.yaml` with your specific configuration

#### Docker Deployment
1. Set up your production server with Docker and Docker Compose
2. Generate SSH key pair for deployment access
3. Add the private key as `PRODUCTION_SSH_KEY` secret
4. Update deployment paths in the workflow

### 3. Database Configuration

The workflows use MySQL 8.0 for testing. Ensure your `database.sql` file contains:
- Table creation statements
- Initial data (if needed)
- Proper indexes and constraints

## 📦 Docker Registry

Docker images are automatically built and pushed to GitHub Container Registry:
```
ghcr.io/itspriyanshuks17/project-manage:latest
ghcr.io/itspriyanshuks17/project-manage:main-sha123abc
ghcr.io/itspriyanshuks17/project-manage:v1.0.0
```

## 🏃‍♂️ Running Workflows

### Automatic Triggers
- **Push to main/develop:** Runs full CI/CD pipeline
- **Pull Request:** Runs validation checks
- **Weekly:** Runs security monitoring
- **Release tag:** Runs release workflow

### Manual Triggers
- Security monitoring can be triggered manually from Actions tab
- Individual workflows can be triggered via workflow_dispatch

## 🧪 Testing Locally

Before pushing, you can test your changes locally:

```bash
# Install dependencies
npm ci

# Run security audit
npm audit

# Test Docker build
docker build -f docker/Dockerfile -t test-image .

# Test with database
docker-compose up -d
npm start
```

## 📊 Monitoring and Notifications

### Built-in Monitoring
- Dependency updates (weekly)
- Security vulnerabilities (on every build)
- License compliance (weekly)
- Docker image security (weekly)

### Notification Integration

To integrate with your notification system, update the notification steps in:
- `ci-cd.yml` (deployment notifications)
- `release.yml` (release notifications)
- `security-monitor.yml` (security alerts)

Example integrations:
- **Slack:** Use slack-notify action
- **Discord:** Use discord-webhook action
- **Email:** Use mail action
- **Teams:** Use teams-notify action

## 🔍 Troubleshooting

### Common Issues

1. **Database Connection Fails**
   - Check if `database.sql` exists and is valid
   - Verify environment variables are set correctly

2. **Docker Build Fails**
   - Ensure `docker/Dockerfile` exists
   - Check if all required files are copied

3. **Deployment Fails**
   - Verify all required secrets are set
   - Check deployment server accessibility
   - Validate configuration files

4. **Tests Fail**
   - Add proper test scripts to `package.json`
   - Ensure test database is properly set up

### Debugging Workflows

1. **Enable Debug Logging:**
   Add this to workflow environment:
   ```yaml
   env:
     ACTIONS_STEP_DEBUG: true
     ACTIONS_RUNNER_DEBUG: true
   ```

2. **Check Logs:**
   - Go to Actions tab in GitHub
   - Select the failed workflow run
   - Expand the failed step to see detailed logs

## 🚀 Deployment Process

### Standard Deployment (main branch)
1. Code pushed to `main`
2. Tests run automatically
3. Docker image built and pushed
4. Deployment to production (if configured)

### Release Deployment
1. Create and push a version tag: `git tag v1.0.0 && git push origin v1.0.0`
2. Release workflow runs automatically
3. GitHub release created with changelog
4. Versioned Docker image built
5. Production deployment (for stable releases)

## 📝 Customization

### Adding New Checks
1. Edit the appropriate workflow file
2. Add your custom steps
3. Update this README with new features

### Environment-specific Configuration
1. Use GitHub Environments for different deployment targets
2. Configure environment-specific secrets
3. Update workflow conditions as needed

### Custom Notifications
1. Choose your notification service
2. Add the appropriate action to notify steps
3. Configure required secrets for the service

## 🤝 Contributing

When contributing to this project:
1. All PRs trigger validation workflows
2. Ensure tests pass before merging
3. Follow semantic versioning for releases
4. Update documentation for workflow changes

---

For more information about GitHub Actions, visit the [GitHub Actions Documentation](https://docs.github.com/en/actions).
