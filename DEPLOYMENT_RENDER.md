# 🚀 Deploy to Render (Free Tier)

Production deployment guide for Movr backend using **Render.com** free tier. No credit card required!

---

## **Why Render?**

✅ **Truly Free:** PostgreSQL + Web Service all free  
✅ **Easy Setup:** GitHub integration, automatic deployments  
✅ **No Sleeping:** Free tier runs 24/7 (unlike some platforms)  
✅ **Scales Later:** Paid tier available when you grow  

---

## **Prerequisites**

- ✅ Code pushed to GitHub (main branch)
- ✅ Render.com account (https://render.com) - sign up with GitHub
- ✅ `backend/Dockerfile` ready (already done!)

---

## **Step 1: Create PostgreSQL Database**

1. Go to https://dashboard.render.com
2. Left sidebar → **Databases**
3. Click **Create Database**
   - Name: `movr-db`
   - Database: PostgreSQL 15
   - Region: Pick one (e.g., **Ohio** or **Frankfurt**)
   - Plan: **Free**
4. Click **Create**
5. ⏳ Wait ~2 minutes for creation
6. Copy the **Internal Database URL** (save it - you'll need this)
   - Should look like: `postgresql://user:pass@host/dbname`

---

## **Step 2: Deploy Backend**

### 2.1 Create Web Service

1. Left sidebar → **Web Services**
2. Click **Create Web Service**
3. Select **Build and deploy from a Git repository**
4. Connect GitHub:
   - Click **Connect Account** (if needed)
   - Select your **Movr** repository
   - Select branch: **main**
5. Click **Connect**

### 2.2 Configure Build

1. **Name:** `movr-api`
2. **Region:** Same as database
3. **Branch:** `main`
4. **Runtime:** Docker
5. **Build Command:** Leave blank (uses Dockerfile)
6. **Start Command:** Leave blank

⚠️ **IMPORTANT:** Render will auto-detect and use `backend/Dockerfile`

### 2.3 Set Environment Variables

Click **Environment** and add these variables:

```
DEBUG=False
API_TITLE=Movr API
API_VERSION=1.0.0
ENVIRONMENT=production
SECRET_KEY=<generate-a-random-secret-key-here-make-it-long>
PORT=8080

DATABASE_URL=<paste-internal-postgres-url-from-step-1>

PAYSTACK_PUBLIC_KEY=pk_live_your_key
PAYSTACK_SECRET_KEY=sk_live_your_key
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_key
CLOUDINARY_API_SECRET=your_secret
SENDGRID_API_KEY=your_key
SENDGRID_FROM_EMAIL=noreply@movr.app
ALLOWED_ORIGINS=["https://your-domain-or-app-url"]
```

### 2.4 Deploy

1. Click **Create Web Service**
2. ⏳ Render builds and deploys (~3-5 minutes)
3. Check the **Logs** tab to monitor build progress
4. Once done, you'll see a green checkmark and a URL like:
   ```
   https://movr-api-xxxxx.onrender.com
   ```

---

## **Step 3: Verify Deployment**

Once deployment finishes, test these URLs:

### Health Check
```
https://your-app.onrender.com/health
```

Should return:
```json
{"status":"healthy","version":"1.0.0","environment":"production"}
```

### API Documentation
```
https://your-app.onrender.com/docs
```

---

## **Step 4: Handle First Request Delay**

⚠️ **Important:** Render's free tier pauses services after 15 minutes of inactivity.

First request after pause will take 10-15 seconds while the service wakes up. This is normal behavior for free tier.

**Solution:** Add a periodic health check (optional):
- Use an external service like https://uptimerobot.com (free tier)
- Set it to ping `/health` every 10 minutes
- Keeps your service always awake

---

## **Step 5: Update Flutter App**

Replace all API URLs in Flutter code:

**Find:**
```
https://demosystem.pythonanywhere.com
```

**Replace with:**
```
https://your-app.onrender.com
```

See `FLUTTER_PRODUCTION_API_UPDATE.md` for all files that need updating.

---

## **Cost Breakdown**

| Service | Cost | Notes |
|---------|------|-------|
| Web Service | **FREE** | Free tier (wake-on-demand) |
| PostgreSQL | **FREE** | 256 MB free |
| **Total** | **$0** | Truly free for MVP! |

**Upgrade when you need it:**
- PostgreSQL: $7-300+/month (depending on size)
- Web Service: Paid tier for always-on ($7+/month)

---

## **Common Tasks**

### View Logs
1. Go to your Web Service dashboard
2. Click **Logs** tab
3. Real-time logs appear here

### Rebuild & Redeploy
1. Go to **Deployments** tab
2. Click **Manual Deploy**
3. Select branch: `main`

### Update Environment Variables
1. Go to **Environment** tab
2. Edit variables
3. Click **Save Changes**
4. Service auto-redeploys

### Connect to Database
From your local machine:
```bash
psql "<internal-database-url>"
```

---

## **Troubleshooting**

### **Build Fails**
1. Check **Logs** tab for error message
2. Verify `backend/Dockerfile` exists and is valid
3. Ensure all required environment variables are set
4. Check if `requirements.txt` has all dependencies

### **App Crashes on Start**
1. Check **Logs** tab
2. Verify `DATABASE_URL` is correct
3. Ensure `SECRET_KEY` is set and not empty

### **Getting "Cannot find module" errors**
1. Rebuild service: **Manual Deploy** → `main`
2. Make sure Python dependencies in `backend/requirements.txt` are complete

### **First request is slow**
This is normal on free tier! Service wakes from pause. Use UptimeRobot to keep it awake.

---

## **Auto-Deploy on Git Push (Already Enabled!)**

Every time you push to `main`:
1. Render automatically detects the push
2. Builds the Docker image
3. Deploys to production
4. Zero downtime

---

## **Scale to Production (Later)**

When free tier isn't enough:
1. Upgrade Web Service to paid tier (~$7/month)
2. Upgrade PostgreSQL plan (as needed)
3. Same code, no changes needed!

---

**Ready to deploy!** 🚀