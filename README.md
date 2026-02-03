# Internship Task 2: My Journey with Terraform & AWS

Today, I focused on learning **Terraform** and **AWS** (Amazon Web Services) to understand how to manage infrastructure using code. This document summarizes what I learned and how I set up my environment.

## What I Learned: Terraform

I learned that **Terraform** is an "Infrastructure as Code" (IaC) tool. It helps in automating the creation of cloud resources.

*   **Key Concept:** Instead of manually creating servers on the AWS website, I can write a configuration file, and Terraform will create them for me.
*   **Declarative Nature:** I just need to describe *what* I want (e.g., "one server"), and Terraform handles the *how*.
*   **State Management:** Terraform uses a file called `terraform.tfstate` to keep track of the resources it manages.

## What I Learned: AWS

I explored **AWS** and learned about its core services which act as building blocks for applications:

*   **EC2:** These are virtual servers. I can choose different types (like `t2.micro`) depending on my needs.
*   **S3:** This is for storage. It works like a cloud folder for files.
*   **IAM:** This allows me to manage permissions so only authorized users/tools can access my resources.

## Diving Deeper: Advanced Concepts

After grasping the basics, I started looking into more advanced topics to make my infrastructure more robust.

### Advanced Terraform
*   **Modules:** I learned that I can wrap my code into reusable modules. This prevents me from copying and pasting code everywhere.
*   **Remote Backends:** Instead of keeping the `terraform.tfstate` file on my laptop, I should store it in an S3 bucket. This acts as a single source of truth for the team.
*   **State Locking:** To prevent two people from running Terraform at the same time and corrupting the state, I can use DynamoDB for locking.
*   **Variables & Outputs:** I can make my code dynamic by using variables for inputs and outputs to display important information (like an IP address) after creation.

### Advanced AWS
*   **VPC (Virtual Private Cloud):** This is complex but essential. It involves creating my own private network with subnets, route tables, and internet gateways to securely isolate my resources.
*   **RDS (Relational Database Service):** AWS manages the database for me (like patching and backups), which is much easier than installing MySQL on an EC2 instance myself.
*   **ELB (Elastic Load Balancing):** This helps distribute incoming traffic across multiple instances so that no single server gets overwhelmed.

## My Setup Process

To get everything working, I followed these steps:

1.  **Installed Terraform:** I downloaded and installed Terraform on my machine.
2.  **Installed AWS CLI:** I set up the command-line interface to interact with AWS.
3.  **Configured Credentials:** I used the `aws configure` command to link my machine to my AWS account using my Access Key and Secret Key.

## The Workflow I Practiced

I learned the standard Terraform lifecycle, which consists of four main commands:

1.  **`terraform init`**: I ran this to initialize my project directory and download the AWS provider plugins.
2.  **`terraform plan`**: used this to preview what changes Terraform would make before actually applying them.
3.  **`terraform apply`**: This command executed the plan and actually created the infrastructure on AWS.
4.  **`terraform destroy`**: I learned that this is important for cleaning up resources to avoid unnecessary costs.

---

*This task helped me understand the power of automating infrastructure 
