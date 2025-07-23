import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "Finhabit API"
    DATABASE_URL: str = os.getenv("DATABASE_URL")
    OTP_TTL_MINUTES: int = int(os.getenv("OTP_TTL_MINUTES", 5))

settings = Settings()
