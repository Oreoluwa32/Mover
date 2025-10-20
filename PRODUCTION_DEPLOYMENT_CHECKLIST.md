# ✅ Production Deployment Checklist - 30 Minutes to Live

**Goal**: Get your backend live on Railway and connected to Flutter app by end of this checklist.

---

## 🚀 PHASE 1: Prepare (5 minutes)

- [ ] Backend code is on GitHub (check: https://github.com/YOUR_USERNAME/Movr)
- [ ] `.env` file is NOT committed to Git (check: `.gitignore` contains `.env`)
- [ ] Dockerfile exists at `backend/Dockerfile`
- [ ] `requirements.txt` exists at `backend/requirements.txt`
- [ ] All dependencies are listed in `requirements.txt` (run `pip freeze > requirements.txt`)

**Quick Check:**
```bash
cd c:\Users\oreol\Documents\Projects\Movr
git status
# Should show files to commit but NOT .env file
```

---

## 🚂 PHASE 2: Create Railway Services (10 minutes)

### A. Create Railway Project
- [ ] Go to https://railway.app
- [ ] Click "Start Free"
- [ ] Sign in with GitHub
- [ ] Create new project

### B. Add PostgreSQL Database
- [ ] Click "+ New" → "Database" → "PostgreSQL"
- [ ] Wait for provisioning (2-3 minutes)
- [ ] Go to PostgreSQL settings
- [ ] Copy **PostgreSQL Connection URL** from "Connect" tab
- [ ] Save it: `postgresql+psycopg://...` format
- [ ] Paste into your notes for Step 3

### C. Add Redis Cache
- [ ] Click "+ New" → "Database" → "Redis"
- [ ] Wait for provisioning (1-2 minutes)
- [ ] Go to Redis settings
- [ ] Copy **Redis Connection URL** from "Connect" tab
- [ ] Save it: `redis://...` format
- [ ] Paste into your notes for Step 3

### D. Deploy Backend Service
- [ ] Click "+ New" → "GitHub Repo"
- [ ] Select your **Movr** repository
- [ ] Click "Deploy"
- [ ] Wait for initial deployment (2-3 minutes)
- [ ] **IMPORTANT**: It will FAIL without environment variables (that's normal!)
- [ ] Go to "Deployments" tab and note your service URL: `https://your-app.up.railway.app`

---

## ⚙️ PHASE 3: Configure Environment Variables (10 minutes)

### A. Backend Service Configuration
- [ ] Go to your backend service in Railway dashboard
- [ ] Click "Variables" tab
- [ ] Click "+ New Variable" for each:

```
DEBUG=False
API_TITLE=Movr API
API_VERSION=1.0.0
ENVIRONMENT=production
SECRET_KEY=[Generate: python -c "import secrets; print(secrets.token_urlsafe(32))"]
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7
```

### B. Database Connection
- [ ] Add PostgreSQL connection:
```
DATABASE_URL=[Paste PostgreSQL URL from Railway]
```

### C. Redis Connection
- [ ] Add Redis connection:
```
REDIS_URL=[Paste Redis URL from Railway]
```

### D. External Services (if configured)
- [ ] Add Monnify keys:
```
MONNIFY_API_KEY=[Your Monnify API key]
MONNIFY_SECRET_KEY=[Your Monnify Secret key]
MONNIFY_CONTRACT_CODE=[Your contract code]
```

- [ ] Add Cloudinary keys:
```
CLOUDINARY_CLOUD_NAME=[Your cloud name]
CLOUDINARY_API_KEY=[Your API key]
CLOUDINARY_API_SECRET=[Your API secret]
```

- [ ] Add SendGrid key:
```
SENDGRID_API_KEY=[Your SendGrid API key]
SENDGRID_FROM_EMAIL=noreply@movr.app
```

### E. CORS Configuration
- [ ] Add CORS origins:
```
ALLOWED_ORIGINS=["https://your-domain.com"]
```
(Keep it simple for now, can update later)

---

## 🧪 PHASE 4: Verify Deployment (5 minutes)

### A. Test Health Endpoint
- [ ] Open browser: `https://your-railway-url.up.railway.app/health`
- [ ] Should return:
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "environment": "production"
}
```
- [ ] If 502 error: Wait 2-3 more minutes, Railway might still be deploying

### B. Test Swagger Documentation
- [ ] Open: `https://your-railway-url.up.railway.app/docs`
- [ ] Should show Swagger UI with all API endpoints
- [ ] Click "GET /health" → "Try it out" → "Execute"
- [ ] Should work ✅

### C. Check Logs for Errors
- [ ] Go to Railway backend service
- [ ] Click "Logs" tab
- [ ] Scroll to bottom to see latest logs
- [ ] Should see: `"Movr API v1.0.0 initialized in production mode"`
- [ ] Should NOT see any errors about database connection
- [ ] If errors: Go back to Phase 3 and verify all variables

---

## 📱 PHASE 5: Update Flutter App (5 minutes)

### A. Find Your Production URL
- [ ] Go to Railway dashboard → Backend service
- [ ] Click "Deployments" tab
- [ ] Copy the URL: `https://your-app.up.railway.app`

### B. Update Flutter API Configuration
- [ ] Open `lib/core/app_export.dart`
- [ ] Find line with `API_BASE_URL` or similar constant
- [ ] **Change from:**
```dart
const String API_BASE_URL = 'http://localhost:8000';
```
- [ ] **Change to:**
```dart
const String API_BASE_URL = 'https://your-railway-url.up.railway.app';
```
- [ ] Save the file

### C. Rebuild Flutter App
```bash
flutter clean
flutter pub get
flutter run
```

### D. Test in App
- [ ] Open the Flutter app
- [ ] Try to **Register** a new user
- [ ] Enter test data:
  - Email: `testuser@movr.app`
  - Password: `TestPassword123`
  - First Name: `Test`
  - Last Name: `User`
- [ ] Should succeed and return tokens
- [ ] Try to **Login** with same credentials
- [ ] Should work ✅

---

## 🔍 PHASE 6: Verification (5 minutes)

Before showing to supervisor, verify all these:

- [ ] Backend health check works: `https://your-url.up.railway.app/health` ✅
- [ ] Swagger docs load: `https://your-url.up.railway.app/docs` ✅
- [ ] Flutter app can register new user ✅
- [ ] Flutter app can login ✅
- [ ] No CORS errors in Flutter console ✅
- [ ] No database errors in Railway logs ✅

---

## 📊 PHASE 7: Show Your Supervisor

### Live Demo Points:
1. **Show the API is running:**
   - Open: `https://your-railway-url.up.railway.app/docs`
   - Click on an endpoint, click "Execute"
   - Show response ✅

2. **Show the database is working:**
   - In Railway, click PostgreSQL plugin
   - Show users table with test data ✅

3. **Show the Flutter app is connected:**
   - Open Flutter app
   - Register new user
   - Show success message ✅

4. **Show production URL:**
   - Share the URL: `https://your-railway-url.up.railway.app`
   - Show it's live and accessible from any device ✅

---

## 🆘 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| 502 Bad Gateway | Wait 3-5 minutes, Railway might be deploying |
| Connection refused to database | Check `DATABASE_URL` in Railway variables, ensure PostgreSQL plugin is running |
| CORS error from Flutter | Add Flutter app domain to `ALLOWED_ORIGINS` in variables |
| "ModuleNotFoundError" in logs | Ensure `requirements.txt` is up to date: `pip freeze > requirements.txt` |
| Can't find PostgreSQL URL | Go to PostgreSQL plugin → "Connect" tab → copy from there |

---

## 📞 If Stuck

1. **Check Railway Logs:**
   - Backend service → "Logs" tab → see what's actually failing

2. **Read the Error Message:**
   - Most errors tell you exactly what's wrong

3. **Verify Environment Variables:**
   - Go to Variables tab → check all variables are there
   - No spaces before/after values

4. **Restart Deployment:**
   - Go to "Deployments" tab
   - Click "Redeploy" on latest deployment

---

## ✅ Success!

Once you reach this point, your backend is **live in production** and:

- ✅ Accessible from anywhere (not just locally)
- ✅ Running on Railway's servers (you don't manage servers)
- ✅ Automatically scales if needed
- ✅ Has HTTPS/SSL included
- ✅ Data is persisted in PostgreSQL
- ✅ Cache working via Redis
- ✅ Connected to Flutter app

**Your supervisor can now:**
- See the live API
- Test the Flutter app
- View real data in the database
- Verify everything works

---

## 🎯 Next Steps (After Demo)

1. Add custom domain (optional but looks professional)
2. Set up error alerts with Sentry
3. Enable database backups
4. Add monitoring for performance
5. Plan for scaling (automatic on Railway)

**Enjoy your live app! 🚀**