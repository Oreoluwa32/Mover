# Paystack Payment Integration Plan for Movr

## Overview
Replace Monnify with Paystack as the primary payment gateway. The system uses a wallet-based payment model where users can fund their wallet and use it for transactions.

---

## 1. Backend Implementation

### 1.1 Update Configuration (Backend)

**File**: `backend/app/config.py`

Replace Monnify environment variables with Paystack:

```python
# Remove:
MONNIFY_API_KEY: str = ""
MONNIFY_SECRET_KEY: str = ""
MONNIFY_CONTRACT_CODE: str = ""

# Add:
PAYSTACK_PUBLIC_KEY: str = ""
PAYSTACK_SECRET_KEY: str = ""
```

### 1.2 Create Paystack Service (Backend)

**File**: `backend/app/utils/paystack.py` (NEW FILE)

Replace the Monnify payment class with a new Paystack payment service:

```python
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
            "Content-Type": "application/json"
        }
    
    def initialize_transaction(
        self,
        amount: float,
        email: str,
        metadata: Dict[str, Any] = None,
        currency: str = "NGN"
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
                url,
                json=payload,
                headers=self._get_headers(),
                timeout=30
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
                url,
                headers=self._get_headers(),
                timeout=30
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
        self,
        account_number: str,
        bank_code: str,
        account_name: str
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
            "name": account_name
        }
        
        try:
            response = requests.post(
                url,
                json=payload,
                headers=self._get_headers(),
                timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Paystack recipient creation failed: {str(e)}")
            return {"status": False, "message": str(e)}
    
    def transfer_funds(
        self,
        recipient_code: str,
        amount: float,
        reason: str = "Wallet withdrawal"
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
            "reason": reason
        }
        
        try:
            response = requests.post(
                url,
                json=payload,
                headers=self._get_headers(),
                timeout=30
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
                url,
                headers=self._get_headers(),
                timeout=30
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to get banks: {str(e)}")
            return {"status": False, "message": str(e)}
    
    def verify_account_number(
        self,
        account_number: str,
        bank_code: str
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
        
        params = {
            "account_number": account_number,
            "bank_code": bank_code
        }
        
        try:
            response = requests.get(
                url,
                params=params,
                headers=self._get_headers(),
                timeout=30
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
        signature = headers.get('x-paystack-signature', '')
        
        hash_obj = hmac.new(
            self.secret_key.encode(),
            body.encode(),
            hashlib.sha512
        )
        
        computed_signature = hash_obj.hexdigest()
        
        return hmac.compare_digest(computed_signature, signature)

# Initialize Paystack instance
paystack = PaystackPayment()
```

### 1.3 Update Payment Model

**File**: `backend/app/models/payment.py`

Replace Monnify references with Paystack:

```python
# Change from:
monnify_reference = Column(String, nullable=True, index=True)
monnify_payment_reference = Column(String, nullable=True)

# To:
paystack_reference = Column(String, nullable=True, index=True)
paystack_access_code = Column(String, nullable=True)
```

### 1.4 Create Payment Routes

**File**: `backend/app/api/routes/payments.py` (NEW FILE)

Create API endpoints for wallet and payment operations.

### 1.5 Update .env Configuration

**File**: `backend/.env`

```bash
# Remove Monnify
# MONNIFY_API_KEY=...
# MONNIFY_SECRET_KEY=...
# MONNIFY_CONTRACT_CODE=...

# Add Paystack
PAYSTACK_PUBLIC_KEY=pk_live_xxxxx  # or pk_test_xxxxx for testing
PAYSTACK_SECRET_KEY=sk_live_xxxxx  # or sk_test_xxxxx for testing
```

---

## 2. Flutter App Implementation

### 2.1 Update Paystack Service

**File**: `lib/services/paystack_services.dart`

Enhance the existing Paystack service with complete implementation.

### 2.2 Update Dependencies

**File**: `pubspec.yaml`

Ensure Paystack Flutter package is added:

```yaml
dependencies:
  flutter_paystack: ^1.5.1  # or latest version
```

### 2.3 Update Deposit/Wallet Flow

**Files to update**:
- `lib/presentation/deposit_screen/notifier/deposit_notifier.dart`
- `lib/presentation/deposit_bottomsheet/deposit_bottomsheet.dart`
- `lib/presentation/select_plan_screen/select_plan_screen.dart`

### 2.4 Add Wallet Management Screens

Create screens for:
- Wallet balance display
- Transaction history
- Withdrawal request form
- Payment history

---

## 3. Subscription Plans Integration

### Plan Structure

```
Basic:
- ₦500/month
- 10 trip searches per month
- Monetize 20 trips

Rover:
- ₦2,500/month
- 35 trip searches per month
- 50 route additions
- Advanced scheduling

Courier:
- ₦5,000/month
- Unlimited trip searches
- Manage multiple movers

Courier Plus:
- ₦10,000/month
- All Courier features +
- Advanced route editing
```

### Plan Payment Flow

1. User selects plan during signup
2. Redirected to Paystack payment
3. Payment verified
4. Plan activated in user account
5. Wallet can be funded separately

---

## 4. Webhook Integration

### Paystack Webhook Handler

**File**: `backend/app/api/routes/webhooks.py` (NEW FILE)

Create endpoint to handle Paystack webhooks:
- Transaction completion
- Wallet funding confirmation
- Refund processing

---

## 5. Environment Variables Summary

### Backend (.env)

```
# Paystack
PAYSTACK_PUBLIC_KEY=pk_test_xxxxx
PAYSTACK_SECRET_KEY=sk_test_xxxxx

# Optional: Other services
SENDGRID_API_KEY=...
CLOUDINARY_API_KEY=...
```

### Flutter (.env or constants)

```
PAYSTACK_PUBLIC_KEY=pk_test_xxxxx
API_BASE_URL=your_backend_url
```

---

## 6. Testing Checklist

### Backend
- [ ] Paystack transaction initialization
- [ ] Transaction verification
- [ ] Wallet funding confirmation
- [ ] Webhook validation
- [ ] Transfer/withdrawal functionality

### Flutter
- [ ] Wallet funding flow
- [ ] Plan subscription payment
- [ ] Transaction history display
- [ ] Payment status updates
- [ ] Error handling

---

## 7. Security Considerations

1. **Secret Keys**: Never commit secret keys to version control
2. **HTTPS Only**: All payments must use HTTPS
3. **Webhook Validation**: Always validate webhook signatures
4. **Data Encryption**: Encrypt sensitive payment data
5. **Rate Limiting**: Implement rate limiting on payment endpoints
6. **Audit Logging**: Log all payment transactions

---

## 8. Deployment Steps

1. Update backend environment variables
2. Deploy backend changes
3. Update Flutter app with new Paystack configuration
4. Test in staging environment
5. Enable webhooks in Paystack dashboard
6. Deploy to production
7. Monitor transaction logs

---

## 9. References

- **Paystack Documentation**: https://paystack.com/docs/api/
- **Paystack Dashboard**: https://dashboard.paystack.com/
- **Flutter Paystack Package**: https://pub.dev/packages/flutter_paystack

---

## Next Steps

1. **Phase 1**: Backend integration (Paystack service + payment routes)
2. **Phase 2**: Wallet management (deposit, withdrawal, balance)
3. **Phase 3**: Subscription plan integration
4. **Phase 4**: Flutter app updates
5. **Phase 5**: Testing & deployment