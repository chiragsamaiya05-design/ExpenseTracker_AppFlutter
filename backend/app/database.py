from sqlalchemy import create_engine, text
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from app.config import settings


# PostgreSQL connection
def create_database_engine():
    database_url = settings.DATABASE_URL

    # SQLAlchemy URL objects handle password escaping automatically.
    return create_engine(
        database_url,
        pool_pre_ping=True,
    )


engine = create_database_engine()


# Database session factory
SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
)


# Base class for SQLAlchemy models
class Base(DeclarativeBase):
    pass


# Database session dependency for FastAPI
def get_db():
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()


# Test PostgreSQL connection
def test_database_connection():
    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))

    return "PostgreSQL connection successful"