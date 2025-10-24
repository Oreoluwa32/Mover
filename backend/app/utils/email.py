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
                    body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #333; }}
                    .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                    .header {{ background-color: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }}
                    .content {{ background-color: #ffffff; padding: 20px; border: 1px solid #ddd; border-radius: 0 0 5px 5px; }}
                    .otp-code {{ font-size: 28px; font-weight: bold; color: #4CAF50; text-align: center; letter-spacing: 8px; margin: 30px 0; font-family: 'Courier New', monospace; border: 2px dashed #4CAF50; padding: 15px; }}
                    .footer {{ font-size: 12px; color: #999; text-align: center; margin-top: 30px; border-top: 1px solid #eee; padding-top: 15px; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1 style="margin: 0;">Email Verification</h1>
                    </div>
                    <div class="content">
                        <p>Hello {user_name},</p>
                        <p>Your verification code is:</p>
                        
                        <div class="otp-code">{otp}</div>
                        
                        <p>This code expires in 10 minutes.</p>
                        <p>If you didn't request this code, you can safely ignore this email.</p>
                        
                        <p>—<br>Movr Support Team</p>
                    </div>
                    <div class="footer">
                        <p>© 2024 Movr. All rights reserved.</p>
                        <p><a href="https://movr.app/contact" style="color: #999; text-decoration: none;">Contact Support</a></p>
                    </div>
                </div>
            </body>
        </html>
        """
        
        plain_text_content = f"""
Hello {user_name},

Your verification code is: {otp}

This code expires in 10 minutes.

If you didn't request this code, you can safely ignore this email.

—
Movr Support Team
© 2024 Movr. All rights reserved.
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

def send_password_reset_email(email: str, reset_link: str, first_name: str = None) -> bool:
    """
    Send password reset email with deep link
    
    Args:
        email: User's email address
        reset_link: The deep link containing the reset token (movr://reset-password?token=xyz)
        first_name: User's first name for personalization
    
    Returns:
        True if email sent successfully, False otherwise
    """
    try:
        if not settings.SENDGRID_API_KEY:
            logger.warning("SendGrid API key not configured")
            return False
        
        user_name = first_name if first_name else "User"
        subject = "Password Reset Request - Movr"
        
        html_content = f"""
        <html>
            <head>
                <style>
                    body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #333; }}
                    .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                    .header {{ background-color: #FF6B35; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }}
                    .content {{ background-color: #ffffff; padding: 20px; border: 1px solid #ddd; border-radius: 0 0 5px 5px; }}
                    .reset-button {{ display: inline-block; background-color: #FF6B35; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; text-align: center; }}
                    .warning {{ background-color: #fff3cd; border: 1px solid #ffc107; padding: 10px; border-radius: 3px; margin: 15px 0; color: #856404; }}
                    .footer {{ font-size: 12px; color: #999; text-align: center; margin-top: 30px; border-top: 1px solid #eee; padding-top: 15px; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1 style="margin: 0;">Password Reset Request</h1>
                    </div>
                    <div class="content">
                        <p>Hello {user_name},</p>
                        <p>We received a request to reset your Movr account password. Click the button below to set a new password:</p>
                        
                        <div style="text-align: center;">
                            <a href="{reset_link}" class="reset-button">Reset Password</a>
                        </div>
                        
                        <p>Or copy and paste this link in your browser:</p>
                        <p style="word-break: break-all; background-color: #f5f5f5; padding: 10px; border-radius: 3px;">
                            <code>{reset_link}</code>
                        </p>
                        
                        <div class="warning">
                            <strong>⚠️ Security Notice:</strong><br>
                            This link will expire in 1 hour. If you didn't request this, please ignore this email or contact support.
                        </div>
                        
                        <p style="margin-top: 20px;">Best regards,<br>The Movr Support Team</p>
                    </div>
                    <div class="footer">
                        <p>© 2024 Movr. All rights reserved.</p>
                        <p><a href="https://movr.app/contact" style="color: #999; text-decoration: none;">Contact Support</a></p>
                    </div>
                </div>
            </body>
        </html>
        """
        
        plain_text_content = f"""
Hello {user_name},

We received a request to reset your Movr account password. Click the link below to set a new password:

{reset_link}

This link will expire in 1 hour. If you didn't request this, please ignore this email or contact support.

Best regards,
The Movr Support Team

© 2024 Movr. All rights reserved.
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
        
        logger.info(f"Password reset email sent to {email} - Status: {response.status_code}")
        return response.status_code == 202
    
    except Exception as e:
        logger.error(f"Failed to send password reset email to {email}: {str(e)}")
        return False