from flask import Flask, jsonify, request
import os
import json

app = Flask(__name__)

# Directory where sample_responses/*.json are stored
BASE_DIR = os.path.dirname(__file__)
DATA_DIR = os.path.join(BASE_DIR, "sample_responses")

# Optional: API key for secure access
API_KEY = "fi-agent-secret"

# List of available MCP tools (endpoints)
AVAILABLE_TOOLS = {
    "fetch_bank_transactions": "fetch_bank_transactions.json",
    "fetch_credit_report": "fetch_credit_report.json",
    "fetch_epf_details": "fetch_epf_details.json",
    "fetch_mf_transactions": "fetch_mf_transactions.json",
    "fetch_net_worth": "fetch_net_worth.json",
    "fetch_stock_transactions": "fetch_stock_transactions.json"
}

# Middleware for API key auth
@app.before_request
def verify_api_key():
    if request.path == "/" or request.path.startswith("/health"):
        return
    if request.headers.get("x-api-key") != API_KEY:
        return jsonify({"error": "Unauthorized"}), 401

# Root health check or metadata
@app.route("/")
def index():
    return jsonify({
        "status": "MCP Server running",
        "tools_available": list(AVAILABLE_TOOLS.keys()),
        "how_to_call": "Send GET to /mcp/<tool_name> with x-api-key header"
    })

@app.route("/health")
def health():
    return jsonify({"status": "OK"})

# Generic endpoint to serve all MCP tool data
@app.route("/mcp/<string:tool_name>", methods=["GET"])
def get_tool_data(tool_name):
    if tool_name not in AVAILABLE_TOOLS:
        return jsonify({"error": f"Tool '{tool_name}' not found"}), 404
    
    json_file = os.path.join(DATA_DIR, AVAILABLE_TOOLS[tool_name])
    
    try:
        with open(json_file, "r") as f:
            data = json.load(f)

        # Optional: You can support user_id filtering here
        user_id = request.args.get("user_id")
        if user_id:
            # Just demo logic — no real filtering yet
            data["requested_user_id"] = user_id
        
        return jsonify(data)
    
    except Exception as e:
        return jsonify({"error": f"Error loading data for {tool_name}: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=False)
