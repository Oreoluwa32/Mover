from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import HTTPException, status, Depends, Header
from sqlalchemy.orm import Session
from app.config import settings
from app.database import get_db
import bcrypt

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    """Hash a password using bcrypt (truncated to 72 bytes for bcrypt compatibility)"""
    # bcrypt has a 72 byte limit - must truncate at byte level, not character level
    # Encode to UTF-8, truncate to 72 bytes
    password_bytes = password.encode('utf-8')[:72]
    # Hash directly with bcrypt to avoid re-encoding by passlib
    hashed = bcrypt.hashpw(password_bytes, bcrypt.gensalt())
    return hashed.decode('utf-8')

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against its hash (truncated to 72 bytes for bcrypt compatibility)"""
    # bcrypt has a 72 byte limit - truncate at byte level, not character level
    # Encode to UTF-8, truncate to 72 bytes
    password_bytes = plain_password.encode('utf-8')[:72]
    # Verify directly with bcrypt
    try:
        return bcrypt.checkpw(password_bytes, hashed_password.encode('utf-8'))
    except ValueError:
        return False

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """
    Create a JWT access token
    
    Args:
        data: Dictionary containing token data
        expires_delta: Optional expiration time delta
    
    Returns:
        Encoded JWT token
    """
    to_encode = data.copy()
    
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire, "iat": datetime.utcnow()})
    encoded_jwt = jwt.encode(
        to_encode, 
        settings.SECRET_KEY, 
        algorithm=settings.ALGORITHM
    )
    
    return encoded_jwt

def create_refresh_token(data: dict) -> str:
    """Create a JWT refresh token"""
    expires_delta = timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    to_encode = data.copy()
    
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire, "iat": datetime.utcnow(), "type": "refresh"})
    
    encoded_jwt = jwt.encode(
        to_encode, 
        settings.SECRET_KEY, 
        algorithm=settings.ALGORITHM
    )
    
    return encoded_jwt

def verify_token(token: str) -> Optional[Dict[str, Any]]:
    """
    Verify and decode a JWT token
    
    Args:
        token: JWT token string
    
    Returns:
        Decoded token payload or None if invalid
    """
    try:
        payload = jwt.decode(
            token, 
            settings.SECRET_KEY, 
            algorithms=[settings.ALGORITHM]
        )
        return payload
    except JWTError:
        return None

def get_user_id_from_token(token: str) -> Optional[str]:
    """Extract user ID from token"""
    payload = verify_token(token)
    if payload:
        return payload.get("sub")
    return None

def raise_unauthorized():
    """Raise unauthorized exception"""
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired token",
        headers={"WWW-Authenticate": "Bearer"},
    )

def raise_forbidden():
    """Raise forbidden exception"""
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="Access forbidden",
    )

def raise_not_found(detail: str = "Resource not found"):
    """Raise not found exception"""
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=detail,
    )

def raise_conflict(detail: str):
    """Raise conflict exception"""
    raise HTTPException(
        status_code=status.HTTP_409_CONFLICT,
        detail=detail,
    )

async def get_current_user(
    authorization: Optional[str] = Header(None, alias="Authorization"),
    db: Session = Depends(get_db)
):
    """
    FastAPI dependency to get the current authenticated user from JWT token.
    
    Args:
        authorization: Authorization header containing "Bearer <token>"
        db: Database session
    
    Returns:
        User object if valid token, raises HTTPException otherwise
    """
    import logging
    logger = logging.getLogger(__name__)
    logger.debug(f"Auth header received: {authorization is not None}")
    
    if not authorization:
        logger.error("No authorization header provided")
        raise_unauthorized()
    
    # Extract token from "Bearer <token>" format
    try:
        scheme, token = authorization.split()
        if scheme.lower() != "bearer":
            logger.error(f"Invalid scheme: {scheme}")
            raise_unauthorized()
    except ValueError as e:
        logger.error(f"Failed to parse authorization header: {e}")
        raise_unauthorized()
    
    # Verify token and get payload
    logger.debug(f"Verifying token: {token[:20]}...")
    payload = verify_token(token)
    if not payload:
        logger.error("Token verification failed")
        raise_unauthorized()
    
    # Get user ID from token
    user_id = payload.get("sub")
    if not user_id:
        raise_unauthorized()
    
    # Fetch user from database
    from app.models.user import User
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        raise_unauthorized()
    
    # Check if user is active
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account is inactive",
        )
    
    return user