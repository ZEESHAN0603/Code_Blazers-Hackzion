"""
OCR Service — Uses DocTR to extract raw text from receipt images.
Model is loaded once as a singleton to avoid repeated downloads.

NOTE: DocTR is lazy-loaded so the app starts even if torch/doctr
      is not installed. OCR will return an error only when actually called.
"""

import io
import numpy as np

_ocr_model = None
_doctr_available = True

try:
    from doctr.models import ocr_predictor
except ImportError:
    _doctr_available = False
    print("[OCRService] WARNING: python-doctr not installed. OCR will be unavailable.")


def _get_model():
    global _ocr_model
    if not _doctr_available:
        return None
    if _ocr_model is None:
        print("[OCRService] Loading DocTR model (downloads on first run)...")
        _ocr_model = ocr_predictor(pretrained=True)
        print("[OCRService] Model ready.")
    return _ocr_model


class OCRService:
    def extract_text(self, image_bytes: bytes) -> str:
        """
        Accepts raw image bytes, runs DocTR OCR, and returns extracted text.
        Returns an empty string on failure.
        """
        if not _doctr_available:
            raise RuntimeError(
                "DocTR is not installed. Run: pip install python-doctr[pytorch]"
            )

        try:
            from PIL import Image
            model = _get_model()
            image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
            img_array = np.array(image)

            result = model([img_array])

            lines = []
            for page in result.pages:
                for block in page.blocks:
                    for line in block.lines:
                        words = [word.value for word in line.words]
                        lines.append(" ".join(words))

            return "\n".join(lines).strip()

        except Exception as e:
            print(f"[OCRService] Error during OCR: {e}")
            return ""


# Singleton instance — model loads lazily on first /scan-receipt call
ocr_service = OCRService()
