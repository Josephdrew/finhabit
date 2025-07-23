from fastapi import APIRouter
from app.routes import net_worth
from app.routes import budget

api_router = APIRouter()

api_router.include_router(net_worth.router, tags=["Net Worth"])
api_router.include_router(budget.router, tags=["Budget"])