terraform {
  backend "s3" {
    bucket = "terraform-remote-config-bucket"
    key = "terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraformtable"
  }
}

module "network" {
    source = "./modules/network"
    vpc_name = var.vpc_name
    cidr = var.cidr
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets
    cluster_name = var.cluster_name
    instance_count = var.instance_count
}

module "rds" {
    source = "./modules/rds"
    rds_subnet_1 = module.network.subnet_1
    rds_subnet_2 = module.network.subnet_2
    allocated_storage = var.allocated_storage
    vpc_id = module.network.vpc_id
    engine = var.engine
    engine_version = var.engine_version
    db_name = var.db_name
    username = var.username
    instance_class = var.instance_class
    identifier = var.identifier
    private_subnets = var.private_subnets
}

module "redis" {
  source = "./modules/redis"
  redis-subnet-1 = module.network.subnet_1
  redis-subnet-2 = module.network.subnet_2
  redis-name = var.redis-name
  redis-engine = var.redis-engine
  redis-engine-version = var.redis-engine-version
  redis-node-type = var.redis-node-type
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.network.vpc_id
  public_subnets = module.network.public_subnets
  private_subnets = module.network.private_subnets
  cluster_name = var.cluster_name
  instance_type = var.eks_instance_type
}