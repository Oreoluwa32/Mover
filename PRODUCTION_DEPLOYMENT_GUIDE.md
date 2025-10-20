# 🚀 Production Deployment Guide - Movr Backend on Railway

This guide will get your backend live and accessible to your supervisor in **~30 minutes**.

---

## 📋 Prerequisites

- GitHub account (free)
- Railway account (free, sign up at railway.app)
- Backend code pushed to GitHub

---

## 🎯 Step 1: Prepare Your Repository (5 minutes)

### 1.1 Ensure Your Backend is on GitHub

```bash
# Check if git is initialized
cd c:\Users\oreol\Documents\Projects\Movr
git status

# If not initialized, initialize git
git init

# If not added to GitHub, create a new repo on GitHub and:
git remote add origin https://github.com/YOUR_USERNAME/Movr.git
git branch -M main
git push -u origin main
```

### 1.2 Create `.env` file for Production

In `c:\Users\oreol\Documents\Projects\Movr\backend\`, create a new `.env.production` file:

```env
# FastAPI Configuration
DEBUG=False
API_TITLE=Movr API
API_VERSION=1.0.0

# Database (Railway will provide)
DATABASE_URL=postgresql+psycopg://postgres:PASSWORD@HOST:5432/movr

# Redis (Railway will provide)
REDIS_URL=redis://default:PASSWORD@HOST:6379/0

# JWT Authentication - CHANGE THESE IN PRODUCTION
SECRET_KEY=your-production-secret-key-change-this-to-something-long-and-random
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# Monnify Payment
MONNIFY_API_KEY=your_live_api_key
MONNIFY_SECRET_KEY=your_live_secret_key
MONNIFY_CONTRACT_CODE=your_contract_code

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# SendGrid
SENDGRID_API_KEY=SG.your_sendgrid_key
SENDGRID_FROM_EMAIL=noreply@movr.app

# Sentry (Optional)
SENTRY_DSN=

# CORS Configuration - Add your domain here
ALLOWED_ORIGINS=["https://your-domain.com","https://www.your-domain.com"]

# Environment
ENVIRONMENT=production
```

---

## 🚂 Step 2: Set Up Railway (10 minutes)

### 2.1 Create Railway Account
1. Go to https://railway.app
2. Click **"Start Free"**
3. Sign in with GitHub (easier option)
4. Create new project

### 2.2 Add PostgreSQL Database
1. In Railway dashboard, click **"+ New"**
2. Select **"Database"** → **"PostgreSQL"**
3. Wait for it to provision (2-3 minutes)
4. Click on PostgreSQL, go to **"Connect"** tab
5. Copy the connection string under **"Postgres Connection URL"**

### 2.3 Add Redis Cache
1. Click **"+ New"** again
2. Select **"Database"** → **"Redis"**
3. Wait for it to provision
4. Click on Redis, go to **"Connect"** tab
5. Copy the connection string under **"Redis Connection URL"**

### 2.4 Deploy Backend Service
1. In Railway, click **"+ New"** → **"GitHub Repo"**
2. Connect your GitHub account if not already done
3. Select **"Movr"** repository
4. Railway should detect it's a Python project (FastAPI)
5. Click **"Deploy"**

---

## ⚙️ Step 3: Configure Environment Variables in Railway (5 minutes)

### 3.1 Go to Your Backend Service
1. In Railway dashboard, click on your **"app"** or **"backend"** service
2. Go to the **"Variables"** tab

### 3.2 Add Environment Variables
Click **"New Variable"** and add these (in the exact format shown):

```
DEBUG=False
API_TITLE=Movr API
API_VERSION=1.0.0
SECRET_KEY=your-production-secret-key-make-this-very-long-and-random-12345678901234567890
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7
ENVIRONMENT=production
MONNIFY_API_KEY=your_live_api_key
MONNIFY_SECRET_KEY=your_live_secret_key
MONNIFY_CONTRACT_CODE=your_contract_code
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
SENDGRID_API_KEY=SG.your_sendgrid_key
SENDGRID_FROM_EMAIL=noreply@movr.app
SENTRY_DSN=
ALLOWED_ORIGINS=["https://your-domain.com","https://www.your-domain.com"]
```

### 3.3 Add Database Connection
1. Get PostgreSQL connection string from Railway PostgreSQL plugin
2. Create variable:
   ```
   DATABASE_URL=postgresql+psycopg://postgres:PASSWORD@HOST:5432/movr
   ```

### 3.4 Add Redis Connection
1. Get Redis connection string from Railway Redis plugin
2. Create variable:
   ```
   REDIS_URL=redis://default:PASSWORD@HOST:6379/0
   ```

---

## 🌐 Step 4: Get Your Production URL (Immediate)

### 4.1 Find Your Backend URL
1. Go to your backend service in Railway
2. Click **"Deployments"** tab
3. You'll see a URL like: `https://movr-backend.up.railway.app`
4. **This is your production backend URL!**

### 4.2 Test It's Working
Open in browser: `https://your-railway-url.up.railway.app/docs`

You should see Swagger API documentation! 🎉

---

## 📱 Step 5: Update Flutter App to Use Production Backend (10 minutes)

### 5.1 Update API Base URL

In `lib/core/app_export.dart` (or wherever your API base URL is defined):

**Before (Local):**
```dart
const String API_BASE_URL = 'http://localhost:8000';
```

**After (Production):**
```dart
const String API_BASE_URL = 'https://your-railway-url.up.railway.app';
```

### 5.2 Rebuild Flutter App
```bash
flutter clean
flutter pub get
flutter run
```

### 5.3 Test Connection
1. Open the Flutter app
2. Try to register/login
3. Check backend logs in Railway for requests

---

## 🔐 Step 6: Production Security Checklist

- [ ] Change `SECRET_KEY` to a long, random string
- [ ] Set `DEBUG=False`
- [ ] Set `ENVIRONMENT=production`
- [ ] Add your domain to `ALLOWED_ORIGINS`
- [ ] Keep `.env.production` file locally only, never commit to Git
- [ ] Update Monnify keys to **LIVE** keys (not test)
- [ ] Update Cloudinary, SendGrid credentials to production accounts
- [ ] Enable HTTPS (Railway provides this by default)

---

## 📊 Step 7: Monitor Your Backend

### 7.1 View Logs
1. In Railway, go to your backend service
2. Click **"Logs"** tab
3. See all API requests in real-time

### 7.2 Check Metrics
1. Click **"Metrics"** tab
2. Monitor CPU, Memory, Network usage

### 7.3 Set Up Health Checks
Your health endpoint is already configured:
```
GET https://your-railway-url.up.railway.app/health
```

Response:
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "environment": "production"
}
```

---

## 💰 Step 8: Understand Railway Pricing

### Free Tier:
- **$5/month free credit**
- Perfect for MVP
- PostgreSQL + Redis + Backend all fit within free tier

### What You Get for Free:
- PostgreSQL database (5GB)
- Redis cache (1GB)
- FastAPI backend (512MB RAM)
- Auto-scaling
- SSL/HTTPS included

### Cost Breakdown:
- PostgreSQL: ~$20/month (included in free tier for MVP)
- Redis: ~$10/month (included in free tier)
- Backend: ~$10/month (included in free tier)
- **Total for MVP: $5/month (free credit covers it)**

---

## 🔄 Step 9: Continuous Deployment

### Auto-Deploy on Git Push
1. Railway automatically deploys when you push to GitHub
2. Go to **"Deployments"** tab to see all deployments
3. Each push to `main` branch triggers a new deployment

### To Deploy New Version:
```bash
# Make changes locally
git add .
git commit -m "Update backend"
git push origin main

# Railway automatically deploys in 2-3 minutes
```

---

## 🚨 Common Production Issues & Fixes

### Issue: "Connection refused" to database
**Solution:**
- Wait 5-10 minutes for Railway to provision services
- Check PostgreSQL plugin is running
- Verify `DATABASE_URL` is correct

### Issue: "CORS error" from Flutter app
**Solution:**
- Add your flutter app domain to `ALLOWED_ORIGINS`
- For local testing: add `http://localhost:8081`
- Format must be: `["https://domain.com","http://localhost:8081"]`

### Issue: "ModuleNotFoundError" in logs
**Solution:**
- Ensure `requirements.txt` is in backend directory
- Railway will run: `pip install -r requirements.txt` automatically
- Check Dockerfile is properly set up

### Issue: Port conflicts
**Solution:**
- Railway automatically assigns port 8000
- No need to configure port

---

## ✅ Verification Checklist

Before showing to supervisor, verify:

- [ ] Backend URL works: `https://your-url.up.railway.app/health`
- [ ] Swagger docs load: `https://your-url.up.railway.app/docs`
- [ ] Database is connected (check in PostgreSQL plugin)
- [ ] Redis is connected (check in Redis plugin)
- [ ] Flutter app connects to production backend
- [ ] Can register new user from app
- [ ] User appears in PostgreSQL database
- [ ] Can login and get tokens

---

## 📞 Quick Links

- **Railway Dashboard**: https://railway.app/dashboard
- **Backend Swagger Docs**: `https://your-url.up.railway.app/docs`
- **Backend ReDoc**: `https://your-url.up.railway.app/redoc`
- **PostgreSQL Admin**: Available via Railway plugin
- **Redis Admin**: Available via Railway Redis plugin

---

## 🎉 You're Done!

Your backend is now live! Show your supervisor:
1. The live API URL
2. The Swagger documentation
3. The working Flutter app connected to production
4. The database with real data

**Next Steps for Production:**
1. Add custom domain (optional, but looks professional)
2. Set up email notifications for errors
3. Monitor performance metrics
4. Plan for scaling (automatic on Railway)

---

## 📚 Additional Resources

- **Railway Docs**: https://docs.railway.app
- **FastAPI Deployment**: https://fastapi.tiangolo.com/deployment/
- **PostgreSQL Best Practices**: https://www.postgresql.org/docs/current/sql-syntax.html