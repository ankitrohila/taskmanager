# Task Manager - Complete Deployment Commands

## Step 1: Add DNS A Record in GoDaddy

### Via GoDaddy Dashboard:
1. Go to: https://dcc.godaddy.com/control/dnsmanagement?domainName=brandthink.in
2. Click **"Add New Record"** button
3. Fill the form:
   - **Type**: A
   - **Name**: taskmanager
   - **Data/Value**: 89.116.22.196
   - **TTL**: 600
4. Click **Save**

### Via PowerShell (GoDaddy API):
```powershell
# If you have GoDaddy API credentials
$apiKey = "YOUR_GODADDY_API_KEY"
$apiSecret = "YOUR_GODADDY_API_SECRET"

$headers = @{
    "Authorization" = "sso-key ${apiKey}:${apiSecret}"
    "Content-Type" = "application/json"
}

$body = @(
    @{
        type = "A"
        name = "taskmanager"
        data = "89.116.22.196"
        ttl = 600
    }
) | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.godaddy.com/v1/domains/brandthink.in/records" `
    -Method POST `
    -Headers $headers `
    -Body $body
```

---

## Step 2: Deploy Code to VPS with SSH Password Authentication

### Option A: Using SSH Password Authentication (Direct)

```powershell
# 1. Set variables
$VPS_IP = "89.116.22.196"
$VPS_USER = "root"
$APP_DIR = "/home/taskmanager"

# 2. SSH into VPS and update application
ssh ${VPS_USER}@${VPS_IP} "cd ${APP_DIR} && git pull origin main && npm install && pm2 restart taskmanager"
```

### Option B: Deploy from VS Code Integrated Terminal

**In VS Code:**
1. Open Terminal: `Ctrl+` (backtick)
2. Run these commands:

```powershell
# Navigate to project
cd D:\taskmanager

# Deploy to VPS
ssh root@89.116.22.196 "cd /home/taskmanager && git pull origin main && npm install && pm2 restart taskmanager"
```

### Option C: Using SCP to Copy Files (Alternative Method)

```powershell
# Copy entire project to VPS
scp -r D:\taskmanager\* root@89.116.22.196:/home/taskmanager/

# Then SSH and install
ssh root@89.116.22.196 "cd /home/taskmanager && npm install && pm2 restart taskmanager"
```

---

## Step 3: Verify Deployment

### Check Application Status (On VPS):
```powershell
ssh root@89.116.22.196 "pm2 status"
```

### View Application Logs:
```powershell
ssh root@89.116.22.196 "pm2 logs taskmanager"
```

### Test Application:
```powershell
# Once DNS propagates (wait 5-15 minutes)
nslookup taskmanager.brandthink.in
curl http://taskmanager.brandthink.in
```

---

## Complete PowerShell Deployment Script

**Save as: `deploy.ps1`**

```powershell
# Complete deployment script for Task Manager

param(
    [string]$VpsIp = "89.116.22.196",
    [string]$VpsUser = "root",
    [string]$AppDir = "/home/taskmanager",
    [string]$Domain = "taskmanager.brandthink.in"
)

Write-Host "=== Task Manager Deployment ===" -ForegroundColor Green
Write-Host "VPS: $VpsIp" -ForegroundColor Cyan
Write-Host "Domain: $Domain" -ForegroundColor Cyan
Write-Host ""

# Step 1: Commit current changes
Write-Host "Step 1: Committing changes to Git..." -ForegroundColor Yellow
git add .
git commit -m "Deployment $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ErrorAction SilentlyContinue
git push origin main

Write-Host "✓ Code pushed to GitHub" -ForegroundColor Green
Write-Host ""

# Step 2: Pull on VPS and restart
Write-Host "Step 2: Deploying to VPS..." -ForegroundColor Yellow
ssh ${VpsUser}@${VpsIp} "
cd $AppDir
echo 'Pulling latest code...'
git pull origin main

echo 'Installing dependencies...'
npm install

echo 'Restarting application...'
pm2 restart taskmanager

echo 'Showing status...'
pm2 status
"

Write-Host "✓ Deployment complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Add DNS A record in GoDaddy (taskmanager -> 89.116.22.196)" -ForegroundColor White
Write-Host "2. Wait 5-15 minutes for DNS propagation" -ForegroundColor White
Write-Host "3. Visit: http://$Domain" -ForegroundColor White
```

**Run the script:**
```powershell
cd D:\taskmanager
.\deploy.ps1
```

---

## Manual Deployment Steps

### Step 1: Push Code to GitHub
```powershell
cd D:\taskmanager
git add .
git commit -m "Update taskmanager deployment $(Get-Date -Format 'yyyy-MM-dd')"
git push origin main
```

### Step 2: SSH into VPS
```powershell
ssh root@89.116.22.196
```

### Step 3: Update Application on VPS
```bash
# Once logged into VPS, run:
cd /home/taskmanager
git pull origin main
npm install
pm2 restart taskmanager
```

### Step 4: Verify
```bash
pm2 status
pm2 logs taskmanager -n 10
```

---

## If You Need to Restart Everything

```powershell
ssh root@89.116.22.196 "
cd /home/taskmanager
pm2 stop taskmanager
pm2 delete taskmanager
pm2 start ecosystem.config.js
pm2 save
"
```

---

## Troubleshooting

### Port Already in Use
```powershell
ssh root@89.116.22.196 "lsof -i :3000"
```

### View Nginx Logs
```powershell
ssh root@89.116.22.196 "tail -f /var/log/nginx/taskmanager_error.log"
```

### Check if Nginx is Running
```powershell
ssh root@89.116.22.196 "systemctl status nginx"
```

### Restart Nginx
```powershell
ssh root@89.116.22.196 "systemctl reload nginx"
```

---

## Quick Reference Commands

| Task | Command |
|------|---------|
| Deploy | `ssh root@89.116.22.196 "cd /home/taskmanager && git pull && npm install && pm2 restart taskmanager"` |
| Status | `ssh root@89.116.22.196 "pm2 status"` |
| Logs | `ssh root@89.116.22.196 "pm2 logs taskmanager"` |
| SSH Into VPS | `ssh root@89.116.22.196` |
| Test App | `curl http://taskmanager.brandthink.in` |
| DNS Check | `nslookup taskmanager.brandthink.in` |

---

**Ready to deploy! Choose your preferred method above and execute the commands.**
