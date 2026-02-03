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


