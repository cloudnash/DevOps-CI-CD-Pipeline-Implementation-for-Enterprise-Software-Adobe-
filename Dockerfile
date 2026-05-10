
FROM hshar/webapp

# Maintainer information
LABEL maintainer="myemail@example.com"
LABEL description="Abode Software Web Application"
LABEL version="1.0"

# Set working directory
WORKDIR /var/www/html

# Copy application code to container
# This will copy everything from GitHub repo to /var/www/html
COPY . /var/www/html/

# Make sure the web directory has proper permissions
RUN chmod -R 755 /var/www/html

# Create a tests directory if it doesn't exist
RUN mkdir -p /tests

# Copy test scripts
COPY tests/ /tests/

# Expose port 80 for web traffic
EXPOSE 80

# Health check - verify web server is responding
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

# Start the web server
# The hshar/webapp base image already has Apache configured
CMD ["apache2ctl", "-D", "FOREGROUND"]

# ============================================
# DOCKERFILE EXPLANATION:
# ============================================
# 
# This Dockerfile does the following:
# 
# 1. Uses 'hshar/webapp' as base image
#    - This image already has Apache web server
#    - Pre-configured for serving web applications
# 
# 2. Copies application code to /var/www/html
#    - This is the standard web server directory
#    - Apache serves files from this location
# 
# 3. Sets proper permissions
#    - Ensures web server can read files
# 
# 4. Adds health checks
#    - Automatically checks if app is running
#    - Jenkins can verify successful deployment
# 
# 5. Exposes port 80
#    - Standard HTTP port for web traffic
# 
# ============================================
# HOW TO USE:
# ============================================
# 
# Build the image:
#   docker build -t yourdockerhub/abode-webapp:latest .
# 
# Run the container:
#   docker run -d -p 80:80 yourdockerhub/abode-webapp:latest
# 
# Access the application:
#   http://localhost:80
# 
# ============================================
