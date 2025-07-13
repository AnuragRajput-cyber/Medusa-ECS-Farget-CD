provider "aws" {
  region = var.region
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "rds" {
  source = "./modules/rds"

  vpc_id                  = module.networking.vpc_id
  private_subnet_ids      = module.networking.private_subnet_ids
  ecs_security_group_id   = module.networking.ecs_security_group_id
  db_instance_class       = var.db_instance_class
  db_username             = var.db_username
  db_password             = var.db_password
  db_multi_az            = var.db_multi_az
}

module "ecs" {
  source = "./modules/ecs"

  region                  = var.region
  vpc_id                  = module.networking.vpc_id
  public_subnet_ids       = module.networking.public_subnet_ids
  private_subnet_ids      = module.networking.private_subnet_ids
  alb_security_group_id   = module.networking.alb_security_group_id
  ecs_security_group_id   = module.networking.ecs_security_group_id
  db_host                 = module.rds.db_host
  db_port                 = module.rds.db_port
  db_username                 = var.db_username 
  db_password             = var.db_password
  db_name                 = module.rds.db_name
  jwt_secret              = var.jwt_secret
  cookie_secret           = var.cookie_secret
  desired_count           = var.desired_count
}