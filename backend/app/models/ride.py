from sqlalchemy import Column, String, Float, ForeignKey, Enum, DateTime, Text
from app.models.base import BaseModel
from datetime import datetime
import enum

class RideStatus(str, enum.Enum):
    REQUESTED = "requested"
    ACCEPTED = "accepted"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class Ride(BaseModel):
    __tablename__ = "rides"
    
    # Users
    customer_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    driver_id = Column(String, ForeignKey("users.id"), nullable=True, index=True)
    
    # Pickup
    pickup_latitude = Column(Float, nullable=False)
    pickup_longitude = Column(Float, nullable=False)
    pickup_address = Column(String, nullable=False)
    
    # Dropoff
    dropoff_latitude = Column(Float, nullable=False)
    dropoff_longitude = Column(Float, nullable=False)
    dropoff_address = Column(String, nullable=False)
    
    # Status
    status = Column(Enum(RideStatus), default=RideStatus.REQUESTED, nullable=False, index=True)
    
    # Pricing
    estimated_fare = Column(Float, nullable=True)
    actual_fare = Column(Float, nullable=True)
    payment_method = Column(String, default="wallet")  # wallet, card, cash
    
    # Notes
    notes = Column(Text, nullable=True)
    cancellation_reason = Column(String, nullable=True)
    
    # Timing
    scheduled_time = Column(DateTime, nullable=True)
    started_at = Column(DateTime, nullable=True)
    completed_at = Column(DateTime, nullable=True)
    
    def __repr__(self):
        return f"<Ride {self.id} - {self.status}>"