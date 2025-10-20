# 🚀 GO LIVE IN 30 MINUTES - Quick Start

**Your supervisor needs to see it working. Let's make it live.**

---

## 📋 Quick Overview

```
Step 1: Backend Code on GitHub (5 min)
Step 2: Deploy to Railway (10 min) 
Step 3: Update Flutter URLs (10 min)
Step 4: Show Your Supervisor (5 min)
```

**Total Time: ~30 minutes**

---

## ✅ STEP 1: GitHub Setup (5 minutes)

### Is your code on GitHub?
- [ ] Yes, I have it on GitHub
- [ ] No, I need to push it first

**If NO:**
```bash
cd c:\Users\oreol\Documents\Projects\Movr
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/Movr.git
git branch -M main
git push -u origin main
```

**Done:** Your code is now on GitHub ✅

---

## ✅ STEP 2: Deploy to Railway (10 minutes)

### 2.1 - Create Railway Account & Services
1. Go to https://railway.app
2. Click "Start Free" → Sign in with GitHub
3. Create new project
4. Add PostgreSQL: Click "+ New" → "Database" → "PostgreSQL" → Wait 2 min
5. Add Redis: Click "+ New" → "Database" → "Redis" → Wait 1 min
6. Deploy Backend: Click "+ New" → "GitHub Repo" → Select "Movr" → Click "Deploy" → Wait 2 min

### 2.2 - Get Connection Strings
- [ ] Go to PostgreSQL plugin → "Connect" tab → Copy URL → Save it
- [ ] Go to Redis plugin → "Connect" tab → Copy URL → Save it
- [ ] Go to Backend service → "Deployments" tab → Note your URL: `https://your-app.up.railway.app`

### 2.3 - Add Environment Variables to Railway Backend
1. Go to Backend service → "Variables" tab
2. Click "+ New Variable" and add these one by one:

```
DEBUG=False
API_TITLE=Movr API
API_VERSION=1.0.0
ENVIRONMENT=production
SECRET_KEY=generate-this-using-python-secrets-or-use-a-random-long-string
DATABASE_URL=[PASTE PostgreSQL URL]
REDIS_URL=[PASTE Redis URL]
MONNIFY_API_KEY=your_key
MONNIFY_SECRET_KEY=your_secret
MONNIFY_CONTRACT_CODE=your_code
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_key
CLOUDINARY_API_SECRET=your_secret
SENDGRID_API_KEY=your_key
SENDGRID_FROM_EMAIL=noreply@movr.app
ALLOWED_ORIGINS=["https://your-domain.com"]
```

### 2.4 - Test Backend
- [ ] Open: `https://your-railway-url.up.railway.app/health`
- [ ] Should return: `{"status":"healthy","version":"1.0.0","environment":"production"}`
- [ ] If 502 error: Wait 3-5 minutes, Railway might be deploying

**Done:** Backend is LIVE ✅

---

## ✅ STEP 3: Update Flutter App URLs (10 minutes)

### 3.1 - Find All Files with Hardcoded URLs

Open VS Code Find & Replace:
```
Ctrl+Shift+H
```

### 3.2 - Replace All Demo URLs

**Find:**
```
https://demosystem\.pythonanywhere\.com
```

**Replace with:**
```
https://your-railway-url.up.railway.app
```

**Example: If your Railway URL is**
```
https://movr-backend-prod.up.railway.app
```

**Replace with:**
```
https://movr-backend-prod.up.railway.app
```

### 3.3 - Specific Endpoint Updates

These files need endpoint updates too (use Find & Replace on each):

| File | Find | Replace |
|------|------|---------|
| create_account_screen.dart | `/register/` | `/api/v1/auth/register` |
| sign_in_screen.dart | `/login/` | `/api/v1/auth/login` |
| check_mail_screen.dart | `/verify-otp/` | `/api/v1/auth/verify-otp` |
| forgot_password_screen.dart | `/forgot-password/` | `/api/v1/auth/forgot-password` |
| reset_password_screen.dart | `/reset-password/` | `/api/v1/auth/reset-password` |

**Full details:** See `FLUTTER_PRODUCTION_API_UPDATE.md`

### 3.4 - Rebuild Flutter App
```bash
flutter clean
flutter pub get
flutter run
```

### 3.5 - Test in App
- [ ] Open Flutter app
- [ ] Try to Register: Enter test email, password, name
- [ ] Should succeed with access token
- [ ] Try to Login with same credentials
- [ ] Should succeed

**Done:** Flutter connects to production ✅

---

## ✅ STEP 4: Show Your Supervisor (5 minutes)

Show them these live:

1. **Open API Documentation:**
   - URL: `https://your-railway-url.up.railway.app/docs`
   - Show Swagger UI with all endpoints
   - Click "GET /health" → Execute → Show response

2. **Open Flutter App:**
   - Register a new user
   - Show success message
   - Show user created in database

3. **Check Database:**
   - Go to Railway → PostgreSQL → Open UI
   - Show users table with test data

4. **Show Production URL:**
   - The API is accessible from anywhere at: `https://your-railway-url.up.railway.app`
   - Can access from mobile, other devices, anywhere

---

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| 502 Bad Gateway | Wait 5 minutes, Railway might be deploying |
| Connection refused to database | Check DATABASE_URL variable in Railway is correct |
| CORS error from Flutter | Make sure you added origin to ALLOWED_ORIGINS |
| "Command not found" | Make sure you're in the right directory or use full path |
| Flutter app won't connect | Make sure URL is updated, check backend logs in Railway |

---

## 📊 What You Get for Free

- **$5/month free credit on Railway**
- Enough for MVP with PostgreSQL + Redis + FastAPI
- Auto-scaling
- HTTPS/SSL included
- Automatic deploys when you push to GitHub

---

## 🎯 Success Criteria

Your supervisor should see:

- ✅ API is live and accessible
- ✅ Documentation (Swagger) works
- ✅ Flutter app connects successfully
- ✅ Database has real users
- ✅ Everything works from a different network (not just localhost)

---

## 📚 Full Documentation

- **Detailed Production Guide:** `PRODUCTION_DEPLOYMENT_GUIDE.md`
- **Flutter URLs Update:** `FLUTTER_PRODUCTION_API_UPDATE.md`
- **Backend Setup:** `BACKEND_GETTING_STARTED.md`

---

## 🚀 You're Ready!

Everything is set up. Just follow this checklist and you'll be live in 30 minutes.

**If you get stuck on anything, read the detailed guide for that step.**

Good luck! 🎉