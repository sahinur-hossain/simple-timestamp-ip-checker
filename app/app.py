import http.server
import socketserver
import json
import logging
import threading
import os
from datetime import datetime
from zoneinfo import ZoneInfo
from ipaddress import ip_address

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class SecureTimeHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            client_ip = self._get_client_ip()
            response = {
                "timestamp": datetime.now(ZoneInfo("Asia/Kolkata")).isoformat(),
                "ip": client_ip,
            }
            self._send_response(200, response)
        else:
            self._send_response(404, {"error": "Not Found"})

    def _send_response(self, status_code, data):
        response_body = json.dumps(data, separators=(',', ':')).encode("utf-8")
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(response_body)))
        self.end_headers()
        self.wfile.write(response_body)
        logging.info(f"Response sent: {data}")

    def log_message(self, format, *args):
        return  # Suppress default logging for cleaner output

    def _get_client_ip(self):
        # Try to get real client IP from X-Forwarded-For (LB use-case)
        x_forwarded_for = self.headers.get("X-Forwarded-For")
        if x_forwarded_for:
            ip_str = x_forwarded_for.split(",")[0].strip()
            try:
                ip_address(ip_str)
                via_lb = ip_str.startswith("11.11.")  # Customize as needed
                return ip_str
            except ValueError:
                pass

        # Fall back to the direct client IP
        ip_str = self.client_address[0]
        try:
            ip_address(ip_str)
            via_lb = ip_str.startswith("11.11.")  # Customize as needed
            return ip_str
        except ValueError:
            return "Unknown", False

class ThreadedSecureServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    daemon_threads = True
    allow_reuse_address = True

PORT = int(os.getenv("PORT", 5000))

# Ensure the server runs as a non-root user inside a container
if os.geteuid() == 0:
    raise PermissionError("This application must not be run as root.")

def start_server():
    with ThreadedSecureServer(("", PORT), SecureTimeHandler) as httpd:
        logging.info(f"Serving securely on port {PORT}")
        httpd.serve_forever()

if __name__ == "__main__":
    server_thread = threading.Thread(target=start_server, daemon=True)
    server_thread.start()
    try:
        while True:
            pass  # Keep the main thread alive
    except KeyboardInterrupt:
        logging.info("Shutting down server.")