# Session 18 — Terraform & Infrastructure as Code

A hands-on session covering Infrastructure as Code (IaC) with Terraform and an introduction to five key AWS service areas — IAM, EC2, S3, VPC, and DynamoDB/RDS.

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=flat-square&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat-square&logo=amazonaws)
![Language](https://img.shields.io/badge/Language-HCL-844FBA?style=flat-square)
![Status](https://img.shields.io/badge/status-documented-blue?style=flat-square)

> A hands-on session covering Infrastructure as Code (IaC) with Terraform and an introduction to five key AWS service areas.

---

## Overview

This session focuses on **Infrastructure as Code (IaC)** using Terraform and introduces five important AWS service areas:

- IAM
- EC2
- S3
- VPC
- DynamoDB & RDS

The practical work includes creating AWS infrastructure using Terraform, understanding Terraform configuration files, variables, outputs, state, providers, resources, and the standard Terraform workflow.

---

# 1. Infrastructure as Code

## What is Infrastructure as Code?

Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure using machine-readable configuration files instead of manually creating resources through a cloud provider's graphical interface.

With IaC, infrastructure can be:

- Reproduced consistently
- Version controlled
- Reviewed through Git
- Automated
- Modified safely
- Destroyed and recreated when required

Terraform is one of the most widely used IaC tools.

---

# 2. Terraform

Terraform is an open-source Infrastructure as Code tool developed by HashiCorp.

It allows infrastructure to be defined using **HashiCorp Configuration Language (HCL)**.

Terraform can manage resources from cloud providers and other services using providers.

### Main Terraform concepts

| Concept | Description |
|---|---|
| Provider | Connects Terraform to a platform such as AWS |
| Resource | Represents infrastructure that Terraform creates or manages |
| Variable | Allows configurable input values |
| Output | Displays useful values after Terraform operations |
| State | Stores Terraform's knowledge of managed infrastructure |
| Module | Reusable collection of Terraform configuration |
| Plan | Shows proposed infrastructure changes |
| Apply | Creates or modifies infrastructure |
| Destroy | Removes infrastructure managed by Terraform |

---

# 3. Terraform Architecture

The basic Terraform workflow is:

```text
Terraform Configuration
        |
        v
     Provider
        |
        v
     terraform plan
        |
        v
     terraform apply
        |
        v
    AWS Resources
        |
        v
 Terraform State
```

Terraform compares the desired infrastructure defined in configuration files with the current state and determines what changes are required.

---

# 4. Terraform Project Structure

The Terraform S3 demonstration contains:

```text
terraform-s3-demo/
├── images/
│   ├── 01-terraform-init-fmt-validate.png
│   ├── 02-vpc-basic-terraform-apply.png
│   └── 03-vpc-public-private-terraform-apply.png
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars
└── resultReadme.md
```

Terraform generates additional runtime artifacts during execution, such as `.terraform/`, `terraform.tfstate`, `terraform.tfstate.backup`, and `.terraform.lock.hcl`. These are local generated files and are not part of the committed project sources.

---

# 5. Terraform Provider

A provider allows Terraform to communicate with an external platform.

For this project, the AWS provider is used.

Example:

```hcl
provider "aws" {
  region = var.aws_region
}
```

The provider allows Terraform to create and manage AWS resources.

---

# 6. Terraform Resources

A Terraform resource represents an infrastructure component.

For example, an AWS S3 bucket can be represented as:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}
```

The first value identifies the resource type and the second value is the local Terraform name.

---

# 7. Terraform Variables

Variables make Terraform configurations reusable and configurable.

Example:

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
```

A value can then be supplied through `terraform.tfvars`.

Example:

```hcl
aws_region = "us-east-1"
```

Variables prevent hard-coding values throughout Terraform configuration files.

---

# 8. Terraform Outputs

Outputs display useful information after Terraform operations.

Example:

```hcl
output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
```

Outputs can be viewed using:

```bash
terraform output
```

---

# 9. Terraform State

Terraform state is used to keep track of infrastructure managed by Terraform.

The main state file is:

```text
terraform.tfstate
```

Terraform uses this state to determine:

- Which resources already exist
- Resource IDs
- Current configuration state
- What changes need to be made

The state file can contain sensitive infrastructure information and should be handled carefully.

For team environments, remote state storage such as an S3 backend can be used.

---

# 10. Terraform S3 Demo

## Objective

The objective of this practical is to create and manage an **AWS S3 bucket using Terraform**.

The intended Terraform workflow is:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform show
terraform output
terraform destroy
```

---

# 11. Terraform Initialization

The first command is:

```bash
terraform init
```

This initializes the Terraform working directory.

It:

- Initializes the backend
- Downloads or loads required providers
- Installs provider dependencies
- Creates the `.terraform` directory
- Creates or updates the dependency lock file

### Result

The configuration was successfully initialized.

![Terraform Init, Format and Validate](./images/01-terraform-init-fmt-validate.png)

---

# 12. Terraform Formatting

The command:

```bash
terraform fmt
```

formats Terraform configuration files according to Terraform's standard formatting rules.

It helps maintain:

- Consistent indentation
- Consistent spacing
- Readable HCL code

---

# 13. Terraform Validation

The command:

```bash
terraform validate
```

checks whether the Terraform configuration is syntactically valid and internally consistent.

A successful validation produces:

```text
Success! The configuration is valid.
```

This confirms that Terraform can understand the configuration before attempting to create infrastructure.

---

# 14. Terraform Plan

The command:

```bash
terraform plan
```

creates an execution plan.

Terraform analyzes the configuration and determines which resources would be:

- Created
- Modified
- Destroyed

A typical plan for a new S3 bucket would show:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

The plan is a safe way to review proposed infrastructure changes before applying them.

> The S3 plan/apply workflow is documented here as the expected workflow. At the time of this practical, valid AWS credentials were not available, so AWS-authenticated S3 operations were not executed.

---

# 15. Terraform Apply

The command:

```bash
terraform apply
```

applies the Terraform configuration and creates the required AWS resources.

Terraform displays the planned changes and asks for confirmation.

The expected confirmation is:

```text
Do you want to perform these actions?
Enter a value: yes
```

For the S3 demonstration, a successful execution would create the configured S3 bucket.

---

# 16. Terraform Show

After applying the configuration:

```bash
terraform show
```

can be used to display the resources currently tracked by Terraform state.

It provides detailed information about the infrastructure managed by Terraform.

---

# 17. Terraform Output

The command:

```bash
terraform output
```

displays values defined in the Terraform `outputs.tf` file.

For an S3 project, outputs could include values such as:

```text
bucket_name
bucket_arn
```

This provides an easy way to retrieve important resource information.

---

# 18. Terraform Destroy

When the infrastructure is no longer required:

```bash
terraform destroy
```

can be used to remove resources managed by Terraform.

Terraform displays the resources that will be destroyed and requests confirmation.

The expected successful result is similar to:

```text
Destroy complete!
```

This demonstrates the complete Terraform infrastructure lifecycle:

```text
Initialize
    ↓
Format
    ↓
Validate
    ↓
Plan
    ↓
Apply
    ↓
Show / Output
    ↓
Destroy
```

---

# 19. Terraform + AWS VPC Practical Work

Terraform was also used to provision AWS networking infrastructure.

These practical exercises demonstrate that Terraform can manage multiple AWS resources together.

## Basic VPC Deployment

The first VPC practical created six AWS resources, including:

- VPC
- Internet Gateway
- Public Subnet
- Route Table
- Route Table Association
- Security Group

The deployment completed successfully with:

```text
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
```

![Basic VPC Terraform Apply](./images/02-vpc-basic-terraform-apply.png)

---

# 20. Public and Private VPC Architecture

A more complete VPC configuration was also created using Terraform.

The configuration included:

- VPC
- Internet Gateway
- Public Subnet
- Private Subnet
- Public Route Table
- Private Route Table
- Public Route Table Association
- Private Route Table Association
- Web Security Group
- Internal Security Group

The deployment completed successfully with:

```text
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
```

![Public and Private VPC Terraform Apply](./images/03-vpc-public-private-terraform-apply.png)

This demonstrates how Terraform can provision an entire network architecture from declarative configuration.

---

# 21. AWS IAM

## What is IAM?

AWS Identity and Access Management (IAM) controls authentication and authorization for AWS resources.

IAM determines:

- Who can access AWS
- What actions they can perform
- Which resources they can access

## IAM Users

An IAM user represents an individual identity within an AWS account.

A user can have credentials such as:

- Console password
- Access key
- Secret access key

## IAM Groups

Groups allow multiple IAM users to receive common permissions.

For example:

```text
Developers
    ├── User 1
    ├── User 2
    └── User 3
```

A policy attached to the group can apply to all members.

## IAM Roles

IAM roles provide temporary permissions that can be assumed by:

- AWS services
- Applications
- EC2 instances
- Lambda functions
- Other trusted identities

Roles are preferred over embedding long-term credentials in applications.

## IAM Policies

Policies are JSON documents that define permissions.

A policy can specify:

- Effect
- Action
- Resource
- Conditions

Example structure:

```json
{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "*"
}
```

## Least Privilege

The principle of least privilege means providing only the permissions required to perform a task.

For example, an application that only needs to read S3 objects should not receive full administrative access.

## IAM Best Practices

- Use least privilege
- Avoid using the root account for everyday work
- Enable MFA
- Prefer IAM roles for AWS services
- Avoid unnecessary long-term access keys
- Regularly review permissions
- Use groups to manage common permissions
- Rotate credentials when required

## IAM Use Cases

IAM is commonly used for:

- User access management
- Application permissions
- EC2 instance roles
- CI/CD permissions
- Cross-account access
- AWS service authorization

---

# 22. AWS EC2

## What is EC2?

Amazon EC2 (Elastic Compute Cloud) provides resizable virtual servers in AWS.

An EC2 instance can be used to run:

- Web applications
- APIs
- Backend services
- Development environments
- Databases
- Compute workloads

## AMI

An AMI (Amazon Machine Image) is a template used to launch an EC2 instance.

It can contain:

- Operating system
- Software
- Configuration
- Required packages

## Instance Types

EC2 provides different instance families for different workloads.

Examples include:

- General purpose
- Compute optimized
- Memory optimized
- Storage optimized
- Accelerated computing

The instance type determines resources such as CPU, memory, and networking capabilities.

## Key Pairs

Key pairs are used for secure access to EC2 instances.

For Linux instances, an SSH key pair can be used to authenticate without a password.

## Security Groups

Security groups act as virtual firewalls for EC2 instances.

They control inbound and outbound traffic.

Example:

```text
Internet
   |
   v
Security Group
   |
   v
EC2 Instance
```

## EBS

Amazon EBS (Elastic Block Store) provides persistent block storage for EC2 instances.

EBS volumes can be used for:

- Operating system storage
- Application data
- Databases
- Persistent files

## Public and Private IP Addresses

An EC2 instance may have:

- Private IP address
- Public IPv4 address
- Elastic IP address

Private IP addresses are used within a VPC, while public addressing allows communication with the internet when correctly configured.

## EC2 Lifecycle

A typical EC2 lifecycle includes:

```text
Launch
  ↓
Running
  ↓
Stop / Start
  ↓
Reboot
  ↓
Terminate
```

Terminating an instance permanently removes the instance.

## EC2 Use Cases

- Web servers
- Application servers
- APIs
- Development environments
- Batch processing
- Compute workloads
- Self-hosted applications

---

# 23. Amazon S3

## What is S3?

Amazon Simple Storage Service (S3) is an object storage service.

S3 stores data as objects inside buckets.

The basic structure is:

```text
S3
 |
 └── Bucket
      |
      ├── Object
      ├── Object
      └── Object
```

## Buckets

A bucket is a container for objects.

Bucket names must be globally unique across AWS.

## Objects

An object consists of:

- Data
- Object key
- Metadata

Objects can contain documents, images, videos, backups, logs, datasets, and other files.

## S3 Storage Classes

S3 provides different storage classes for different access patterns.

Examples include:

- S3 Standard
- S3 Intelligent-Tiering
- S3 Standard-IA
- S3 One Zone-IA
- S3 Glacier Instant Retrieval
- S3 Glacier Flexible Retrieval
- S3 Glacier Deep Archive

The choice depends on access frequency and retrieval requirements.

## Versioning

S3 Versioning allows multiple versions of an object to be retained.

It helps protect against:

- Accidental deletion
- Accidental overwrites
- Data recovery requirements

## Lifecycle Rules

S3 lifecycle rules automatically transition or delete objects based on defined conditions.

For example:

```text
S3 Standard
      ↓
Infrequent Access
      ↓
Glacier
      ↓
Delete
```

This can reduce storage costs.

## Encryption

S3 supports encryption for stored data.

Encryption options include:

- Server-side encryption with S3 managed keys
- Server-side encryption with AWS KMS
- Customer-provided encryption keys

Encryption helps protect stored data.

## Bucket Policies

Bucket policies are resource-based JSON policies that control access to S3 buckets and objects.

They can be used to allow or deny specific actions for specific principals and resources.

## S3 Use Cases

- Static website assets
- Backups
- Data lakes
- Application files
- Images and videos
- Logs
- Dataset storage
- Archive storage

---

# 24. Amazon VPC

## What is a VPC?

Amazon Virtual Private Cloud (VPC) provides an isolated virtual network inside AWS.

It allows control over:

- IP address ranges
- Subnets
- Routing
- Internet connectivity
- Network security

## CIDR

CIDR defines the IP address range of a network.

Example:

```text
10.20.0.0/16
```

A `/16` network provides a large private address range that can be divided into smaller subnets.

## Subnets

A subnet is a subdivision of a VPC.

Subnets can be:

- Public
- Private

Example:

```text
VPC
 |
 +--- Public Subnet
 |
 +--- Private Subnet
```

## Route Tables

Route tables determine where network traffic should be sent.

A public subnet commonly contains a route to an Internet Gateway.

Example:

```text
0.0.0.0/0 → Internet Gateway
```

## Internet Gateway

An Internet Gateway allows resources in a VPC to communicate with the public internet when appropriate routing and public addressing are configured.

## NAT Gateway

A NAT Gateway allows resources in a private subnet to initiate outbound internet connections without directly exposing those resources to inbound internet traffic.

Typical architecture:

```text
Internet
   |
Internet Gateway
   |
Public Subnet
   |
NAT Gateway
   |
Private Subnet
```

## Security Groups

Security Groups are stateful virtual firewalls associated with resources such as EC2 instances.

They control inbound and outbound traffic.

## Network ACLs

Network Access Control Lists (NACLs) operate at the subnet level.

Unlike security groups, NACLs are stateless and support explicit allow and deny rules.

## Public vs Private Subnet

### Public Subnet

A public subnet normally has a route to an Internet Gateway.

It can contain resources that need direct internet connectivity.

### Private Subnet

A private subnet does not have a direct route to an Internet Gateway.

Resources can use a NAT Gateway for outbound internet access when required.

## VPC Use Cases

- Hosting web applications
- Creating secure application networks
- Separating public and private workloads
- Database isolation
- Multi-tier applications
- Controlling network traffic

---

# 25. Amazon DynamoDB

## What is DynamoDB?

Amazon DynamoDB is a fully managed NoSQL database service.

It is designed for:

- High availability
- Low latency
- Automatic scaling
- Large-scale applications

## Tables

DynamoDB stores data in tables.

A table contains items, and each item contains attributes.

Example:

```text
Users
 |
 +-- Item
 |    ├── userId
 |    ├── name
 |    └── email
 |
 +-- Item
      ├── userId
      ├── name
      └── email
```

## Items

An item is a single record in a DynamoDB table.

Items can contain different attributes depending on the application's data model.

## Attributes

Attributes are the individual data fields within an item.

Examples:

```text
userId
name
email
age
```

## Partition Key

The partition key determines how DynamoDB distributes data across partitions.

It is required for every DynamoDB table.

Example:

```text
userId
```

## Sort Key

A sort key can be combined with a partition key to create a composite primary key.

It allows multiple related items to share the same partition key while being ordered by the sort key.

## DynamoDB Use Cases

- Serverless applications
- High-scale APIs
- Gaming applications
- User profiles
- Session management
- Real-time applications
- Event-driven systems

---

# 26. Amazon RDS

## What is RDS?

Amazon Relational Database Service (RDS) is a managed relational database service.

AWS manages many operational tasks such as:

- Provisioning
- Backups
- Patching
- Monitoring
- Infrastructure maintenance

## Supported Database Engines

RDS supports several relational database engines, including:

- PostgreSQL
- MySQL
- MariaDB
- Oracle
- Microsoft SQL Server
- Amazon Aurora

## DB Instances

An RDS DB instance provides the compute and storage environment used to run the relational database.

Configuration includes:

- Instance class
- Storage
- Database engine
- Network settings
- Security settings

## RDS Security

RDS can be secured using:

- VPC networking
- Security groups
- Encryption
- IAM integration where supported
- Database authentication
- Private subnets

Databases should generally not be exposed directly to the public internet unless there is a specific requirement and appropriate security controls.

## Backups

RDS supports automated backups and database snapshots.

Backups help recover databases from failures or accidental data changes.

## Multi-AZ

Multi-AZ deployments provide high availability by maintaining a standby database in another Availability Zone.

If the primary instance becomes unavailable, AWS can perform a failover.

## Read Replicas

Read replicas are copies of a database that can be used to handle read traffic.

They are useful for:

- Scaling read-heavy applications
- Reducing load on the primary database
- Reporting workloads

## RDS Use Cases

- Web applications
- Enterprise applications
- Transactional systems
- Relational workloads
- Business applications
- Applications requiring SQL databases

---

# 27. DynamoDB vs RDS

| Feature | DynamoDB | RDS |
|---|---|---|
| Database type | NoSQL | Relational |
| Data model | Key-value / document | Tables and relationships |
| Query model | DynamoDB APIs | SQL |
| Scaling | Highly managed/automatic | Instance and configuration based |
| Schema | Flexible | Structured |
| Transactions | Supported | Supported |
| Best suited for | High-scale NoSQL workloads | Relational applications |

---

# 28. Terraform vs Manual AWS Configuration

Terraform provides several advantages over manually creating resources through the AWS Console.

### Manual approach

```text
Open AWS Console
      ↓
Create VPC
      ↓
Create Subnet
      ↓
Create Route Table
      ↓
Create Security Group
      ↓
Configure resources manually
```

### Terraform approach

```text
Write Terraform configuration
          ↓
terraform plan
          ↓
terraform apply
          ↓
Infrastructure created
```

Terraform makes infrastructure reproducible and easier to version control.

---

# 29. Infrastructure Lifecycle

The overall Terraform lifecycle is:

```text
Write Configuration
        ↓
terraform init
        ↓
terraform fmt
        ↓
terraform validate
        ↓
terraform plan
        ↓
terraform apply
        ↓
terraform show / output
        ↓
terraform destroy
```

This workflow provides a structured way to create, inspect, manage, and remove infrastructure.

---

# 30. Key Learnings

Through this session, the following concepts were covered:

- Infrastructure as Code
- Terraform
- HCL configuration
- Terraform providers
- Terraform resources
- Variables
- Outputs
- Terraform state
- Terraform initialization
- Terraform formatting
- Terraform validation
- Terraform planning
- Terraform application
- Terraform destruction
- AWS IAM
- AWS EC2
- Amazon S3
- Amazon VPC
- DynamoDB
- Amazon RDS
- Public and private subnets
- Route tables
- Internet Gateway
- Security Groups
- NACLs
- Database high availability
- NoSQL vs relational databases

---

# 31. Practical Evidence

The following screenshots provide practical evidence of the Terraform work completed during the session.

### Terraform Initialization, Formatting and Validation

![Terraform Init, Format and Validate](./images/01-terraform-init-fmt-validate.png)

### Basic VPC Terraform Deployment

![Basic VPC Terraform Apply](./images/02-vpc-basic-terraform-apply.png)

### Public and Private VPC Terraform Deployment

![Public and Private VPC Terraform Apply](./images/03-vpc-public-private-terraform-apply.png)

---

# 32. Conclusion

Session 18 introduced Infrastructure as Code using Terraform and connected the concepts to AWS services.

Terraform allows infrastructure to be defined declaratively and managed through a repeatable workflow instead of relying entirely on manual configuration.

The practical work demonstrated Terraform initialization, formatting, validation, and successful AWS VPC provisioning. The S3 Terraform workflow was also documented as the target exercise, with the remaining AWS-authenticated commands described according to their expected behavior because active AWS credentials were not available during the exercise.

The session also provided a foundation in five major AWS service areas:

```text
IAM
 |
 +-- Identity and permissions

EC2
 |
 +-- Compute

S3
 |
 +-- Object Storage

VPC
 |
 +-- Networking

DynamoDB / RDS
 |
 +-- Databases
```

These services form an important foundation for designing, deploying, and managing cloud infrastructure using Terraform and AWS.

---

## Notes

- All images are referenced from `./images/` — make sure that folder is committed to the repository, otherwise the image links will break on GitHub.
- Terraform state files (`.terraform/`, `terraform.tfstate`, `terraform.tfstate.backup`, `.terraform.lock.hcl`) are local generated artifacts and should not be committed to the repository.
- Code fences, tables, and headings have been checked for valid GitHub Markdown rendering.

---

## Author

**Tanmay Mittal**

Roll No.: **24BCS10491**