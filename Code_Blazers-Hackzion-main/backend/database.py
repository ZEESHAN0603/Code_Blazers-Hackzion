import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

if not SUPABASE_URL or "YOUR_SUPABASE_PROJECT_ID" in SUPABASE_URL:
    print("\n[WARNING] SUPABASE_URL is not set or using placeholder! Please update your .env file.\n")

if not SUPABASE_KEY or "YOUR_SUPABASE_ANON_KEY" in SUPABASE_KEY:
    print("\n[WARNING] SUPABASE_KEY is not set or using placeholder! Please update your .env file.\n")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def get_supabase():
    """Returns the Supabase client instance."""
    return supabase
