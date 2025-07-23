from google.adk.agents import Agent
from .tools import save_user_goal, calculate_required_saving, show_progress

goal_planner_agent = Agent(
    name="goal_planner_agent",
    model="gemini-2.0-flash",
    description="Tracks and projects user saving goals.",
    instruction="""
Given a goal and target date, records the goal and computes the per-period savings needed. Tracks progress and provides reminders.
""",
    tools=[save_user_goal, calculate_required_saving, show_progress],
)
