import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.main import app
from app.database import get_db
from app.models.base import Base

# Use in-memory SQLite for tests
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.create_all(bind=engine)

def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

client = TestClient(app)

@pytest.fixture(scope="function")
def setup_database():
    """Create tables before each test"""
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)

def test_health_check(setup_database):
    """Test health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"

def test_user_registration(setup_database):
    """Test user registration"""
    user_data = {
        "email": "test@example.com",
        "phone": "1234567890",
        "password": "password123",
        "first_name": "Test",
        "last_name": "User",
        "role": "customer"
    }
    
    response = client.post("/api/v1/auth/register", json=user_data)
    assert response.status_code == 201
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data
    assert data["token_type"] == "bearer"

def test_duplicate_email(setup_database):
    """Test registration with duplicate email"""
    user_data = {
        "email": "test@example.com",
        "phone": "1234567890",
        "password": "password123",
        "first_name": "Test",
        "last_name": "User",
    }
    
    # First registration
    response1 = client.post("/api/v1/auth/register", json=user_data)
    assert response1.status_code == 201
    
    # Second registration with same email
    user_data["phone"] = "0987654321"
    response2 = client.post("/api/v1/auth/register", json=user_data)
    assert response2.status_code == 409
    assert "Email already registered" in response2.json()["detail"]

def test_login_success(setup_database):
    """Test successful login"""
    # Register user
    user_data = {
        "email": "test@example.com",
        "phone": "1234567890",
        "password": "password123",
        "first_name": "Test",
        "last_name": "User",
    }
    client.post("/api/v1/auth/register", json=user_data)
    
    # Login
    login_data = {
        "email": "test@example.com",
        "password": "password123"
    }
    response = client.post("/api/v1/auth/login", json=login_data)
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data

def test_login_invalid_password(setup_database):
    """Test login with invalid password"""
    # Register user
    user_data = {
        "email": "test@example.com",
        "phone": "1234567890",
        "password": "password123",
        "first_name": "Test",
        "last_name": "User",
    }
    client.post("/api/v1/auth/register", json=user_data)
    
    # Login with wrong password
    login_data = {
        "email": "test@example.com",
        "password": "wrongpassword"
    }
    response = client.post("/api/v1/auth/login", json=login_data)
    assert response.status_code == 401
    assert "Invalid email or password" in response.json()["detail"]

def test_invalid_email_format(setup_database):
    """Test registration with invalid email"""
    user_data = {
        "email": "invalid-email",
        "phone": "1234567890",
        "password": "password123",
        "first_name": "Test",
        "last_name": "User",
    }
    
    response = client.post("/api/v1/auth/register", json=user_data)
    assert response.status_code == 422  # Validation error