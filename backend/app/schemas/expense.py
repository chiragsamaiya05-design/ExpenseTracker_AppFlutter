from datetime import date as DateType, datetime
from decimal import Decimal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class ExpenseCreate(BaseModel):
    id: UUID | None = None
    title: str = Field(
        min_length=1,
        max_length=150
    )
    amount: Decimal = Field(
        gt=0,
        max_digits=12,
        decimal_places=2,
    )
    category: str = Field(
        min_length=1,
        max_length=100
    )
    date: DateType


class ExpenseUpdate(BaseModel):
    title: str | None = Field(
        default=None,
        min_length=1,
        max_length=150,
    )
    amount: Decimal | None = Field(
        default=None,
        gt=0,
        max_digits=12,
        decimal_places=2,
    )
    category: str | None = Field(
        default=None,
        min_length=1,
        max_length=100,
    )
    date: DateType | None = None


class ExpenseResponse(BaseModel):
    id: UUID
    title: str
    amount: Decimal
    category: str
    date: DateType
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)