# Movr Backend Startup Checklist

Complete this checklist to launch your backend successfully!

## ✅ Phase 1: Local Environment Setup (Day 1-2)

### Prerequisites Installation
- [ ] Install Python 3.10+ from python.org
- [ ] Install Docker Desktop from docker.com
- [ ] Install Git (git-scm.com)
- [ ] Install Visual Studio Code or your preferred IDE

### Python Setup
- [ ] Create virtual environment: `python -m venv venv`
- [ ] Activate virtual environment
  - Windows: `venv\Scripts\activate`
  - Mac/Linux: `source venv/bin/activate`
- [ ] Install dependencies: `pip install -r requirements.txt`

### Docker Services
- [ ] Start services: `docker-compose up -d`
- [ ] Verify PostgreSQL: `docker-compose ps`
- [ ] Test database connection via Adminer: http://localhost:8080
  - Username: postgres
  - Password: password
  - Server: postgres
  - Database: movr

### FastAPI Server
- [ ] Run: `uvicorn app.main:app --reload`
- [ ] Access Swagger UI: http://localhost:8000/docs
- [ ] Test health endpoint: http://localhost:8000/health
- [ ] **Expected Response:**
  ```json
  {
    "status": "healthy",
    "version": "1.0.0",
    "environment": "development"
  }
  ```

---

## ✅ Phase 2: Configuration (Day 2-3)

### External Services Registration

**Monnify (Payments - Nigeria)**
- [ ] Create account at https://app.monnify.com
- [ ] Get test credentials
- [ ] Add to `.env`:
  ```env
  MONNIFY_API_KEY=your_test_key
  MONNIFY_SECRET_KEY=your_test_secret
  MONNIFY_CONTRACT_CODE=your_contract_code
  ```

**Cloudinary (File Storage)**
- [ ] Create account at https://cloudinary.com
- [ ] Get API credentials
- [ ] Add to `.env`:
  ```env
  CLOUDINARY_CLOUD_NAME=your_cloud_name
  CLOUDINARY_API_KEY=your_api_key
  CLOUDINARY_API_SECRET=your_api_secret
  ```

**SendGrid (Email)**
- [ ] Create account at https://sendgrid.com
- [ ] Create API key
- [ ] Add to `.env`:
  ```env
  SENDGRID_API_KEY=your_api_key
  SENDGRID_FROM_EMAIL=noreply@movr.app
  ```

**Sentry (Error Tracking - Optional)**
- [ ] Create account at https://sentry.io
- [ ] Create project for Python
- [ ] Get DSN
- [ ] Add to `.env`:
  ```env
  SENTRY_DSN=your_dsn
  ```

### Environment Configuration
- [ ] Copy `.env.example` to `.env`
- [ ] Update all values in `.env`
- [ ] **NEVER commit `.env` to Git**
- [ ] Verify `.gitignore` includes `.env`

---

## ✅ Phase 3: API Testing (Day 3-4)

### Test User Registration
- [ ] POST to http://localhost:8000/api/v1/auth/register
- [ ] Body:
  ```json
  {
    "email": "test@movr.app",
    "phone": "08000000000",
    "password": "SecurePass123",
    "first_name": "John",
    "last_name": "Doe",
    "role": "customer"
  }
  ```
- [ ] **Expected Response:**
  ```json
  {
    "access_token": "eyJ0eXAi...",
    "refresh_token": "eyJ0eXAi...",
    "token_type": "bearer",
    "expires_in": 1800
  }
  ```

### Test User Login
- [ ] POST to http://localhost:8000/api/v1/auth/login
- [ ] Body:
  ```json
  {
    "email": "test@movr.app",
    "password": "SecurePass123"
  }
  ```
- [ ] Verify tokens are returned

### Test Database
- [ ] Check user was created:
  ```bash
  docker-compose exec postgres psql -U postgres -d movr
  SELECT * FROM users;
  \q
  ```

---

## ✅ Phase 4: Testing & Code Quality (Day 4-5)

### Run Unit Tests
- [ ] Run all tests: `pytest`
- [ ] Run with coverage: `pytest --cov=app`
- [ ] All tests should pass ✓

### Code Formatting
- [ ] Format code: `black app/`
- [ ] Lint code: `flake8 app/`
- [ ] Fix any issues

### Test Auth Endpoints
- [ ] Run: `pytest tests/test_auth.py -v`
- [ ] Verify all tests pass

---

## ✅ Phase 5: Connect to Flutter App (Week 2)

### Update Flutter App Configuration
- [ ] Open `frontend/lib/core/app_export.dart`
- [ ] Update API base URL:
  ```dart
  const String API_BASE_URL = 'http://localhost:8000';
  ```
- [ ] For device testing, use your machine's IP:
  ```dart
  const String API_BASE_URL = 'http://192.168.1.x:8000'; // Your IP
  ```

### Test API Connection
- [ ] Build Flutter app
- [ ] Try login/registration
- [ ] Check backend logs: `docker-compose logs -f backend`
- [ ] Monitor network requests in Swagger UI

---

## ✅ Phase 6: Production Preparation (Week 3)

### Choose Hosting Platform

**Option A: Railway.app (Recommended for MVP)**
- [ ] Create account at https://railway.app
- [ ] Connect GitHub repository
- [ ] Add environment variables:
  - `DATABASE_URL=postgresql://...`
  - `REDIS_URL=redis://...`
  - All Monnify, Cloudinary, SendGrid keys
- [ ] Deploy from dashboard

**Option B: Render.com**
- [ ] Create account at https://render.com
- [ ] Connect GitHub repository
- [ ] Configure PostgreSQL database
- [ ] Set environment variables
- [ ] Deploy

**Option C: DigitalOcean App Platform**
- [ ] Create account at https://digitalocean.com
- [ ] Create Docker container app
- [ ] Upload Dockerfile and docker-compose
- [ ] Configure PostgreSQL managed database
- [ ] Deploy

### Domain Setup (Optional)
- [ ] Register domain at namecheap.com or similar
- [ ] Point DNS to hosting provider
- [ ] Get SSL certificate (auto-provided by most platforms)

### Production Environment File
- [ ] Create `.env.production`:
  ```env
  DEBUG=False
  ENVIRONMENT=production
  
  DATABASE_URL=postgresql://prod_user:prod_pass@prod_host:5432/movr
  REDIS_URL=redis://prod_host:6379/0
  
  SECRET_KEY=your-long-random-secret-key
  ALLOWED_ORIGINS=https://yourdomain.com,https://api.yourdomain.com
  ```

### Deployment Steps
- [ ] Push code to main branch
- [ ] Platform deploys automatically (if CI/CD configured)
- [ ] Test production API
- [ ] Monitor errors in Sentry

---

## ✅ Phase 7: Mobile App Integration (Week 3+)

### Update Flutter App for Production
- [ ] Change API_BASE_URL to production endpoint
- [ ] Rebuild APK/iOS
- [ ] Test all features:
  - [ ] User registration
  - [ ] Login
  - [ ] Profile management
  - [ ] Ride requests
  - [ ] Payments (test mode)

### Real-time Features (if needed)
- [ ] Implement WebSocket for location tracking
- [ ] Test live driver tracking
- [ ] Test real-time notifications

---

## ✅ Troubleshooting Guide

### Issue: Database Connection Failed
```bash
# Check PostgreSQL is running
docker-compose ps

# Restart
docker-compose restart postgres

# Check logs
docker-compose logs postgres
```

### Issue: Port 5432 Already in Use
```bash
# Windows
netstat -ano | findstr :5432

# Mac/Linux
lsof -i :5432

# Kill process or change port in docker-compose.yml
```

### Issue: Virtual Environment Not Working
```bash
# Deactivate and reactivate
deactivate
venv\Scripts\activate  # Windows
source venv/bin/activate  # Mac/Linux

# Or create new one
rm -r venv
python -m venv venv
```

### Issue: Dependencies Won't Install
```bash
# Upgrade pip
python -m pip install --upgrade pip

# Clear cache
pip cache purge

# Reinstall
pip install -r requirements.txt
```

### Issue: ModuleNotFoundError
```bash
# Make sure you're in backend directory
cd backend

# Activate virtual environment
source venv/bin/activate  # or appropriate command

# Try import
python -c "import fastapi"
```

---

## 📞 Quick Commands Reference

```bash
# Start development
docker-compose up -d
source venv/bin/activate
uvicorn app.main:app --reload

# Stop services
docker-compose down

# View logs
docker-compose logs -f postgres

# Run tests
pytest
pytest tests/test_auth.py -v
pytest --cov=app

# Format code
black app/
flake8 app/

# Access database
docker-compose exec postgres psql -U postgres -d movr

# Create backup
docker-compose exec postgres pg_dump -U postgres movr > backup.sql

# Check health
curl http://localhost:8000/health
```

---

## 📋 Deployment Checklist

Before deploying to production:

- [ ] All tests passing (`pytest`)
- [ ] Code formatted with black
- [ ] No linting errors (flake8)
- [ ] All secrets in `.env.production`
- [ ] Database migrated to production
- [ ] Sentry configured
- [ ] CORS origins updated
- [ ] SSL certificate configured
- [ ] Database backups configured
- [ ] Monitoring alerts set up
- [ ] API documentation accessible
- [ ] Health check working
- [ ] Test payment gateway configured
- [ ] Email service tested

---

## 🚀 Success Indicators

Your backend is ready when:

✅ API returns 200 on `/health`
✅ User registration works end-to-end
✅ JWT tokens are issued correctly
✅ Database shows new users after registration
✅ All tests pass
✅ Flutter app can connect and login
✅ Monnify payments work in test mode
✅ Files upload to Cloudinary
✅ Emails send via SendGrid
✅ Errors tracked in Sentry
✅ Real-time features work (WebSocket)
✅ Production deployment successful

---

## 📞 Support Resources

- FastAPI Docs: https://fastapi.tiangolo.com
- SQLAlchemy: https://docs.sqlalchemy.org
- PostgreSQL: https://www.postgresql.org/docs
- Railway.app: https://docs.railway.app
- Render: https://render.com/docs
- Monnify: https://docs.monnify.com

---

## Next Steps

1. **Complete Phase 1**: Get local environment running
2. **Complete Phase 2**: Configure all external services
3. **Complete Phase 3**: Test all API endpoints
4. **Complete Phase 4**: Ensure code quality
5. **Complete Phase 5**: Integrate with Flutter
6. **Complete Phase 6**: Deploy to production
7. **Complete Phase 7**: Test on mobile

**Estimated Timeline**: 3-4 weeks for full MVP

Good luck! 🚀