# Production Ready Terraform Infrastructure Walkthrough

## Overview

This document summarizes the production‑style Terraform infrastructure that was provisioned.

Environment: dev
Region: us-east-1
Organization: myorg

---

# 1. Networking Layer

## VPC

* CIDR: 10.0.0.0/16
* DNS support enabled
* DNS hostnames enabled

## Subnets

Three-tier subnet architecture across 3 Availability Zones.

Public Subnets

* 10.0.0.0/24
* 10.0.1.0/24
* 10.0.2.0/24

Private Application Subnets

* 10.0.10.0/24
* 10.0.11.0/24
* 10.0.12.0/24

Database Subnets

* 10.0.20.0/24
* 10.0.21.0/24
* 10.0.22.0/24

## Internet Gateway

Attached to VPC for public subnet internet access.

## NAT Gateway

Single NAT Gateway deployed in public subnet to allow private subnet outbound internet access.

## Route Tables

Public Route Table

* 0.0.0.0/0 -> Internet Gateway

Private Route Table

* 0.0.0.0/0 -> NAT Gateway

Database Route Table

* Isolated network tier

---

# 2. Security Layer

Four security groups were created.

## ALB Security Group

Ingress

* 80 from 0.0.0.0/0
* 443 from 0.0.0.0/0

## Service-A Security Group

Ingress

* 8080 from ALB SG

Egress

* 5432 to RDS SG
* 443 to Internet

## RDS Security Group

Ingress

* 5432 from Service-A SG

## Monitoring Security Group

Ingress

* 9187 from VPC CIDR

This demonstrates **security-group to security-group communication**, which is the recommended production pattern.

---

# 3. Compute Layer

## EC2 Instance

Service: service-a
Instance Type: t3.micro
AMI: Amazon Linux
Subnet: Private subnet

Security Group

* service-a

IAM Role

* EC2 instance role attached
* Policy: AmazonSSMManagedInstanceCore

Purpose

* Enables secure SSM access without SSH.

---

# 4. Database Layer

## RDS PostgreSQL

Engine: PostgreSQL 15
Instance Class: db.t4g.micro
Storage: 20 GB
Port: 5432

Security Groups

* rds
* monitoring

Network

* Database subnets
* Not publicly accessible

Secrets

* Master password automatically stored in AWS Secrets Manager.

---

# 5. Connectivity (Secure Access)

## Step 1 — Connect to EC2 using SSM

aws ssm start-session --target <instance-id>

This avoids SSH and public IP exposure.

## Step 2 — Port Forwarding to RDS

aws ssm start-session
--target <instance-id>
--document-name AWS-StartPortForwardingSessionToRemoteHost
--parameters '{"host":["<rds-endpoint>"],"portNumber":["5432"],"localPortNumber":["5432"]}'

## Step 3 — Connect locally using psql

psql -h localhost -p 5432 -U postgres -d postgres

This securely tunnels database traffic through the EC2 instance.

---

# 6. Verified Results

Successfully connected to PostgreSQL.

Databases present:

* appdb1
* postgres
* template0
* template1
* rdsadmin

SSL connection established.

---

# 7. Key Production Best Practices Demonstrated

* Multi-AZ VPC design
* Three tier subnet architecture
* NAT gateway for private workloads
* No public access to EC2
* No public access to RDS
* IAM role based access
* SSM instead of SSH
* Secrets Manager for database credentials
* Security group based service communication
* Infrastructure as Code with Terraform modules

---

# 8. Terraform Modules Used

Modules implemented:

* vpc
* security-groups
* ec2
* rds
* ec2-iam-role

Infrastructure created:

* VPC
* Subnets
* NAT Gateway
* Internet Gateway
* Route Tables
* Security Groups
* EC2 instance
* IAM Role + Instance Profile
* PostgreSQL RDS

Total resources created: 46

---

# Final Architecture

Internet
|
v
ALB (public subnet)
|
v
Service-A EC2 (private subnet)
|
v
PostgreSQL RDS (database subnet)

Access Method

Developer → AWS SSM → EC2 → RDS

No direct database exposure to internet.

---

This architecture follows a simplified production-ready AWS infrastructure pattern suitable for real DevOps environments.


---
---
---

# Real Company Procedure: Database Password Handling with AWS Secrets Manager

This document explains how real production systems securely retrieve database credentials without storing passwords in code, Terraform, or environment files.

---

# 1. Goal

Production systems must avoid hardcoded credentials.

Instead of:

```
DB_PASSWORD=mySuperSecret
```

Companies use **Secrets Manager + IAM roles**.

Architecture:

```
Application
      │
      ▼
AWS Secrets Manager
      │
      ▼
RDS Database
```

The password is fetched dynamically.

---

# 2. Secret Creation (Automatically by RDS)

When RDS is created with managed password:

```
manage_master_user_password = true
```

AWS automatically:

* Generates a random password
* Stores it in Secrets Manager
* Enables password rotation

Example secret JSON:

```
{
  "username": "postgres",
  "password": "random-generated-password",
  "engine": "postgres",
  "host": "myorg-postgres-db-1-dev.xxxxx.us-east-1.rds.amazonaws.com",
  "port": 5432
}
```

---

# 3. Grant Application Access (IAM Role)

Applications must be allowed to read the secret.

Example IAM policy:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "<secret-arn>"
    }
  ]
}
```

Attach this policy to:

* EC2 instance role
* EKS service account
* ECS task role

---

# 4. Application Startup Procedure

The application should fetch the secret **during startup**.

Example startup flow:

```
Application starts
        │
        ▼
Fetch secret from Secrets Manager
        │
        ▼
Parse username / password
        │
        ▼
Connect to database
```

---

# 5. Example: Bash Startup Script

Used in many EC2 deployments.

```
SECRET=$(aws secretsmanager get-secret-value \
  --secret-id my-db-secret \
  --query SecretString \
  --output text)

DB_USER=$(echo $SECRET | jq -r .username)
DB_PASS=$(echo $SECRET | jq -r .password)
DB_HOST=$(echo $SECRET | jq -r .host)
```

Database connection:

```
psql -h $DB_HOST -U $DB_USER -d appdb
```

---

# 6. Example: Python Application

Many backend services fetch secrets directly.

```
import boto3
import json

client = boto3.client("secretsmanager")

response = client.get_secret_value(
    SecretId="my-db-secret"
)

secret = json.loads(response["SecretString"])

username = secret["username"]
password = secret["password"]
host = secret["host"]
```

The application then uses these credentials to connect to PostgreSQL.

---

# 7. What Happens When Password Rotates

Secrets Manager rotates the password automatically.

```
Secrets Manager
        │
        ▼
Updates RDS password
        │
        ▼
Updates stored secret
```

Applications simply fetch the latest secret.

No manual change required.

---

# 8. Environment Variables in Production

Production applications **do not store passwords**.

Instead they store only the secret name.

Example:

```
DB_SECRET_NAME=my-db-secret
AWS_REGION=us-east-1
```

The application retrieves credentials at runtime.

---

# 9. Kubernetes Production Pattern

In Kubernetes environments:

```
Pod
 │
 ▼
IAM Role (IRSA)
 │
 ▼
Secrets Manager
 │
 ▼
RDS
```

The pod dynamically retrieves credentials using AWS SDK.

---

# 10. Security Advantages

Using Secrets Manager provides:

* No passwords stored in Git repositories
* Automatic credential rotation
* Centralized secret management
* IAM based access control

---

# 11. Summary (Production Workflow)

```
Terraform
   │
   ▼
Creates RDS with managed password
   │
   ▼
Secrets Manager stores credentials
   │
   ▼
Application IAM role gets permission
   │
   ▼
Application fetches secret at startup
   │
   ▼
Application connects to RDS
```

This is the standard pattern used in modern cloud production systems.

