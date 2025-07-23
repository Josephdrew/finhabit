from google.adk.agents import Agent
from .tools import project_savings, estimate_goal, assess_loan, plan_retirement

future_planner_agent = Agent(
    name="future_planner_agent",
    model="gemini-2.0-flash",
    description="Estimates future net worth, retirement, and major goal projections.",
    instruction="""
Given current finances and user queries like 'How much will I have at 40?', do forward projections, simulate goals, and assess loan affordability.
""",
    tools=[project_savings, estimate_goal, assess_loan, plan_retirement],
)
