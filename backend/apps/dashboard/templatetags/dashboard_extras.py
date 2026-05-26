from django import template

register = template.Library()

_TONES = {
    "green": {"active", "verified", "completed", "delivered", "success", "accepted", "live"},
    "amber": {"pending", "in_review", "open", "proposed", "draft"},
    "blue": {"matched", "in_progress", "in_transit", "picked_up", "published", "acknowledged"},
    "red": {"suspended", "rejected", "cancelled", "failed", "damaged", "sos"},
    "gray": {"inactive", "idle", "ended", "paused"},
}
_VALUE_TO_TONE = {value: tone for tone, values in _TONES.items() for value in values}


@register.filter
def status_tone(value: str) -> str:
    return _VALUE_TO_TONE.get((value or "").lower(), "gray")


@register.filter
def humanize_status(value: str) -> str:
    return (value or "").replace("_", " ").title()
