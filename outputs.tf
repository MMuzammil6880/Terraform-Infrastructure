# This file contains the output variables for the prod environment.

# VPC ID

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "value of the Prod-VPC"
}


#wordpress server public IP
output "wordpress_server_public_ip" {
  value       = aws_eip.server.public_ip
  description = "value of the Prod-Wordpress-Public-IP"
}

