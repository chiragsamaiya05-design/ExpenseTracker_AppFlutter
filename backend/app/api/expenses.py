from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, Response, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.database import get_db
from app.models.expense import Expense
from app.models.user import User
from app.schemas.expense import (
    ExpenseCreate,
    ExpenseResponse,
    ExpenseUpdate,
)

router = APIRouter(prefix="/expenses", tags=["Expenses"])


@router.post(
    "",
    response_model=ExpenseResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_expense(
    payload: ExpenseCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):

    if payload.id is not None:
        existing_expense = db.scalar(
            select(Expense).where(Expense.id == payload.id)
        )

        if existing_expense is not None:

            if existing_expense.user_id != current_user.id:
              raise HTTPException( 
                  status_code=status.HTTP_409_CONFLICT,
                    detail="Expense ID already exists.", 
                    )  
            if existing_expense.deleted_at is not None: 
                raise HTTPException( 
                    status_code=status.HTTP_409_CONFLICT, 
                    detail="This expense has already been deleted.", 
                    )
            return existing_expense
    
    expense = Expense(
        **({"id": payload.id} if payload.id is not None else {}),
        user_id=current_user.id,
        title=payload.title,
        amount=payload.amount,
        category=payload.category,
        date=payload.date,
    )

    db.add(expense)
    db.commit()
    db.refresh(expense)

    return expense


@router.get("", response_model=list[ExpenseResponse])
def list_expenses(
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    statement = (
        select(Expense)
        .where(
            Expense.user_id == current_user.id,
            Expense.deleted_at.is_(None),
        )
        .order_by(Expense.date.desc(), Expense.created_at.desc())
        .limit(limit)
        .offset(offset)
    )

    return list(db.scalars(statement).all())


@router.get("/{expense_id}", response_model=ExpenseResponse)
def get_expense(
    expense_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    statement = select(Expense).where(
        Expense.id == expense_id,
        Expense.user_id == current_user.id,
        Expense.deleted_at.is_(None),
    )

    expense = db.scalar(statement)

    if expense is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Expense not found.",
        )

    return expense


@router.put("/{expense_id}", response_model=ExpenseResponse)
def update_expense(
    expense_id: UUID,
    payload: ExpenseUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    expense = db.scalar(
        select(Expense).where(
            Expense.id == expense_id,
            Expense.user_id == current_user.id,
            Expense.deleted_at.is_(None),
        )
    )

    if expense is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Expense not found.",
        )

    changes = payload.model_dump(exclude_unset=True)

    for field, value in changes.items():
        setattr(expense, field, value)

    db.commit()
    db.refresh(expense)

    return expense


@router.delete("/{expense_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_expense(
    expense_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    expense = db.scalar(
        select(Expense).where(
            Expense.id == expense_id,
            Expense.user_id == current_user.id,
            Expense.deleted_at.is_(None),
        )
    )

    if expense is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Expense not found.",
        )

    # Soft delete: preserve the record for potential offline synchronization.
    from datetime import datetime, timezone

    expense.deleted_at = datetime.now(timezone.utc)

    db.commit()

    return Response(status_code=status.HTTP_204_NO_CONTENT)