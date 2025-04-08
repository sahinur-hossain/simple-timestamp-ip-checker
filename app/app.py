from flask import Flask, request, jsonify
from datetime import datetime
import pytz
import logging
from waitress import serve

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = Flask(__name__)

@app.route("/")
def get_time():
    ist = pytz.timezone("Asia/Kolkata")
    current_time = datetime.now(ist).isoformat()
    response = {
        "timestamp": current_time,
        "ip": request.remote_addr
    }
    logging.info(f"Request from {request.remote_addr}, Response: {response}")
    return jsonify(response)

if __name__ == "__main__":
    logging.info("Starting SimpleTimeService...")
    serve(app, host="0.0.0.0", port=5000)
