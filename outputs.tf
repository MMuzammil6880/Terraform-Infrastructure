# This file contains the output variables for the prod environment.

# VPC ID

output "vpc_id" {
  value = module.vpc.vpc_id
  description = "value of the Prod-VPC"
}


#server key pair

output "wordpress_server_key_pair" {
  value = module.wordpress_server_key_pair.key_pair_name
  description = "value of the Prod-Server-Key-Pair"
}

