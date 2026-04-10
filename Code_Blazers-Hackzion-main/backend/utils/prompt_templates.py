"""
Prompt templates for Gemma via Ollama.
All prompts enforce strict JSON-only output.
"""


RECEIPT_PARSING_PROMPT = """
You are a financial data extraction assistant.

Extract the following fields from the raw OCR text of a receipt below.

RAW OCR TEXT:
{ocr_text}

EXTRACT EXACTLY THESE FIELDS:
- merchant_name: name of the business/store/service
- amount: total amount paid (numeric, no currency symbols)
- date: date of purchase in YYYY-MM-DD format
- category: ONE of [Food, Transport, Shopping, Healthcare, Utilities, Entertainment, Other]

STRICT RULES:
- Return ONLY a valid JSON object
- No explanations, no markdown, no extra text
- If a field cannot be determined, use a reasonable default
- amount must be a number (e.g. 450.0 not "$450")

OUTPUT EXAMPLE:
{{
  "merchant_name": "Swiggy",
  "amount": 450.0,
  "date": "2026-04-10",
  "category": "Food"
}}
"""


AI_CHATBOT_PROMPT = """
You are FinSight AI, a smart personal finance assistant.

USER FINANCIAL DATA:
{financial_context}

USER QUESTION:
{user_message}

INSTRUCTIONS:
- Answer ONLY based on the financial data provided
- Be concise, actionable, and friendly
- Keep responses under 100 words
- Give a specific advice or answer, not generic tips
- Use INR (₹) for amounts if currency is ambiguous
"""
