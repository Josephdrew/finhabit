from google.adk.agents import Agent
from google.adk.tools.agent_tool import AgentTool

from .sub_agents.fi_mcp_agent.agent import fi_mcp_agent
# from .sub_agents.investment_intel_agent.agent import investment_intel_agent
# from .sub_agents.future_planner_agent.agent import future_planner_agent
# from .sub_agents.financial_health_agent.agent import financial_health_agent
# from .sub_agents.financial_wisdom_agent.agent import financial_wisdom_agent
# from .sub_agents.goal_planner_agent.agent import goal_planner_agent
# from .sub_agents.nudges_agent.agent import nudges_agent

root_agent = Agent(
    name="manager",
    model="gemini-2.0-flash",
    description="Orchestrates specialized finance agents to provide a unified personal finance assistant.",
    instruction="""
You are a manager agent overseeing specialized sub-agents. Your primary job is to route user requests to the correct agent based on their description.

- **Routing Rules:**
- If the user asks to "get my details", "fetch my data", or anything related to retrieving their financial profile, transfer to the **fi_mcp_agent**.
- For investment analysis or insights, transfer to **investment_intel_agent**.
- For future planning or projections, transfer to **future_planner_agent**.
- For scoring or financial health, transfer to **financial_health_agent**.
- For news or advice, transfer to **financial_wisdom_agent**.
- For savings goals, transfer to **goal_planner_agent**.
- For summaries or notifications, transfer to **nudges_agent**.


If the request doesn't match any of these, use your best judgment to find the most relevant agent.
""",
    sub_agents=[
        fi_mcp_agent,
        #financial_wisdom_agent 
        #investment_intel_agent, future_planner_agent,
        #financial_health_agent,  goal_planner_agent, nudges_agent,
    ],
    tools=[],
)
