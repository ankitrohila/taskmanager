#!/bin/bash

# Deploy script for taskmanager
# This script deploys the taskmanager application to the Hostinger VPS

set -e

# Configuration
VPS_IP="89.116.22.196"
SSH_USER="root"
APP_DIR="/home/taskmanager"
DOMAIN="taskmanager.brandthink.in"
PORT="3000"

echo "Starting deployment to $DOMAIN..."

# 1. SSH into VPS and setup
ssh $SSH_USER@$VPS_IP << 'SSHEOF'
    echo "Creating application directory..."
    mkdir -p /home/taskmanager
    cd /home/taskmanager

    echo "Cloning repository..."
    if [ -d ".git" ]; then
        git pull origin main
    else
        git clone https://github.com/ankitrohila/taskmanager.git .
    fi

    echo "Installing dependencies..."
    npm install

    echo "Application setup complete!"
SSHEOF

echo "Deployment complete!"
echo "Application running at http://$DOMAIN"
