#!/usr/bin/env pwsh

# Task Manager Deployment Script
# Run from: .\deploy.ps1

param(
    [string]$VpsIp = "89.116.22.196",
    [string]$VpsUser = "root",
    [string]$AppDir = "/home/taskmanager",
    [string]$Domain = "taskmanager.brandthink.in",
    [switch]$SkipGit = $false
)

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         Task Manager - VPS Deployment Script                      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  VPS IP:      $VpsIp"
Write-Host "  User:        $VpsUser"
Write-Host "  App Dir:     $AppDir"
Write-Host "  Domain:      $Domain"
Write-Host ""

# Step 1: Git Commit and Push
if (-not $SkipGit) {
    Write-Host "Step 1/3: Committing and pushing to GitHub..." -ForegroundColor Green
    Write-Host "─────────────────────────────────────────────" -ForegroundColor Gray

    try {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        git add .
        git commit -m "Deploy: $timestamp" -ErrorAction SilentlyContinue
        git push origin main
        Write-Host "✓ Code pushed to GitHub" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Git error: $_" -ForegroundColor Red
        Write-Host "Continuing with deployment anyway..." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Step 1/3: Skipping Git (--SkipGit flag used)" -ForegroundColor Gray
}

Write-Host ""

# Step 2: SSH Deploy
Write-Host "Step 2/3: Deploying to VPS..." -ForegroundColor Green
Write-Host "─────────────────────────────" -ForegroundColor Gray

$deployCommand = @"
set -e
echo '1. Navigating to app directory...'
cd $AppDir

echo '2. Pulling latest code from GitHub...'
git pull origin main

echo '3. Installing dependencies...'
npm install

echo '4. Restarting application with PM2...'
pm2 restart taskmanager

echo '5. Application status:'
pm2 status

echo ''
echo '✓ Deployment complete!'
"@

try {
    ssh ${VpsUser}@${VpsIp} $deployCommand
    Write-Host "✓ VPS deployment successful" -ForegroundColor Green
}
catch {
    Write-Host "✗ SSH deployment failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 3: Verification
Write-Host "Step 3/3: Verifying deployment..." -ForegroundColor Green
Write-Host "─────────────────────────────────" -ForegroundColor Gray

$verifyCommand = @"
pm2 status | grep taskmanager
echo ''
echo 'Recent logs:'
pm2 logs taskmanager -n 5 --nostream
"@

ssh ${VpsUser}@${VpsIp} $verifyCommand

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    ✓ DEPLOYMENT SUCCESSFUL                        ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "───────────" -ForegroundColor Gray
Write-Host "1. Add DNS A Record in GoDaddy:" -ForegroundColor White
Write-Host "   - Domain: $Domain" -ForegroundColor Gray
Write-Host "   - Type: A" -ForegroundColor Gray
Write-Host "   - Value: $VpsIp" -ForegroundColor Gray
Write-Host "   - TTL: 600" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Wait 5-15 minutes for DNS propagation" -ForegroundColor White
Write-Host ""
Write-Host "3. Test the application:" -ForegroundColor White
Write-Host "   nslookup $Domain" -ForegroundColor Gray
Write-Host "   curl http://$Domain" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Visit: http://$Domain" -ForegroundColor Cyan
Write-Host ""
Write-Host "Application Details:" -ForegroundColor Yellow
Write-Host "───────────────────" -ForegroundColor Gray
Write-Host "- Server: Hostinger VPS ($VpsIp)" -ForegroundColor White
Write-Host "- Domain: $Domain" -ForegroundColor White
Write-Host "- Port: 3000 (via Nginx)" -ForegroundColor White
Write-Host "- Process Manager: PM2" -ForegroundColor White
Write-Host "- GitHub: https://github.com/ankitrohila/taskmanager" -ForegroundColor White
Write-Host ""
