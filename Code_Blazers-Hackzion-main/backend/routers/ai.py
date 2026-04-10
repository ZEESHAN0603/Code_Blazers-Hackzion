from fastapi import APIRouter, HTTPException
from typing import List

from database import get_supabase
import schemas
from services.llm_service import llm_service

router = APIRouter(tags=["AI"])

@router.post("/ai-chat", response_model=schemas.ChatResponse)
def ai_chat(request: schemas.ChatRequest):
    """
    Financial AI chatbot powered by Gemma (Ollama).
    Automatically pulls user transactions and goals as context.
    """
    supabase = get_supabase()
    
    # Build financial context
    transactions_res = supabase.table("transactions").select("*").limit(50).execute()
    goals_res = supabase.table("goals").select("*").execute()
    subscriptions_res = supabase.table("subscriptions").select("*").execute()

    transactions = transactions_res.data or []
    goals = goals_res.data or []
    subscriptions = subscriptions_res.data or []

    context_lines = []

    if transactions:
        context_lines.append("RECENT TRANSACTIONS:")
        for t in transactions:
            context_lines.append(
                f"  - {t['merchant']}: ₹{t['amount']} ({t['category']}) on {t['date']}"
            )

    if subscriptions:
        total_subs = sum(s['amount'] for s in subscriptions)
        context_lines.append(f"\nSUBSCRIPTIONS: {len(subscriptions)} active, total ₹{total_subs:.2f}/month")

    if goals:
        context_lines.append("\nFINANCIAL GOALS:")
        for g in goals:
            progress = (g['saved_amount'] / g['target_amount'] * 100) if g['target_amount'] > 0 else 0
            context_lines.append(
                f"  - {g['goal_name']}: ₹{g['saved_amount']} / ₹{g['target_amount'] } ({progress:.1f}%)"
            )

    if not context_lines:
        context_lines.append("No financial data available yet.")

    financial_context = "\n".join(context_lines)

    try:
        response_text = llm_service.ask_financial_question(
            user_message=request.user_message,
            financial_context=financial_context
        )
    except ConnectionError as e:
        raise HTTPException(status_code=503, detail={"error": str(e)})
    except Exception as e:
        raise HTTPException(status_code=500, detail={"error": f"AI error: {str(e)}"})

    return schemas.ChatResponse(response=response_text)

@router.get("/dashboard", response_model=schemas.DashboardResponse)
def get_dashboard():
    """
    Returns a financial summary for the dashboard.
    Includes: total spending, subscriptions, savings, and a basic spending prediction.
    """
    supabase = get_supabase()
    
    transactions_res = supabase.table("transactions").select("*").execute()
    subscriptions_res = supabase.table("subscriptions").select("*").execute()
    goals_res = supabase.table("goals").select("*").execute()

    transactions = transactions_res.data or []
    subscriptions = subscriptions_res.data or []
    goals = goals_res.data or []

    total_spending = sum(t['amount'] for t in transactions)
    subscription_total = sum(s['amount'] for s in subscriptions)
    goal_savings_total = sum(g['saved_amount'] for g in goals)

    # Basic prediction: average transactions × frequency assumption
    if transactions:
        predicted = (total_spending / max(len(transactions), 1)) * len(transactions) * 1.05
    else:
        predicted = 0.0

    return schemas.DashboardResponse(
        total_spending=round(total_spending, 2),
        subscription_total=round(subscription_total, 2),
        goal_savings_total=round(goal_savings_total, 2),
        predicted_next_month_spending=round(predicted, 2),
        transaction_count=len(transactions)
    )
