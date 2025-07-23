from sqlalchemy.ext.asyncio import AsyncSession
from app.models.budget import BudgetChoice
from app.schemas.budget import BudgetChoiceCreate

async def create_budget_choice(db: AsyncSession, data: BudgetChoiceCreate):
    new_choice = BudgetChoice(**data.dict())
    db.add(new_choice)
    await db.commit()
    await db.refresh(new_choice)
    return new_choice