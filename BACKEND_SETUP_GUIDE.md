# Movr Backend Setup Guide - MVP with Free Tier Services

## Tech Stack (Free Tier MVP)

### Backend Framework
- **FastAPI** (Python) - High performance, async-ready
- **Python 3.10+**

### Databases
- **PostgreSQL** - Free tier (render.com or railway.app)
- **Redis** - Free tier (upstash.com)

### Real-Time
- **WebSockets via FastAPI**
- **Socket.IO** for live tracking

### Infrastructure & Deployment
- **Docker + Docker Compose** - Local development
- **Railway.app** or **Render.com** - Free tier hosting
- **GitHub** - Version control & CI/CD

### External Services (Free Tier)
| Service | Purpose | Free Tier | Notes |
|---------|---------|-----------|-------|
| **Monnify** | Payments (Nigeria) | Per transaction | https://monnify.com |
| **Cloudinary** | File storage (images) | 25GB/month | Free tier adequate for MVP |
| **SendGrid** | Email service | 100 emails/day | Enough for MVP notifications |
| **Sentry** | Error tracking | Free tier | 10k errors/month |
| **GitHub** | Source control & Actions | Unlimited | CI/CD included |
| **Upstash** | Redis (10k commands/day) | Free tier | Sufficient for MVP |
| **Render** | PostgreSQL + Backend hosting | 90 days free | Then $7-15/month |
| **Railway.app** | PostgreSQL + Backend hosting | $5 free credit/month | Perpetual free tier |

---

## Step 1: Local Development Setup (Week 1)

### 1.1 Install Required Tools

```bash
# Python 3.10+ (download from python.org)
python --version

# Git (if not installed)
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Docker Desktop (for containerization)
# Download from docker.com
```

### 1.2 Create Project Structure

```bash
cd c:\Users\oreol\Documents\Projects
# Backend already exists in monorepo

# Create backend directory (if not existing)
mkdir -p Movr/backend
cd Movr/backend
```

### 1.3 Create Virtual Environment

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Mac/Linux
python3 -m venv venv
source venv/bin/activate
```

### 1.4 Create requirements.txt

**File: `backend/requirements.txt`**

```
# Core Framework
fastapi==0.104.1
uvicorn[standard]==0.24.0
python-multipart==0.0.6

# Database
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
alembic==1.13.1

# Authentication & Security
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
pydantic==2.5.0
pydantic-settings==2.1.0

# Real-time
python-socketio==5.10.0
python-engineio==4.8.0

# External Services
requests==2.31.0
python-dotenv==1.0.0
cloudinary==1.36.0

# Utilities
pytz==2023.3
python-dateutil==2.8.2

# Development & Testing
pytest==7.4.3
pytest-asyncio==0.21.1
black==23.12.0
flake8==6.1.0

# Monitoring
sentry-sdk==1.39.1

# Task Queue (optional for MVP, but useful)
redis==5.0.1
```

### 1.5 Install Dependencies

```bash
pip install -r requirements.txt
```

---

## Step 2: Environment Configuration (Week 1)

**File: `backend/.env.example`**

```env
# FastAPI
DEBUG=True
API_TITLE=Movr API
API_VERSION=1.0.0

# Database
DATABASE_URL=postgresql://postgres:password@localhost:5432/movr

# Redis
REDIS_URL=redis://localhost:6379/0

# JWT Authentication
SECRET_KEY=your-secret-key-change-this-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# Paystack Payment
PAYSTACK_PUBLIC_KEY=pk_test_your_public_key
PAYSTACK_SECRET_KEY=sk_test_your_secret_key

# Cloudinary (File Storage)
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret

# SendGrid (Email)
SENDGRID_API_KEY=your-sendgrid-api-key
SENDGRID_FROM_EMAIL=noreply@movr.app

# Sentry (Error Tracking)
SENTRY_DSN=your-sentry-dsn

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8000

# Environment
ENVIRONMENT=development
```

**File: `backend/.env`** (local copy, add to .gitignore)

```env
DEBUG=True
API_TITLE=Movr API
API_VERSION=1.0.0

DATABASE_URL=postgresql://postgres:password@localhost:5432/movr
REDIS_URL=redis://localhost:6379/0

SECRET_KEY=your-local-secret-key-12345
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

PAYSTACK_PUBLIC_KEY=pk_test_your_key
PAYSTACK_SECRET_KEY=sk_test_your_key

CLOUDINARY_CLOUD_NAME=test
CLOUDINARY_API_KEY=test
CLOUDINARY_API_SECRET=test

SENDGRID_API_KEY=test
SENDGRID_FROM_EMAIL=test@movr.app

SENTRY_DSN=

ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8000,http://localhost:8081

ENVIRONMENT=development
```

---

## Step 3: Database Setup (Week 1)

### 3.1 Create docker-compose.yml

**File: `backend/docker-compose.yml`**

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: movr_postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: movr
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: movr_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  adminer:
    image: adminer:latest
    container_name: movr_adminer
    ports:
      - "8080:8080"
    depends_on:
      - postgres

volumes:
  postgres_data:
  redis_data:
```

### 3.2 Start Services

```bash
# Start PostgreSQL and Redis
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f postgres
```

### 3.3 Access Database Management UI

- **Adminer**: http://localhost:8080
- Username: `postgres`
- Password: `password`
- Database: `movr`

---

## Step 4: FastAPI Project Structure (Week 1-2)

### 4.1 Create Main Files

**File: `backend/app/config.py`**

```python
from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    # FastAPI
    DEBUG: bool = True
    API_TITLE: str = "Movr API"
    API_VERSION: str = "1.0.0"
    
    # Database
    DATABASE_URL: str
    
    # Redis
    REDIS_URL: str
    
    # JWT
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    
    # Paystack
    PAYSTACK_PUBLIC_KEY: str
    PAYSTACK_SECRET_KEY: str
    
    # Cloudinary
    CLOUDINARY_CLOUD_NAME: str
    CLOUDINARY_API_KEY: str
    CLOUDINARY_API_SECRET: str
    
    # SendGrid
    SENDGRID_API_KEY: str
    SENDGRID_FROM_EMAIL: str
    
    # Sentry
    SENTRY_DSN: str = ""
    
    # CORS
    ALLOWED_ORIGINS: List[str] = ["http://localhost:3000"]
    
    # Environment
    ENVIRONMENT: str = "development"
    
    class Config:
        env_file = ".env"

settings = Settings()
```

**File: `backend/app/main.py`**

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import sentry_sdk
from app.config import settings

# Initialize Sentry if configured
if settings.SENTRY_DSN:
    sentry_sdk.init(dsn=settings.SENTRY_DSN)

app = FastAPI(
    title=settings.API_TITLE,
    version=settings.API_VERSION,
    debug=settings.DEBUG
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health_check():
    return {"status": "healthy", "version": settings.API_VERSION}

# API Routes will be added here
```

### 4.2 Create Database Models

**File: `backend/app/models/__init__.py`**

```python
from .user import User
from .ride import Ride
from .delivery import Delivery
from .route import Route
from .payment import Payment

__all__ = ["User", "Ride", "Delivery", "Route", "Payment"]
```

**File: `backend/app/models/user.py`**

```python
from sqlalchemy import Column, String, DateTime, Boolean, Float, Integer, Enum
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import enum

Base = declarative_base()

class UserRole(str, enum.Enum):
    CUSTOMER = "customer"
    DRIVER = "driver"
    ADMIN = "admin"

class User(Base):
    __tablename__ = "users"
    
    id = Column(String, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    phone = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    profile_image_url = Column(String, nullable=True)
    role = Column(Enum(UserRole), default=UserRole.CUSTOMER)
    
    # Location
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    
    # Ratings
    average_rating = Column(Float, default=5.0)
    total_ratings = Column(Integer, default=0)
    
    # Status
    is_active = Column(Boolean, default=True)
    is_verified = Column(Boolean, default=False)
    is_banned = Column(Boolean, default=False)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    last_login = Column(DateTime, nullable=True)
```

**File: `backend/app/models/ride.py`**

```python
from sqlalchemy import Column, String, DateTime, Float, Integer, ForeignKey, Enum
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import enum

Base = declarative_base()

class RideStatus(str, enum.Enum):
    REQUESTED = "requested"
    ACCEPTED = "accepted"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class Ride(Base):
    __tablename__ = "rides"
    
    id = Column(String, primary_key=True, index=True)
    customer_id = Column(String, ForeignKey("users.id"), nullable=False)
    driver_id = Column(String, ForeignKey("users.id"), nullable=True)
    
    # Pickup & Dropoff
    pickup_latitude = Column(Float, nullable=False)
    pickup_longitude = Column(Float, nullable=False)
    pickup_address = Column(String, nullable=False)
    
    dropoff_latitude = Column(Float, nullable=False)
    dropoff_longitude = Column(Float, nullable=False)
    dropoff_address = Column(String, nullable=False)
    
    # Status
    status = Column(Enum(RideStatus), default=RideStatus.REQUESTED)
    
    # Pricing
    estimated_fare = Column(Float, nullable=True)
    actual_fare = Column(Float, nullable=True)
    
    # Time
    scheduled_time = Column(DateTime, nullable=True)
    started_at = Column(DateTime, nullable=True)
    completed_at = Column(DateTime, nullable=True)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
```

### 4.3 Create Pydantic Schemas

**File: `backend/app/schemas/__init__.py`**

```python
# Schemas will be imported here
```

**File: `backend/app/schemas/user.py`**

```python
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class UserCreate(BaseModel):
    email: EmailStr
    phone: str
    password: str
    first_name: str
    last_name: str
    role: str = "customer"

class UserResponse(BaseModel):
    id: str
    email: str
    first_name: str
    last_name: str
    phone: str
    profile_image_url: Optional[str] = None
    average_rating: float
    is_verified: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
```

---

## Step 5: Database Connection (Week 2)

**File: `backend/app/database.py`**

```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from app.config import settings

engine = create_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG,
    pool_pre_ping=True,
    pool_recycle=3600,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

---

## Step 6: Authentication Setup (Week 2)

**File: `backend/app/utils/auth.py`**

```python
from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from app.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def verify_token(token: str) -> Optional[dict]:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload
    except JWTError:
        return None
```

---

## Step 7: Create API Routes (Week 2-3)

**File: `backend/app/api/routes/health.py`**

```python
from fastapi import APIRouter

router = APIRouter(prefix="/api/v1", tags=["health"])

@router.get("/health")
async def health_check():
    return {"status": "healthy"}
```

**File: `backend/app/api/routes/auth.py`**

```python
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.user import UserCreate, UserLogin, TokenResponse
from app.utils.auth import hash_password, verify_password, create_access_token
from datetime import timedelta
import uuid

router = APIRouter(prefix="/api/v1/auth", tags=["auth"])

@router.post("/register", response_model=TokenResponse)
async def register(user_data: UserCreate, db: Session = Depends(get_db)):
    # Check if user exists
    from app.models.user import User
    
    existing_user = db.query(User).filter(User.email == user_data.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create user
    user = User(
        id=str(uuid.uuid4()),
        email=user_data.email,
        phone=user_data.phone,
        password_hash=hash_password(user_data.password),
        first_name=user_data.first_name,
        last_name=user_data.last_name,
        role=user_data.role,
    )
    
    db.add(user)
    db.commit()
    
    # Create tokens
    access_token = create_access_token({"sub": user.id, "email": user.email})
    refresh_token = create_access_token(
        {"sub": user.id, "type": "refresh"},
        timedelta(days=7)
    )
    
    return TokenResponse(access_token=access_token, refresh_token=refresh_token)

@router.post("/login", response_model=TokenResponse)
async def login(credentials: UserLogin, db: Session = Depends(get_db)):
    from app.models.user import User
    
    user = db.query(User).filter(User.email == credentials.email).first()
    
    if not user or not verify_password(credentials.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    if not user.is_active:
        raise HTTPException(status_code=403, detail="User account is inactive")
    
    access_token = create_access_token({"sub": user.id, "email": user.email})
    refresh_token = create_access_token(
        {"sub": user.id, "type": "refresh"},
        timedelta(days=7)
    )
    
    return TokenResponse(access_token=access_token, refresh_token=refresh_token)
```

---

## Step 8: Run Locally

```bash
# Activate virtual environment
venv\Scripts\activate  # Windows
# or
source venv/bin/activate  # Mac/Linux

# Install dependencies
pip install -r requirements.txt

# Start services
docker-compose up -d

# Run FastAPI server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Access:**
- API: http://localhost:8000
- Docs: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- Database UI: http://localhost:8080

---

## Step 9: Setup Monnify Integration

### Get Paystack Test Keys

1. Go to https://dashboard.paystack.com (create account if needed)
2. Navigate to Settings → API Keys & Webhooks
3. Copy your TEST keys:
   - Public Key (pk_test_...)
   - Secret Key (sk_test_...)
4. Copy to `.env`:
   - `PAYSTACK_PUBLIC_KEY`
   - `PAYSTACK_SECRET_KEY`

> **Note:** Use LIVE keys (pk_live_..., sk_live_...) in production

**File: `backend/app/utils/payments.py`**

```python
import requests
import base64
from app.config import settings

class MonnifyPayment:
    BASE_URL = "https://api.monnify.com"
    
    def __init__(self):
        self.api_key = settings.MONNIFY_API_KEY
        self.secret_key = settings.MONNIFY_SECRET_KEY
        self.contract_code = settings.MONNIFY_CONTRACT_CODE
    
    def _get_auth_header(self):
        credentials = f"{self.api_key}:{self.secret_key}"
        encoded = base64.b64encode(credentials.encode()).decode()
        return {"Authorization": f"Basic {encoded}"}
    
    def initialize_transaction(self, amount: float, reference: str, 
                              customer_name: str, customer_email: str):
        """Initialize payment transaction"""
        url = f"{self.BASE_URL}/api/v1/transactions/init"
        
        payload = {
            "amount": amount,
            "contractCode": self.contract_code,
            "paymentReference": reference,
            "paymentDescription": "Movr Service Payment",
            "customerName": customer_name,
            "customerEmail": customer_email,
            "incomeSplitConfig": [],
            "redirectUrl": "https://movr.app/payment-callback"
        }
        
        response = requests.post(
            url, 
            json=payload, 
            headers=self._get_auth_header()
        )
        
        return response.json()
    
    def verify_transaction(self, reference: str):
        """Verify payment status"""
        url = f"{self.BASE_URL}/api/v1/transactions/verify/{reference}"
        
        response = requests.get(url, headers=self._get_auth_header())
        
        return response.json()

monnify = MonnifyPayment()
```

---

## Step 10: CI/CD Setup with GitHub Actions (Week 3)

**File: `.github/workflows/tests.yml`**

```yaml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_PASSWORD: password
          POSTGRES_DB: movr
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.10'
    
    - name: Install dependencies
      run: |
        cd backend
        pip install -r requirements.txt
    
    - name: Run tests
      run: |
        cd backend
        pytest
```

---

## Complete Project Structure After Setup

```
Movr/
├── frontend/                          # Flutter app
│   └── lib/
│
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                   # FastAPI app
│   │   ├── config.py                 # Settings
│   │   ├── database.py               # DB connection
│   │   ├── models/
│   │   │   ├── __init__.py
│   │   │   ├── user.py
│   │   │   ├── ride.py
│   │   │   ├── delivery.py
│   │   │   ├── route.py
│   │   │   └── payment.py
│   │   ├── schemas/
│   │   │   ├── __init__.py
│   │   │   └── user.py
│   │   ├── api/
│   │   │   ├── routes/
│   │   │   │   ├── auth.py
│   │   │   │   ├── users.py
│   │   │   │   ├── rides.py
│   │   │   │   ├── deliveries.py
│   │   │   │   ├── payments.py
│   │   │   │   └── routes.py
│   │   │   └── websocket/
│   │   │       └── location_tracking.py
│   │   ├── services/
│   │   │   ├── ride_service.py
│   │   │   ├── payment_service.py
│   │   │   └── notification_service.py
│   │   └── utils/
│   │       ├── auth.py
│   │       ├── payments.py
│   │       └── helpers.py
│   ├── tests/
│   │   ├── __init__.py
│   │   ├── test_auth.py
│   │   └── test_rides.py
│   ├── requirements.txt
│   ├── .env.example
│   ├── .env                          # (git ignored)
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── pytest.ini
│
├── .github/
│   └── workflows/
│       └── tests.yml
│
├── .gitignore
└── README.md
```

---

## Immediate Next Steps (Do This First)

### Week 1 (Days 1-5)
- [ ] Install Python, Git, Docker
- [ ] Create backend folder in your repo
- [ ] Copy all `.py` files from this guide
- [ ] Create `.env` file with dummy values
- [ ] Run `docker-compose up -d`
- [ ] Test database connection via Adminer (http://localhost:8080)

### Week 1 (Days 5-7)
- [ ] Create virtual environment
- [ ] Install dependencies from `requirements.txt`
- [ ] Run FastAPI server locally
- [ ] Test /health endpoint in Swagger UI

### Week 2 (Days 1-3)
- [ ] Get Monnify test account
- [ ] Implement authentication endpoints
- [ ] Write unit tests for auth
- [ ] Test registration & login

### Week 2 (Days 4-7)
- [ ] Implement ride request endpoints
- [ ] Implement ride listing endpoints
- [ ] Test with Postman/Insomnia

### Week 3
- [ ] Setup real-time WebSocket for tracking
- [ ] Deploy to Railway.app or Render.com
- [ ] Connect Flutter app to live backend

---

## Quick Commands Reference

```bash
# Start development
docker-compose up -d
source venv/bin/activate  # or venv\Scripts\activate on Windows
uvicorn app.main:app --reload

# Database
docker-compose exec postgres psql -U postgres -d movr

# Tests
pytest
pytest --cov=app

# Code formatting
black app/
flake8 app/

# Create new model
# Edit app/models/your_model.py then update app/models/__init__.py

# API Documentation
# Automatically generated at http://localhost:8000/docs
```

---

## Need Help?

1. **Database Issues?** → Check Adminer at http://localhost:8080
2. **API Not Starting?** → Check logs: `docker-compose logs fastapi`
3. **Port Already in Use?** → Change port in docker-compose.yml or stop other services
4. **Import Errors?** → Ensure you're in virtual environment and dependencies installed

---

## Free Tier Cost Breakdown for MVP

| Service | Cost | Limit |
|---------|------|-------|
| PostgreSQL (Railway) | Free* | 7 days, then $7/month |
| Redis (Upstash) | Free | 10k commands/day |
| Backend Hosting (Railway) | Free* | $5 credit/month (continuous) |
| Cloudinary | Free | 25GB/month |
| SendGrid | Free | 100 emails/day |
| Monnify Payments | ~2.5% + fees | Per transaction |
| GitHub | Free | Unlimited |
| **Total Monthly** | **~$0 (first 90 days)** | Then ~$12-15/month |

*Railway offers $5 free credits monthly that can cover both database and backend for MVP usage.

---

## What to Do Now

1. **Copy all code files** from this guide
2. **Set up folder structure** exactly as shown
3. **Run local setup** (Docker + Python)
4. **Respond with any issues** and I'll help debug

Ready to start? Let me know when you've completed the local setup!