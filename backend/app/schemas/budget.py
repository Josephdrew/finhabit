from pydantic import BaseModel, Field
from datetime import datetime

class BudgetChoiceCreate(BaseModel):
    user_id: int
    needs_percentage: float = Field(..., ge=0, le=100)
    wants_percentage: float = Field(..., ge=0, le=100)
    savings_percentage: float = Field(..., ge=0, le=100)

class BudgetChoiceResponse(BudgetChoiceCreate):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True
