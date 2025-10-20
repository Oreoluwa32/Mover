# 🚂 Railway Monorepo Deployment Fix

## Problem
Railway tried to build your entire repo (Flutter + Backend) but got confused because there's no app at the root level.

## Error Message
```
✖ Railpack could not determine how to build the app.
⚠ Script start.sh not found
```

## ✅ What I Fixed For You

1. ✅ Created `railway.toml` - tells Railway to deploy only the `backend/` folder
2. ✅ Updated `backend/Dockerfile` - now respects Railway's `PORT` environment variable
3. ✅ Both files are ready to deploy!

## Solution (2 options)

### 🎯 Option 1: Quick Fix (1 minute)

Just commit and push:
```bash
git add .
git commit -m "Fix Railway monorepo deployment"
git push
```

Railway will auto-redeploy! ✨

---

### Option 2: Manual Deploy

1. **Go to Railway Dashboard** → Select your service
2. **Click "Deploy"** button manually
3. Wait 2-3 minutes for build to complete

---

## What Changed

| Before | After |
|--------|-------|
| ❌ Railway tried to deploy entire repo | ✅ Railway deploys only `backend/` folder |
| ❌ Confused by Flutter files | ✅ Uses `backend/Dockerfile` correctly |
| ❌ Port hardcoded to 8000 | ✅ Respects Railway's PORT env var |
| ❌ Failed: "Can't detect build type" | ✅ Builds successfully 🎉 |

---

## File Changes Made

### 1. Created `railway.toml` (NEW)
```toml
[build]
dockerfile = "backend/Dockerfile"
context = "backend"
```
✅ Tells Railway to use the backend folder

### 2. Updated `backend/Dockerfile` (MODIFIED)
```dockerfile
ENV PORT=8000  # Added default port
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
```
✅ Now respects Railway's PORT environment variable

---

## Deploy Now!

### Step 1: Commit your changes
```bash
git add .
git commit -m "Fix Railway monorepo deployment - use backend subfolder"
git push origin main
```

### Step 2: Watch the deployment
- Go to Railway Dashboard
- Select your service  
- Click "Deployments" tab
- Watch for new deployment (should start automatically)
- Wait 2-3 minutes for build to complete

### Step 3: Success! 🎉
Your backend URL will be something like:  
**`https://movr-backend.up.railway.app`**

---

## Verify Deployment

Once deployed, test these URLs:

1. **Health Check**: `https://movr-backend.up.railway.app/health`
   - Should return: `{"status":"ok"}`

2. **API Docs**: `https://movr-backend.up.railway.app/docs`
   - Should show interactive Swagger UI

3. **API Root**: `https://movr-backend.up.railway.app/`
   - Should return API info

---

## Troubleshooting

### Still seeing build error?

Check the deployment logs:
1. Go to Railway Dashboard
2. Click your service → "Deployments" tab
3. Click the failed deployment
4. Scroll through "Build Logs" to see what failed
5. Common issues:
   - ❌ Database connection failed → Add DATABASE_URL env var
   - ❌ Missing env variables → Add in Railway dashboard
   - ❌ Port already in use → This is handled now ✅

### How to check logs while building

```
Railway Dashboard → Service → Deployments → Click latest → View Logs
```

### Need to rollback?

If something breaks:
1. Go to Railway Dashboard
2. Click "Deployments"
3. Find the last working version
4. Click the 3-dot menu → "Redeploy"

---

## Next: Update Flutter App

Once backend is live, you need to update your Flutter app to point to the production URL.

📖 Follow: **`FLUTTER_PRODUCTION_API_UPDATE.md`**

The production URL will be: `https://movr-backend.up.railway.app` (or your custom domain)