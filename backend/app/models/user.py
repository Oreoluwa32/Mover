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
    phone = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    
    # Profile Information
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    profile_image_url = Column(String, nullable=True)
    
    # Role & Status
    role = Column(Enum(UserRole), default=UserRole.CUSTOMER, nullable=False)
    is_active = Column(Boolean, default=True)
    is_verified = Column(Boolean, default=False)
    is_banned = Column(Boolean, default=False)
    
    # Location (for drivers)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    last_location_update = Column(DateTime, nullable=True)
    
    # Ratings
    average_rating = Column(Float, default=5.0)
    total_ratings = Column(Integer, default=0)
    
    # Wallet
    wallet_balance = Column(Float, default=0.0)
    
    # Authentication
    last_login = Column(DateTime, nullable=True)
    
    def __repr__(self):
        return f"<User {self.email}>"