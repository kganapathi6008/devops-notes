# AWS Infrastructure Setup & Connection Guide

## Overview

This document explains the Terraform infrastructure created and how to connect to the resources.

Infrastructure includes:

* VPC
* Public / Private / Database subnets
* NAT Gateway
* EC2 instance (service-a)
* PostgreSQL RDS
* Security Groups
* IAM Role for EC2 with SSM access

---

# Architecture

VPC CIDR: 10.0.0.0/16

Public Subnets
Private Subnets
Database Subnets

EC2 runs in Private Subnet.
RDS runs in Database Subnet.

---

# Resources Created

## VPC

* CIDR: 10.0.0.0/16
* DNS enabled

## Subnets

Public:
```
10.0.0.0/24
10.0.1.0/24
10.0.2.0/24
```
Private:
```
10.0.10.0/24
10.0.11.0/24
10.0.12.0/24
```

Database:
```
10.0.20.0/24
10.0.21.0/24
10.0.22.0/24
```

## EC2 Instance
```
Instance Type: t3.micro
Private IP: 10.0.10.203
```
## RDS
```
Engine: PostgreSQL
Port: 5432
Endpoint:
myorg-postgres-db-1-dev.cixik60wq589.us-east-1.rds.amazonaws.com
```
---

# Prerequisites

## Windows

Install the following:

AWS CLI
Session Manager Plugin
PostgreSQL Client

```
choco install awscli
```

```
choco install session-manager-plugin
```

```
choco install postgresql
```

## Linux

```
sudo dnf update
```

```
sudo dnf install awscli
```

```
sudo dnf install postgresql-client
```

---

# Configure AWS CLI

```
aws configure
```

Provide:

* Access Key
* Secret Key
* Region

---

# Connect to EC2 using AWS SSM

EC2 instance is created **without a public IP** because it is deployed inside a **private subnet**.

Instead of SSH, we use **AWS Systems Manager (SSM) Session Manager**.

Benefits:

* No need to open port **22 (SSH)**
* No bastion host required
* Works even if instance is in **private subnet**
* Access controlled using **IAM**

Flow:
```
Laptop
   │
aws ssm start-session
   │
AWS SSM Service
   │
SSM Agent inside EC2
   │
Shell session created
```

Command to start session:

```
aws ssm start-session --target INSTANCE_ID
```

Example from this environment:

```
aws ssm start-session --target i-05897aae9259d1288
```

Example output:

```
Starting session with SessionId: new-user-1-bvg2e6xpetgzgp3kiph5kfxftu
```

Inside the instance:

```
whoami
```

Output:

```
ssm-user
```

To switch to root:

```
sudo su -
```

Example session:

```
sh-5.2$ whoami
ssm-user

sh-5.2$ sudo su -
[root@ip-10-0-10-203 ~]#
```

Important points:

* **ssm-user** is created automatically by SSM
* sudo access is available
* No SSH key required

---

# Connecting to RDS PostgreSQL

Your RDS instance is **not publicly accessible**.

```
publicly_accessible = false
```

This means:

* Database is reachable only **inside VPC**
* Direct connection from laptop will fail

Solution:

Use **SSM Port Forwarding via EC2**.

EC2 acts as a **secure tunnel** to the database.

---

# Step 1 — Start Port Forwarding Session

Run this in **Terminal 1**:

```
$ aws ssm start-session \
--target i-05897aae9259d1288 \
--document-name AWS-StartPortForwardingSessionToRemoteHost \
--parameters '{"host":["myorg-postgres-db-1-dev.cixik60wq589.us-east-1.rds.amazonaws.com"],"portNumber":["5432"],"localPortNumber":["5432"]}'
```

Explanation:

```
--target
EC2 instance used as tunnel
```

```
host
Actual RDS endpoint
```

```
portNumber
Remote RDS port
```

```
localPortNumber
Local machine port used for connection
```

Example output:

```
Starting session with SessionId: new-user-1-fd2yr47qjvssuknbs9u2idohli
Port 5432 opened for sessionId new-user-1-fd2yr47qjvssuknbs9u2idohli.
Waiting for connections...

Connection accepted for session [new-user-1-fd2yr47qjvssuknbs9u2idohli]
```

This means:

Your **local port 5432 → EC2 → RDS** tunnel is active.

Keep this terminal running.

---

# Step 2 — Connect from Local Machine

Open **Terminal 2** and run:

```
psql -h localhost -p 5432 -U postgres -d postgres
```

Explanation:

```
-h localhost
Connect to local machine
```

```
-p 5432
Forwarded port
```

```
-U postgres
Database user
```

```
-d postgres
Default database
```

Example output:

```
psql (16.2, server 15.14)

SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384)
```

List databases:

```
\l
```

Example result:

```
List of databases

appdb1
postgres
rdsadmin
template0
template1
```

Meaning:

```
appdb1
Application database created by Terraform
```

```
postgres
Default PostgreSQL database
```

```
rdsadmin
Internal AWS management database
```

---

# Network Flow Explained

Actual connection path:

```
Laptop
  ↓
SSM Tunnel
  ↓
EC2 (Private Subnet)
  ↓
RDS PostgreSQL (Database Subnet)
```

Key point:

```
RDS never becomes publicly accessible
```

Security remains intact.

---

## List RDS

```
aws rds describe-db-instances
```

## List EC2

```
aws ec2 describe-instances
```

## Test DB port

```
nc -zv host 5432
```

---

# Important Points

* EC2 has no public IP
* SSM is used for access
* RDS is private
* NAT Gateway provides internet access

---

# Clean Up

```
terraform destroy -var-file=environments/dev.tfvars
```
