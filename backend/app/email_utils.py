import os, smtplib, ssl
from email.mime.text import MIMEText
from dotenv import load_dotenv
load_dotenv()

def send_email_otp(to_email: str, otp: str):
    msg        = MIMEText(f"Your one‑time password is {otp}. It expires in 5 minutes.")
    msg["Subject"] = "Your Login OTP"
    msg["From"]    = os.getenv("EMAIL_USER")
    msg["To"]      = to_email

    context = ssl.create_default_context()
    with smtplib.SMTP(os.getenv("EMAIL_HOST"), int(os.getenv("EMAIL_PORT"))) as server:
        server.starttls(context=context)
        server.login(os.getenv("EMAIL_USER"), os.getenv("EMAIL_PASS"))
        server.send_message(msg)
