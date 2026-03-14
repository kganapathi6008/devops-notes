# Terraform Lab: VPC + Private RDS + Jumpbox Access

## Overview

This document explains the infrastructure built using Terraform and the steps used to access a private PostgreSQL RDS instance through a jumpbox using SSH tunneling.

Architecture implemented in AWS:

```
Internet
  |
  v
Jumpbox EC2 (Public Subnet)
  |
  | SSH Tunnel
  v
Private RDS PostgreSQL (Database Subnet)
  ^
  |
Service-A EC2 (Private Subnet)
```

The RDS instance is not publicly accessible. Access is performed through a jumpbox located in a public subnet.

---

# Infrastructure Components

## VPC

```
CIDR   : 10.0.0.0/16
Region : us-east-1
```

### Subnet Tiers

Public Subnets

```
10.0.0.0/24
10.0.1.0/24
10.0.2.0/24
```

Private Subnets

```
10.0.10.0/24
10.0.11.0/24
10.0.12.0/24
```

Database Subnets

```
10.0.20.0/24
10.0.21.0/24
10.0.22.0/24
```

---

# Security Groups

## Jumpbox Security Group

Inbound

```
Port 22 -> 0.0.0.0/0
```

Outbound

```
All traffic allowed
```

## Service-A Security Group

Inbound

```
Port 8080
```

Outbound

```
All traffic allowed
```

## RDS Security Group

Inbound

```
Port 5432 -> 10.0.0.0/16
```

Outbound

```
All traffic allowed
```

---

# EC2 Instances

## Jumpbox

```
Instance Type : t3.micro
Subnet        : Public
Public IP     : Enabled
Purpose       : SSH access + port forwarding
```

## Service-A

```
Instance Type : t3.micro
Subnet        : Private
Public IP     : Disabled
```

---

# RDS Database

```
Engine        : PostgreSQL 15
Instance Type : db.t4g.micro
Storage       : 20 GB
Public Access : Disabled
Port          : 5432
```

Endpoint example

```
myorg-postgres-db-1-dev.cixik60wq589.us-east-1.rds.amazonaws.com
```

Database created

```
appdb1
```

---

# Terraform Commands Used

Initialize Terraform

```
terraform init -upgrade -backend-config=backend/backend-dev.hcl
```

Plan infrastructure

```
terraform plan -var-file=environments/dev.tfvars
```

Apply infrastructure

```
terraform apply -var-file=environments/dev.tfvars --auto-approve
```

---

# SSH Access to Jumpbox

```
ssh -i keys/dev/myorg-dev-jumpbox-key.pem ec2-user@18.208.201.216
```

---

# SSH Tunnel to RDS

Create SSH tunnel from local machine

```
ssh -i keys/dev/myorg-dev-jumpbox-key.pem ec2-user@18.208.201.216 \
-L 5432:myorg-postgres-db-1-dev.cixik60wq589.us-east-1.rds.amazonaws.com:5432
```

This forwards

```
Localhost:5432 -> Jumpbox -> RDS:5432
```

The SSH session must remain open while using the tunnel.

---

# Connect to PostgreSQL from Local Machine

```
psql -h localhost -p 5432 -U postgres -d postgres
```

Enter the RDS password when prompted.

---

# Verify Databases

Inside psql

```
\l
```

Expected output

```
appdb1
postgres
template0
template1
rdsadmin
```

---

# Example Database Operations

Switch database

```
\c appdb1
```

Create table

```
CREATE TABLE users (
 id SERIAL PRIMARY KEY,
 name TEXT
);
```

Insert data

```
INSERT INTO users (name) VALUES ('Ganapathi');
```

Query data

```
SELECT * FROM users;
```

---

# Generated SSH Keys

```
keys/dev/myorg-dev-jumpbox-key.pem
keys/dev/myorg-dev-service-a-key.pem
```

---

# Terraform Outputs

Important outputs produced by Terraform

```
VPC ID
Public Subnets
Private Subnets
Database Subnets
Security Group IDs
EC2 Instance IDs
RDS Endpoint
```

Example RDS output

```
myorg-postgres-db-1-dev.cixik60wq589.us-east-1.rds.amazonaws.com:5432
```

---

# Key Concepts Demonstrated

```
Terraform modules
Multi-tier VPC architecture
Public / Private / Database subnet separation
EC2 jumpbox pattern
Private RDS database
SSH tunneling for database access
Terraform outputs
Infrastructure as Code best practices
```

---

# Next Improvements

```
Restrict SSH access to personal IP instead of 0.0.0.0/0
Replace jumpbox with AWS SSM Session Manager
Add Application Load Balancer for service-a
Store database credentials in AWS Secrets Manager
Split Terraform into terraform-live and terraform-modules structure
```
