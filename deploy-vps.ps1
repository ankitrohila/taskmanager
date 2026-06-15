# Deployment script for taskmanager to Hostinger VPS
# Run this script to deploy the application to the live server

$VPS_IP = "89.116.22.196"
$VPS_USER = "root"
$APP_DIR = "/home/taskmanager"
$DOMAIN = "taskmanager.brandthink.in"
$PORT = "3000"

Write-Host "Starting deployment to $DOMAIN..." -ForegroundColor Green
Write-Host "VPS IP: $VPS_IP" -ForegroundColor Yellow

# Step 1: Create application directory and clone repository
Write-Host "`n1. Setting up application directory on VPS..." -ForegroundColor Cyan
$sshCmd = @"
set -e
echo 'Creating directories...'
mkdir -p $APP_DIR
cd $APP_DIR

if [ -d .git ]; then
    echo 'Repository exists, pulling latest changes...'
    git pull origin main
else
    echo 'Cloning repository...'
    git clone https://github.com/ankitrohila/taskmanager.git .
fi

echo 'Installing dependencies...'
npm install

echo 'Application directory ready!'
"@

# Execute SSH command
ssh ${VPS_USER}@${VPS_IP} $sshCmd

# Step 2: Create nginx configuration
Write-Host "`n2. Creating nginx configuration..." -ForegroundColor Cyan

$nginxConfig = @"
server {
    listen 80;
    listen [::]:80;
    server_name taskmanager.brandthink.in;

    # Logs
    access_log /var/log/nginx/taskmanager_access.log;
    error_log /var/log/nginx/taskmanager_error.log;

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
"@

# Create temporary nginx config file
$nginxConfigPath = "/tmp/taskmanager-nginx.conf"
Write-Host "Creating nginx config at $nginxConfigPath" -ForegroundColor Yellow

# Execute via SSH to create the config
ssh ${VPS_USER}@${VPS_IP} "cat > $nginxConfigPath" -InputObject $nginxConfig

# Step 3: Copy nginx config to sites-available
Write-Host "`n3. Installing nginx configuration..." -ForegroundColor Cyan
ssh ${VPS_USER}@${VPS_IP} "cp $nginxConfigPath /etc/nginx/sites-available/taskmanager && ln -sf /etc/nginx/sites-available/taskmanager /etc/nginx/sites-enabled/ 2>/dev/null || true && nginx -t && systemctl reload nginx"

# Step 4: Start application with PM2
Write-Host "`n4. Starting application with PM2..." -ForegroundColor Cyan
ssh ${VPS_USER}@${VPS_IP} "cd $APP_DIR && npm install -g pm2 && pm2 start server.js --name taskmanager && pm2 save && pm2 startup"

# Step 5: Verification
Write-Host "`n5. Verifying deployment..." -ForegroundColor Cyan
ssh ${VPS_USER}@${VPS_IP} "echo 'PM2 Status:' && pm2 status && echo '' && echo 'Nginx Status:' && systemctl status nginx | head -10"

Write-Host "`n✅ Deployment completed successfully!" -ForegroundColor Green
Write-Host "Application is running at: http://$DOMAIN" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Add DNS A record in GoDaddy: $DOMAIN -> $VPS_IP" -ForegroundColor White
Write-Host "2. Wait for DNS propagation (usually 5-15 minutes)" -ForegroundColor White
Write-Host "3. Test the application at https://$DOMAIN" -ForegroundColor White
