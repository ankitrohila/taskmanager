# 🚀 PUSH TASK MANAGER TO LIVE SERVER - Complete Guide

## ✅ Status: Application TESTED and WORKING

The screenshot confirms your Task Manager is fully functional! Now let's push it to the live server.

---

## 📖 Step-by-Step: Deploy from VS Code

### **Step 1: Open Project in VS Code**

```powershell
# Open the project folder in VS Code
code D:\taskmanager
```

Or manually:
1. Open VS Code
2. File → Open Folder
3. Select `D:\taskmanager`

---

### **Step 2: Open Integrated Terminal in VS Code**

**Press:** `Ctrl + ` (backtick)

Or: Terminal → New Terminal

You should see a PowerShell terminal at the bottom of VS Code.

---

### **Step 3: Run Deployment Commands**

**Copy and paste this into the VS Code terminal:**

```powershell
# Step 1: Verify you're in the right directory
cd D:\taskmanager

# Step 2: Check git status
git status

# Step 3: Commit your changes
git add .
git commit -m "Push Task Manager to live server"

# Step 4: Push to GitHub
git push origin main

# Step 5: Deploy to VPS
ssh root@89.116.22.196 "cd /home/taskmanager && git pull origin main && npm install && pm2 restart taskmanager"
```

---

## ⚡ Quick Deploy (All-in-One Command)

**Paste this single command in VS Code terminal:**

```powershell
cd D:\taskmanager && git add . && git commit -m "Deploy to live: $(Get-Date -Format 'yyyy-MM-dd HH:mm')" && git push origin main && ssh root@89.116.22.196 "cd /home/taskmanager && git pull origin main && npm install && pm2 restart taskmanager && pm2 status"
```

---

## 📝 Individual Commands (If you prefer step-by-step)

### **In VS Code Terminal:**

**1. Check current status:**
```powershell
git status
```

**2. Stage all changes:**
```powershell
git add .
```

**3. Commit with message:**
```powershell
git commit -m "Task Manager live deployment"
```

**4. Push to GitHub:**
```powershell
git push origin main
```

**5. Deploy to VPS:**
```powershell
ssh root@89.116.22.196 "cd /home/taskmanager && git pull origin main && npm install && pm2 restart taskmanager"
```

**6. Check application status:**
```powershell
ssh root@89.116.22.196 "pm2 status"
```

**7. View application logs:**
```powershell
ssh root@89.116.22.196 "pm2 logs taskmanager -n 10"
```

---

## 🔄 What Each Command Does

| Command | What it does |
|---------|-------------|
| `git add .` | Stages all changes for commit |
| `git commit -m "..."` | Creates a commit with your changes |
| `git push origin main` | Pushes to GitHub repository |
| `git pull origin main` | Downloads latest code on VPS |
| `npm install` | Installs/updates dependencies |
| `pm2 restart taskmanager` | Restarts the application |
| `pm2 status` | Shows if app is running |
| `pm2 logs taskmanager` | Shows application logs |

---

## ✅ Verification Steps

### **After running the deploy command, verify:**

**1. Check if code was pushed to GitHub:**
```powershell
# Should show your commit
git log -1 --oneline
```

**2. Check if app restarted on VPS:**
```powershell
ssh root@89.116.22.196 "pm2 status"
```

Expected output: taskmanager should show `online` status

**3. Check application logs:**
```powershell
ssh root@89.116.22.196 "pm2 logs taskmanager -n 20"
```

Should see: "Task Manager server running on http://localhost:3000"

**4. Test on VPS directly:**
```powershell
ssh root@89.116.22.196 "curl http://localhost:3000"
```

Should return HTML content of your Task Manager

---

## 🌐 Access Your Live Application

### **Once DNS is propagated (5-15 minutes):**

```
http://taskmanager.brandthink.in
```

Or test the IP directly:
```powershell
curl http://89.116.22.196:3000
```

---

## 📦 Current VPS Status

```powershell
# SSH into VPS to check everything
ssh root@89.116.22.196

# Inside VPS terminal:
pm2 status              # Check if app is running
pm2 logs taskmanager    # View logs
systemctl status nginx  # Check nginx
ps aux | grep node      # Find node processes
```

---

## 🆘 Troubleshooting

### **If deployment fails:**

**1. Check SSH access:**
```powershell
ssh root@89.116.22.196 "echo 'Connection successful'"
```

**2. Check git on VPS:**
```powershell
ssh root@89.116.22.196 "cd /home/taskmanager && git status"
```

**3. Check if app is running:**
```powershell
ssh root@89.116.22.196 "pm2 status"
```

**4. View error logs:**
```powershell
ssh root@89.116.22.196 "pm2 logs taskmanager --err"
```

**5. Restart everything:**
```powershell
ssh root@89.116.22.196 "pm2 stop taskmanager && pm2 start ecosystem.config.js && pm2 status"
```

---

## 📋 DNS Configuration

**Still need to add DNS? Use this:**

### **In GoDaddy Dashboard:**
1. https://dcc.godaddy.com/control/dnsmanagement?domainName=brandthink.in
2. Click "Add New Record"
3. Fill:
   - Type: **A**
   - Name: **taskmanager**
   - Value: **89.116.22.196**
   - TTL: **600**
4. Click **Save**

### **Via API (if you have credentials):**
```powershell
$apiKey = "YOUR_KEY"
$apiSecret = "YOUR_SECRET"
$headers = @{
    "Authorization" = "sso-key ${apiKey}:${apiSecret}"
    "Content-Type" = "application/json"
}
$body = @(@{"type"="A";"name"="taskmanager";"data"="89.116.22.196";"ttl"=600}) | ConvertTo-Json
Invoke-RestMethod -Uri "https://api.godaddy.com/v1/domains/brandthink.in/records" -Method POST -Headers $headers -Body $body
```

---

## 🎯 Summary

| Step | Command | Time |
|------|---------|------|
| 1 | `cd D:\taskmanager` | 5 sec |
| 2 | `git add .` | 5 sec |
| 3 | `git commit -m "..."` | 5 sec |
| 4 | `git push origin main` | 10 sec |
| 5 | SSH deploy command | 30 sec |
| 6 | Verify with `pm2 status` | 5 sec |
| **Total** | | **~1 minute** |

---

## ✨ You're Done!

1. **Copy the deploy command above**
2. **Paste into VS Code terminal**
3. **Press Enter**
4. **Application deployed!** 🚀

**That's it!** The application is now live on your VPS. Once DNS propagates, it will be accessible at `http://taskmanager.brandthink.in`

---

## 📞 Need Help?

- **SSH Connection Issues?** Make sure you have OpenSSH client installed
- **Git Issues?** Check you're in the right directory (D:\taskmanager)
- **Permission Denied?** The root user needs to exist on VPS (it does by default on Hostinger)
- **Application not running?** Check logs with: `ssh root@89.116.22.196 "pm2 logs taskmanager"`

---

**Happy Deploying! 🎉**
