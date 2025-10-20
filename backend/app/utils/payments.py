import requests
import base64
import json
from typing import Optional, Dict, Any
from app.config import settings
import logging

logger = logging.getLogger(__name__)

class MonnifyPayment:
    """Monnify Payment Gateway Integration"""
    
    BASE_URL = "https://api.monnify.com"
    
    def __init__(self):
        self.api_key = settings.MONNIFY_API_KEY
        self.secret_key = settings.MONNIFY_SECRET_KEY
        self.contract_code = settings.MONNIFY_CONTRACT_CODE
        
        if not all([self.api_key, self.secret_key, self.contract_code]):
            logger.warning("Monnify credentials not fully configured")
    
    def _get_auth_header(self) -> Dict[str, str]:
        """Generate Basic Auth header for Monnify API"""
        credentials = f"{self.api_key}:{self.secret_key}"
        encoded = base64.b64encode(credentials.encode()).decode()
        return {
            "Authorization": f"Basic {encoded}",
            "Content-Type": "application/json"
        }
    
    def initialize_transaction(
        self,
        amount: float,
        reference: str,
        customer_name: str,
        customer_email: str,
        customer_phone: str,
        description: str = "Movr Service Payment"
    ) -> Dict[str, Any]:
        """
        Initialize a payment transaction
        
        Args:
            amount: Transaction amount in Naira
            reference: Unique transaction reference
            customer_name: Customer's full name
            customer_email: Customer's email
            customer_phone: Customer's phone number
            description: Transaction description
        
        Returns:
            API response with payment link
        """
        url = f"{self.BASE_URL}/api/v1/transactions/init"
        
        payload = {
            "amount": amount,
            "contractCode": self.contract_code,
            "paymentReference": reference,
            "paymentDescription": description,
            "customerName": customer_name,
            "customerEmail": customer_email,
            "redirectUrl": "https://movr.app/payment-callback",
            "incomeSplitConfig": []
        }
        
        try:
            response = requests.post(
                url,
                json=payload,
                headers=self._get_auth_header(),
                timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Monnify transaction initialization failed: {str(e)}")
            return {"status": "error", "message": str(e)}
    
    def verify_transaction(self, reference: str) -> Dict[str, Any]:
        """
        Verify a payment transaction
        
        Args:
            reference: Payment reference to verify
        
        Returns:
            Transaction details and status
        """
        url = f"{self.BASE_URL}/api/v1/transactions/verify/{reference}"
        
        try:
            response = requests.get(
                url,
                headers=self._get_auth_header(),
                timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Monnify transaction verification failed: {str(e)}")
            return {"status": "error", "message": str(e)}
    
    def get_transaction_status(self, transaction_reference: str) -> Optional[str]:
        """
        Get simple transaction status
        
        Args:
            transaction_reference: Reference ID
        
        Returns:
            Status string: success, pending, failed, or None
        """
        result = self.verify_transaction(transaction_reference)
        
        if result.get("status") == "SUCCESS":
            if result.get("responseBody", {}).get("paymentStatus") == "PAID":
                return "success"
            elif result.get("responseBody", {}).get("paymentStatus") == "PENDING":
                return "pending"
            else:
                return "failed"
        
        return None
    
    def process_refund(
        self,
        original_reference: str,
        amount: float,
        reason: str = "Customer Request"
    ) -> Dict[str, Any]:
        """
        Process a refund for a transaction
        
        Args:
            original_reference: Original payment reference
            amount: Refund amount
            reason: Reason for refund
        
        Returns:
            Refund response
        """
        url = f"{self.BASE_URL}/api/v1/transactions/{original_reference}/refund"
        
        payload = {
            "refundAmount": amount,
            "reason": reason
        }
        
        try:
            response = requests.post(
                url,
                json=payload,
                headers=self._get_auth_header(),
                timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Monnify refund failed: {str(e)}")
            return {"status": "error", "message": str(e)}

# Initialize Monnify instance
monnify = MonnifyPayment()