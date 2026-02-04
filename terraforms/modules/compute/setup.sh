#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting deployment..."

# Dev Mode Strategy: Skipping Swap to save disk space (8GB limit)
# Skipping 'npm run build' to save RAM

# Update and install dependencies
apt-get update
apt-get upgrade -y
apt-get install -y git build-essential

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Verify Node version
echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"

# Setup Strapi Directory
mkdir -p /opt/strapi
cd /opt/strapi

# Clone Repository
git clone https://github.com/Maheshroy50/Strapi--project.git .

# Create .env file
# Note: HOST=0.0.0.0 is crucial for Dev Mode to be accessible outside localhost
cat > .env <<EOF
HOST=0.0.0.0
PORT=1337
APP_KEYS=${app_keys}
API_TOKEN_SALT=${api_token_salt}
ADMIN_JWT_SECRET=${admin_jwt_secret}
TRANSFER_TOKEN_SALT=${transfer_token_salt}
JWT_SECRET=${jwt_secret}
DATABASE_CLIENT=sqlite
DATABASE_FILENAME=.tmp/data.db
EOF

# Install Dependencies
echo "Installing dependencies..."
npm install

# Create necessary directories for Strapi
echo "Creating Strapi directories..."
mkdir -p /opt/strapi/public/uploads
mkdir -p /opt/strapi/.tmp
chown -R root:root /opt/strapi

# Create Systemd Service for Dev Mode
cat > /etc/systemd/system/strapi.service <<EOF
[Unit]
Description=Strapi Node.js Service (Dev Mode)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/strapi
# using 'npm run develop' instead of start
ExecStart=/usr/bin/npm run develop
Restart=always
Environment=NODE_ENV=development

[Install]
WantedBy=multi-user.target
EOF

# Enable and Start Service
systemctl daemon-reload
systemctl enable strapi
systemctl start strapi

echo "Deployment completed successfully!"
