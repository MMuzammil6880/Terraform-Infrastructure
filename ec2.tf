#below is the code for creating the private key and AWS key pair for the EC2 instance

# Generate private key
resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair from public key
resource "aws_key_pair" "server" {
  key_name   = "${var.env_prefix}-server-key"
  public_key = tls_private_key.server.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.server.private_key_pem
  filename = "${path.module}/${var.env_prefix}-server-key.pem"
}

resource "null_resource" "set_pem_permissions" {
  provisioner "local-exec" {
    command = "chmod 400 ${local_file.private_key.filename}"
  }
  depends_on = [local_file.private_key]
}


#below is the code for creatingt the elastic IP for the EC2 instance

resource "aws_eip" "server" {
  domain = "vpc"

  tags = {
    name    = "${var.env_prefix}-eip"
    managed = "${var.tf_tag}"
  }
}

#below is the code for creating the EC2 instance with Ansible playbook to install WordPress

module "ec2_server" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "${var.env_prefix}-server"
  ami                         = "ami-07d9b9ddc6cd8dd30"
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.server.key_name
  monitoring                  = false
  vpc_security_group_ids      = [module.wordpress_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              apt update && apt upgrade -y
              apt install -y python3 python3-pip git ansible mysql-server mysql-client

              # Start MySQL service
              systemctl enable mysql
              systemctl start mysql

              # Clone Ansible repo
              git clone https://github.com/MMuzammil6880/wodpress-ansible.git /opt/wordpress-ansible

              # Run playbook
              cd /opt/wordpress-ansible
              ansible-playbook -i "localhost," -c local wordpress.yml
              EOF

  tags = {

    managed = "${var.tf_tag}"
  }

  depends_on = [
    aws_key_pair.server,
    aws_eip.server,
    module.ssm_role
  ]

}

#below is the code for creating the EIP association with the EC2 instance

resource "aws_eip_association" "server_eip_association" {
  instance_id = module.ec2_server.id
  public_ip   = aws_eip.server.public_ip


  depends_on = [
    module.ec2_server,
    aws_eip.server
  ]
}



