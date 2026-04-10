from fastapi import APIRouter, HTTPException
from database import get_supabase
import schemas

router = APIRouter(prefix="/auth", tags=["Auth"])

@router.post("/signup", response_model=schemas.AuthResponse)
def signup(payload: schemas.UserSignup):
    """Register a new user in Supabase Auth."""
    supabase = get_supabase()
    try:
        # Sign up using Supabase Auth
        # Note: If email confirmation is enabled in your Supabase project, 
        # the user will need to confirm their email before they can sign in.
        res = supabase.auth.sign_up({
            "email": payload.email,
            "password": payload.password,
            "options": {
                "data": {"full_name": payload.full_name}
            }
        })
        
        if not res.session:
            # This happens if email confirmation is required
            return schemas.AuthResponse(
                access_token="verification_email_sent",
                user_id=res.user.id,
                email=res.user.email
            )

        return schemas.AuthResponse(
            access_token=res.session.access_token,
            user_id=res.user.id,
            email=res.user.email
        )
    except Exception as e:
        # Extract error message for better user feedback
        error_msg = str(e)
        if "already registered" in error_msg.lower():
            error_msg = "User with this email already exists."
        elif "at least 6 characters" in error_msg.lower():
            error_msg = "Password must be at least 6 characters."
        raise HTTPException(status_code=400, detail=error_msg)

@router.post("/login", response_model=schemas.AuthResponse)
def login(payload: schemas.UserLogin):
    """Authenticate a user using Supabase Auth."""
    supabase = get_supabase()
    try:
        res = supabase.auth.sign_in_with_password({
            "email": payload.email,
            "password": payload.password
        })
        
        if not res.session:
             raise HTTPException(status_code=401, detail="Invalid login credentials")

        return schemas.AuthResponse(
            access_token=res.session.access_token,
            user_id=res.user.id,
            email=res.user.email
        )
    except Exception as e:
        raise HTTPException(status_code=401, detail=str(e))
