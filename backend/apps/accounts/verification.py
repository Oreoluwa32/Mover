from __future__ import annotations

from .models import KycRecord, User, Vehicle


VEHICLE_DOCUMENT_FIELDS = (
    "vehicle_photo",
    "driver_license",
    "vehicle_report",
    "vehicle_insurance",
)


def has_completed_personal_information(user: User) -> bool:
    return all(
        [
            bool((user.first_name or "").strip()),
            bool((user.last_name or "").strip()),
            bool((user.email or "").strip()),
            bool((user.phone_number or "").strip()),
        ]
    )


def has_verified_government_identification(user: User) -> bool:
    kyc_record = getattr(user, "kyc_record", None)
    if kyc_record is None:
        return False
    return (
        bool((kyc_record.nin or "").strip())
        and bool((kyc_record.bvn or "").strip())
        and kyc_record.status == KycRecord.Status.VERIFIED
    )


def has_vehicle_documents(vehicle: Vehicle) -> bool:
    metadata = vehicle.metadata if isinstance(vehicle.metadata, dict) else {}
    return all(bool(str(metadata.get(field) or "").strip()) for field in VEHICLE_DOCUMENT_FIELDS)


def has_verified_vehicle_identification(user: User) -> bool:
    return any(
        vehicle.is_verified and has_vehicle_documents(vehicle)
        for vehicle in user.vehicles.all()
    )


def is_fully_verified_user(user: User) -> bool:
    return (
        has_completed_personal_information(user)
        and has_verified_government_identification(user)
        and has_verified_vehicle_identification(user)
    )
