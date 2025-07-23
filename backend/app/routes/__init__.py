from fastapi import APIRouter
from app.routes import net_worth

api_router = APIRouter()

api_router.include_router(net_worth.router, tags=["Net Worth"])