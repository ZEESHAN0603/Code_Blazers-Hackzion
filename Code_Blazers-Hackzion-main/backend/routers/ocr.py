from fastapi import APIRouter, UploadFile, File, HTTPException
from services.ocr_service import ocr_service
from services.llm_service import llm_service
from services.parser_service import normalize_receipt_data
from schemas import OCRResponse
from database import get_supabase

router = APIRouter(prefix="/scan-receipt", tags=["OCR"])


@router.post("/", response_model=OCRResponse)
async def scan_receipt(file: UploadFile = File(...)):
    """
    Upload a receipt image to extract structured expense data and save to Supabase.
    """
    # Step 1: Read file
    try:
        content = await file.read()
    except Exception:
        raise HTTPException(status_code=400, detail="Failed to read uploaded file")

    # Step 2: OCR
    try:
        ocr_text = ocr_service.extract_text(content)
    except RuntimeError as e:
        raise HTTPException(status_code=503, detail={"error": str(e)})

    if not ocr_text:
        raise HTTPException(
            status_code=422,
            detail={"error": "OCR failed to extract text from the image. Ensure the image is clear."}
        )

    # Step 3: LLM Parsing
    try:
        raw_data = llm_service.parse_receipt(ocr_text)
    except ConnectionError as e:
        raise HTTPException(status_code=503, detail={"error": str(e)})
    except Exception as e:
        raise HTTPException(status_code=500, detail={"error": f"LLM error: {str(e)}"})

    if not raw_data:
        raise HTTPException(
            status_code=422,
            detail={"error": "Failed to parse receipt data. LLM returned invalid JSON."}
        )

    # Step 4: Normalize
    normalized = normalize_receipt_data(raw_data)
    
    # Step 5: Store in Supabase
    supabase = get_supabase()
    transaction_data = {
        "merchant": normalized["merchant"],
        "amount": normalized["amount"],
        "category": normalized["category"],
        "date": normalized["date"],
        "payment_method": "Scanned Receipt"
    }
    
    supabase.table("transactions").insert(transaction_data).execute()

    return OCRResponse(
        merchant_name=normalized["merchant"],
        amount=normalized["amount"],
        date=normalized["date"],
        category=normalized["category"]
    )
