from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_async_session
from app.schemas.net_worth import NetWorthResponse
from app.crud.net_worth import get_latest_snapshot_for_user

router = APIRouter()

@router.get("/home", response_model=NetWorthResponse)
async def fetch_net_worth(user_id: int = 1, db: AsyncSession = Depends(get_async_session)):
    result = await get_latest_snapshot_for_user(db, user_id)
    if not result:
        raise HTTPException(status_code=404, detail="No net worth snapshot found.")
    return result
