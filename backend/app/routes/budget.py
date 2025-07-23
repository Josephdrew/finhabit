from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_async_session
from app.crud.budget import create_budget_choice
from app.schemas.budget import BudgetChoiceCreate

router = APIRouter()

@router.post("/budget-choice")
async def create_budget_choice_route(
    data: BudgetChoiceCreate,
    db: AsyncSession = Depends(get_async_session)
):
    return await create_budget_choice(db, data)
