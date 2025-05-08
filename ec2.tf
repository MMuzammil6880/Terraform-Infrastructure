module "wordpress_server_key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "${var.env_prefix}-wordpress-server-key"
  create_private_key = true
}


resource "aws_eip" "wordpress" {
  domain = "vpc"

  tags = {
    name    = "${var.env_prefix}-wordpress-eip"
    managed = "${var.tf_tag}"
  }
}

module "wordpress_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  ami = "ami-084568db4383263d4"
  instance_type          = var.ec2_instance_type
  key_name               = module.wordpress_server_key_pair.key_pair_name
  monitoring             = false 
  vpc_security_group_ids = module.wordpress_sg.security_group_id
  subnet_id              = aws_subnet.public1.id
  associate_public_ip_address = false
  iam_instance_profile = module.ssm_role.iam_instance_profile_name

  tags = {
    name    = "${var.env_prefix}-wordpress-server"
    managed = "${var.tf_tag}"
  }

  depends_on = [
    module.wordpress_server_key_pair,
    aws_eip.wordpress,
    module.ssm_role
  ]

}




resource "aws_eip_association" "wordpress_eip_association" {
  instance_id = module.wordpress_server.id 
  public_ip        = aws_eip.wordpress.public_ip 
  

  depends_on = [ 
    module.wordpress_server,
    aws_eip.wordpress
   ]
}
