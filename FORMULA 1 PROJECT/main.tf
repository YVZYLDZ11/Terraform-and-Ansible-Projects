# 1. Define the required providers
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# 2. Configure the Docker provider
provider "docker" {
  # Uses the default local Docker daemon socket
}

# 3. Pull the Nginx image for our F1 Telemetry Receiver
resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

# 4. Create the Trackside Edge Server container
resource "docker_container" "telemetry_server" {
  name  = "f1-trackside-telemetry"
  image = docker_image.nginx_image.image_id

  # Map port 80 inside the container to port 8080 on your local machine
  ports {
    internal = 80
    external = 8080
  }
}