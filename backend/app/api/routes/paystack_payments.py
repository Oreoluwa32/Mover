"""
Paystack Payment Endpoints - Flutter Integration

These endpoints are called directly from the Flutter app for:
1. Initializing transactions (with WebView payment)
2. Verifying transactions after payment

🔒 SECURITY NOTE:
- Secret key is stored in backend .env (NOT exposed to frontend)
- Frontend only has public key and backend URL
- All Paystack API calls use backend secret key
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field
from app.database import get_db
from app.models.user import User
from app.models.payment import Payment, PaymentStatus, PaymentMethod, TransactionType
from app.utils.auth import get_current_user
from app.utils.paystack import paystack
import uuid
import json
import logging

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api/paystack", tags=["Paystack - Flutter"])


# ==================== Schemas ====================

class InitializeTransactionRequest(BaseModel):
    """Schema for initializing Paystack transaction from Flutter"""
    amount: str = Field(..., description="Amount in NGN (as string)")
    email: str = Field(..., description="Customer email")
    currency: str = Field(default="NGN", description="Currency code")
    reference: str = Field(..., description="Unique transaction reference")
    channels: list = Field(default=["card", "bank", "bank_transfer"], description="Payment channels")


class VerifyTransactionResponse(BaseModel):
    """Schema for transaction verification response"""
    reference: str
    status: str
    amount: float
    email: str
    paid_at: str = None


# ==================== Endpoints ====================

@router.post("/initialize-transaction")
async def initialize_paystack_transaction(
    request: InitializeTransactionRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Initialize a Paystack transaction for WebView payment
    
    Called from Flutter app when user clicks "Pay Now" in Quick Deposit Bottom Sheet.
    
    Args:
        amount: Payment amount in NGN (e.g., "5000")
        email: Customer email
        currency: Currency code (default: NGN)
        reference: Unique transaction reference (e.g., "TXN-1234567890")
        channels: Allowed payment channels
    
    Returns:
        Authorization URL for WebView to load
    
    Process:
        1. Receive request from Flutter app
        2. Use backend secret key (from .env) to initialize with Paystack
        3. Return authorization URL to Flutter
        4. Flutter loads URL in WebView for user to complete payment
        5. On completion, Paystack webhook updates wallet
    """
    try:
        # Validate input
        if not all([request.amount, request.email, request.reference]):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Missing required fields: amount, email, reference"
            )
        
        # Use authenticated user's ID
        user_id = current_user.id
        
        # Use authenticated user's email (security: prevent email spoofing)
        email = current_user.email
        
        # Convert amount to float
        try:
            amount_float = float(request.amount)
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid amount format"
            )
        
        # Initialize Paystack transaction with BACKEND SECRET KEY
        # This is kept safe in .env and NEVER exposed to frontend
        paystack_response = paystack.initialize_transaction(
            amount=amount_float,
            email=email,
            currency=request.currency,
            metadata={
                "user_id": user_id,
                "reference": request.reference,
                "channels": request.channels,
            }
        )
        
        # Check if Paystack initialization was successful
        if not paystack_response.get("status"):
            logger.error(f"Paystack initialization failed: {paystack_response}")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=paystack_response.get("message", "Failed to initialize payment")
            )
        
        paystack_data = paystack_response.get("data", {})
        
        # Create payment record in database
        payment = Payment(
            id=str(uuid.uuid4()),
            user_id=user_id,
            amount=amount_float,
            transaction_type=TransactionType.CREDIT,
            payment_method=PaymentMethod.CARD,
            status=PaymentStatus.PENDING,
            reference=request.reference,  # Frontend reference
            description="Wallet Deposit via WebView",
            related_type="wallet",
            paystack_reference=paystack_data.get("reference"),  # Paystack reference
            paystack_access_code=paystack_data.get("access_code"),
            meta=json.dumps({
                "channels": request.channels,
                "email": email,
                "source": "flutter_webview"
            })
        )
        
        db.add(payment)
        db.commit()
        db.refresh(payment)
        
        logger.info(f"✅ Payment initialized: {request.reference} - {amount_float}NGN for {email}")
        
        # Return response in format Flutter expects
        return {
            "status": True,
            "message": "Authorization URL created",
            "data": {
                "authorization_url": paystack_data.get("authorization_url"),
                "access_code": paystack_data.get("access_code"),
                "reference": request.reference
            }
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"❌ Transaction initialization error: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to initialize transaction: {str(e)}"
        )


@router.get("/verify-transaction/{reference}")
async def verify_paystack_transaction(
    reference: str,
    db: Session = Depends(get_db),
):
    """
    Verify a Paystack transaction and update wallet
    
    Called from Flutter app after user completes payment in WebView.
    
    Args:
        reference: Transaction reference to verify
    
    Returns:
        Transaction status and details
    
    Process:
        1. Receive reference from Flutter app
        2. Find payment record in database
        3. Call Paystack API with backend SECRET KEY to verify
        4. If successful, update wallet balance
        5. Return status to Flutter
    """
    try:
        # Validate input
        if not reference:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Reference is required"
            )
        
        # Find payment record
        payment = db.query(Payment).filter(Payment.reference == reference).first()
        
        if not payment:
            logger.warning(f"Payment not found: {reference}")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Payment not found"
            )
        
        # Verify with Paystack using BACKEND SECRET KEY
        paystack_response = paystack.verify_transaction(payment.paystack_reference)
        
        if not paystack_response.get("status"):
            logger.warning(f"Paystack verification failed: {reference}")
            payment.status = PaymentStatus.FAILED
            db.commit()
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Payment verification failed"
            )
        
        paystack_data = paystack_response.get("data", {})
        payment_status = paystack_data.get("status")
        
        if payment_status == "success":
            # Update payment status
            payment.status = PaymentStatus.SUCCESSFUL
            payment.processed_at = paystack_data.get("paid_at")
            
            # Update user wallet if user exists
            if payment.user_id:
                user = db.query(User).filter(User.id == payment.user_id).first()
                if user:
                    previous_balance = user.wallet_balance
                    user.wallet_balance += payment.amount
                    db.commit()
                    logger.info(
                        f"✅ Payment verified: {reference} - {payment.amount}NGN "
                        f"Wallet: {previous_balance} → {user.wallet_balance}"
                    )
            else:
                db.commit()
                logger.info(f"✅ Payment verified: {reference} - {payment.amount}NGN")
            
            return {
                "status": True,
                "message": "Verification successful",
                "data": {
                    "reference": reference,
                    "status": "success",
                    "amount": payment.amount,
                    "email": paystack_data.get("customer", {}).get("email"),
                    "paid_at": paystack_data.get("paid_at")
                }
            }
        
        elif payment_status == "pending":
            logger.info(f"Payment pending: {reference}")
            return {
                "status": True,
                "message": "Payment is pending",
                "data": {
                    "reference": reference,
                    "status": "pending",
                    "amount": payment.amount
                }
            }
        
        else:
            # Payment failed
            payment.status = PaymentStatus.FAILED
            db.commit()
            logger.warning(f"❌ Payment failed: {reference}")
            return {
                "status": False,
                "message": "Payment failed",
                "data": {
                    "reference": reference,
                    "status": "failed",
                    "amount": payment.amount
                }
            }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"❌ Transaction verification error: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to verify transaction: {str(e)}"
        )


# ==================== Health Check ====================

@router.get("/health")
async def health_check():
    """Health check for Paystack payment endpoints"""
    return {
        "status": "healthy",
        "message": "Paystack payment endpoints ready",
        "endpoints": [
            "POST /api/paystack/initialize-transaction",
            "GET /api/paystack/verify-transaction/{reference}"
        ]
    }