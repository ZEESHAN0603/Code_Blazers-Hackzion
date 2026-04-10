from fastapi import APIRouter, Depends, HTTPException
from typing import List

from database import get_supabase
import schemas

router = APIRouter(prefix="/transactions", tags=["Transactions"])

@router.get("/", response_model=List[schemas.TransactionRead])
def get_all_transactions(skip: int = 0, limit: int = 100):
    """Retrieve all transactions with optional pagination."""
    supabase = get_supabase()
    response = supabase.table("transactions").select("*").range(skip, skip + limit - 1).execute()
    
    if not response.data and skip == 0:
        demo_data = [
            {"merchant": "Swiggy", "amount": 450, "category": "Food", "date": "2023-11-01", "payment_method": "UPI"},
            {"merchant": "Uber", "amount": 120, "category": "Transport", "date": "2023-11-02", "payment_method": "Credit Card"},
            {"merchant": "Amazon", "amount": 899, "category": "Shopping", "date": "2023-11-03", "payment_method": "UPI"},
            {"merchant": "Zomato", "amount": 300, "category": "Food", "date": "2023-11-04", "payment_method": "UPI"},
            {"merchant": "Electricity", "amount": 1500, "category": "Bills", "date": "2023-11-05", "payment_method": "Bank Transfer"},
            {"merchant": "Netflix", "amount": 649, "category": "Subscription", "date": "2023-11-06", "payment_method": "Credit Card"},
            {"merchant": "Flipkart", "amount": 1200, "category": "Shopping", "date": "2023-11-07", "payment_method": "UPI"}
        ]
        supabase.table("transactions").insert(demo_data).execute()
        response = supabase.table("transactions").select("*").range(skip, skip + limit - 1).execute()
        
    return response.data

@router.post("/", response_model=schemas.TransactionRead, status_code=201)
def create_transaction(payload: schemas.TransactionCreate):
    """Create a new manual transaction."""
    supabase = get_supabase()
    response = supabase.table("transactions").insert(payload.dict()).execute()
    if not response.data:
        raise HTTPException(status_code=400, detail="Failed to create transaction")
    return response.data[0]

@router.put("/{id}", response_model=schemas.TransactionRead)
def update_transaction(id: str, payload: schemas.TransactionUpdate):
    """Partially update a transaction by ID."""
    supabase = get_supabase()
    update_data = payload.dict(exclude_unset=True)
    response = supabase.table("transactions").update(update_data).eq("id", id).execute()
    if not response.data:
        raise HTTPException(status_code=404, detail=f"Transaction {id} not found")
    return response.data[0]

@router.delete("/{id}")
def delete_transaction(id: str):
    """Delete a transaction by ID."""
    supabase = get_supabase()
    response = supabase.table("transactions").delete().eq("id", id).execute()
    if not response.data:
        raise HTTPException(status_code=404, detail=f"Transaction {id} not found")
    return {"message": f"Transaction {id} deleted successfully"}
