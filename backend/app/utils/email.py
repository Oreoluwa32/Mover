import random
import logging
from datetime import datetime
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from app.config import settings

logger = logging.getLogger(__name__)

def generate_otp() -> str:
    """Generate a 4-digit OTP"""
    return ''.join([str(random.randint(0, 9)) for _ in range(4)])

def send_otp_email(email: str, otp: str, first_name: str = None) -> bool:
    """
    Send OTP to user's email using SendGrid
    
    Args:
        email: User's email address
        otp: The OTP code to send
        first_name: User's first name for personalization
    
    Returns:
        True if email sent successfully, False otherwise
    """
    try:
        if not settings.SENDGRID_API_KEY:
            logger.warning("SendGrid API key not configured")
            return False
        
        user_name = first_name if first_name else "User"
        subject = "Email Verification - Your OTP Code"
        
        html_content = f"""
        <html>
            <head>
                <style>
                    body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }}
                    .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                    .header {{ background-color: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }}
                    .content {{ background-color: #f9f9f9; padding: 20px; border: 1px solid #ddd; border-radius: 0 0 5px 5px; }}
                    .otp-code {{ font-size: 32px; font-weight: bold; color: #4CAF50; text-align: center; letter-spacing: 5px; margin: 20px 0; font-family: 'Courier New', monospace; }}
                    .footer {{ font-size: 12px; color: #999; text-align: center; margin-top: 20px; }}
                    .warning {{ color: #ff9800; font-size: 14px; margin: 10px 0; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>Movr Email Verification</h1>
                    </div>
                    <div class="content">
                        <p>Hello {user_name},</p>
                        <p>Thank you for registering with Movr! To complete your email verification, please use the OTP code below:</p>
                        
                        <div class="otp-code">{otp}</div>
                        
                        <p>This OTP code will expire in <strong>10 minutes</strong>.</p>
                        
                        <p class="warning">⚠️ If you didn't request this code, please ignore this email. Never share your OTP with anyone.</p>
                        
                        <p>Best regards,<br>The Movr Team</p>
                    </div>
                    <div class="footer">
                        <p>© 2024 Movr. All rights reserved.</p>
                    </div>
                </div>
            </body>
        </html>
        """
        
        plain_text_content = f"""
        Hello {user_name},
        
        Thank you for registering with Movr! To complete your email verification, please use the OTP code below:
        
        {otp}
        
        This OTP code will expire in 10 minutes.
        
        If you didn't request this code, please ignore this email. Never share your OTP with anyone.
        
        Best regards,
        The Movr Team
        """
        
        message = Mail(
            from_email=settings.SENDGRID_FROM_EMAIL,
            to_emails=email,
            subject=subject,
            plain_text_content=plain_text_content,
            html_content=html_content
        )
        
        sg = SendGridAPIClient(settings.SENDGRID_API_KEY)
        response = sg.send(message)
        
        logger.info(f"OTP email sent to {email} - Status: {response.status_code}")
        return response.status_code == 202
    
    except Exception as e:
        logger.error(f"Failed to send OTP email to {email}: {str(e)}")
        return False

def send_verification_email(email: str, first_name: str = None) -> bool:
    """
    Send verification success email
    """
    try:
        if not settings.SENDGRID_API_KEY:
            logger.warning("SendGrid API key not configured")
            return False
        
        user_name = first_name if first_name else "User"
        subject = "Email Verified Successfully"
        
        html_content = f"""
        <html>
            <head>
                <style>
                    body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }}
                    .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                    .header {{ background-color: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }}
                    .content {{ background-color: #f9f9f9; padding: 20px; border: 1px solid #ddd; border-radius: 0 0 5px 5px; }}
                    .success {{ color: #4CAF50; font-size: 16px; text-align: center; margin: 20px 0; }}
                    .footer {{ font-size: 12px; color: #999; text-align: center; margin-top: 20px; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>✓ Email Verified</h1>
                    </div>
                    <div class="content">
                        <p>Hello {user_name},</p>
                        <p>Your email has been verified successfully! Your Movr account is now fully activated.</p>
                        
                        <div class="success">You can now start using all Movr services.</div>
                        
                        <p>Best regards,<br>The Movr Team</p>
                    </div>
                    <div class="footer">
                        <p>© 2024 Movr. All rights reserved.</p>
                    </div>
                </div>
            </body>
        </html>
        """
        
        message = Mail(
            from_email=settings.SENDGRID_FROM_EMAIL,
            to_emails=email,
            subject=subject,
            html_content=html_content
        )
        
        sg = SendGridAPIClient(settings.SENDGRID_API_KEY)
        response = sg.send(message)
        
        logger.info(f"Verification confirmation email sent to {email}")
        return response.status_code == 202
    
    except Exception as e:
        logger.error(f"Failed to send verification email to {email}: {str(e)}")
        return False