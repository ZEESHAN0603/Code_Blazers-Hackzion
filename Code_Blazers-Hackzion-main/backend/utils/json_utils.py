"""
JSON extraction utilities for safely parsing LLM responses.
Gemma may return text alongside JSON — this module isolates the JSON block.
"""

import json
import regex  # 'regex' supports recursive patterns unlike 're'


def extract_json(text: str) -> dict | None:
    """
    Extracts the first valid JSON object from an LLM response string.
    Uses recursive regex to handle nested braces safely.

    Returns a parsed dict or None if extraction fails.
    """
    if not text:
        return None

    try:
        # Strategy 1: Try parsing the entire string directly
        return json.loads(text.strip())
    except json.JSONDecodeError:
        pass

    try:
        # Strategy 2: Use regex to find a JSON block with balanced braces
        match = regex.search(r'\{(?:[^{}]|(?R))*\}', text, regex.DOTALL)
        if match:
            json_str = match.group(0)
            return json.loads(json_str)
    except (json.JSONDecodeError, Exception):
        pass

    return None


def safe_float(value) -> float:
    """Safely converts a value to float, returning 0.0 on failure."""
    try:
        return float(str(value).replace(",", "").replace("₹", "").replace("$", "").strip())
    except (ValueError, TypeError):
        return 0.0
