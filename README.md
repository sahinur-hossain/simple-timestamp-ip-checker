# Simple Time Server

A lightweight Python-based HTTP server that returns the current timestamp (in IST) and the request origin IP address. 

##  Features

- Returns **IST timestamp** and **client IP** in JSON format
- Multi-threaded HTTP server using Python's `http.server`
- Minimal image size using multi-stage Docker build
- Containerized and automated with Terraform (optional)

## 🐳 Docker Usage

###  Build and run the Docker image

```bash
docker build -t secure-time-server .
docker run -d -p 8080:5000 secure-time-server
