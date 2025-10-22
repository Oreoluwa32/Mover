import requests
import hmac
import hashlib
from typing import Optional, Dict, Any
from app.config import settings
import logging

logger = logging.getLogger(__name__)


class PaystackPayment:
    """Paystack Payment Gateway Integration"""

    BASE_URL = "https://api.paystack.co"

    def __init__(self):
        self.secret_key = settings.PAYSTACK_SECRET_KEY
        self.public_key = settings.PAYSTACK_PUBLIC_KEY

        if not all([self.secret_key, self.public_key]):
            logger.warning("Paystack credentials not fully configured")

    def _get_headers(self) -> Dict[str, str]:
        """Generate headers for Paystack API"""
        return {
            "Authorization": f"Bearer {self.secret_key}",
            "Content-Type": "application/json",
        }

    def initialize_transaction(
        self,
        amount: float,
        email: str,
        metadata: Dict[str, Any] = None,
        currency: str = "NGN",
    ) -> Dict[str, Any]:
        """
        Initialize a payment transaction

        Args:
            amount: Amount in Naira (will be converted to kobo)
            email: Customer email
            metadata: Additional data to store with transaction
            currency: Currency code (default: NGN)

        Returns:
            API response with authorization URL
        """
        url = f"{self.BASE_URL}/transaction/initialize"

        payload = {
            "amount": int(amount * 100),  # Convert to kobo
            "email": email,
            "currency": currency,
        }

        if metadata:
            payload["metadata"] = metadata

        try:
            response = requests.post(
                url, json=payload, headers=self._get_headers(), timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Paystack transaction initialization failed: {str(e)}")
            return {"status": False, "message": str(e)}

    def verify_transaction(self, reference: str) -> Dict[str, Any]:
        """
        Verify a payment transaction

        Args:
            reference: Payment reference to verify

        Returns:
            Transaction details and status
        """
        url = f"{self.BASE_URL}/transaction/verify/{reference}"

        try:
            response = requests.get(
                url, headers=self._get_headers(), timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Paystack transaction verification failed: {str(e)}")
            return {"status": False, "message": str(e)}

    def get_transaction_status(self, reference: str) -> Optional[str]:
        """
        Get simple transaction status

        Args:
            reference: Reference ID

        Returns:
            Status string: success, pending, failed, or None
        """
        result = self.verify_transaction(reference)

        if result.get("status") and result.get("data"):
            status = result["data"].get("status")
            if status == "success":
                return "success"
            elif status == "pending":
                return "pending"
            else:
                return "failed"

        return None

    def create_recipient(
        self, account_number: str, bank_code: str, account_name: str
    ) -> Dict[str, Any]:
        """
        Create a transfer recipient for wallet withdrawal

        Args:
            account_number: Bank account number
            bank_code: Bank code
            account_name: Account name

        Returns:
            Recipient details
        """
        url = f"{self.BASE_URL}/transferrecipient"

        payload = {
            "type": "nuban",
            "account_number": account_number,
            "bank_code": bank_code,
            "name": account_name,
        }

        try:
            response = requests.post(
                url, json=payload, headers=self._get_headers(), timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Paystack recipient creation failed: {str(e)}")
            return {"status": False, "message": str(e)}

    def transfer_funds(
        self, recipient_code: str, amount: float, reason: str = "Wallet withdrawal"
    ) -> Dict[str, Any]:
        """
        Transfer funds to a recipient

        Args:
            recipient_code: Recipient code from create_recipient
            amount: Amount in Naira
            reason: Transfer reason

        Returns:
            Transfer response
        """
        url = f"{self.BASE_URL}/transfer"

        payload = {
            "source": "balance",
            "amount": int(amount * 100),  # Convert to kobo
            "recipient": recipient_code,
            "reason": reason,
        }

        try:
            response = requests.post(
                url, json=payload, headers=self._get_headers(), timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Paystack transfer failed: {str(e)}")
            return {"status": False, "message": str(e)}

    def get_banks(self) -> Dict[str, Any]:
        """Get list of supported banks"""
        url = f"{self.BASE_URL}/bank"

        try:
            response = requests.get(
                url, headers=self._get_headers(), timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to get banks: {str(e)}")
            return {"status": False, "message": str(e)}

    def verify_account_number(
        self, account_number: str, bank_code: str
    ) -> Dict[str, Any]:
        """
        Verify account number with bank

        Args:
            account_number: Bank account number
            bank_code: Bank code

        Returns:
            Account details
        """
        url = f"{self.BASE_URL}/bank/resolve"

        params = {"account_number": account_number, "bank_code": bank_code}

        try:
            response = requests.get(
                url, params=params, headers=self._get_headers(), timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Account verification failed: {str(e)}")
            return {"status": False, "message": str(e)}

    def validate_webhook(self, headers: Dict, body: str) -> bool:
        """
        Validate webhook signature

        Args:
            headers: Request headers containing x-paystack-signature
            body: Raw request body

        Returns:
            True if signature is valid
        """
        signature = headers.get("x-paystack-signature", "")

        hash_obj = hmac.new(
            self.secret_key.encode(), body.encode(), hashlib.sha512
        )

        computed_signature = hash_obj.hexdigest()

        return hmac.compare_digest(computed_signature, signature)


# Initialize Paystack instance
paystack = PaystackPayment()