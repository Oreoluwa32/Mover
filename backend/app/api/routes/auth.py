from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.user import (
    UserCreate, UserLogin, TokenResponse, GoogleAuthRequest,
    SendOTPRequest, VerifyOTPRequest, OTPResponse, VerificationResponse
)
from app.models.user import User
from app.utils.auth import hash_password, verify_password, create_access_token, create_refresh_token
from app.utils.email import generate_otp, send_otp_email, send_verification_email
from datetime import timedelta, datetime
import uuid
import logging

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api/v1/auth", tags=["Authentication"])

OTP_EXPIRY_MINUTES = 10  # OTP expires in 10 minutes
MAX_OTP_ATTEMPTS = 5  # Maximum failed OTP attempts

@router.post("/register", response_model=OTPResponse, status_code=status.HTTP_201_CREATED)
async def register(user_data: UserCreate, db: Session = Depends(get_db)):
    """
    Register a new user and send OTP for email verification
    
    - **email**: User's email address (must be unique)
    - **password**: User's password (minimum 8 characters)
    - **phone**: User's phone number (optional, must be unique if provided)
    - **first_name**: User's first name (optional)
    - **last_name**: User's last name (optional)
    - **role**: User role (customer/driver/admin)
    
    Returns OTP response with message and email. User must verify with /verify-otp endpoint.
    """
    # Check if email exists
    existing_email = db.query(User).filter(User.email == user_data.email).first()
    if existing_email:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already registered"
        )
    
    # Check if phone exists (only if phone is provided)
    if user_data.phone:
        existing_phone = db.query(User).filter(User.phone == user_data.phone).first()
        if existing_phone:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Phone number already registered"
            )
    
    # Generate OTP
    otp = generate_otp()
    
    # Create new user
    user = User(
        id=str(uuid.uuid4()),
        email=user_data.email,
        phone=user_data.phone,
        password_hash=hash_password(user_data.password),
        first_name=user_data.first_name,
        last_name=user_data.last_name,
        role=user_data.role,
        is_active=True,
        is_verified=False,  # Not verified until OTP is confirmed
        verification_otp=otp,
        otp_created_at=datetime.utcnow(),
        otp_attempts=0,
    )
    
    try:
        db.add(user)
        db.commit()
        db.refresh(user)
        
        # Send OTP email
        email_sent = send_otp_email(user.email, otp, user.first_name)
        
        if not email_sent:
            logger.warning(f"Failed to send OTP email to {user.email}, but user was created")
        
        logger.info(f"New user registered (pending verification): {user.email}")
        
        return OTPResponse(
            message="Registration successful. An OTP has been sent to your email. Please verify your email within 10 minutes.",
            email=user.email,
            otp_expires_in=OTP_EXPIRY_MINUTES * 60
        )
    except Exception as e:
        db.rollback()
        logger.error(f"Registration error: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create user account"
        )

@router.post("/login", response_model=TokenResponse)
async def login(credentials: UserLogin, db: Session = Depends(get_db)):
    """
    Login user with email and password
    
    Returns access and refresh tokens
    """
    user = db.query(User).filter(User.email == credentials.email).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
        )
    
    # Verify password
    if not verify_password(credentials.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
        )
    
    # Check if email is verified
    if not user.is_verified:
        # Send a fresh OTP to the user
        otp = generate_otp()
        user.verification_otp = otp
        user.otp_created_at = datetime.utcnow()
        user.otp_attempts = 0
        
        try:
            db.commit()
            db.refresh(user)
            
            # Send OTP email
            email_sent = send_otp_email(user.email, otp, user.first_name)
            logger.info(f"Fresh OTP sent to {user.email} during login attempt")
            
            if not email_sent:
                logger.warning(f"Failed to send fresh OTP to {user.email}, but user needs verification")
        except Exception as e:
            db.rollback()
            logger.error(f"Error sending fresh OTP during login: {str(e)}")
        
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="email_not_verified"
        )
    
    # Check if user is active
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account is inactive"
        )
    
    # Check if user is banned
    if user.is_banned:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account has been banned"
        )
    
    # Create tokens
    access_token = create_access_token({"sub": user.id, "email": user.email})
    refresh_token = create_refresh_token({"sub": user.id})
    
    logger.info(f"User logged in: {user.email}")
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=30 * 60
    )

@router.post("/send-otp", response_model=OTPResponse)
async def send_otp(request: SendOTPRequest, db: Session = Depends(get_db)):
    """
    Send or resend OTP to user's email for verification
    
    - **email**: User's email address
    
    Use this endpoint to resend OTP if the first one expired or was not received.
    """
    user = db.query(User).filter(User.email == request.email).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # If user is already verified, no need to send OTP
    if user.is_verified:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="This email is already verified"
        )
    
    # Generate new OTP
    otp = generate_otp()
    
    # Update user with new OTP
    user.verification_otp = otp
    user.otp_created_at = datetime.utcnow()
    user.otp_attempts = 0  # Reset attempts on resend
    
    try:
        db.commit()
        db.refresh(user)
        
        # Send OTP email
        email_sent = send_otp_email(user.email, otp, user.first_name)
        
        if not email_sent:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to send OTP email. Please try again."
            )
        
        logger.info(f"OTP resent to {user.email}")
        
        return OTPResponse(
            message="OTP has been sent to your email. Please verify within 10 minutes.",
            email=user.email,
            otp_expires_in=OTP_EXPIRY_MINUTES * 60
        )
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error sending OTP to {user.email}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to send OTP"
        )

@router.post("/verify-otp", response_model=TokenResponse)
async def verify_otp(request: VerifyOTPRequest, db: Session = Depends(get_db)):
    """
    Verify user email with OTP and return access/refresh tokens
    
    - **email**: User's email address
    - **otp**: 4-digit OTP code sent to email
    
    After successful verification, user will receive tokens to access the app.
    """
    user = db.query(User).filter(User.email == request.email).first()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Check if already verified
    if user.is_verified:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email is already verified. Please login."
        )
    
    # Check if too many failed attempts
    if user.otp_attempts >= MAX_OTP_ATTEMPTS:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Too many failed attempts. Please request a new OTP."
        )
    
    # Check if OTP has expired
    if user.otp_created_at:
        from datetime import timedelta
        otp_expiry_time = user.otp_created_at + timedelta(minutes=OTP_EXPIRY_MINUTES)
        if datetime.utcnow() > otp_expiry_time:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="OTP has expired. Please request a new one."
            )
    
    # Verify OTP
    if user.verification_otp != request.otp:
        user.otp_attempts += 1
        db.commit()
        
        remaining_attempts = MAX_OTP_ATTEMPTS - user.otp_attempts
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid OTP. {remaining_attempts} attempts remaining."
        )
    
    # OTP is correct - mark user as verified
    user.is_verified = True
    user.email_verified_at = datetime.utcnow()
    user.verification_otp = None
    user.otp_created_at = None
    user.otp_attempts = 0
    
    try:
        db.commit()
        db.refresh(user)
        
        # Send verification confirmation email
        send_verification_email(user.email, user.first_name)
        
        # Create tokens
        access_token = create_access_token({"sub": user.id, "email": user.email})
        refresh_token = create_refresh_token({"sub": user.id})
        
        logger.info(f"User email verified: {user.email}")
        
        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=30 * 60
        )
    except Exception as e:
        db.rollback()
        logger.error(f"Error verifying OTP for {user.email}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to verify email"
        )

@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(refresh_token: str, db: Session = Depends(get_db)):
    """
    Refresh access token using refresh token
    """
    from app.utils.auth import verify_token
    
    payload = verify_token(refresh_token)
    if not payload or payload.get("type") != "refresh":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token"
        )
    
    user_id = payload.get("sub")
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user or not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found or inactive"
        )
    
    # Create new access token
    access_token = create_access_token({"sub": user.id, "email": user.email})
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=30 * 60
    )

@router.post("/google-signin", response_model=TokenResponse)
async def google_signin(google_data: GoogleAuthRequest, db: Session = Depends(get_db)):
    """
    Authenticate user with Google Sign-In
    
    - **id_token**: Google ID token from frontend
    - **email**: User's email from Google
    - **first_name**: User's first name
    - **last_name**: User's last name
    """
    # Note: In production, you should verify the id_token with Google's servers
    # For now, we trust the frontend to send valid data (after Google verification on client side)
    
    # Check if user exists
    user = db.query(User).filter(User.email == google_data.email).first()
    
    if user:
        # User exists, just create tokens
        if not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User account is inactive"
            )
        
        if user.is_banned:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User account has been banned"
            )
    else:
        # Create new user from Google data
        # Generate a random phone number for Google users if not provided
        user = User(
            id=str(uuid.uuid4()),
            email=google_data.email,
            phone=f"google_{uuid.uuid4().hex[:8]}",  # Temporary identifier
            password_hash=hash_password(google_data.id_token),  # Use id_token as password substitute
            first_name=google_data.first_name,
            last_name=google_data.last_name,
            role="customer",
            is_active=True,
            is_verified=True,  # Google email is already verified
            email_verified_at=datetime.utcnow(),
        )
        
        try:
            db.add(user)
            db.commit()
            db.refresh(user)
            logger.info(f"New Google user registered: {user.email}")
        except Exception as e:
            db.rollback()
            logger.error(f"Google registration error: {str(e)}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to create user account"
            )
    
    # Create tokens
    access_token = create_access_token({"sub": user.id, "email": user.email})
    refresh_token = create_refresh_token({"sub": user.id})
    
    logger.info(f"Google user authenticated: {user.email}")
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=30 * 60  # 30 minutes
    )