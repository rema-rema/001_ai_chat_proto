# Multi-stage build for production deployment
FROM node:18-alpine AS frontend-builder

WORKDIR /app/client
COPY client/package*.json ./
RUN npm ci --only=production

COPY client/ ./
RUN npm run build

# Python backend stage
FROM python:3.11-slim

WORKDIR /app

# Install Python dependencies
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ ./

# Copy built frontend from previous stage
COPY --from=frontend-builder /app/client/out ./static

# Create a simple static file server for frontend
RUN echo 'from flask import Flask, send_from_directory\n\
app = Flask(__name__)\n\
@app.route("/")\n\
def serve_index():\n\
    return send_from_directory("static", "index.html")\n\
@app.route("/<path:path>")\n\
def serve_static(path):\n\
    return send_from_directory("static", path)\n\
if __name__ == "__main__":\n\
    app.run(host="0.0.0.0", port=3000)' > static_server.py

# Expose ports
EXPOSE 5000 3000

# Start both backend and frontend
CMD ["sh", "-c", "python static_server.py & python app.py"]