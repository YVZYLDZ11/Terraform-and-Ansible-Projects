# Terraform-and-Ansible-Projects
# ☁️ Secure Two-Tier Web Application Architecture on Azure

![Terraform](https://img.shields.io/badge/Terraform-1.9+-purple?style=flat&logo=terraform)
![Ansible](https://img.shields.io/badge/Ansible-2.10+-red?style=flat&logo=ansible)
![Azure](https://img.shields.io/badge/Azure-Cloud-blue?style=flat&logo=microsoftazure)
![Linux](https://img.shields.io/badge/OS-Ubuntu_Linux-orange?style=flat&logo=linux)

## 📖 Project Overview
This project demonstrates a fully automated **Infrastructure as Code (IaC)** pipeline to deploy a secure **Two-Tier Web Architecture** on Microsoft Azure.

The infrastructure is provisioned using **Terraform** with a modular design, and the server configuration (Web Server & Database) is automated using **Ansible**.

## 🏗️ Architecture Design
The architecture consists of two main layers:
1.  **Frontend Layer (Public):** An Nginx Web Server hosted in a public subnet, accessible via HTTP (Port 80).
2.  **Backend Layer (Private):** A MariaDB Database hosted in a private subnet, accessible **only** from the Frontend server.

### 🔒 Key Features
* **Modular Terraform Code:** Infrastructure is split into `network` and `compute` modules for reusability.
* **Remote State Management:** Terraform state is stored securely in an Azure Storage Account (Blob) to prevent state locking issues.
* **Security First:** The database is isolated in a private subnet with strict Network Security Groups (NSGs).
* **Configuration Management:** Zero-touch server configuration using Ansible Playbooks.

---

## 📂 Project Structure
```bash
.
├── modules/               # Reusable Terraform Modules
│   ├── network/           # VNet, Subnets, NSGs
│   └── compute/           # Virtual Machines, NICs
├── ansible/               # Ansible Configuration
│   ├── db_install.yml     # Playbook for MariaDB
│   ├── web_install.yml    # Playbook for Nginx
│   └── hosts.ini          # Inventory file
├── main.tf                # Main configuration entry point
├── variables.tf           # Variable definitions
├── outputs.tf             # Output values (Public IPs, etc.)
└── provider.tf            # Azure Provider configuration

🚀 How to Deploy
1. Prerequisites
Azure Subscription

Terraform installed

Ansible installed (Control Node)

Azure CLI (az login)

2. Infrastructure Provisioning (Terraform)
Initialize and apply the Terraform configuration:

terraform init
terraform plan
terraform apply --auto-approve


3. Configuration Management (Ansible)
Once the infrastructure is ready, use the generated IP addresses to configure the servers:

Bash

# Verify connection
ansible -i hosts.ini all -m ping

# Deploy Database Layer
ansible-playbook -i hosts.ini db_install.yml

# Deploy Web Layer
ansible-playbook -i hosts.ini web_install.yml


🛠️ Tech Stack
Cloud Provider: Microsoft Azure

IaC Tool: Terraform

Config Management: Ansible

Web Server: Nginx

Database: MariaDB

OS: Ubuntu 22.04 LTS

👨‍💻 Author
YAVUZ YILDIZ Aspiring DevOps Engineer https://www.linkedin.com/in/yavuzyildizyz/



