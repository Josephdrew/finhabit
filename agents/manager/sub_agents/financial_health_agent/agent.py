from google.adk.agents import Agent
from .tools import calc_net_worth, analyze_debt, credit_impact

financial_health_agent = Agent(
    name="financial_health_agent",
    model="gemini-2.0-flash",
    description="Calculates net worth, analyzes debt and credit impacts.",
    instruction="""
Handles basic and advanced financial health queries. Tracks net worth trend, highlights debt ratio, interprets credit scores, and flags anomalies.
""",
    tools=[calc_net_worth, analyze_debt, credit_impact],
)
