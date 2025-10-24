"""
User Profile & Status Endpoints

Handles user-related operations like:
- Toggling live status (location sharing)
- Profile updates
- User preferences
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel
from app.database import get_db
from app.models.user import User
from app.utils.auth import get_current_user
import logging

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api/v1/user", tags=["User"])


# ==================== Schemas ====================

class ToggleLiveRequest(BaseModel):
    """Schema for toggling live status"""
    is_live: bool


class UserStatusResponse(BaseModel):
    """Schema for user status response"""
    status: bool
    message: str
    is_live: bool


# ==================== Endpoints ====================

@router.post("/toggle-live", response_model=dict)
async def toggle_live_status(
    request: ToggleLiveRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Toggle user's live status (location sharing)
    
    When enabled:
    - User's location is shared in real-time
    - Driver can receive ride requests
    - Customer can place orders
    
    When disabled:
    - Location sharing stops
    - User won't receive requests
    
    Args:
        is_live: Boolean to enable/disable live status
    
    Returns:
        Updated user's live status
    """
    try:
        # Verify user exists
        user = db.query(User).filter(User.id == current_user.id).first()
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Update user's live status
        previous_status = user.is_live
        user.is_live = request.is_live
        
        db.commit()
        db.refresh(user)
        
        action = "enabled" if request.is_live else "disabled"
        logger.info(
            f"✅ User live status {action}: {user.email} "
            f"({user.role}) - Status changed from {previous_status} to {user.is_live}"
        )
        
        return {
            "status": True,
            "message": f"Your route is now {'live' if request.is_live else 'disabled'}",
            "is_live": user.is_live
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"❌ Failed to toggle live status for {current_user.email}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update live status: {str(e)}"
        )


@router.get("/live-status", response_model=dict)
async def get_live_status(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Get user's current live status
    
    Returns:
        Current is_live status for the authenticated user
    """
    try:
        user = db.query(User).filter(User.id == current_user.id).first()
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        return {
            "status": True,
            "is_live": user.is_live
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"❌ Failed to get live status for {current_user.email}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve live status: {str(e)}"
        )


# ==================== Health Check ====================

@router.get("/health")
async def health_check():
    """Health check for user endpoints"""
    return {
        "status": "healthy",
        "message": "User endpoints ready",
        "endpoints": [
            "POST /api/v1/user/toggle-live",
            "GET /api/v1/user/live-status"
        ]
    }