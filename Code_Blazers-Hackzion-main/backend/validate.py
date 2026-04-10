import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Test imports (skip OCR model load)
from backend.database import engine, Base, get_db
from backend import models, schemas
from backend.utils.json_utils import extract_json, safe_float
from backend.utils.prompt_templates import RECEIPT_PARSING_PROMPT, AI_CHATBOT_PROMPT
print('[OK] All core imports succeeded')

# Test JSON extractor
raw = '{"merchant_name": "Swiggy", "amount": 450.0, "date": "2026-04-10", "category": "Food"}'
result = extract_json(raw)
assert result['merchant_name'] == 'Swiggy', 'JSON extraction failed'
print('[OK] extract_json works correctly')

# Test safe_float
assert safe_float('450') == 450.0
assert safe_float('650.5') == 650.5
print('[OK] safe_float works correctly')

# Test DB table creation
Base.metadata.create_all(bind=engine)
print('[OK] Database tables created successfully')

print('\n[READY] Backend is fully ready to run.')
