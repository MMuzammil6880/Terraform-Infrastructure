# This file contains the output variables for the prod environment.

# VPC ID

output "vpc_id" {
  value = module.vpc.vpc_id
  description = "value of the Prod-VPC"
}


output "iam_instance_profile_name" {
  value       = module.ssm_instance_profile.name
  description = "IAM Instance Profile name for EC2 (SSM)"
}

#wordpress server public IP
output "wordpress_server_public_ip" {
  value = aws_eip.wordpress.public_ip
  description = "value of the Prod-Wordpress-Public-IP"
}

