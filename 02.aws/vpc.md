# Amazon VPC (Virtual Private Cloud)

## What is a VPC?
- **VPC** stands for Virtual Private Cloud. It is a logically isolated network within the AWS cloud where you can launch AWS resources like EC2 instances, load balancers, and auto-scaling groups.
- When you create an AWS account, a **default VPC** is automatically created in each region. This default VPC allows instances to connect to the internet directly.

### Why do we need a VPC?

- **Isolation:** Ensures your resources are secure and not directly accessible from the internet.
- **Customization:** You control your IP ranges, subnets, route tables, and gateways.
- **Security:** Use security groups and network ACLs to control traffic.
- **Scalability:** Easily expand your network as your application grows.
- **Hybrid connectivity:** Connect your VPC to on-premises data centers using VPN or Direct Connect.

## VPC and CIDR Blocks
- When creating a VPC, you must specify an IP range using a **CIDR block** (Classless Inter-Domain Routing). This defines the range of IP addresses available for your resources.
- A **CIDR block** represents the IP range and the number of available IPs.





### CIDR (Classless Inter-Domain Routing)

- **CIDR block** defines the IP address range for your VPC.
- AWS allows you to specify an IPv4 CIDR block between **/16** and **/28**.
- **/16** means 65,536 IP addresses (largest allowed in VPC).
- **/28** means 16 IP addresses (smallest allowed in VPC).

### CIDR Block Range

A CIDR block is represented as:

```
10.0.0.0/16
```

- **10.0.0.0** is the network portion.
- **/16** means the first 16 bits are the network portion, leaving 16 bits for host addresses.

| CIDR Block | Number of IPs |
| ---------- | ------------- |
| /16        | 65,536        |
| /17        | 32,768        |
| /18        | 16,384        |
| /19        | 8,192         |
| /20        | 4,096         |
| /21        | 2,048         |
| /22        | 1,024         |
| /23        | 512           |
| /24        | 256           |
| /25        | 128           |
| /26        | 64            |
| /27        | 32            |
| /28        | 16            |

### How to calculate the number of IPs

Formula:

```
Number of IPs = 2^(32 - subnet mask)
```

For example:

- **/24**: 2^(32 - 24) = 2^8 = 256 IPs
- **/28**: 2^(32 - 28) = 2^4 = 16 IPs

### Examples of CIDR blocks:
- `10.0.0.0/16`: This allows **65,536 IP addresses** (from 10.0.0.0 to 10.0.255.255).
- `10.0.0.0/24`: This allows **256 IP addresses** (from 10.0.0.0 to 10.0.0.255).
- `192.168.0.0/28`: This allows **16 IP addresses** (from 192.168.0.0 to 192.168.0.15).


## Subnets
- A **subnet** is a smaller network within a VPC. It allows you to partition the VPC’s IP range.
- Subnets help organize and control access to resources.
- Each subnet must have a CIDR block that falls within the VPC’s CIDR range.
- You can create multiple subnets within a VPC.

### Types of Subnets:
1. **Public Subnets**
   - A subnet is public if it is associated with a route table that has a route to an Internet Gateway (IGW).
   - Resources in public subnets can communicate directly with the internet.
2. **Private Subnets**
   - A subnet is private if it does not have a direct route to the Internet Gateway.
   - Resources in private subnets cannot access the internet directly.

### Reserved IP Addresses:
AWS reserves **5 IP addresses** in each subnet's CIDR block:
- **.0**: Network address
- **.1**: VPC router
- **.2**: Reserved by AWS
- **.3**: Reserved by AWS for future use
- **.255**: Broadcast address (if applicable)

#### Example:
- If you have a **10.0.1.0/24** subnet (256 IPs), you will have **251 usable IP addresses**.

## Internet Gateway (IGW)
- An **Internet Gateway** allows resources in your VPC (like EC2 instances in public subnets) to access the internet.
- A subnet becomes **public** when its route table points to an IGW.
- The **default VPC** comes with an IGW already attached, allowing internet access by default.

## NAT Gateway
- A **NAT Gateway** enables instances in a **private subnet** to initiate outbound traffic to the internet, but it prevents incoming traffic from the internet.
- NAT Gateways must be created in a **public subnet**.
- Private subnets use a route to the NAT Gateway to access the internet indirectly.

## Route Tables
- A **route table** contains rules (routes) that determine how traffic is directed.
- Each subnet must be associated with a route table.
- A route table can direct traffic to:
  - An Internet Gateway (for public subnets)
  - A NAT Gateway (for private subnets)
  - Another subnet (for internal communication)

## VPC Peering and CIDR Overlaps
- **VPC Peering** connects two VPCs, allowing them to communicate privately.
- **Limitations:**
  - You **cannot** have VPC peering if the VPCs have overlapping CIDR blocks.
  - Each VPC must have a unique CIDR range to establish peering.

### Can two VPCs have the same CIDR?
- **No**, two VPCs cannot have the same CIDR if you want to set up VPC peering.
- Overlapping CIDRs cause routing conflicts, making VPC peering impossible.

---

## Simple VPC Diagram:

```
                        +-----------------------------------+
                        |        VPC (10.0.0.0/16)          |
                        |                                   |
        +----------------+------------------+------------------+
        |                |                  |                  |
 +-------------+    +-------------+    +-------------+
 | Public Subnet |    | Public Subnet |    | Public Subnet |
 | 10.0.1.0/24  |    | 10.0.2.0/24  |    | 10.0.3.0/24  |
 +-------------+    +-------------+    +-------------+
        | Route Table (Public)            | IGW
        +-----------------+-----------------+-----------------+
        |                |                  |                  |
 +-------------+    +-------------+    +-------------+
 | Private Subnet|    | Private Subnet|    | Private Subnet|
 | 10.0.4.0/24  |    | 10.0.5.0/24  |    | 10.0.6.0/24  |
 +-------------+    +-------------+    +-------------+
        | Route Table (Private)           | NAT Gateway
        +-----------------+-----------------+-----------------+

```

### Route Tables Explanation:
- **Public Route Table:** Associated with public subnets. Contains routes like:
  - `0.0.0.0/0 -> IGW` (to allow internet access)
- **Private Route Table:** Associated with private subnets. Contains routes like:
  - `0.0.0.0/0 -> NAT Gateway` (for internet access via NAT)
  - Routes to other subnets for internal communication

Each subnet must be linked to a route table to control the traffic flow.

---
---
---


## Difference Between IGW and NAT Gateway

Let’s break down the difference between **Internet Gateway (IGW)** and **NAT Gateway (NGW)** — focusing on how traffic flows between the instances and the internet.

---

### 🌐 **Public Subnets (using IGW)**
- Instances in a **public subnet** have a **public IP** or **Elastic IP (EIP)**.
- The **Route Table** for public subnets contains a route like this:

```
0.0.0.0/0 -> IGW
```

**How it works:**
- **Outbound traffic**: The instance can directly access the internet.
- **Inbound traffic**: The instance can receive traffic directly from the internet (for example, SSH access or HTTP requests if running a web server).

✅ **Use case**: Public subnets are for resources that need to be accessed from the internet — load balancers, bastion hosts, etc.

---

### 🔒 **Private Subnets (using NAT Gateway)**
- Instances in a **private subnet** have only **private IPs** (no public IPs).
- The **Route Table** for private subnets contains a route like this:

```
0.0.0.0/0 -> NAT Gateway
```

**How it works:**
- **Outbound traffic**: The instance sends traffic to the NAT Gateway, which forwards it to the internet.
- **Inbound traffic**: The NAT Gateway **does not allow unsolicited inbound traffic** — only responses to requests initiated by the private instance are allowed.

✅ **Use case**: Private subnets are for instances that need to download updates, talk to external APIs, or send logs — but **should not be directly accessible from the internet**.

---

### 🔥 **Key Differences**
- **IGW** = **2-way traffic** (instances can send and receive traffic from the internet directly).
- **NAT Gateway** = **1-way traffic** (instances can send traffic to the internet, but the internet cannot directly reach those instances).

---

### **Example**
- **Public subnet** (using IGW): An EC2 instance with a public IP can host a website — users can access it directly.
- **Private subnet** (using NAT Gateway): An EC2 instance can pull software updates or send logs to S3, but no one can SSH or visit it directly from the internet.

---

Here’s a simple diagram to visualize the differences between IGW and NAT Gateway:

```
                         +-------------------------+
                         |        VPC (10.0.0.0/16)       |
                         |                                 |
     +------------------+-------------------+------------------+
     |                  |                   |                  |
+------------+    +------------+    +------------+    +------------+
| Public Sub |    | Public Sub |    | Private Sub|    | Private Sub|
| 10.0.1.0/24|    | 10.0.2.0/24|    | 10.0.3.0/24|    | 10.0.4.0/24|
+------------+    +------------+    +------------+    +------------+
     |                  |                   |                  |
     | IGW (Internet Gateway)               | NAT Gateway      |
     +------------------+-------------------+------------------+
                         |                                 |
                    Internet                        (Outbound Only)
```

- **Public Subnets** have routes pointing to the IGW, allowing both inbound and outbound internet traffic.
- **Private Subnets** route outbound traffic through the NAT Gateway, allowing instances to access the internet without being directly reachable from it.

---
---
---

# Creating a VPC with Public and Private Subnets

### Steps to create a VPC:

1. **Create VPC:**

   - Go to AWS Console → VPC → Create VPC
   - Name: `MyVPC`
   - IPv4 CIDR block: `10.0.0.0/16`

2. **Create Subnets:**

   - **Public Subnets:**
     - **PublicSubnet1**
       - VPC: `MyVPC`
       - IPv4 CIDR: `10.0.1.0/24`
       - Availability Zone: `us-east-1a`
       - Enable auto-assign public IP
     - **PublicSubnet2**
       - VPC: `MyVPC`
       - IPv4 CIDR: `10.0.2.0/24`
       - Availability Zone: `us-east-1b`
       - Enable auto-assign public IP
     - **PublicSubnet3**
       - VPC: `MyVPC`
       - IPv4 CIDR: `10.0.3.0/24`
       - Availability Zone: `us-east-1c`
       - Enable auto-assign public IP

   - **Private Subnets:**
     - **PrivateSubnet1**
       - VPC: `MyVPC`
       - IPv4 CIDR: `10.0.4.0/24`
       - Availability Zone: `us-east-1a`
     - **PrivateSubnet2**
       - VPC: `MyVPC`
       - IPv4 CIDR: `10.0.5.0/24`
       - Availability Zone: `us-east-1b`
     - **PrivateSubnet3**
       - VPC: `MyVPC`
       - IPv4 CIDR: `10.0.6.0/24`
       - Availability Zone: `us-east-1c`

3. **Create Internet Gateway (IGW):**

   - Name: `MyIGW`
   - Attach to `MyVPC`

4. **Create NAT Gateway (NGW):**

   - Name: `MyNAT`
   - Subnet: `PublicSubnet1`
   - Allocate Elastic IP

5. **Create Route Tables:**

   - **Public Route Table:**
     - Name: `PublicRT`
     - Routes:
       - Destination: `0.0.0.0/0`
       - Target: `Internet Gateway (IGW)`
     - Associate with **all public subnets**
   - **Private Route Table:**
     - Name: `PrivateRT`
     - Routes:
       - Destination: `0.0.0.0/0`
       - Target: `NAT Gateway (NGW)`
     - Associate with **all private subnets**

6. **Security Groups (SG):**

   - Create a security group named `MySG`
   - Inbound rules:
     - Allow HTTP (port 80)
     - Allow HTTPS (port 443)
     - Allow SSH (port 22)

7. **Network ACLs (NACL):**

   - Create a new NACL
   - Add rules for inbound and outbound traffic (stateless)

8. **DHCP Options Set:**

   - Define DNS servers (Amazon DNS: `AmazonProvidedDNS`)
   - Configure domain name (`ec2.internal`)

9. **Enable DNS:**

   - Enable **DNS hostnames** for public IP resolution.
   - Enable **DNS resolution** to use Amazon DNS.

## Best Practices for VPC

- **Subnet planning:**
  - Use `/24` subnets for easy IP management.
  - Separate public and private subnets.
- **Security:**
  - Use security groups for instance-level security.
  - Use NACLs for subnet-level rules.
- **High Availability:**
  - Spread subnets across multiple Availability Zones (AZs).
- **Routing:**
  - Ensure public subnets have routes to IGW.
  - Ensure private subnets have routes to NAT Gateway.
- **Monitoring:**
  - Use VPC Flow Logs to capture IP traffic.

## Conclusion

A VPC gives you full control over your cloud network, allowing you to build secure, scalable applications in AWS. Understanding CIDR, subnets, route tables, and security layers is crucial for creating robust architectures.

---
