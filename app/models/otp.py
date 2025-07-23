import os
from sqlalchemy import Column, String, DateTime, func
from datetime import timedelta, datetime
from ..database import Base

class OTP(Base):
    __tablename__ = "otps"

    phone      = Column(String(20), primary_key=True)
    otp        = Column(String(6),  nullable=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    @classmethod
    def expiry_time(cls):
        from ..core.config import settings
        return datetime.utcnow() + timedelta(minutes=settings.OTP_TTL_MINUTES)