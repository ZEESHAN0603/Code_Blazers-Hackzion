"""
LLM Service — handles all communication with Ollama (Gemma model).
"""

import requests
from utils.json_utils import extract_json
from utils.prompt_templates import RECEIPT_PARSING_PROMPT, AI_CHATBOT_PROMPT

OLLAMA_URL = "http://localhost:11434/api/chat"
CHAT_MODEL = "mistral:7b"
PARSER_MODEL = "gemma2:latest"


class LLMService:
    def __init__(self, url: str = OLLAMA_URL):
        self.url = url

    def _chat(self, prompt: str, model: str) -> str:
        """
        Internal method: sends a prompt to Ollama and returns raw content string.
        Raises ConnectionError if Ollama is unreachable.
        """
        payload = {
            "model": model,
            "messages": [
                {"role": "user", "content": prompt}
            ],
            "stream": False
        }
        try:
            response = requests.post(self.url, json=payload, timeout=60)
            response.raise_for_status()
            data = response.json()
            return data.get("message", {}).get("content", "")
        except requests.exceptions.ConnectionError:
            raise ConnectionError(
                "Ollama is not running. Please start Ollama with: ollama serve"
            )
        except requests.exceptions.Timeout:
            raise TimeoutError("Ollama request timed out. The model may still be loading.")
        except requests.exceptions.RequestException as e:
            raise RuntimeError(f"Ollama request failed: {str(e)}")

    def parse_receipt(self, ocr_text: str) -> dict | None:
        """
        Sends OCR-extracted text to Gemma and extracts structured expense JSON.
        Returns a dict with: merchant_name, amount, date, category
        """
        prompt = RECEIPT_PARSING_PROMPT.format(ocr_text=ocr_text)
        raw_response = self._chat(prompt, model=PARSER_MODEL)
        return extract_json(raw_response)

    def ask_financial_question(self, user_message: str, financial_context: str) -> str:
        """
        Sends a financial question along with user data context to Mistral.
        Returns a natural language response string.
        """
        prompt = AI_CHATBOT_PROMPT.format(
            financial_context=financial_context,
            user_message=user_message
        )
        return self._chat(prompt, model=CHAT_MODEL)


# Singleton instance — prevents multiple Ollama connections
llm_service = LLMService()
