# Simple Time Server

A lightweight Python-based HTTP server that returns the current timestamp (in IST) and the request origin IP address. 

##  Features

- Returns **IST timestamp** and **client IP** in JSON format
- Multi-threaded HTTP server using Python's `http.server`
- Minimal image size using multi-stage Docker build
- Containerized and automated with Terraform (optional)

### Clone the the Github repo
```bash
git clone https://github.com/sahinur-hossain/simple-timestamp-ip-checker.git
cd simple-timestamp-ip-checker/app
```
Make sure you are in the directory containing the **Dockerfile** and **app.py** file



## 🐳 Docker Usage

###  Build and run the Docker image

Make sure you have docker installed and running

```bash
systemctl status docker
```
Once docker is up and running, we can build and run the docker image.
We can also change the host port as required.
```bash
docker build -t secure-time-server .
docker run -d -p 8080:5000 secure-time-server
```

## 🛠️  Terraform Usage

Make sure you have terraform installed
```bash
terraform -v
```
Once you have the github repo cloned, move to the terraform directory
```bash
cd simple-timestamp-ip-checker/terraform
```
<b>Here we have <code>providers.tf</code> file, we would need to configure the secret and access key in order to deploy the resources </b>

Once we have configure the access keys, we can initialize, plan and apply.
```bash
terraform init
terraform plan
terraform apply
