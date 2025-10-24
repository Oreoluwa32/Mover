from sqlalchemy import Column, String, Boolean, Float, Integer, Enum, DateTime
from app.models.base import BaseModel
from datetime import datetime
import enum

class UserRole(str, enum.Enum):
    CUSTOMER = "customer"
    DRIVER = "driver"
    ADMIN = "admin"

class User(BaseModel):
    __tablename__ = "users"
    
    # Authentication
    email = Column(String, unique=True, index=True, nullable=False)
    phone = Column(String, unique=True, index=True, nullable=True)
    password_hash = Column(String, nullable=False)
    
    # Profile Information
    first_name = Column(String, nullable=True)
    last_name = Column(String, nullable=True)
    profile_image_url = Column(String, nullable=True)
    
    # Role & Status
    role = Column(Enum(UserRole), default=UserRole.CUSTOMER, nullable=False)
    is_active = Column(Boolean, default=True)
    is_verified = Column(Boolean, default=False)
    is_banned = Column(Boolean, default=False)
    
    # Location & Live Status (for drivers)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    last_location_update = Column(DateTime, nullable=True)
    is_live = Column(Boolean, default=False)  # Whether user is actively sharing location
    
    # Ratings
    average_rating = Column(Float, default=5.0)
    total_ratings = Column(Integer, default=0)
    
    # Wallet
    wallet_balance = Column(Float, default=0.0)
    
    # Authentication
    last_login = Column(DateTime, nullable=True)
    
    # Email Verification
    email_verified_at = Column(DateTime, nullable=True)
    verification_otp = Column(String, nullable=True)  # 6-digit OTP
    otp_created_at = Column(DateTime, nullable=True)  # Track OTP expiration
    otp_attempts = Column(Integer, default=0)  # Track failed OTP attempts
    
    # Password Reset
    reset_token = Column(String, nullable=True, unique=True, index=True)  # Unique reset token
    reset_token_created_at = Column(DateTime, nullable=True)  # Track token expiration
    reset_token_used = Column(Boolean, default=False)  # Track if token was already used
    
    def __repr__(self):
        return f"<User {self.email}>"