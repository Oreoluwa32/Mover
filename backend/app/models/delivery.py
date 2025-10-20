from sqlalchemy import Column, String, Float, ForeignKey, Enum, DateTime, Text, Integer
from app.models.base import BaseModel
from datetime import datetime
import enum

class DeliveryStatus(str, enum.Enum):
    PENDING = "pending"
    ASSIGNED = "assigned"
    PICKED_UP = "picked_up"
    IN_TRANSIT = "in_transit"
    DELIVERED = "delivered"
    FAILED = "failed"
    CANCELLED = "cancelled"

class Delivery(BaseModel):
    __tablename__ = "deliveries"
    
    # Users
    sender_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    receiver_id = Column(String, ForeignKey("users.id"), nullable=True, index=True)
    driver_id = Column(String, ForeignKey("users.id"), nullable=True, index=True)
    
    # Pickup
    pickup_latitude = Column(Float, nullable=False)
    pickup_longitude = Column(Float, nullable=False)
    pickup_address = Column(String, nullable=False)
    pickup_contact = Column(String, nullable=False)
    
    # Delivery
    delivery_latitude = Column(Float, nullable=False)
    delivery_longitude = Column(Float, nullable=False)
    delivery_address = Column(String, nullable=False)
    delivery_contact = Column(String, nullable=False)
    
    # Package Info
    package_description = Column(Text, nullable=True)
    package_weight = Column(Float, nullable=True)  # in kg
    package_size = Column(String, nullable=True)  # small, medium, large
    
    # Status
    status = Column(Enum(DeliveryStatus), default=DeliveryStatus.PENDING, nullable=False, index=True)
    
    # Pricing
    estimated_cost = Column(Float, nullable=True)
    actual_cost = Column(Float, nullable=True)
    
    # Timing
    scheduled_time = Column(DateTime, nullable=True)
    picked_up_at = Column(DateTime, nullable=True)
    delivered_at = Column(DateTime, nullable=True)
    
    # Notes
    special_instructions = Column(Text, nullable=True)
    failure_reason = Column(String, nullable=True)
    
    def __repr__(self):
        return f"<Delivery {self.id} - {self.status}>"