from google.adk.agents import Agent
from .tools import generate_nudges, send_notification

nudges_agent = Agent(
    name="nudges_agent",
    model="gemini-2.0-flash",
    description="Compiles outputs from all agents to send as concise, actionable nudges.",
    instruction="""
Reads output from all agents, creates one-line nudges with emojis, and sends notifications. Focus on driving action and good habits.
""",
    tools=[generate_nudges, send_notification],
)
