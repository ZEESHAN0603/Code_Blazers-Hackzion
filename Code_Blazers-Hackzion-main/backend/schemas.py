from pydantic import BaseModel
from typing import Optional


# ──────────────────────────────────────────────
# Transaction Schemas
# ──────────────────────────────────────────────

class TransactionBase(BaseModel):
    merchant: str
    amount: float
    category: str
    date: str
    payment_method: Optional[str] = None


class TransactionCreate(TransactionBase):
    pass


class TransactionUpdate(BaseModel):
    merchant: Optional[str] = None
    amount: Optional[float] = None
    category: Optional[str] = None
    date: Optional[str] = None
    payment_method: Optional[str] = None


class TransactionRead(TransactionBase):
    id: str

    class Config:
        from_attributes = True


# ──────────────────────────────────────────────
# Subscription Schemas
# ──────────────────────────────────────────────

class SubscriptionBase(BaseModel):
    service_name: str
    amount: float
    billing_cycle: str  # monthly, yearly, weekly


class SubscriptionCreate(SubscriptionBase):
    pass


class SubscriptionRead(SubscriptionBase):
    id: str

    class Config:
        from_attributes = True


# ──────────────────────────────────────────────
# Goal Schemas
# ──────────────────────────────────────────────

class GoalBase(BaseModel):
    goal_name: str
    target_amount: float
    saved_amount: Optional[float] = 0.0


class GoalCreate(GoalBase):
    pass


class GoalUpdate(BaseModel):
    goal_name: Optional[str] = None
    target_amount: Optional[float] = None
    saved_amount: Optional[float] = None


class GoalRead(GoalBase):
    id: str

    class Config:
        from_attributes = True


# ──────────────────────────────────────────────
# AI / OCR Schemas
# ──────────────────────────────────────────────

class OCRResponse(BaseModel):
    merchant_name: str
    amount: float
    date: str
    category: str


class ChatRequest(BaseModel):
    user_message: str


class ChatResponse(BaseModel):
    response: str


class DashboardResponse(BaseModel):
    total_spending: float
    subscription_total: float
    goal_savings_total: float
    predicted_next_month_spending: float
    transaction_count: int


# ──────────────────────────────────────────────
# Auth Schemas
# ──────────────────────────────────────────────

class UserSignup(BaseModel):
    email: str
    password: str
    full_name: Optional[str] = None


class UserLogin(BaseModel):
    email: str
    password: str


class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    email: str
