# 🐳 Local Development with Docker Compose

Run your entire stack locally with one command!

---

## **Quick Start**

### Prerequisites
- Docker Desktop (https://www.docker.com/products/docker-desktop)

### 1. Start Everything
```bash
docker-compose up -d
```

Services started:
- ✅ FastAPI Backend (http://localhost:8000)
- ✅ PostgreSQL (localhost:5432)

### 2. Verify
```bash
# Check services
docker-compose ps

# View logs
docker-compose logs -f backend
```

### 3. Access Backend
- **API Docs:** http://localhost:8000/docs
- **Health:** http://localhost:8000/health

---

## **Configuration**

Create `.env` in project root:

```env
DEBUG=True
API_TITLE=Movr API
API_VERSION=1.0.0
ENVIRONMENT=development
SECRET_KEY=dev-key
API_PORT=8000

DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=movr_db
DB_PORT=5432

MONNIFY_API_KEY=
MONNIFY_SECRET_KEY=
MONNIFY_CONTRACT_CODE=
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=
SENDGRID_API_KEY=
SENDGRID_FROM_EMAIL=dev@movr.app
ALLOWED_ORIGINS=["http://localhost:3000","http://localhost:8000"]
```

---

## **Common Commands**

```bash
# View backend logs
docker-compose logs -f backend

# Rebuild backend
docker-compose build --no-cache backend

# Restart backend
docker-compose restart backend

# Access database
docker-compose exec db psql -U postgres -d movr_db

# Stop everything
docker-compose down

# Remove all data
docker-compose down -v
```

---

## **Troubleshooting**

| Issue | Solution |
|-------|----------|
| Port already in use | Change port in docker-compose.yml |
| Docker not running | Open Docker Desktop |
| Build fails | `docker-compose build --no-cache backend` |
| DB connection error | Check DATABASE_URL environment variable |

---

## **Next: Deploy to Production**

When ready: `DEPLOYMENT_RENDER.md`