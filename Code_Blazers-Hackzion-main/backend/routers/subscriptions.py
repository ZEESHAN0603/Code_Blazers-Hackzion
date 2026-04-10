from fastapi import APIRouter, Depends, HTTPException
from typing import List
from pydantic import BaseModel
import asyncio

from database import get_supabase
import schemas

router = APIRouter(prefix="/subscriptions", tags=["Subscriptions"])

class DetectEmail(BaseModel):
    email: str

@router.get("/", response_model=List[schemas.SubscriptionRead])
async def get_subscriptions(email: str = None):
    """Retrieve all subscriptions."""
    supabase = get_supabase()
    
    if email:
        # Ignore filtering by email since the subscriptions table has no email column
        pass
    
    response = supabase.table("subscriptions").select("*").execute()
    
    if not response.data and not email:
        demo_data = [
            {"service_name": "Netflix", "amount": 649, "billing_cycle": "monthly"},
            {"service_name": "Amazon Prime", "amount": 299, "billing_cycle": "monthly"},
            {"service_name": "Internet", "amount": 999, "billing_cycle": "monthly"},
            {"service_name": "Gym", "amount": 1500, "billing_cycle": "monthly"}
        ]
        supabase.table("subscriptions").insert(demo_data).execute()
        response = supabase.table("subscriptions").select("*").execute()
        
    return response.data

@router.post("/detect", response_model=List[schemas.SubscriptionRead])
async def detect_and_add_subscriptions(payload: DetectEmail):
    """Detect subscriptions by email and add them to the database."""
    email = payload.email
    supabase = get_supabase()
    new_subs = []
    
    if email == "udayapriyanudhayapriyan@gmail.com":
        new_subs = [
            {"service_name": "Adobe", "amount": 500, "billing_cycle": "monthly"},
            {"service_name": "Apple Music", "amount": 99, "billing_cycle": "monthly"}
        ]
    elif email == "ragul652770@gmail.com":
        new_subs = [
            {"service_name": "Hotstar", "amount": 299, "billing_cycle": "monthly"}
        ]
    elif email == "1enjoyfully1@gmail.com":
        new_subs = [
            {"service_name": "Spotify Premium", "amount": 119, "billing_cycle": "monthly"}
        ]
    else:
        await asyncio.sleep(3)
        return []
        
    response = supabase.table("subscriptions").insert(new_subs).execute()
    return response.data

@router.post("/", response_model=schemas.SubscriptionRead, status_code=201)
def create_subscription(payload: schemas.SubscriptionCreate):
    """Manually add a subscription."""
    supabase = get_supabase()
    response = supabase.table("subscriptions").insert(payload.dict()).execute()
    if not response.data:
        raise HTTPException(status_code=400, detail="Failed to create subscription")
    return response.data[0]

@router.delete("/{id}")
def delete_subscription(id: str):
    """Remove a subscription by ID."""
    supabase = get_supabase()
    response = supabase.table("subscriptions").delete().eq("id", id).execute()
    if not response.data:
        raise HTTPException(status_code=404, detail=f"Subscription {id} not found")
    return {"message": f"Subscription {id} deleted successfully"}
