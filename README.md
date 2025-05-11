🚀 Terraform AWS WordPress Deployment

This Terraform project automates the deployment of a production-ready WordPress server and MySQL RDS database on AWS. It follows best practices and includes VPC setup, EC2 provisioning, RDS configuration, Security Groups, IAM roles, and automated WordPress installation using an Ansible playbook triggered via EC2 user_data.

📁 Project Structure
.
├── backend.tf                # Remote backend (S3) configuration

├── ec2.tf                    # EC2 instance and Elastic IP

├── iam.tf                    # SSM IAM role and instance profile

├── outputs.tf                # Output values

├── provider.tf               # AWS provider configuration

├── rds.tf                    # MySQL RDS instance

├── sg.tf                     # Security Groups (EC2 and RDS)

├── variables.tf              # All project variables

├── vpc.tf                    # VPC, subnets, route tables, and IGW


🚀 What It Does

✅ Creates:

1. Custom VPC with 3 public and 3 private subnets.

2.EC2 instance (for WordPress) in a public subnet with:

3. SSM role
   
3.1 Create a Key pair and install it in the Current folder.
   
3.2 Attached Elastic IP
   
3.3 Auto-generated key pair (downloaded locally)
   
3.4 User data script that:
      
. Installs Python, Git, and Ansible
      
. Clone the Ansible repo: https://github.com/MMuzammil6880/wodpress-ansible.git
      
. Executes wordpress.yml playbook locally to install and configure WordPress

5. MySQL RDS database.
   
5.1 EC2 SG allows HTTP/HTTPS and SSH (configurable)
   
5.2 RDS SG restricts access to the private network only    

6. IAM Roles & Instance Profiles:
   
6.1 Used for SSM access and secure instance management


🔧 Usage

1. Configure Remote Backend (optional)

Update backend.tf with your S3 bucket and key:

bucket = "your-bucket-name"
key    = "path/to/terraform.tfstate"
region = "your-region"


2. Customize Variables
   Edit variables.tf to update
      In variables.tf, modify:
      env_prefix – to identify resources
      provider_region – AWS region
      db_username, db_password, db_engine – for the database
      wordpress_ingress_rules – IPs and ports allowed
      Subnet CIDRs and instance types

3. Initialize
$ terraform init

4. Plan
$ terraform plan

5. Apply
$ terraform apply

To apply without prompts:
$ terraform apply -auto-approve


🛠️ WordPress Setup via Ansible (User Data)
   Once the EC2 instance is provisioned, the following user data script is executed automatically:
      #!/bin/bash
      apt update && apt upgrade -y
      apt install -y python3 python3-pip git ansible

   #Clone Ansible repo
      git clone https://github.com/MMuzammil6880/wodpress-ansible.git /opt/wordpress-ansible

   #Run playbook
      cd /opt/wordpress-ansible
      ansible-playbook -i "localhost," -c local wordpress.yml
   
   This ensures WordPress is installed and configured automatically without manual intervention.

🔒 Security Notes
   
EC2 SG allows configurable HTTP/HTTPS and SSH (default open)
   
RDS is securely isolated in private subnets with restricted access
   
EC2 uses AWS SSM for secure management (no open SSH by default)
   
Key pair is auto-generated and downloaded locally for optional access

🔄 Outputs

After deployment, the Terraform output provides:

vpc_id – ID of the created VPC

wordpress_server_key_pair – EC2 key pair name

ec2_public_ip – Public IP of the WordPress server

rds_endpoint – RDS database endpoint

📌 Notes
   
Uses Terraform AWS modules from the community (terraform-aws-modules)
   
Subnet and route table management is manual for fine control
   
EC2 instance is assigned an Elastic IP
   
RDS deletion protection is enabled for production safety
   
WordPress is ready-to-use right after deployment


🧼 Cleanup
   $ terraform destroy
