from sqlalchemy import Column, Integer, String, DateTime, func
from sqlalchemy.sql import text
from datetime import timedelta, datetime
from .database import Base

class User(Base):
    __tablename__ = "users"

    id        = Column(Integer, primary_key=True, index=True)
    name      = Column(String(100), nullable=False)
    email     = Column(String(100), unique=True, nullable=False)
    phone     = Column(String(20), unique=True, nullable=False)
    created_at= Column(DateTime(timezone=True),
                       server_default=func.now(), nullable=False)

class OTP(Base):
    """
    Store only the last OTP sent per phone.
    """
    __tablename__ = "otps"

    phone      = Column(String(20), primary_key=True)         # 1‑to‑1 with user
    otp        = Column(String(6),  nullable=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    created_at = Column(DateTime(timezone=True),
                        server_default=func.now(), nullable=False)

    @classmethod
    def expiry_time(cls):
        from dotenv import load_dotenv; load_dotenv()
        ttl = int(os.getenv("OTP_TTL_MINUTES", 5))
        return datetime.utcnow() + timedelta(minutes=ttl)
