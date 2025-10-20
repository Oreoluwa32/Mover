from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime
from app.models.user import UserRole

# Request Schemas
class UserCreate(BaseModel):
    email: EmailStr
    phone: str = Field(..., min_length=10, max_length=15)
    password: str = Field(..., min_length=8, max_length=72, description="Password (max 72 characters, longer passwords will be truncated)")
    first_name: str = Field(..., min_length=2, max_length=100)
    last_name: str = Field(..., min_length=2, max_length=100)
    role: UserRole = UserRole.CUSTOMER

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    phone: Optional[str] = None
    profile_image_url: Optional[str] = None

class UpdateLocationRequest(BaseModel):
    latitude: float
    longitude: float

# Response Schemas
class UserResponse(BaseModel):
    id: str
    email: str
    first_name: str
    last_name: str
    phone: str
    profile_image_url: Optional[str] = None
    average_rating: float
    is_verified: bool
    wallet_balance: float
    created_at: datetime
    
    class Config:
        from_attributes = True

class UserProfileResponse(BaseModel):
    id: str
    email: str
    phone: str
    first_name: str
    last_name: str
    profile_image_url: Optional[str] = None
    role: UserRole
    average_rating: float
    total_ratings: int
    wallet_balance: float
    is_verified: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Token Schemas
class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int = 1800  # 30 minutes in seconds

class TokenRefreshRequest(BaseModel):
    refresh_token: str

# Password Reset
class ForgotPasswordRequest(BaseModel):
    email: EmailStr

class ResetPasswordRequest(BaseModel):
    token: str
    new_password: str = Field(..., min_length=8, max_length=72, description="Password (max 72 characters)")

# Pagination
class PaginationParams(BaseModel):
    skip: int = Field(0, ge=0)
    limit: int = Field(10, ge=1, le=100)