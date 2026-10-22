from uuid import UUID

import jwt
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.security import (
    create_access_token,
    decode_access_token,
    hash_password,
    verify_password,
)
from app.database import get_db
from app.models.user import User
from app.schemas.auth import (
    SignupRequest,
    TokenResponse,
    UserResponse,
)
import hmac

from app.config import settings


router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="/api/v1/auth/login"
)


# --------------------------------------------------
# JSON LOGIN SCHEMA
# --------------------------------------------------

class LoginJSON(BaseModel):
    phone: str = Field(min_length=10, max_length=20)
    password: str = Field(min_length=1, max_length=128)


class PasswordChangeRequest(BaseModel):
    current_password: str
    new_password: str = Field(min_length=8, max_length=128)

class DevPasswordResetRequest(BaseModel):
    phone: str = Field(min_length=10, max_length=20)
    recovery_code: str = Field(min_length=6, max_length=12)
    new_password: str = Field(min_length=8, max_length=128)

# --------------------------------------------------
# SHARED USER AUTHENTICATION
# --------------------------------------------------

def authenticate_user(
    phone: str,
    password: str,
    db: Session,
) -> User:

    user = db.scalar(
        select(User).where(User.phone == phone)
    )

    if (
        user is None
        or user.password_hash is None
        or not verify_password(
            password,
            user.password_hash,
        )
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect phone number or password.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return user




@router.post(
    "/signup",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
def signup(
    payload: SignupRequest,
    db: Session = Depends(get_db),
):
    existing_user = db.scalar(
        select(User).where(
            User.phone == payload.phone
        )
    )

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Unable to create an account with these details.",
        )

    user = User(
        phone=payload.phone,
        password_hash=hash_password(
            payload.password
        ),
    )

    db.add(user)

    try:
        db.commit()
        db.refresh(user)

    except Exception:
        db.rollback()

        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Unable to create an account. Check the supplied details.",
        )

    return user


# --------------------------------------------------
# FORM LOGIN FOR SWAGGER OAUTH2
# POST /api/v1/auth/login
# --------------------------------------------------

@router.post(
    "/login",
    response_model=TokenResponse,
)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
):
    # Swagger's OAuth2 form uses "username".
    # We use that field to receive the phone number.

    user = authenticate_user(
        phone=form_data.username,
        password=form_data.password,
        db=db,
    )

    return TokenResponse(
        access_token=create_access_token(user.id)
    )


# --------------------------------------------------
# JSON LOGIN FOR FLUTTER
# POST /api/v1/auth/login/json
# --------------------------------------------------

@router.post(
    "/login/json",
    response_model=TokenResponse,
)
def login_json(
    payload: LoginJSON,
    db: Session = Depends(get_db),
):
    user = authenticate_user(
        phone=payload.phone,
        password=payload.password,
        db=db,
    )

    return TokenResponse(
        access_token=create_access_token(user.id)
    )


# --------------------------------------------------
# GET CURRENT AUTHENTICATED USER
# --------------------------------------------------

def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> User:

    credentials_error = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired access token.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = decode_access_token(token)

        user_id = UUID(
            payload["sub"]
        )

    except (
        jwt.InvalidTokenError,
        ValueError,
        KeyError,
        TypeError,
    ):
        raise credentials_error

    user = db.get(
        User,
        user_id,
    )

    if user is None:
        raise credentials_error

    return user


# --------------------------------------------------
# CURRENT USER PROFILE
# GET /api/v1/auth/me
# --------------------------------------------------

@router.get(
    "/me",
    response_model=UserResponse,
)
def get_me(
    current_user: User = Depends(
        get_current_user
    ),
):
    return current_user

@router.post("/change-password")
def change_password(
    payload: PasswordChangeRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not verify_password(
        payload.current_password,
        current_user.password_hash,
    ):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Current password is incorrect.",
        )

    current_user.password_hash = hash_password(payload.new_password)

    db.commit()

    return {"message": "Password changed successfully."}

@router.post("/dev-reset-password")
def dev_reset_password(
    payload: DevPasswordResetRequest,
    db: Session = Depends(get_db),
):
    # Never permit this development mechanism if it is not configured.
    expected_code = settings.DEV_PASSWORD_RESET_CODE

    if not expected_code or not hmac.compare_digest(
        payload.recovery_code,
        expected_code,
    ):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Unable to reset the password with the supplied details.",
        )

    user = db.scalar(
        select(User).where(User.phone == payload.phone.strip())
    )

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Unable to reset the password with the supplied details.",
        )

    user.password_hash = hash_password(payload.new_password)
    db.commit()

    return {
        "message": "If the supplied details are valid, the reset request has been processed."
    }