This Terraform project automates the deployment of a WordPress server and MySQL RDS database on AWS using production-ready best practices. It includes VPC setup, EC2 instance provisioning, RDS configuration, security groups, and IAM roles.

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
4. Key pair
5. Attached Elastic IP
6. MySQL RDS database in private subnets with:
7. Encrypted storage
8. Multi-AZ enabled (by adding more subnets)
9. Security Groups for controlled access
10. IAM Role & Profile for SSM (no SSH needed)

🔧 Usage
1. Configure Remote Backend (optional)
Update backend.tf with your S3 bucket and key:

bucket = "your-bucket-name"
key    = "path/to/terraform.tfstate"
region = "your-region"


2. Customize Variables
   
In variables.tf, modify:
env_prefix – to identify resources
provider_region – AWS region
db_username, db_password, db_engine – for the database
wordpress_ingress_rules – IPs and ports allowed
Subnet CIDRs and instance types

You can also override variables via terraform.tfvars or CLI flags.


3. Initialize
terraform init

4. Plan
terraform plan

5. Apply
terraform apply

To apply without prompts:
terraform apply -auto-approve

🔒 Security Notes

EC2 security group allows open HTTP/HTTPS and SSH.
RDS is protected using its own SG and optional CIDRs.
SSM is used instead of SSH for server access (AmazonSSMManagedInstanceCore policy attached).

🔄 Outputs

After deployment, the terraform output provides:

vpc_id – created VPC ID
wordpress_server_key_pair – key pair name for EC2

📌 Notes

This uses community modules from the terraform-aws-modules GitHub org.
RDS has deletion protection enabled.
Subnets and routes are manually managed for fine control.
The EC2 instance uses an Elastic IP.


🧼 Cleanup
terraform destroy
