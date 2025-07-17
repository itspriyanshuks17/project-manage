# Use official Node.js runtime as base image (security-focused)
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /app

# Create a non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Install dependencies first (better Docker layer caching)
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Copy Docker-specific environment file
COPY docker/.env.docker .env

# Create necessary directories and set permissions
RUN mkdir -p /app/views /app/public /app/logs && \
    chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose the port the app runs on
EXPOSE 8080

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080

# Health check to ensure the container is running properly
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) }).on('error', () => process.exit(1))"

# Start the application
CMD ["npm", "start"]
