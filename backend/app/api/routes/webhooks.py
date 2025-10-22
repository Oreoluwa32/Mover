from fastapi import APIRouter, Depends, HTTPException, status, Header, Request
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.user import User
from app.models.payment import Payment, PaymentStatus
from app.utils.paystack import paystack
import logging

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api/v1/webhooks", tags=["Webhooks"])


@router.post("/paystack")
async def paystack_webhook(request: Request, db: Session = Depends(get_db)):
    """
    Handle Paystack webhooks

    Paystack will send payment notifications to this endpoint.
    Make sure to configure this URL in Paystack dashboard.
    """
    # Get request body
    body = await request.body()
    
    # Get signature from headers
    headers = request.headers
    
    # Validate webhook signature
    if not paystack.validate_webhook(headers, body.decode()):
        logger.warning("Invalid Paystack webhook signature")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid webhook signature",
        )

    # Parse JSON
    import json
    webhook_data = json.loads(body)
    
    event = webhook_data.get("event")
    data = webhook_data.get("data", {})

    logger.info(f"Received Paystack webhook: {event}")

    # Handle charge.success event
    if event == "charge.success":
        return await handle_charge_success(data, db)

    # Handle charge.failed event
    elif event == "charge.failed":
        return await handle_charge_failed(data, db)

    # Handle transfer.success event
    elif event == "transfer.success":
        return await handle_transfer_success(data, db)

    # Handle transfer.failed event
    elif event == "transfer.failed":
        return await handle_transfer_failed(data, db)

    # Handle subscription.create event
    elif event == "subscription.create":
        return await handle_subscription_create(data, db)

    # Handle subscription.disable event
    elif event == "subscription.disable":
        return await handle_subscription_disable(data, db)

    else:
        logger.info(f"Unhandled webhook event: {event}")
        return {"status": "success", "message": "Webhook received"}


# ==================== Event Handlers ====================


async def handle_charge_success(data: dict, db: Session):
    """Handle successful charge/payment"""
    reference = data.get("reference")
    amount = data.get("amount") / 100  # Convert from kobo to Naira
    customer_email = data.get("customer", {}).get("email")
    
    # Find payment record
    payment = db.query(Payment).filter(
        Payment.paystack_reference == reference
    ).first()

    if not payment:
        logger.warning(f"Payment record not found for reference: {reference}")
        return {"status": "success", "message": "Webhook processed"}

    # Update payment status
    payment.status = PaymentStatus.SUCCESSFUL
    payment.processed_at = data.get("paid_at")

    # Update user wallet
    user = db.query(User).filter(User.id == payment.user_id).first()
    if user:
        user.wallet_balance += payment.amount
        logger.info(
            f"Wallet updated for user {user.email}: +{payment.amount}. "
            f"New balance: {user.wallet_balance}"
        )

    db.commit()

    logger.info(f"Charge successful: {reference} - {amount}NGN for {customer_email}")

    return {
        "status": "success",
        "message": "Charge processed successfully",
    }


async def handle_charge_failed(data: dict, db: Session):
    """Handle failed charge/payment"""
    reference = data.get("reference")
    
    # Find payment record
    payment = db.query(Payment).filter(
        Payment.paystack_reference == reference
    ).first()

    if payment:
        payment.status = PaymentStatus.FAILED
        db.commit()
        logger.warning(f"Charge failed: {reference}")

    return {
        "status": "success",
        "message": "Charge failure processed",
    }


async def handle_transfer_success(data: dict, db: Session):
    """Handle successful transfer (withdrawal)"""
    reference = data.get("reference")
    amount = data.get("amount") / 100  # Convert from kobo to Naira
    
    # Find withdrawal payment record
    payment = db.query(Payment).filter(
        Payment.reference.like(f"wdl_%"),
        Payment.paystack_reference == reference
    ).first()

    if payment:
        payment.status = PaymentStatus.SUCCESSFUL
        logger.info(f"Transfer successful: {reference} - {amount}NGN")

    db.commit()

    return {
        "status": "success",
        "message": "Transfer processed successfully",
    }


async def handle_transfer_failed(data: dict, db: Session):
    """Handle failed transfer (withdrawal)"""
    reference = data.get("reference")
    
    # Find withdrawal payment record
    payment = db.query(Payment).filter(
        Payment.reference.like(f"wdl_%"),
        Payment.paystack_reference == reference
    ).first()

    if payment:
        payment.status = PaymentStatus.FAILED
        
        # Refund the amount back to wallet
        user = db.query(User).filter(User.id == payment.user_id).first()
        if user:
            user.wallet_balance += payment.amount
            logger.info(
                f"Transfer failed and refunded: {reference}. "
                f"Wallet refunded with {payment.amount}NGN"
            )

    db.commit()

    logger.warning(f"Transfer failed: {reference}")

    return {
        "status": "success",
        "message": "Transfer failure processed",
    }


async def handle_subscription_create(data: dict, db: Session):
    """Handle subscription creation"""
    customer_code = data.get("customer", {}).get("customer_code")
    plan_code = data.get("plan", {}).get("plan_code")
    
    logger.info(f"Subscription created: {plan_code} for customer {customer_code}")

    return {
        "status": "success",
        "message": "Subscription created",
    }


async def handle_subscription_disable(data: dict, db: Session):
    """Handle subscription cancellation"""
    customer_code = data.get("customer", {}).get("customer_code")
    plan_code = data.get("plan", {}).get("plan_code")
    
    logger.info(f"Subscription disabled: {plan_code} for customer {customer_code}")

    return {
        "status": "success",
        "message": "Subscription disabled",
    }