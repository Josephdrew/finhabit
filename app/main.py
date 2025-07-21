from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from . import database, crud, schemas, email_utils

app = FastAPI(title="Auth‑OTP API")

# --- DB initialise on startup (development only) ----------------------------
@app.on_event("startup")
async def startup():
    """
    In production use Alembic migrations instead of `metadata.create_all`.
    """
    async with database.engine.begin() as conn:
        await conn.run_sync(database.Base.metadata.create_all)

# ----------------------------- ROUTES ---------------------------------------
@app.post("/signup", status_code=status.HTTP_201_CREATED)
async def signup(payload: schemas.UserCreate,
                 db: AsyncSession = Depends(database.get_db)):
    if await crud.get_user_by_phone(db, payload.phone):
        raise HTTPException(409, "Phone already registered")

    await crud.create_user(db, payload)
    return {"detail": "User created"}

@app.post("/signin")
async def signin(payload: schemas.SignInRequest,
                 db: AsyncSession = Depends(database.get_db)):
    user = await crud.get_user_by_phone(db, payload.phone)
    if not user:
        raise HTTPException(404, "User not found")

    otp, _ = await crud.create_or_update_otp(db, payload.phone)
    email_utils.send_email_otp(user.email, otp)
    return {"detail": "OTP sent to email"}

@app.post("/verify-otp")
async def verify_otp(payload: schemas.OTPVerifyRequest,
                     db: AsyncSession = Depends(database.get_db)):
    valid = await crud.verify_otp(db, payload.phone, payload.otp)
    if not valid:
        raise HTTPException(400, "Invalid or expired OTP")
    return {"detail": "OTP verified"}
