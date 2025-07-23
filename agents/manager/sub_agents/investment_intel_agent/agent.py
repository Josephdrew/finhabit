from google.adk.agents import Agent
from .tools import analyze_portfolio, compare_benchmark, suggest_rebalance

investment_intel_agent = Agent(
    name="investment_intel_agent",
    model="gemini-2.0-flash",
    description="Analyzes investment portfolio, benchmarks, and SIP performance.",
    instruction="""
When the user asks about investment portfolio, returns performance analysis, underperforming SIPs, suggestions to rebalance, and top benchmark comparison.
""",
    tools=[analyze_portfolio, compare_benchmark, suggest_rebalance],
)
