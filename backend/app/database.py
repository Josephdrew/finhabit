from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import declarative_base
from app.core.config import settings

# Create async engine
engine = create_async_engine(settings.DATABASE_URL, echo=True)

# Create sessionmaker for async sessions
async_session = async_sessionmaker(
    bind=engine,
    expire_on_commit=False,
    class_=AsyncSession
)

Base = declarative_base()

# Dependency for FastAPI
async def get_async_session() -> AsyncSession:
    async with async_session() as session:
        yield session
