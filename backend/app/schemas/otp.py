from pydantic import BaseModel
from datetime import datetime

class OTPBase(BaseModel):
    phone: str
    otp: str
    expires_at: datetime
