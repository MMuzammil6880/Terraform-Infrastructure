# module "db" {
#   source = "terraform-aws-modules/rds/aws"

#   identifier           = "${var.env_prefix}-db"
#   engine               = var.db_engine
#   major_engine_version = var.db_engine_version
#   instance_class       = var.db_instance_type
#   port                 = var.db_port
#   allocated_storage    = var.db_storage_size
#   storage_type         = var.db_storage_type
#   multi_az             = false
#   skip_final_snapshot  = true




#   manage_master_user_password = false
#   username                    = var.db_username
#   password                    = var.db_password



#   vpc_security_group_ids = [module.db_sg.security_group_id]

#   # DB subnet group
#   create_db_subnet_group = true
#   subnet_ids             = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

#   # DB parameter group
#   family = var.db_family


#   # Database Deletion Protection
#   deletion_protection = false

#   #adding the availability zone
#   availability_zone = var.availability_zone2


#   tags = {
#     managed = "${var.tf_tag}"
#   }

# }


