import requests
import json
import uuid
import os

MCP_SERVER_URL = "http://localhost:8080"
SESSION_FILE = ".session_id"

def _get_session_id() -> str:
    if os.path.exists(SESSION_FILE):
        with open(SESSION_FILE, 'r') as f:
            return f.read().strip()
    return logout_and_start_new_session()

def logout_and_start_new_session() -> str:
    if os.path.exists(SESSION_FILE):
        os.remove(SESSION_FILE)
    session_id = f"mcp-session-{uuid.uuid4()}"
    with open(SESSION_FILE, 'w') as f:
        f.write(session_id)
    print(f"✅ New user session created. Session ID: {session_id}")
    return "New session started. Please make your request again."

def _call_mcp_tool(tool_name: str) -> dict:
    session_id = _get_session_id()
    try:
        response = requests.post(
            f"{MCP_SERVER_URL}/mcp/stream",
            headers={"Content-Type": "application/json", "Mcp-Session-Id": session_id},
            json={"jsonrpc": "2.0", "id": 1, "method": "tools/call", "params": {"name": tool_name, "arguments": {}}}
        )
        response.raise_for_status()
        data = response.json()
        
        if 'text' in data.get('result', {}).get('content', [{}])[0]:
            text_content = data['result']['content'][0]['text']
            try:
                login_data = json.loads(text_content)
                if login_data.get("status") == "login_required":
                    return login_data
            except (json.JSONDecodeError, KeyError):
                pass
        return data
    except requests.exceptions.RequestException as e:
        return {"error": f"API request for {tool_name} failed: {e}"}

def _extract_data(response: dict) -> dict:
    try:
        return json.loads(response['result']['content'][0]['text'])
    except:
        return response

# --- CORRECTED PUBLIC TOOL ---
def fetch_net_worth() -> str:
    """Fetches ONLY the net worth data for the logged-in user."""
    print("🚀 Starting net worth data fetch...")
    net_worth_data = _call_mcp_tool("fetch_net_worth")

    if isinstance(net_worth_data, dict) and net_worth_data.get("status") == "login_required":
        return json.dumps(net_worth_data)
        
    # **CRITICAL FIX**: Wrap the extracted data in the "net_worth" key
    formatted_data = {
        "net_worth": _extract_data(net_worth_data)
    }
    
    return json.dumps(formatted_data, indent=2)


# --- EXISTING PUBLIC TOOL ---
def get_all_my_details() -> str:
    """Fetches ALL available financial data for the logged-in user."""
    print("🚀 Starting full data fetch...")
    net_worth_check = _call_mcp_tool("fetch_net_worth")
    if isinstance(net_worth_check, dict) and net_worth_check.get("status") == "login_required":
        return json.dumps(net_worth_check)

    print("Login successful. Fetching data from all sources...")
    all_data = {
        "net_worth": _extract_data(net_worth_check),
        "credit_report": _extract_data(_call_mcp_tool("fetch_credit_report")),
        "epf_details": _extract_data(_call_mcp_tool("fetch_epf_details")),
        "mf_transactions": _extract_data(_call_mcp_tool("fetch_mf_transactions")),
        "bank_transactions": _extract_data(_call_mcp_tool("fetch_bank_transactions")),
        "stock_transactions": _extract_data(_call_mcp_tool("fetch_stock_transactions")),
    }
    print("✅ All data fetched successfully.")
    return json.dumps(all_data, indent=2)