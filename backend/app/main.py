from fastapi import FastAPI, HTTPException

from app.config import settings
from app.database import test_database_connection
from app.api.expenses import router as expenses_router
from app.api.auth import router as auth_router

app = FastAPI(
    title=settings.APP_NAME,
    version="1.0.0",
    description="Backend API for the Expense Tracker",
)

app.include_router(
    auth_router,
    prefix="/api/v1",
)

app.include_router(
    expenses_router,
    prefix="/api/v1",
)


@app.get("/")
def root():
    return {
        "message": "Expense Tracker API is running",
        "environment": settings.APP_ENV,
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}


@app.get("/health/database")
def database_health_check():
    try:
        return {
            "status": "healthy",
            "database": test_database_connection(),
        }
    except Exception as exc:
        print(f"Database connection error: {exc}")

        raise HTTPException(
            status_code=503,
            detail="Database connection failed. Check backend terminal.",
        )

