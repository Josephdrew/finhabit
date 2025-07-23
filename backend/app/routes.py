from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from . import crud, schemas
from .database import get_db

router = APIRouter()

@router.post("/signup", response_model=schemas.UserOut)
async def signup(user: schemas.UserCreate, db: AsyncSession = Depends(get_db)):
    return await crud.create_user(user, db)

@router.post("/login", response_model=schemas.UserOut)
async def login(user: schemas.UserLogin, db: AsyncSession = Depends(get_db)):
    authenticated_user = await crud.authenticate_user(user.email, user.password, db)
    return authenticated_user
