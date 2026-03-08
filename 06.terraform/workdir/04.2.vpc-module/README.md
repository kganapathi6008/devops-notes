# Terraform VPC Module Setup

This guide explains how to create a VPC using the official Terraform module
**terraform-aws-modules/vpc/aws** in **Terraform**.

---

# 1. Project Structure

Example project structure:

```
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
├── env/
│   └── dev.tfvars
│
└── versions.tf
```

---

# 2. variables.tf

Define the input variables required for the VPC module.

```hcl
variable "cluster_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}
```

---

# 3. main.tf

Use the official Terraform AWS VPC module.

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = var.cluster_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
```

---

# 4. dev.tfvars

This file contains environment-specific values for the **dev environment**.

`env/dev.tfvars`

```hcl
cluster_name = "dev-vpc"

cidr = "10.0.0.0/16"

azs = [
  "us-east-1a",
  "us-east-1b"
]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]
```

---

# 5. Running Terraform

Initialize Terraform:

```
terraform init
```

Check the execution plan:

```
terraform plan -var-file="env/dev.tfvars"
```

Apply the configuration:

```
terraform apply -var-file="env/dev.tfvars"
```

---

# 6. Resources Created

This module automatically creates the following AWS resources:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Route Table Associations

This architecture is commonly used in real-world DevOps environments.

Example architecture:

```
Internet
   │
Internet Gateway
   │
Public Subnets
   │
Application Load Balancer
   │
Private Subnets
   │
EC2 / EKS Worker Nodes
```

---

# 7. Why Use Terraform VPC Module

Advantages of using the official module:

* Avoid writing hundreds of lines of networking code
* Production-tested module
* Supports many advanced networking configurations
* Easy to reuse across environments

---

# 8. Environment Example

You can create multiple environments using different tfvars files:

```
env/dev.tfvars
env/stage.tfvars
env/prod.tfvars
```

Example:

```
terraform apply -var-file="env/prod.tfvars"
```

This allows the same Terraform code to create different infrastructures for **dev, stage, and prod** environments.
