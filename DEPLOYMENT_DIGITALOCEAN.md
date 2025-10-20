# 🚀 Deploy to DigitalOcean App Platform

Production deployment guide for Movr backend. DigitalOcean is ideal for MVP scaling with easy transitions to other platforms.

---

## **Prerequisites**

- ✅ Code pushed to GitHub
- ✅ DigitalOcean account (https://digitalocean.com)
- ✅ PostgreSQL & Redis databases created

---

## **Step 1: Create DigitalOcean Resources**

### 1.1 PostgreSQL Database
1. Dashboard → "Databases" → "Create Database"
2. Engine: PostgreSQL 15
3. Cluster name: `movr-db`
4. Region: Same as your app (e.g., New York)
5. Size: `Basic ($15/mo)` - sufficient for MVP
6. Copy connection string from "Connection Details" tab

### 1.2 Redis Database
1. Dashboard → "Databases" → "Create Database"
2. Engine: Redis 7
3. Cluster name: `movr-redis`
4. Region: Same as PostgreSQL
5. Size: `Basic ($15/mo)`
6. Copy connection string

---

## **Step 2: Deploy App to DigitalOcean**

### 2.1 Create App
1. **Dashboard** → "Apps" → "Create App"
2. Select **GitHub** → Choose your Movr repository
3. Select branch: `main`

### 2.2 Configure Build
1. Source: GitHub repo
2. Dockerfile Path: `backend/Dockerfile`
3. Build Context: `backend` (important!)

### 2.3 Set Environment Variables

Click "Environment Variables" and add:

```
DEBUG=False
API_TITLE=Movr API
API_VERSION=1.0.0
ENVIRONMENT=production
SECRET_KEY=<generate-random-string>
PORT=8080

DATABASE_URL=<paste-postgresql-connection-string>
REDIS_URL=<paste-redis-connection-string>

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

### 2.4 Configure HTTP
1. Go to "Components"
2. Click backend service
3. Set HTTP port to `8080`
4. Enable "HTTP to HTTPS Redirect"

### 2.5 Deploy
1. Review all settings
2. Click "Create Resources"
3. Wait 5-10 minutes for build completion
4. Get your public URL: `https://movr-api-xxxxx.ondigitalocean.app`

---

## **Step 3: Verify Deployment**

### Health Check
```
https://your-app.ondigitalocean.app/health
```

Should return:
```json
{"status":"healthy","version":"1.0.0","environment":"production"}
```

### API Docs
```
https://your-app.ondigitalocean.app/docs
```

---

## **Step 4: Update Flutter App**

Replace all API URLs in Flutter:

**Find:**
```
https://demosystem\.pythonanywhere\.com
```

**Replace with:**
```
https://your-app.ondigitalocean.app
```

See `FLUTTER_PRODUCTION_API_UPDATE.md` for all files.

---

## **Cost Breakdown (Monthly)**

| Service | Cost | Notes |
|---------|------|-------|
| App (0.5 CPU) | ~$6 | Starter tier |
| PostgreSQL | ~$15 | Managed database |
| Redis | ~$15 | Managed cache |
| **Total** | ~**$36** | Handles 1000+ users |

---

## **Scaling**

When you grow:
- Upgrade app resources (CPU/RAM)
- Scale database (read replicas)
- Add DigitalOcean Spaces (CDN)

All without changing code!

---

## **Monitoring**

- **Logs:** Apps → Deployments → View logs
- **Metrics:** Apps → Dashboard (CPU, RAM, bandwidth)
- **Database:** Databases → Overview

---

## **Auto-Deploy (Optional)**

Push to `main` → DigitalOcean automatically rebuilds and deploys! 🚀