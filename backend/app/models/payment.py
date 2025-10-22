from sqlalchemy import Column, String, Float, ForeignKey, Enum, DateTime, Text, Boolean
from app.models.base import BaseModel
from datetime import datetime
import enum

class PaymentMethod(str, enum.Enum):
    WALLET = "wallet"
    CARD = "card"
    BANK_TRANSFER = "bank_transfer"
    USSD = "ussd"
    CASH = "cash"

class PaymentStatus(str, enum.Enum):
    PENDING = "pending"
    PROCESSING = "processing"
    SUCCESSFUL = "successful"
    FAILED = "failed"
    REFUNDED = "refunded"

class TransactionType(str, enum.Enum):
    DEBIT = "debit"
    CREDIT = "credit"

class Payment(BaseModel):
    __tablename__ = "payments"
    
    # User
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    
    # Transaction Details
    amount = Column(Float, nullable=False)
    transaction_type = Column(Enum(TransactionType), nullable=False)  # debit/credit
    payment_method = Column(Enum(PaymentMethod), nullable=False)
    status = Column(Enum(PaymentStatus), default=PaymentStatus.PENDING, nullable=False, index=True)
    
    # Reference
    reference = Column(String, unique=True, index=True, nullable=False)
    description = Column(String, nullable=False)
    related_id = Column(String, nullable=True)  # ride_id, delivery_id, etc.
    related_type = Column(String, nullable=True)  # ride, delivery, refund, etc.
    
    # Paystack Payment Details
    paystack_reference = Column(String, nullable=True, index=True)
    paystack_access_code = Column(String, nullable=True)
    
    # Metadata
    meta = Column(Text, nullable=True)  # JSON string
    
    # Refund
    is_refunded = Column(Boolean, default=False)
    refund_amount = Column(Float, nullable=True)
    refund_reference = Column(String, nullable=True)
    refunded_at = Column(DateTime, nullable=True)
    refund_reason = Column(String, nullable=True)
    
    # Timestamps
    processed_at = Column(DateTime, nullable=True)
    
    def __repr__(self):
        return f"<Payment {self.reference} - {self.status}>"