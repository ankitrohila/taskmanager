# 🚀 Task Manager - Quick Start Deployment Guide

## ⚡ TL;DR - Just Run These Commands

### Step 1: Open VS Code Terminal
```powershell
# Press Ctrl+` to open terminal in VS Code, then:
cd D:\taskmanager
.\deploy.ps1
```

That's it! The script will:
✓ Commit your code to GitHub  
✓ Push to remote repository  
✓ Deploy to VPS  
✓ Restart the application  

### Step 2: Add DNS Record in GoDaddy (2 minutes)

**Option A - Manual (Easiest)**
1. Open: https://dcc.godaddy.com/control/dnsmanagement?domainName=brandthink.in
2. Click "**Add New Record**" button (top left box)
3. Fill in:
   - **Type**: A
   - **Name**: taskmanager
   - **Value/Data**: 89.116.22.196
   - **TTL**: 600
4. Click "**Save**"

**Option B - PowerShell (If you have API keys)**
```powershell
$apiKey = "YOUR_API_KEY"
$apiSecret = "YOUR_API_SECRET"
$headers = @{
    "Authorization" = "sso-key ${apiKey}:${apiSecret}"
    "Content-Type" = "application/json"
}
$body = @(@{"type"="A";"name"="taskmanager";"data"="89.116.22.196";"ttl"=600}) | ConvertTo-Json
Invoke-RestMethod -Uri "https://api.godaddy.com/v1/domains/brandthink.in/records" -Method POST -Headers $headers -Body $body
```

### Step 3: Wait & Verify (5-15 minutes)

```powershell
# Check DNS
nslookup taskmanager.brandthink.in

# Test application
curl http://taskmanager.brandthink.in

# Or open in browser: http://taskmanager.brandthink.in
```

---

## 📋 Detailed Commands

### Deploy Script (Recommended)
```powershell
# In VS Code terminal or PowerShell:
cd D:\taskmanager
.\deploy.ps1
```

### Manual Deployment (Step by Step)

**1. Commit and Push Code**
```powershell
cd D:\taskmanager
git add .
git commit -m "Deployment update"
git push origin main
```

**2. Update on VPS**
```powershell
ssh root@89.116.22.196 "cd /home/taskmanager && git pull origin main && npm install && pm2 restart taskmanager"
```

**3. Check Status**
```powershell
ssh root@89.116.22.196 "pm2 status"
```

---

## 🔗 DNS Record Details

When adding in GoDaddy, use these exact values:

| Field | Value |
|-------|-------|
| **Type** | A |
| **Name** | taskmanager |
| **Data/Value** | 89.116.22.196 |
| **TTL** | 600 |

---

## ✅ After Everything is Done

| Action | Command |
|--------|---------|
| **View Logs** | `ssh root@89.116.22.196 "pm2 logs taskmanager"` |
| **Restart App** | `ssh root@89.116.22.196 "pm2 restart taskmanager"` |
| **Stop App** | `ssh root@89.116.22.196 "pm2 stop taskmanager"` |
| **Update Code** | `ssh root@89.116.22.196 "cd /home/taskmanager && git pull && npm install && pm2 restart taskmanager"` |
| **SSH Into VPS** | `ssh root@89.116.22.196` |

---

## 🎯 Final URLs

| Item | URL |
|------|-----|
| **Live Application** | http://taskmanager.brandthink.in |
| **GitHub Repository** | https://github.com/ankitrohila/taskmanager |
| **GoDaddy DNS Management** | https://dcc.godaddy.com/control/dnsmanagement?domainName=brandthink.in |

---

## 🆘 Troubleshooting

**Application not responding after deployment?**
```powershell
ssh root@89.116.22.196 "pm2 logs taskmanager -n 20"
```

**Need to check if nginx is running?**
```powershell
ssh root@89.116.22.196 "systemctl status nginx"
```

**Port 3000 in use?**
```powershell
ssh root@89.116.22.196 "lsof -i :3000"
```

---

## 📦 Project Structure

```
D:\taskmanager\
├── server.js              # Express server
├── public/
│   ├── index.html         # UI
│   ├── style.css          # Styles
│   └── script.js          # Client-side JS
├── package.json           # Dependencies
├── deploy.ps1            # Deployment script (RUN THIS!)
├── deploy-vps.ps1        # Alternative VPS script
├── DEPLOY_COMMANDS.md    # All commands reference
├── DEPLOYMENT.md         # Full documentation
└── QUICK_START.md        # This file
```

---

## 🎉 You're All Set!

1. **Run**: `.\deploy.ps1` in VS Code terminal
2. **Add DNS record** in GoDaddy (2 minutes)
3. **Wait** 5-15 minutes for DNS propagation
4. **Visit**: http://taskmanager.brandthink.in

Enjoy your Task Manager! 🚀
