"""
Parser Service — Post-processes and validates data from the LLM.
Normalizes fields before saving to the database.
"""

from datetime import date
from utils.json_utils import safe_float

VALID_CATEGORIES = [
    "Food", "Transport", "Shopping", "Healthcare",
    "Utilities", "Entertainment", "Other"
]


def normalize_receipt_data(raw: dict) -> dict:
    """
    Cleans and validates data received from the LLM receipt parser.
    Returns a clean dict ready for database insertion.
    """
    merchant = str(raw.get("merchant_name") or raw.get("merchant") or "Unknown").strip()
    amount = safe_float(raw.get("amount", 0))
    category = str(raw.get("category", "Other")).strip()
    raw_date = str(raw.get("date", "")).strip()

    # Validate category
    if category not in VALID_CATEGORIES:
        category = "Other"

    # Validate date format; fall back to today if invalid
    try:
        date.fromisoformat(raw_date)
    except ValueError:
        raw_date = date.today().isoformat()

    return {
        "merchant": merchant,
        "amount": amount,
        "category": category,
        "date": raw_date,
        "payment_method": "Receipt Scan"
    }
