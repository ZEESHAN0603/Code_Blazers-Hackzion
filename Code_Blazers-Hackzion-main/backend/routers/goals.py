from fastapi import APIRouter, Depends, HTTPException
from typing import List

from database import get_supabase
import schemas

router = APIRouter(prefix="/goals", tags=["Goals"])

@router.get("/", response_model=List[schemas.GoalRead])
def get_all_goals():
    """Retrieve all financial goals."""
    supabase = get_supabase()
    response = supabase.table("goals").select("*").execute()
    
    if not response.data:
        demo_data = [
            {"goal_name": "Emergency Fund", "target_amount": 50000, "saved_amount": 0},
            {"goal_name": "Buy Laptop", "target_amount": 80000, "saved_amount": 15000}
        ]
        supabase.table("goals").insert(demo_data).execute()
        response = supabase.table("goals").select("*").execute()
        
    return response.data

@router.post("/", response_model=schemas.GoalRead, status_code=201)
def create_goal(payload: schemas.GoalCreate):
    """Create a new savings goal."""
    supabase = get_supabase()
    response = supabase.table("goals").insert(payload.dict()).execute()
    if not response.data:
        raise HTTPException(status_code=400, detail="Failed to create goal")
    return response.data[0]

@router.put("/{id}", response_model=schemas.GoalRead)
def update_goal(id: str, payload: schemas.GoalUpdate):
    """Update goal progress (e.g. increase saved_amount)."""
    supabase = get_supabase()
    update_data = payload.dict(exclude_unset=True)
    response = supabase.table("goals").update(update_data).eq("id", id).execute()
    if not response.data:
        raise HTTPException(status_code=404, detail=f"Goal {id} not found")
    return response.data[0]

@router.delete("/{id}")
def delete_goal(id: str):
    """Delete a goal by ID."""
    supabase = get_supabase()
    response = supabase.table("goals").delete().eq("id", id).execute()
    if not response.data:
        raise HTTPException(status_code=404, detail=f"Goal {id} not found")
    return {"message": f"Goal {id} deleted successfully"}
