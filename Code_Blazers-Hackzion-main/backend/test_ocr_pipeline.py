import sys
import io
import time
import requests
from PIL import Image, ImageDraw
import numpy as np

# Change directory into the backend correctly in the script or run it from the backend dir
sys.path.append(".")

from services.ocr_service import ocr_service
from services.llm_service import llm_service

def create_dummy_receipt():
    img = Image.new('RGB', (600, 400), color=(255, 255, 255))
    d = ImageDraw.Draw(img)
    d.text((50, 50), 'UBER RIDES', fill=(0, 0, 0))
    d.text((50, 100), 'Total: 250.00', fill=(0, 0, 0))
    d.text((50, 150), 'Date: 2026-04-10', fill=(0, 0, 0))
    d.text((50, 200), 'Thank you for riding with us!', fill=(0, 0, 0))
    bio = io.BytesIO()
    img.save(bio, format='PNG')
    return bio.getvalue()

def run_pipeline():
    print("Generating dummy receipt image...")
    image_bytes = create_dummy_receipt()
    
    print("Running DocTR OCR model...")
    start_ocr = time.time()
    ocr_text = ocr_service.extract_text(image_bytes)
    print(f"OCR Text extracted (in {time.time() - start_ocr:.2f}s):")
    print("-" * 40)
    print(ocr_text)
    print("-" * 40)
    
    if not ocr_text.strip():
        print("FAILED: No text extracted.")
        return
        
    print(f"Sending to Gemma 2 ({llm_service.url}) for parsing...")
    start_llm = time.time()
    try:
        parsed_data = llm_service.parse_receipt(ocr_text)
        print(f"Parsed JSON answer (in {time.time() - start_llm:.2f}s):")
        print("=" * 40)
        import json
        print(json.dumps(parsed_data, indent=2))
        print("=" * 40)
    except Exception as e:
        print("LLM Error:", e)

if __name__ == "__main__":
    run_pipeline()
