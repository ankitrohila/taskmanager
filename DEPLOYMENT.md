# Task Manager Deployment Guide

## Deployment Status: ✅ IN PROGRESS

### ✅ Completed Steps:

1. **Created Task Manager Application**
   - Express.js server with Node.js
   - RESTful API endpoints for task management
   - Beautiful, responsive UI with task filtering
   - Ready to deploy

2. **Pushed Code to GitHub**
   - Repository: https://github.com/ankitrohila/taskmanager
   - All files committed and pushed to main branch

3. **Deployed to Hostinger VPS**
   - VPS IP: 89.116.22.196
   - Application cloned and dependencies installed
   - PM2 configured to manage the application
   - Application running on port 3000
   - PM2 set to restart on boot

4. **Configured Nginx**
   - Nginx configured as reverse proxy for taskmanager.brandthink.in
   - Proxy forwarding from port 80 to 3000
   - Configuration file: /etc/nginx/sites-available/taskmanager
   - Nginx reloaded and ready

### 🔄 Remaining Steps:

#### Step 1: Add DNS A Record in GoDaddy

1. Go to https://dcc.godaddy.com/control/dnsmanagement?domainName=brandthink.in
2. Click "Add New Record" button
3. Fill in the form:
   - **Type**: A
   - **Name**: taskmanager
   - **Data**: 89.116.22.196
   - **TTL**: 600 (or auto)
4. Click "Save"
5. Wait for DNS propagation (usually 5-15 minutes)

OR use DNS API:
```bash
curl -X POST "https://api.godaddy.com/v1/domains/brandthink.in/records" \
  -H "Authorization: sso-key YOUR_API_KEY:YOUR_API_SECRET" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "type": "A",
      "name": "taskmanager",
      "data": "89.116.22.196",
      "ttl": 600
    }
  ]'
```

#### Step 2: Verify Deployment

After DNS propagates (wait 5-15 minutes), test:

```bash
# Check DNS resolution
nslookup taskmanager.brandthink.in

# Test application
curl http://taskmanager.brandthink.in
```

#### Step 3: Verify Application is Running (on VPS)

```bash
ssh root@89.116.22.196

# Check PM2 status
pm2 status

# Check Nginx status
systemctl status nginx

# View application logs
pm2 logs taskmanager

# Test locally on VPS
curl http://localhost:3000
```

### Testing Commands

```bash
# Test application is running
curl -I http://89.116.22.196:3000

# Get all tasks (test API)
curl http://89.116.22.196:3000/api/tasks

# Create a new task
curl -X POST http://89.116.22.196:3000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"My Task","description":"Task description"}'
```

## Application Features

- **Create Tasks**: Add new tasks with title, description, and due date
- **View Tasks**: See all tasks with status and due dates
- **Edit Tasks**: Mark tasks as completed
- **Delete Tasks**: Remove tasks you no longer need
- **Filter Tasks**: View all, active, or completed tasks
- **Responsive Design**: Works on desktop and mobile

## API Endpoints

- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create a new task
- `GET /api/tasks/:id` - Get a specific task
- `PUT /api/tasks/:id` - Update a task
- `DELETE /api/tasks/:id` - Delete a task

## Live URL

Once DNS is configured: **http://taskmanager.brandthink.in**

## Maintenance

### Restart Application
```bash
ssh root@89.116.22.196
pm2 restart taskmanager
```

### View Logs
```bash
ssh root@89.116.22.196
pm2 logs taskmanager
```

### Update Application
```bash
ssh root@89.116.22.196
cd /home/taskmanager
git pull origin main
npm install
pm2 restart taskmanager
```

### Stop Application
```bash
pm2 stop taskmanager
pm2 delete taskmanager
```

## Server Details

- **Server**: Hostinger VPS (KVM 2)
- **OS**: Ubuntu 22.04 LTS
- **Node.js Version**: Latest LTS
- **Process Manager**: PM2
- **Web Server**: Nginx
- **Application Port**: 3000
- **Uptime**: Auto-restart on VPS reboot
- **Database**: In-memory (sample data)

## Troubleshooting

### Application not accessible
1. Check DNS propagation: `nslookup taskmanager.brandthink.in`
2. Check if application is running: `pm2 status`
3. Check Nginx logs: `tail -f /var/log/nginx/taskmanager_error.log`
4. Test on VPS directly: `curl http://localhost:3000`

### DNS not resolving
1. Verify A record was added to GoDaddy
2. Check record is correct: type=A, name=taskmanager, data=89.116.22.196
3. Wait for DNS propagation (up to 24 hours for full propagation)
4. Clear DNS cache: `ipconfig /flushdns` (Windows) or `sudo dscacheutil -flushcache` (Mac)

### Port already in use
PM2 is configured to use port 3000. If the port is taken:
```bash
# Find process using port 3000
lsof -i :3000

# Change PORT in ecosystem.config.js and restart
pm2 restart taskmanager
```

## Next Steps

1. Add the DNS A record in GoDaddy
2. Wait for DNS propagation
3. Visit taskmanager.brandthink.in in your browser
4. Start creating tasks!

---

**Deployment completed by**: Claude Code
**Date**: 2026-06-15
**Status**: Ready for final DNS configuration and testing
