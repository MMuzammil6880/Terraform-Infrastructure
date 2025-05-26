module "ssm_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  create_role       = true
  role_name         = "${var.env_prefix}-SSM-Role"
  role_description  = "IAM role to allow EC2 instances to connect with AWS Systems Manager"
  role_requires_mfa = false

  trusted_role_services = ["ec2.amazonaws.com"]

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  number_of_custom_role_policy_arns = 1

  tags = {
    managed = var.tf_tag
  }
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.env_prefix}-SSM-Profile"
  role = module.ssm_role.iam_role_name
}
