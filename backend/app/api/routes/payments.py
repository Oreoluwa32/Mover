from fastapi import APIRouter, Depends, HTTPException, status, Header
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
router = APIRouter(prefix="/api/v1/payments", tags=["Payments"])


# ==================== Schemas ====================
class InitializePaymentRequest(BaseModel):
    """Schema for payment initialization"""

    amount: float = Field(..., gt=0, description="Amount in NGN")
    description: str = Field(default="Wallet Funding", description="Payment description")
    related_type: str = Field(default="wallet", description="Type of payment (wallet, subscription, etc.)")


class VerifyPaymentRequest(BaseModel):
    """Schema for payment verification"""
    reference: str = Field(..., description="Payment reference")


class WithdrawalRequest(BaseModel):
    """Schema for withdrawal initialization"""
    account_number: str = Field(..., description="Bank account number")
    bank_code: str = Field(..., description="Bank code")
    account_name: str = Field(..., description="Account name")
    amount: float = Field(..., gt=0, description="Withdrawal amount")


class CompleteWithdrawalRequest(BaseModel):
    """Schema for completing a withdrawal"""
    reference: str = Field(..., description="Withdrawal reference")


# ==================== Wallet Endpoints ====================


@router.get("/wallet/balance")
async def get_wallet_balance(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get user's current wallet balance"""
    user = db.query(User).filter(User.id == current_user.id).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    return {"balance": user.wallet_balance, "currency": "NGN"}


@router.get("/transactions")
async def get_transaction_history(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    limit: int = 50,
    offset: int = 0,
):
    """Get user's transaction history"""
    transactions = (
        db.query(Payment)
        .filter(Payment.user_id == current_user.id)
        .order_by(Payment.created_at.desc())
        .limit(limit)
        .offset(offset)
        .all()
    )

    total = db.query(Payment).filter(Payment.user_id == current_user.id).count()

    return {
        "transactions": [
            {
                "id": t.id,
                "amount": t.amount,
                "type": t.transaction_type,
                "status": t.status,
                "description": t.description,
                "reference": t.reference,
                "created_at": t.created_at,
            }
            for t in transactions
        ],
        "total": total,
        "limit": limit,
        "offset": offset,
    }


# ==================== Payment Initialization ====================


@router.post("/initialize")
async def initialize_payment(
    request: InitializePaymentRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Initialize a payment transaction

    Required fields:
    - amount: Payment amount in NGN
    - description: Payment description
    - related_type: Type of payment (wallet, subscription, etc.)
    """
    amount = request.amount
    description = request.description
    related_type = request.related_type

    user = db.query(User).filter(User.id == current_user.id).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    # Generate unique reference
    reference = f"movr_{uuid.uuid4().hex[:12]}"

    # Initialize Paystack transaction
    paystack_response = paystack.initialize_transaction(
        amount=amount,
        email=user.email,
        metadata={
            "user_id": user.id,
            "user_name": f"{user.first_name} {user.last_name}",
            "description": description,
            "related_type": related_type,
        },
    )

    if not paystack_response.get("status"):
        logger.error(f"Paystack initialization failed: {paystack_response}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to initialize payment",
        )

    paystack_data = paystack_response.get("data", {})

    # Create payment record
    payment = Payment(
        id=str(uuid.uuid4()),
        user_id=user.id,
        amount=amount,
        transaction_type=TransactionType.CREDIT,
        payment_method=PaymentMethod.CARD,
        status=PaymentStatus.PENDING,
        reference=reference,
        description=description,
        related_type=related_type,
        paystack_reference=paystack_data.get("reference"),
        paystack_access_code=paystack_data.get("access_code"),
    )

    db.add(payment)
    db.commit()
    db.refresh(payment)

    logger.info(f"Payment initialized: {reference}")

    return {
        "status": True,
        "message": "Payment initialized successfully",
        "data": {
            "payment_id": payment.id,
            "reference": reference,
            "amount": amount,
            "authorization_url": paystack_data.get("authorization_url"),
            "access_code": paystack_data.get("access_code"),
        },
    }


# ==================== Payment Verification ====================


@router.post("/verify")
async def verify_payment(
    request: VerifyPaymentRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Verify a payment transaction and update wallet

    Required fields:
    - reference: Payment reference
    """
    reference = request.reference

    # Get payment record
    payment = db.query(Payment).filter(Payment.reference == reference).first()

    if not payment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Payment not found"
        )

    if payment.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Unauthorized access to this payment",
        )

    # Verify with Paystack
    verify_response = paystack.verify_transaction(payment.paystack_reference)

    if not verify_response.get("status"):
        logger.error(f"Paystack verification failed: {verify_response}")
        return {
            "status": False,
            "message": "Payment verification failed",
        }

    paystack_data = verify_response.get("data", {})
    payment_status = paystack_data.get("status")

    if payment_status == "success":
        # Update payment status
        payment.status = PaymentStatus.SUCCESSFUL
        payment.processed_at = paystack_data.get("paid_at")

        # Update user wallet
        user = db.query(User).filter(User.id == current_user.id).first()
        user.wallet_balance += payment.amount

        db.commit()

        logger.info(f"Payment verified and wallet updated: {reference}")

        return {
            "status": True,
            "message": "Payment verified successfully",
            "data": {
                "payment_id": payment.id,
                "status": "success",
                "amount": payment.amount,
                "new_balance": user.wallet_balance,
            },
        }

    elif payment_status == "pending":
        return {
            "status": True,
            "message": "Payment is pending",
            "data": {"payment_id": payment.id, "status": "pending"},
        }

    else:
        payment.status = PaymentStatus.FAILED
        db.commit()

        logger.warning(f"Payment failed: {reference}")

        return {
            "status": False,
            "message": "Payment failed",
            "data": {"payment_id": payment.id, "status": "failed"},
        }


# ==================== Withdrawal Endpoints ====================


@router.post("/withdrawal/initialize")
async def initialize_withdrawal(
    request: WithdrawalRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Initialize a withdrawal request

    Required fields:
    - amount: Withdrawal amount
    - account_number: Bank account number
    - bank_code: Bank code
    - account_name: Account name
    """
    amount = request.amount
    account_number = request.account_number
    bank_code = request.bank_code
    account_name = request.account_name

    user = db.query(User).filter(User.id == current_user.id).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    if user.wallet_balance < amount:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Insufficient wallet balance",
        )

    # Verify account number
    verify_response = paystack.verify_account_number(account_number, bank_code)

    if not verify_response.get("status"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid account number or bank code",
        )

    account_info = verify_response.get("data", {})

    # Create transfer recipient
    recipient_response = paystack.create_recipient(
        account_number=account_number,
        bank_code=bank_code,
        account_name=account_name,
    )

    if not recipient_response.get("status"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to create transfer recipient",
        )

    recipient_code = recipient_response.get("data", {}).get("recipient_code")

    # Create withdrawal record
    reference = f"wdl_{uuid.uuid4().hex[:12]}"
    payment = Payment(
        id=str(uuid.uuid4()),
        user_id=user.id,
        amount=amount,
        transaction_type=TransactionType.DEBIT,
        payment_method=PaymentMethod.BANK_TRANSFER,
        status=PaymentStatus.PROCESSING,
        reference=reference,
        description=f"Withdrawal to {account_info.get('account_name')}",
        related_type="withdrawal",
        meta=json.dumps(
            {
                "recipient_code": recipient_code,
                "account_number": account_number,
                "bank_code": bank_code,
                "account_name": account_name,
            }
        ),
    )

    db.add(payment)
    db.commit()
    db.refresh(payment)

    logger.info(f"Withdrawal initialized: {reference}")

    return {
        "status": True,
        "message": "Withdrawal initialized",
        "data": {
            "withdrawal_id": payment.id,
            "reference": reference,
            "amount": amount,
            "account_name": account_info.get("account_name"),
        },
    }


@router.post("/withdrawal/complete")
async def complete_withdrawal(
    request: CompleteWithdrawalRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Complete a withdrawal by transferring funds

    Required fields:
    - reference: Withdrawal reference
    """
    reference = request.reference

    # Get payment record
    payment = db.query(Payment).filter(Payment.reference == reference).first()

    if not payment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Withdrawal not found"
        )

    if payment.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Unauthorized"
        )

    # Get meta data
    meta = json.loads(payment.meta) if payment.meta else {}
    recipient_code = meta.get("recipient_code")

    if not recipient_code:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid withdrawal data",
        )

    # Process transfer
    transfer_response = paystack.transfer_funds(
        recipient_code=recipient_code, amount=payment.amount
    )

    if not transfer_response.get("status"):
        logger.error(f"Paystack transfer failed: {transfer_response}")
        return {
            "status": False,
            "message": "Transfer failed",
        }

    # Update payment status
    payment.status = PaymentStatus.SUCCESSFUL
    payment.processed_at = transfer_response.get("data", {}).get("createdAt")

    # Deduct from wallet
    user = db.query(User).filter(User.id == current_user.id).first()
    user.wallet_balance -= payment.amount

    db.commit()

    logger.info(f"Withdrawal completed: {reference}")

    return {
        "status": True,
        "message": "Withdrawal completed successfully",
        "data": {
            "withdrawal_id": payment.id,
            "amount": payment.amount,
            "new_balance": user.wallet_balance,
        },
    }


# ==================== Banks Endpoint ====================


@router.get("/banks")
async def get_banks():
    """Get list of supported banks"""
    banks_response = paystack.get_banks()

    if not banks_response.get("status"):
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to fetch banks",
        )

    return {
        "status": True,
        "data": banks_response.get("data", []),
    }