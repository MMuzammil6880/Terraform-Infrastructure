/*below code is to create security group using module and there are various ingress 
rules defined in the variable file and allow all egress traffic
the required variables are defined in the variable file*/

#below code is to create security group for frontend server

module "wordpress_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  description = "Security group for frontend server with HTTP and other ports open"

  name   = "${var.env_prefix}-wordpress-sg"
  vpc_id = module.vpc.vpc_id

  # Ingress rules
  ingress_with_cidr_blocks = [
    for rule in var.wordpress_ingress_rules : {
      from_port   = rule.from_port
      to_port     = rule.to_port
      protocol    = rule.protocol
      cidr_blocks = rule.cidr_blocks
      description = lookup(rule, "description", null)
    }
  ]
  # Egress rule (Allow all egress traffic)
  egress_with_cidr_blocks = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]

  tags = {
    managed = "${var.tf_tag}"
  }
}

#below code is to create security group for RDS

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.env_prefix}-db-sg"
  vpc_id = module.vpc.vpc_id

  # Ingress rules
  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.wordpress_sg.security_group_id
      description              = "Allow MySQL from WordPress EC2"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    managed = "${var.tf_tag}"
  }
}

