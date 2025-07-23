from google.adk.agents import Agent
# from google.adk.tools import google_search  # or custom web tools

financial_wisdom_agent = Agent(
    name="financial_wisdom_agent",
    model="gemini-2.0-flash",
    description="Fetches latest finance news and investment strategies.",
    instruction="""
On finance news or 'what's trending', fetch and summarize up-to-date insights, new SIPs, and best practices.
""",
    # tools=[google_search],
)
