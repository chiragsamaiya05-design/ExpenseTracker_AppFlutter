from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

from pydantic import BaseModel, Field


class DevPasswordResetRequest(BaseModel):
    phone: str = Field(min_length=10, max_length=20)
    recovery_code: str = Field(min_length=6, max_length=12)
    new_password: str = Field(min_length=8, max_length=128)


class SignupRequest(BaseModel):
    phone: str = Field(min_length=10, max_length=20)
    password: str = Field(min_length=8, max_length=128)


class LoginRequest(BaseModel):
    phone: str = Field(min_length=10, max_length=20)
    password: str = Field(min_length=1, max_length=128)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserResponse(BaseModel):
    id: UUID
    phone: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)