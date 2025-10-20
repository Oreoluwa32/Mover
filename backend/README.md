# Movr Backend API

FastAPI backend for the Movr transportation platform.

## Quick Start

### Prerequisites
- Python 3.10+
- Docker & Docker Compose
- Git

### Local Setup

1. **Clone & Navigate**
```bash
cd backend
```

2. **Create Virtual Environment**
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Mac/Linux
python3 -m venv venv
source venv/bin/activate
```

3. **Install Dependencies**
```bash
pip install -r requirements.txt
```

4. **Setup Environment Variables**
```bash
cp .env.example .env
# Edit .env with your configuration
```

5. **Start Services**
```bash
docker-compose up -d
```

6. **Run API Server**
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Access Points
- **API Documentation**: http://localhost:8000/docs
- **Alternative Docs**: http://localhost:8000/redoc
- **Database UI**: http://localhost:8080
- **Health Check**: http://localhost:8000/health

---

## Project Structure

```
backend/
├── app/
│   ├── api/                 # API endpoints
│   │   └── routes/
│   ├── models/              # Database models
│   ├── schemas/             # Pydantic schemas
│   ├── services/            # Business logic
│   ├── utils/               # Utility functions
│   ├── config.py            # Configuration
│   ├── database.py          # Database connection
│   └── main.py              # FastAPI app
├── tests/                   # Unit tests
├── requirements.txt         # Dependencies
├── docker-compose.yml       # Local services
└── Dockerfile              # Production image
```

---

## Configuration

### Required Environment Variables

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/movr

# JWT
SECRET_KEY=your-secret-key
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Monnify (Nigeria Payments)
MONNIFY_API_KEY=your_key
MONNIFY_SECRET_KEY=your_secret
MONNIFY_CONTRACT_CODE=your_code

# File Storage (Cloudinary)
CLOUDINARY_CLOUD_NAME=your_cloud
CLOUDINARY_API_KEY=your_key
CLOUDINARY_API_SECRET=your_secret

# Email (SendGrid)
SENDGRID_API_KEY=your_key
SENDGRID_FROM_EMAIL=noreply@movr.app
```

---

## Development

### Running Tests
```bash
pytest
pytest --cov=app          # With coverage
pytest tests/test_auth.py # Specific test file
```

### Code Formatting
```bash
black app/                # Format code
flake8 app/              # Lint code
```

### Database Management

```bash
# View database via Adminer
# Open http://localhost:8080
# User: postgres
# Password: password
# Database: movr

# Access database directly
docker-compose exec postgres psql -U postgres -d movr

# View all tables
\dt

# Exit
\q
```

---

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh access token

### Users
- `GET /api/v1/users/profile` - Get user profile
- `PUT /api/v1/users/profile` - Update profile
- `POST /api/v1/users/location` - Update location

### Rides
- `POST /api/v1/rides` - Request ride
- `GET /api/v1/rides/{ride_id}` - Get ride details
- `PUT /api/v1/rides/{ride_id}/status` - Update ride status

### Payments
- `POST /api/v1/payments/initialize` - Initialize payment
- `GET /api/v1/payments/verify/{reference}` - Verify payment
- `GET /api/v1/payments/history` - Payment history

### Deliveries
- `POST /api/v1/deliveries` - Create delivery
- `GET /api/v1/deliveries/{delivery_id}` - Get delivery details

---

## Deployment

### Docker Build & Run
```bash
# Build image
docker build -t movr-api:latest .

# Run container
docker run -d \
  --name movr-api \
  -p 8000:8000 \
  --env-file .env \
  movr-api:latest
```

### Deploy to Railway.app

1. Install Railway CLI
2. Configure environment variables
3. Deploy:
```bash
railway up
```

### Deploy to Render.com

1. Connect GitHub repository
2. Configure environment variables
3. Deploy from dashboard

---

## Monitoring & Logging

### View Logs
```bash
# Docker logs
docker-compose logs -f backend

# Application logs
tail -f logs/app.log
```

### Performance Monitoring
- Setup Sentry for error tracking
- Configure `SENTRY_DSN` in .env
- View dashboard at sentry.io

---

## Troubleshooting

### Database Connection Error
```bash
# Check if postgres is running
docker-compose ps

# Restart services
docker-compose restart postgres

# Check connection
docker-compose exec postgres psql -U postgres -c "SELECT 1"
```

### Port Already in Use
```bash
# Change port in docker-compose.yml
# Or stop conflicting service
netstat -ano | findstr :5432  # Windows
lsof -i :5432                  # Mac/Linux
```

### Import Errors
```bash
# Verify virtual environment is activated
which python  # Should show venv path

# Reinstall dependencies
pip install -r requirements.txt
```

---

## Contributing

1. Create feature branch: `git checkout -b feature/my-feature`
2. Commit changes: `git commit -am 'Add feature'`
3. Push: `git push origin feature/my-feature`
4. Create Pull Request

---

## License

MIT License - See LICENSE file for details

---

## Support

For issues or questions:
1. Check documentation at `/docs`
2. Review test cases in `tests/`
3. Check GitHub issues
4. Email: dev@movr.app