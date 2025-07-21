from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import datetime
import random, string
from .models import User, OTP

# ---------- USER ----------
async def create_user(db: AsyncSession, user_in):
    user = User(**user_in.model_dump())
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user

async def get_user_by_phone(db: AsyncSession, phone: str):
    result = await db.execute(select(User).where(User.phone == phone))
    return result.scalar_one_or_none()

# ---------- OTP ----------
def _random_otp() -> str:
    return "".join(random.choices(string.digits, k=6))

async def create_or_update_otp(db: AsyncSession, phone: str):
    otp_code = _random_otp()
    expiry   = OTP.expiry_time()

    stmt = (
        update(OTP)
        .where(OTP.phone == phone)
        .values(otp=otp_code, expires_at=expiry, created_at=datetime.utcnow())
    )
    result = await db.execute(stmt)
    if not result.rowcount:                   # => OTP row doesn't exist yet
        db.add(OTP(phone=phone, otp=otp_code, expires_at=expiry))
    await db.commit()
    return otp_code, expiry

async def verify_otp(db: AsyncSession, phone: str, otp_code: str) -> bool:
    result = await db.execute(
        select(OTP).where(OTP.phone == phone, OTP.otp == otp_code)
    )
    record = result.scalar_one_or_none()
    return bool(record and record.expires_at > datetime.utcnow())
