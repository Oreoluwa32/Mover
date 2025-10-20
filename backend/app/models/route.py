from sqlalchemy import Column, String, Float, ForeignKey, Enum, DateTime, Text, Boolean, Integer
from app.models.base import BaseModel
from datetime import datetime
import enum

class RouteType(str, enum.Enum):
    INSTANT = "instant"
    SCHEDULED = "scheduled"

class RouteStatus(str, enum.Enum):
    ACTIVE = "active"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
    PAUSED = "paused"

class Route(BaseModel):
    __tablename__ = "routes"
    
    # Driver
    driver_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    
    # Route Details
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    route_type = Column(Enum(RouteType), default=RouteType.INSTANT, nullable=False)
    status = Column(Enum(RouteStatus), default=RouteStatus.ACTIVE, nullable=False, index=True)
    
    # Starting Point
    start_latitude = Column(Float, nullable=False)
    start_longitude = Column(Float, nullable=False)
    start_address = Column(String, nullable=False)
    
    # Ending Point
    end_latitude = Column(Float, nullable=False)
    end_longitude = Column(Float, nullable=False)
    end_address = Column(String, nullable=False)
    
    # Pricing
    estimated_distance = Column(Float, nullable=True)  # in km
    estimated_duration = Column(Integer, nullable=True)  # in minutes
    price_per_km = Column(Float, default=50.0)
    base_price = Column(Float, default=500.0)
    
    # Capacity
    available_seats = Column(Integer, default=4)
    
    # Timing
    scheduled_departure = Column(DateTime, nullable=True)
    actual_departure = Column(DateTime, nullable=True)
    estimated_arrival = Column(DateTime, nullable=True)
    actual_arrival = Column(DateTime, nullable=True)
    
    # Settings
    is_public = Column(Boolean, default=True)
    accepts_additional_stops = Column(Boolean, default=True)
    
    def __repr__(self):
        return f"<Route {self.id} - {self.name}>"